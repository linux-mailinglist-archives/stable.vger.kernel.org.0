Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A48533DE2
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 15:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbiEYNbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 09:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiEYNbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 09:31:24 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D920222B6
        for <stable@vger.kernel.org>; Wed, 25 May 2022 06:31:22 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e28so29535856wra.10
        for <stable@vger.kernel.org>; Wed, 25 May 2022 06:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MTdwjCNQgtg/AwylFemr7tpRf4frloXXXxWE9yWQCTo=;
        b=NEcPkLxxp091iHdk4cCzQwVb3mvLcMr1kFdpDUokpJRj8AjwAW92SnxCO4QXdi07TT
         IPp/Re1ii3tVbzq6s/s4PuPy+0zNOud53iiJWFC0ZdIZldpDe3PyJZ6EjqS3w9Y9dRXW
         iCNqdHiRcVMyzhalyV8GkMkDxiJrh/j0pfUIeAlaGfMHQKmxxrCfMceRmenu8vgW8XhE
         qmTpWu7sMxAYCVcPpC4x7clQu348WQNWV56Bayx4AB9ZnaltQZmcbiBB2JVaW8yhhNNy
         B1YDzzA4PZvG+Gzmq20frTQAX4HD7tL05FgWB4f8Ubi1YCbZ/4K66N7qtZ/0gpnri7Mm
         JdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MTdwjCNQgtg/AwylFemr7tpRf4frloXXXxWE9yWQCTo=;
        b=cD3txJ9cuAEf0Q/pODuS9jBL/4XViRxlbhL/rG7wSx/JTV8mQhGYtlm8hRa3/dQqLy
         /J2uYXX5KTPYAqb8ID2y6dO+Sn7wWuml2ORHPC8/j0jb+YnJ//Xj1aTQlHCqWmgY8ATS
         HXLfVAkg/GR9C9iKBfYwdCQ0ilrtGAagnUCIf03idQb7UM7u8EzLtG7S66nisS+pakT0
         UTQVT2Q75xZkG0j6Ly59qbGzYq7cHHUtSqwPSbfXkpuJXJvWN8FYSftxif5QllYEcMsY
         PUhZbHFIHSZMvJ87t7R6tyS9R2a+kzjBHIzrrNO8kRD6EZaCwCgfXvzdhpX26rxj/AKp
         NFUA==
X-Gm-Message-State: AOAM531RfwHP/32rSnYdhxUd9pwsD0IuhGRNECxu26gG3eRbfeBTUa8Q
        2nhUUeF7j2k7zVzKxPGe08gJv8XP8CIU0pac
X-Google-Smtp-Source: ABdhPJxNP3plhCABbUUJSvbaD3VwPvV6AfSjRSlyyvhstcf1ZmctGnLmw3gjL8fbsVF0v0TUfWxA5w==
X-Received: by 2002:a5d:514e:0:b0:20e:67a3:d451 with SMTP id u14-20020a5d514e000000b0020e67a3d451mr26521456wrt.350.1653485480766;
        Wed, 25 May 2022 06:31:20 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id x8-20020a7bc208000000b0039765a7add4sm1783320wmi.29.2022.05.25.06.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 06:31:20 -0700 (PDT)
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     stable@vger.kernel.org
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5.4] lockdown: also lock down previous kgdb use
Date:   Wed, 25 May 2022 14:31:07 +0100
Message-Id: <20220525133107.204183-1-daniel.thompson@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Notes:
    Original patch did not backport cleanly. This backport is fixed up,
    compile tested (on arm64) and side-by-side compared against the
    original.

 include/linux/security.h     |  2 ++
 kernel/debug/debug_core.c    | 24 ++++++++++++++
 kernel/debug/kdb/kdb_main.c  | 62 ++++++++++++++++++++++++++++++++++--
 security/lockdown/lockdown.c |  2 ++
 4 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 3f6b8195ae9e..aa5c7141c8d1 100644
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
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 097ab02989f9..565987557ad8 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -56,6 +56,7 @@
 #include <linux/vmacache.h>
 #include <linux/rcupdate.h>
 #include <linux/irq.h>
+#include <linux/security.h>

 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -685,6 +686,29 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
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

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 4567fe998c30..7c96bf9a6c2c 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -45,6 +45,7 @@
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/security.h>
 #include "kdb_private.h"

 #undef	MODULE_PARAM_PREFIX
@@ -198,10 +199,62 @@ struct task_struct *kdb_curr_task(int cpu)
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
@@ -1188,6 +1241,9 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		kdb_curr_task(raw_smp_processor_id());

 	KDB_DEBUG_STATE("kdb_local 1", reason);
+
+	kdb_check_for_lockdown();
+
 	kdb_go_count = 0;
 	if (reason == KDB_REASON_DEBUG) {
 		/* special case below */
diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index 3f38583bed06..655a6edb5d7f 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -33,10 +33,12 @@ static const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
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

base-commit: 04b092e4a01a3488e762897e2d29f85eda2c6a60
--
2.35.1

