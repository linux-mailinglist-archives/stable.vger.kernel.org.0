Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081A520BBC
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfEPP6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42342 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbfEPP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006yi-Rv; Thu, 16 May 2019 16:58:36 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001MQ-AC; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Borislav Petkov" <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.707518560@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 01/86] x86/cpufeature: Add bug flags to /proc/cpuinfo
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 80a208bd3948aceddf0429bd9f9b4cd858d526df upstream.

Dump the flags which denote we have detected and/or have applied bug
workarounds to the CPU we're executing on, in a similar manner to the
feature flags.

The advantage is that those are not accumulating over time like the CPU
features.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1403609105-8332-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeature.h | 10 ++++--
 arch/x86/kernel/cpu/mkcapflags.sh | 51 ++++++++++++++++++++++---------
 arch/x86/kernel/cpu/proc.c        |  8 +++++
 3 files changed, 53 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -268,8 +268,8 @@
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
-#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
-#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
+#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* "tlb_mmatch" AMD Erratum 383 */
+#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* "apic_c1e" AMD Erratum 400 */
 #define X86_BUG_CPU_MELTDOWN	X86_BUG(5) /* CPU is affected by meltdown attack and needs kernel page table isolation */
 #define X86_BUG_SPECTRE_V1	X86_BUG(6) /* CPU is affected by Spectre variant 1 attack with conditional branches */
 #define X86_BUG_SPECTRE_V2	X86_BUG(7) /* CPU is affected by Spectre variant 2 attack with indirect branches */
@@ -284,6 +284,12 @@
 extern const char * const x86_cap_flags[NCAPINTS*32];
 extern const char * const x86_power_flags[32];
 
+/*
+ * In order to save room, we index into this array by doing
+ * X86_BUG_<name> - NCAPINTS*32.
+ */
+extern const char * const x86_bug_flags[NBUGINTS*32];
+
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
 
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -1,23 +1,25 @@
 #!/bin/sh
 #
-# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+# Generate the x86_cap/bug_flags[] arrays from include/asm/cpufeature.h
 #
 
 IN=$1
 OUT=$2
 
-TABS="$(printf '\t\t\t\t\t')"
-trap 'rm "$OUT"' EXIT
+function dump_array()
+{
+	ARRAY=$1
+	SIZE=$2
+	PFX=$3
+	POSTFIX=$4
 
-(
-	echo "#ifndef _ASM_X86_CPUFEATURE_H"
-	echo "#include <asm/cpufeature.h>"
-	echo "#endif"
-	echo ""
-	echo "const char * const x86_cap_flags[NCAPINTS*32] = {"
+	PFX_SZ=$(echo $PFX | wc -c)
+	TABS="$(printf '\t\t\t\t\t')"
+
+	echo "const char * const $ARRAY[$SIZE] = {"
 
-	# Iterate through any input lines starting with #define X86_FEATURE_
-	sed -n -e 's/\t/ /g' -e 's/^ *# *define *X86_FEATURE_//p' $IN |
+	# Iterate through any input lines starting with #define $PFX
+	sed -n -e 's/\t/ /g' -e "s/^ *# *define *$PFX//p" $IN |
 	while read i
 	do
 		# Name is everything up to the first whitespace
@@ -31,11 +33,32 @@ trap 'rm "$OUT"' EXIT
 		# Name is uppercase, VALUE is all lowercase
 		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
 
-		TABCOUNT=$(( ( 5*8 - 14 - $(echo "$NAME" | wc -c) ) / 8 ))
-		printf "\t[%s]%.*s = %s,\n" \
-			"X86_FEATURE_$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+        if [ -n "$POSTFIX" ]; then
+            T=$(( $PFX_SZ + $(echo $POSTFIX | wc -c) + 2 ))
+	        TABS="$(printf '\t\t\t\t\t\t')"
+		    TABCOUNT=$(( ( 6*8 - ($T + 1) - $(echo "$NAME" | wc -c) ) / 8 ))
+		    printf "\t[%s - %s]%.*s = %s,\n" "$PFX$NAME" "$POSTFIX" "$TABCOUNT" "$TABS" "$VALUE"
+        else
+		    TABCOUNT=$(( ( 5*8 - ($PFX_SZ + 1) - $(echo "$NAME" | wc -c) ) / 8 ))
+            printf "\t[%s]%.*s = %s,\n" "$PFX$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+        fi
 	done
 	echo "};"
+}
+
+trap 'rm "$OUT"' EXIT
+
+(
+	echo "#ifndef _ASM_X86_CPUFEATURE_H"
+	echo "#include <asm/cpufeature.h>"
+	echo "#endif"
+	echo ""
+
+	dump_array "x86_cap_flags" "NCAPINTS*32" "X86_FEATURE_" ""
+	echo ""
+
+	dump_array "x86_bug_flags" "NBUGINTS*32" "X86_BUG_" "NCAPINTS*32"
+
 ) > $OUT
 
 trap - EXIT
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -97,6 +97,14 @@ static int show_cpuinfo(struct seq_file
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
+	seq_printf(m, "\nbugs\t\t:");
+	for (i = 0; i < 32*NBUGINTS; i++) {
+		unsigned int bug_bit = 32*NCAPINTS + i;
+
+		if (cpu_has_bug(c, bug_bit) && x86_bug_flags[i])
+			seq_printf(m, " %s", x86_bug_flags[i]);
+	}
+
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);

