Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445A957ED83
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiGWJ6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbiGWJ5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:57:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342123F336;
        Sat, 23 Jul 2022 02:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E24611D4;
        Sat, 23 Jul 2022 09:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0570C341C7;
        Sat, 23 Jul 2022 09:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570238;
        bh=bMri/2ybeRizR5q4f7KPtsMM4WqlBC0dFA8XjkQWNXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW8fpyIafSNs4i8Iy+eSovwavWNLBFCtOnimOpgEwJE+tby3X63duZIULx3sD+J1+
         eV9pX0ExUNE2YDHexX9IoQb456jVBAYDStEZoV/dcBJvrO7nwXW2ZFUrW9YmaY97Tr
         ukpzdAPEjtbLtFhoJFCCIrPglk8VxfUk6Eu5qJOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 016/148] x86/insn: Add a __ignore_sync_check__ marker
Date:   Sat, 23 Jul 2022 11:53:48 +0200
Message-Id: <20220723095228.958106688@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit d30c7b820be5c4777fe6c3b0c21f9d0064251e51 upstream.

Add an explicit __ignore_sync_check__ marker which will be used to mark
lines which are supposed to be ignored by file synchronization check
scripts, its advantage being that it explicitly denotes such lines in
the code.

Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lkml.kernel.org/r/20210304174237.31945-4-bp@alien8.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/inat.h       |    2 +-
 arch/x86/include/asm/insn.h       |    2 +-
 arch/x86/lib/inat.c               |    2 +-
 arch/x86/lib/insn.c               |    6 +++---
 tools/arch/x86/include/asm/inat.h |    2 +-
 tools/arch/x86/include/asm/insn.h |    2 +-
 tools/arch/x86/lib/inat.c         |    2 +-
 tools/arch/x86/lib/insn.c         |    6 +++---
 tools/objtool/sync-check.sh       |   17 +++++++++++++----
 tools/perf/check-headers.sh       |   15 +++++++++++----
 10 files changed, 36 insertions(+), 20 deletions(-)

--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -6,7 +6,7 @@
  *
  * Written by Masami Hiramatsu <mhiramat@redhat.com>
  */
-#include <asm/inat_types.h>
+#include <asm/inat_types.h> /* __ignore_sync_check__ */
 
 /*
  * Internal bits. Don't use bitmasks directly, because these bits are
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -8,7 +8,7 @@
  */
 
 /* insn_attr_t is defined in inat.h */
-#include <asm/inat.h>
+#include <asm/inat.h> /* __ignore_sync_check__ */
 
 struct insn_field {
 	union {
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -4,7 +4,7 @@
  *
  * Written by Masami Hiramatsu <mhiramat@redhat.com>
  */
-#include <asm/insn.h>
+#include <asm/insn.h> /* __ignore_sync_check__ */
 
 /* Attribute tables are generated from opcode map */
 #include "inat-tables.c"
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -10,10 +10,10 @@
 #else
 #include <string.h>
 #endif
-#include <asm/inat.h>
-#include <asm/insn.h>
+#include <asm/inat.h> /*__ignore_sync_check__ */
+#include <asm/insn.h> /* __ignore_sync_check__ */
 
-#include <asm/emulate_prefix.h>
+#include <asm/emulate_prefix.h> /* __ignore_sync_check__ */
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
--- a/tools/arch/x86/include/asm/inat.h
+++ b/tools/arch/x86/include/asm/inat.h
@@ -6,7 +6,7 @@
  *
  * Written by Masami Hiramatsu <mhiramat@redhat.com>
  */
-#include "inat_types.h"
+#include "inat_types.h" /* __ignore_sync_check__ */
 
 /*
  * Internal bits. Don't use bitmasks directly, because these bits are
--- a/tools/arch/x86/include/asm/insn.h
+++ b/tools/arch/x86/include/asm/insn.h
@@ -8,7 +8,7 @@
  */
 
 /* insn_attr_t is defined in inat.h */
-#include "inat.h"
+#include "inat.h" /* __ignore_sync_check__ */
 
 struct insn_field {
 	union {
--- a/tools/arch/x86/lib/inat.c
+++ b/tools/arch/x86/lib/inat.c
@@ -4,7 +4,7 @@
  *
  * Written by Masami Hiramatsu <mhiramat@redhat.com>
  */
-#include "../include/asm/insn.h"
+#include "../include/asm/insn.h" /* __ignore_sync_check__ */
 
 /* Attribute tables are generated from opcode map */
 #include "inat-tables.c"
--- a/tools/arch/x86/lib/insn.c
+++ b/tools/arch/x86/lib/insn.c
@@ -10,10 +10,10 @@
 #else
 #include <string.h>
 #endif
-#include "../include/asm/inat.h"
-#include "../include/asm/insn.h"
+#include "../include/asm/inat.h" /* __ignore_sync_check__ */
+#include "../include/asm/insn.h" /* __ignore_sync_check__ */
 
-#include "../include/asm/emulate_prefix.h"
+#include "../include/asm/emulate_prefix.h" /* __ignore_sync_check__ */
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -16,11 +16,14 @@ arch/x86/include/asm/emulate_prefix.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
 include/linux/static_call_types.h
-arch/x86/include/asm/inat.h     -I '^#include [\"<]\(asm/\)*inat_types.h[\">]'
-arch/x86/include/asm/insn.h     -I '^#include [\"<]\(asm/\)*inat.h[\">]'
-arch/x86/lib/inat.c             -I '^#include [\"<]\(../include/\)*asm/insn.h[\">]'
-arch/x86/lib/insn.c             -I '^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]' -I '^#include [\"<]\(../include/\)*asm/emulate_prefix.h[\">]'
 "
+
+SYNC_CHECK_FILES='
+arch/x86/include/asm/inat.h
+arch/x86/include/asm/insn.h
+arch/x86/lib/inat.c
+arch/x86/lib/insn.c
+'
 fi
 
 check_2 () {
@@ -63,3 +66,9 @@ while read -r file_entry; do
 done <<EOF
 $FILES
 EOF
+
+if [ "$SRCARCH" = "x86" ]; then
+	for i in $SYNC_CHECK_FILES; do
+		check $i '-I "^.*\/\*.*__ignore_sync_check__.*\*\/.*$"'
+	done
+fi
--- a/tools/perf/check-headers.sh
+++ b/tools/perf/check-headers.sh
@@ -75,6 +75,13 @@ include/uapi/asm-generic/mman-common.h
 include/uapi/asm-generic/unistd.h
 '
 
+SYNC_CHECK_FILES='
+arch/x86/include/asm/inat.h
+arch/x86/include/asm/insn.h
+arch/x86/lib/inat.c
+arch/x86/lib/insn.c
+'
+
 # These copies are under tools/perf/trace/beauty/ as they are not used to in
 # building object files only by scripts in tools/perf/trace/beauty/ to generate
 # tables that then gets included in .c files for things like id->string syscall
@@ -129,6 +136,10 @@ for i in $FILES; do
   check $i -B
 done
 
+for i in $SYNC_CHECK_FILES; do
+  check $i '-I "^.*\/\*.*__ignore_sync_check__.*\*\/.*$"'
+done
+
 # diff with extra ignore lines
 check arch/x86/lib/memcpy_64.S        '-I "^EXPORT_SYMBOL" -I "^#include <asm/export.h>" -I"^SYM_FUNC_START\(_LOCAL\)*(memcpy_\(erms\|orig\))"'
 check arch/x86/lib/memset_64.S        '-I "^EXPORT_SYMBOL" -I "^#include <asm/export.h>" -I"^SYM_FUNC_START\(_LOCAL\)*(memset_\(erms\|orig\))"'
@@ -137,10 +148,6 @@ check include/uapi/linux/mman.h       '-
 check include/linux/build_bug.h       '-I "^#\(ifndef\|endif\)\( \/\/\)* static_assert$"'
 check include/linux/ctype.h	      '-I "isdigit("'
 check lib/ctype.c		      '-I "^EXPORT_SYMBOL" -I "^#include <linux/export.h>" -B'
-check arch/x86/include/asm/inat.h     '-I "^#include [\"<]\(asm/\)*inat_types.h[\">]"'
-check arch/x86/include/asm/insn.h     '-I "^#include [\"<]\(asm/\)*inat.h[\">]"'
-check arch/x86/lib/inat.c	      '-I "^#include [\"<]\(../include/\)*asm/insn.h[\">]"'
-check arch/x86/lib/insn.c             '-I "^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]" -I "^#include [\"<]\(../include/\)*asm/emulate_prefix.h[\">]"'
 
 # diff non-symmetric files
 check_2 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl arch/x86/entry/syscalls/syscall_64.tbl


