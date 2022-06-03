Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED8B53CED0
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345011AbiFCRsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345149AbiFCRr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:47:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6785715E;
        Fri,  3 Jun 2022 10:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99EB5B823B0;
        Fri,  3 Jun 2022 17:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82AFC385A9;
        Fri,  3 Jun 2022 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278262;
        bh=p2Kw4t5xphJd3kFvMz9xTPiah3ar/k3FK8fFR1qbuXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luBBs7ikW4Ot6JcBvUfYct4uIVUJkkqQkQb53eDNw/F/td/szFZuX+t9sqfwj/Tla
         lKyJsgCDuGw1oDZynxBwAa5vpc0++CccOa7wulm6CLCC3Ub7oRB6/PrW01/oFPpe42
         qlMq2E0/Hsr1+hq9T9Qpl9TivlSRBN7zxTYf1Nxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 01/34] lockdown: also lock down previous kgdb use
Date:   Fri,  3 Jun 2022 19:42:57 +0200
Message-Id: <20220603173816.035183151@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

commit eadb2f47a3ced5c64b23b90fd2a3463f63726066 upstream.

KGDB and KDB allow read and write access to kernel memory, and thus
should be restricted during lockdown.  An attacker with access to a
serial port (for example, via a hypervisor console, which some cloud
vendors provide over the network) could trigger the debugger so it is
important that the debugger respect the lockdown mode when/if it is
triggered.

Fix this by integrating lockdown into kdb's existing permissions
mechanism.  Unfortunately kgdb does not have any permissions mechanism
(although it certainly could be added later) so, for now, kgdb is simply
and brutally disabled by immediately exiting the gdb stub without taking
any action.

For lockdowns established early in the boot (e.g. the normal case) then
this should be fine but on systems where kgdb has set breakpoints before
the lockdown is enacted than "bad things" will happen.

CVE: CVE-2022-21499
Co-developed-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/security.h     |    2 +
 kernel/debug/debug_core.c    |   24 ++++++++++++++++
 kernel/debug/kdb/kdb_main.c  |   62 ++++++++++++++++++++++++++++++++++++++++---
 security/lockdown/lockdown.c |    2 +
 4 files changed, 87 insertions(+), 3 deletions(-)

--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -118,10 +118,12 @@ enum lockdown_reason {
 	LOCKDOWN_MMIOTRACE,
 	LOCKDOWN_DEBUGFS,
 	LOCKDOWN_XMON_WR,
+	LOCKDOWN_DBG_WRITE_KERNEL,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
 	LOCKDOWN_BPF_READ,
+	LOCKDOWN_DBG_READ_KERNEL,
 	LOCKDOWN_PERF,
 	LOCKDOWN_TRACEFS,
 	LOCKDOWN_XMON_RW,
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -56,6 +56,7 @@
 #include <linux/vmacache.h>
 #include <linux/rcupdate.h>
 #include <linux/irq.h>
+#include <linux/security.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -685,6 +686,29 @@ cpu_master_loop:
 				continue;
 			kgdb_connected = 0;
 		} else {
+			/*
+			 * This is a brutal way to interfere with the debugger
+			 * and prevent gdb being used to poke at kernel memory.
+			 * This could cause trouble if lockdown is applied when
+			 * there is already an active gdb session. For now the
+			 * answer is simply "don't do that". Typically lockdown
+			 * *will* be applied before the debug core gets started
+			 * so only developers using kgdb for fairly advanced
+			 * early kernel debug can be biten by this. Hopefully
+			 * they are sophisticated enough to take care of
+			 * themselves, especially with help from the lockdown
+			 * message printed on the console!
+			 */
+			if (security_locked_down(LOCKDOWN_DBG_WRITE_KERNEL)) {
+				if (IS_ENABLED(CONFIG_KGDB_KDB)) {
+					/* Switch back to kdb if possible... */
+					dbg_kdb_mode = 1;
+					continue;
+				} else {
+					/* ... otherwise just bail */
+					break;
+				}
+			}
 			error = gdb_serial_stub(ks);
 		}
 
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -45,6 +45,7 @@
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/security.h>
 #include "kdb_private.h"
 
 #undef	MODULE_PARAM_PREFIX
@@ -198,10 +199,62 @@ struct task_struct *kdb_curr_task(int cp
 }
 
 /*
- * Check whether the flags of the current command and the permissions
- * of the kdb console has allow a command to be run.
+ * Update the permissions flags (kdb_cmd_enabled) to match the
+ * current lockdown state.
+ *
+ * Within this function the calls to security_locked_down() are "lazy". We
+ * avoid calling them if the current value of kdb_cmd_enabled already excludes
+ * flags that might be subject to lockdown. Additionally we deliberately check
+ * the lockdown flags independently (even though read lockdown implies write
+ * lockdown) since that results in both simpler code and clearer messages to
+ * the user on first-time debugger entry.
+ *
+ * The permission masks during a read+write lockdown permits the following
+ * flags: INSPECT, SIGNAL, REBOOT (and ALWAYS_SAFE).
+ *
+ * The INSPECT commands are not blocked during lockdown because they are
+ * not arbitrary memory reads. INSPECT covers the backtrace family (sometimes
+ * forcing them to have no arguments) and lsmod. These commands do expose
+ * some kernel state but do not allow the developer seated at the console to
+ * choose what state is reported. SIGNAL and REBOOT should not be controversial,
+ * given these are allowed for root during lockdown already.
+ */
+static void kdb_check_for_lockdown(void)
+{
+	const int write_flags = KDB_ENABLE_MEM_WRITE |
+				KDB_ENABLE_REG_WRITE |
+				KDB_ENABLE_FLOW_CTRL;
+	const int read_flags = KDB_ENABLE_MEM_READ |
+			       KDB_ENABLE_REG_READ;
+
+	bool need_to_lockdown_write = false;
+	bool need_to_lockdown_read = false;
+
+	if (kdb_cmd_enabled & (KDB_ENABLE_ALL | write_flags))
+		need_to_lockdown_write =
+			security_locked_down(LOCKDOWN_DBG_WRITE_KERNEL);
+
+	if (kdb_cmd_enabled & (KDB_ENABLE_ALL | read_flags))
+		need_to_lockdown_read =
+			security_locked_down(LOCKDOWN_DBG_READ_KERNEL);
+
+	/* De-compose KDB_ENABLE_ALL if required */
+	if (need_to_lockdown_write || need_to_lockdown_read)
+		if (kdb_cmd_enabled & KDB_ENABLE_ALL)
+			kdb_cmd_enabled = KDB_ENABLE_MASK & ~KDB_ENABLE_ALL;
+
+	if (need_to_lockdown_write)
+		kdb_cmd_enabled &= ~write_flags;
+
+	if (need_to_lockdown_read)
+		kdb_cmd_enabled &= ~read_flags;
+}
+
+/*
+ * Check whether the flags of the current command, the permissions of the kdb
+ * console and the lockdown state allow a command to be run.
  */
-static inline bool kdb_check_flags(kdb_cmdflags_t flags, int permissions,
+static bool kdb_check_flags(kdb_cmdflags_t flags, int permissions,
 				   bool no_args)
 {
 	/* permissions comes from userspace so needs massaging slightly */
@@ -1188,6 +1241,9 @@ static int kdb_local(kdb_reason_t reason
 		kdb_curr_task(raw_smp_processor_id());
 
 	KDB_DEBUG_STATE("kdb_local 1", reason);
+
+	kdb_check_for_lockdown();
+
 	kdb_go_count = 0;
 	if (reason == KDB_REASON_DEBUG) {
 		/* special case below */
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -33,10 +33,12 @@ static const char *const lockdown_reason
 	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
 	[LOCKDOWN_XMON_WR] = "xmon write access",
+	[LOCKDOWN_DBG_WRITE_KERNEL] = "use of kgdb/kdb to write kernel RAM",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
 	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
+	[LOCKDOWN_DBG_READ_KERNEL] = "use of kgdb/kdb to read kernel RAM",
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
 	[LOCKDOWN_XMON_RW] = "xmon read and write access",


