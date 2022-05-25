Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C509E533CEF
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 14:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiEYMtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 08:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiEYMtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 08:49:23 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5837B9FF
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:49:22 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso3283523wmn.4
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kRB7ryb46d5qyv6BlNJ+7J4Cdvyyut4gXAX0jDtf2ww=;
        b=h31x4ScLeHWFbavoidXwe1LEwV5Bl3GaMiZE9VTYzzdkqcNZN9xe1ENSCxNJSJeREu
         4DsxWEVJEWjTgeKmtK3yPDWwZRlEmmPIcW6BJ2Jub0UuHcdIReK8qr7nB7DFtdw9xprS
         ZhV20XPLEyOXYoqLcgzrJJMU2T/+agiyvY6SRTCqHbRCgP0cRhL9yrDE8d9tFeV+IpCX
         J7ElhgEk05yWw3J/lNoabMjbX+VJLTnRz+RgeIXKzBnBVimyyMc/Zcj9xTrbbIwrPEjC
         49StpC8PXeFkb44wZLWvnLfPmMevQD8xJgZd7mQamtsfp0cYE2wmthz8Zo3mC23lO2EX
         mHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kRB7ryb46d5qyv6BlNJ+7J4Cdvyyut4gXAX0jDtf2ww=;
        b=c0Vy5EYFyGO7GPM2VnU4izf+fXWIudxN+nKJIYRPTVwz1ShdxylUKfz8yI3GqOTM9t
         BdsorjfWRDJYVlY0dLUWNAiFwgpd+MwIMo9rGVJDw6LrSVIp/M/dGs4ieHB7uj6yXays
         6lvWV6yUFZ0mdMwx/YpFq37UlY8JLN6vR2uqFQgQKCw/JNFc2XTjrarnN+/ulChhDDkV
         IPgE8n2PIV/eFiyewKuwtBjNAXgnwg1tL4gTTvXrm825E9OmupnQ9lTMj+q4O8EbZ+Lk
         ariibrHXeAa/0JMEneSERL6Wwp5OMzm38laeOGxWfl5XQnVrgxJWnEwyAuqiclnLgD7n
         H08Q==
X-Gm-Message-State: AOAM533SW7AQFvIz2DE64F1hdUbCs+sIEkd3KAGdRYtDB8m/V/hJfggR
        KmHOyfBu7uDLnXRFCZ7KNS2f04K1X0ovfMOv
X-Google-Smtp-Source: ABdhPJxlDwfN6clgN7SVk+Ud7ns00fARl1oYCybCwSNcEVhQOiaF178eF/37h6EUFYtXnAZzZRiNcQ==
X-Received: by 2002:a05:600c:190b:b0:394:880f:ae2c with SMTP id j11-20020a05600c190b00b00394880fae2cmr7826770wmq.79.1653482960379;
        Wed, 25 May 2022 05:49:20 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id t22-20020a1c7716000000b00397381a7ae8sm1661736wmi.30.2022.05.25.05.49.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 05:49:19 -0700 (PDT)
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH v5.10] lockdown: also lock down previous kgdb use
Date:   Wed, 25 May 2022 13:49:18 +0100
Message-Id: <20220525124918.114232-1-daniel.thompson@linaro.org>
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

 include/linux/security.h    |  2 ++
 kernel/debug/debug_core.c   | 24 ++++++++++++++
 kernel/debug/kdb/kdb_main.c | 62 +++++++++++++++++++++++++++++++++++--
 security/security.c         |  2 ++
 4 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 35355429648e..330029ef7e89 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -121,10 +121,12 @@ enum lockdown_reason {
 	LOCKDOWN_DEBUGFS,
 	LOCKDOWN_XMON_WR,
 	LOCKDOWN_BPF_WRITE_USER,
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
index 8661eb2b1771..0f31b22abe8d 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -56,6 +56,7 @@
 #include <linux/vmacache.h>
 #include <linux/rcupdate.h>
 #include <linux/irq.h>
+#include <linux/security.h>

 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -756,6 +757,29 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
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
index 930ac1b25ec7..4e09fab52faf 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -45,6 +45,7 @@
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/security.h>
 #include "kdb_private.h"

 #undef	MODULE_PARAM_PREFIX
@@ -197,10 +198,62 @@ struct task_struct *kdb_curr_task(int cpu)
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
@@ -1194,6 +1247,9 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		kdb_curr_task(raw_smp_processor_id());

 	KDB_DEBUG_STATE("kdb_local 1", reason);
+
+	kdb_check_for_lockdown();
+
 	kdb_go_count = 0;
 	if (reason == KDB_REASON_DEBUG) {
 		/* special case below */
diff --git a/security/security.c b/security/security.c
index d9d42d64f89f..360706cdabab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -59,10 +59,12 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
 	[LOCKDOWN_XMON_WR] = "xmon write access",
 	[LOCKDOWN_BPF_WRITE_USER] = "use of bpf to write user RAM",
+	[LOCKDOWN_DBG_WRITE_KERNEL] = "use of kgdb/kdb to write kernel RAM",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
 	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
+	[LOCKDOWN_DBG_READ_KERNEL] = "use of kgdb/kdb to read kernel RAM",
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
 	[LOCKDOWN_XMON_RW] = "xmon read and write access",

base-commit: c204ee3350ebbc4e2ab108cbce7afc0cac1c407d
--
2.35.1

