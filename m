Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AF82B8860
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 00:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgKRX2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 18:28:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgKRX2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 18:28:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AINOa5V096512;
        Wed, 18 Nov 2020 23:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=SmWEE3ByHnlVFAqMSaN/A+TYWtwBVPWNt6Vsf6QDDWA=;
 b=njMb7faSaf5+Q3kx02K6+ZeQjI37rQh6VigUtqqBC5Yq6yDlT4I2+d4wTYSSoK99c1WY
 Atx9bbUnzScWu5eYZaMiFeTufrkwjBEnMyeblPdRfx8EPSMdxPA7ifnqbTTjxUbAADmS
 ne9qhaJk+IsTc6s166WBmo8X7sg2wmSnKSn7gheZml8WQHHsyTZ7uIxJgF6jNCHck5oB
 8SYnCJeiEQtQZghPan1xk8LBAp5f7n6eIkRcNmbBjK7Fekg0AETwQa0FHd2jOnrLVb74
 Dyu5UYdq6vaM2VjgnOvYolSwkt9i5iXnRlLmwCn4xNOwsqrJipL1bJlBmBIPu25vXSGs vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76m2rsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 23:27:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AINLLaN136260;
        Wed, 18 Nov 2020 23:25:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 34umd17ffe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 23:25:20 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AINPJQJ150558;
        Wed, 18 Nov 2020 23:25:19 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by aserp3020.oracle.com with ESMTP id 34umd17feh-1;
        Wed, 18 Nov 2020 23:25:19 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     saeed.mirzamohammadi@oracle.com, john.p.donnelly@oracle.com,
        stable@vger.kernel.org, Dave Young <dyoung@redhat.com>,
        Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Anson Huang <Anson.Huang@nxp.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86 and ARM
Date:   Wed, 18 Nov 2020 15:24:28 -0800
Message-Id: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180161
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds crashkernel=auto feature to configure reserved memory for
vmcore creation to both x86 and ARM platforms based on the total memory
size.

Cc: stable@vger.kernel.org
Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 Documentation/admin-guide/kdump/kdump.rst |  5 +++++
 arch/arm64/Kconfig                        | 26 ++++++++++++++++++++++-
 arch/arm64/configs/defconfig              |  1 +
 arch/x86/Kconfig                          | 26 ++++++++++++++++++++++-
 arch/x86/configs/x86_64_defconfig         |  1 +
 kernel/crash_core.c                       | 20 +++++++++++++++--
 6 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kdump/kdump.rst b/Documentation/admin-guide/kdump/kdump.rst
index 75a9dd98e76e..f95a2af64f59 100644
--- a/Documentation/admin-guide/kdump/kdump.rst
+++ b/Documentation/admin-guide/kdump/kdump.rst
@@ -285,7 +285,12 @@ This would mean:
     2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
     3) if the RAM size is larger than 2G, then reserve 128M
 
+Or you can use crashkernel=auto if you have enough memory. The threshold
+is 1G on x86_64 and arm64. If your system memory is less than the threshold,
+crashkernel=auto will not reserve memory. The size changes according to
+the system memory size like below:
 
+    x86_64/arm64: 1G-64G:128M,64G-1T:256M,1T-:512M
 
 Boot into System Kernel
 =======================
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1515f6f153a0..d359dcffa80e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1124,7 +1124,7 @@ comment "Support for PE file signature verification disabled"
 	depends on KEXEC_SIG
 	depends on !EFI || !SIGNED_PE_FILE_VERIFICATION
 
-config CRASH_DUMP
+menuconfig CRASH_DUMP
 	bool "Build kdump crash kernel"
 	help
 	  Generate crash dump after being started by kexec. This should
@@ -1135,6 +1135,30 @@ config CRASH_DUMP
 
 	  For more details see Documentation/admin-guide/kdump/kdump.rst
 
+if CRASH_DUMP
+
+config CRASH_AUTO_STR
+        string "Memory reserved for crash kernel"
+	depends on CRASH_DUMP
+        default "1G-64G:128M,64G-1T:256M,1T-:512M"
+	help
+	  This configures the reserved memory dependent
+	  on the value of System RAM. The syntax is:
+	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
+	              range=start-[end]
+
+	  For example:
+	      crashkernel=512M-2G:64M,2G-:128M
+
+	  This would mean:
+
+	      1) if the RAM is smaller than 512M, then don't reserve anything
+	         (this is the "rescue" case)
+	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
+	      3) if the RAM size is larger than 2G, then reserve 128M
+
+endif # CRASH_DUMP
+
 config XEN_DOM0
 	def_bool y
 	depends on XEN
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 5cfe3cf6f2ac..899ef3b6a78f 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -69,6 +69,7 @@ CONFIG_SECCOMP=y
 CONFIG_KEXEC=y
 CONFIG_KEXEC_FILE=y
 CONFIG_CRASH_DUMP=y
+# CONFIG_CRASH_AUTO_STR is not set
 CONFIG_XEN=y
 CONFIG_COMPAT=y
 CONFIG_RANDOMIZE_BASE=y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f6946b81f74a..bacd17312bb1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2035,7 +2035,7 @@ config KEXEC_BZIMAGE_VERIFY_SIG
 	help
 	  Enable bzImage signature verification support.
 
-config CRASH_DUMP
+menuconfig CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on X86_64 || (X86_32 && HIGHMEM)
 	help
@@ -2049,6 +2049,30 @@ config CRASH_DUMP
 	  (CONFIG_RELOCATABLE=y).
 	  For more details see Documentation/admin-guide/kdump/kdump.rst
 
+if CRASH_DUMP
+
+config CRASH_AUTO_STR
+        string "Memory reserved for crash kernel" if X86_64
+	depends on CRASH_DUMP
+        default "1G-64G:128M,64G-1T:256M,1T-:512M"
+	help
+	  This configures the reserved memory dependent
+	  on the value of System RAM. The syntax is:
+	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
+	              range=start-[end]
+
+	  For example:
+	      crashkernel=512M-2G:64M,2G-:128M
+
+	  This would mean:
+
+	      1) if the RAM is smaller than 512M, then don't reserve anything
+	         (this is the "rescue" case)
+	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
+	      3) if the RAM size is larger than 2G, then reserve 128M
+
+endif # CRASH_DUMP
+
 config KEXEC_JUMP
 	bool "kexec jump"
 	depends on KEXEC && HIBERNATION
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 9936528e1939..7a87fbecf40b 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -33,6 +33,7 @@ CONFIG_EFI_MIXED=y
 CONFIG_HZ_1000=y
 CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
+# CONFIG_CRASH_AUTO_STR is not set
 CONFIG_HIBERNATION=y
 CONFIG_PM_DEBUG=y
 CONFIG_PM_TRACE_RTC=y
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 106e4500fd53..a44cd9cc12c4 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -7,6 +7,7 @@
 #include <linux/crash_core.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
+#include <linux/kexec.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -41,6 +42,15 @@ static int __init parse_crashkernel_mem(char *cmdline,
 					unsigned long long *crash_base)
 {
 	char *cur = cmdline, *tmp;
+	unsigned long long total_mem = system_ram;
+
+	/*
+	 * Firmware sometimes reserves some memory regions for it's own use.
+	 * so we get less than actual system memory size.
+	 * Workaround this by round up the total size to 128M which is
+	 * enough for most test cases.
+	 */
+	total_mem = roundup(total_mem, SZ_128M);
 
 	/* for each entry of the comma-separated list */
 	do {
@@ -85,13 +95,13 @@ static int __init parse_crashkernel_mem(char *cmdline,
 			return -EINVAL;
 		}
 		cur = tmp;
-		if (size >= system_ram) {
+		if (size >= total_mem) {
 			pr_warn("crashkernel: invalid size\n");
 			return -EINVAL;
 		}
 
 		/* match ? */
-		if (system_ram >= start && system_ram < end) {
+		if (total_mem >= start && total_mem < end) {
 			*crash_size = size;
 			break;
 		}
@@ -250,6 +260,12 @@ static int __init __parse_crashkernel(char *cmdline,
 	if (suffix)
 		return parse_crashkernel_suffix(ck_cmdline, crash_size,
 				suffix);
+#ifdef CONFIG_CRASH_AUTO_STR
+	if (strncmp(ck_cmdline, "auto", 4) == 0) {
+		ck_cmdline = CONFIG_CRASH_AUTO_STR;
+		pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
+	}
+#endif
 	/*
 	 * if the commandline contains a ':', then that's the extended
 	 * syntax -- if not, it must be the classic syntax
-- 
2.18.4

