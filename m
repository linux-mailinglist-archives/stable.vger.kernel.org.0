Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04D14B2C18
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 18:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347132AbiBKRtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 12:49:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344922AbiBKRtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 12:49:17 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD89AE
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1644601756; x=1676137756;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ipt/VilkN22Mf9ExO8hBTkfWqgUC+CwYsHKY9rcI0zE=;
  b=PT+5OWz15CNNbiGyyrVWGpDczVwTZIAGEZYKnIwJi2Wb3SydCpsvJaoj
   ZTZ9IVcu+HpMZaVXzsMrAIYqUbMoS7RnjOjdBm5jm72A6YkvPL0CdLLyW
   qB7dNd5Z/ub2jlC0dSKrMpHDxJk1DJa32fTNN8JjYHY7tKiA/36R8e2Sj
   Y=;
X-IronPort-AV: E=Sophos;i="5.88,361,1635206400"; 
   d="scan'208";a="991450754"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 11 Feb 2022 17:49:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com (Postfix) with ESMTPS id 130F4C082F;
        Fri, 11 Feb 2022 17:49:15 +0000 (UTC)
Received: from EX13D13UWB004.ant.amazon.com (10.43.161.218) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 11 Feb 2022 17:49:14 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D13UWB004.ant.amazon.com (10.43.161.218) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 11 Feb 2022 17:49:14 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.28 via Frontend Transport; Fri, 11 Feb 2022 17:49:13
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 60668E59; Fri, 11 Feb 2022 17:49:13 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14] bpf: Add kconfig knob for disabling unpriv bpf by default
Date:   Fri, 11 Feb 2022 17:49:09 +0000
Message-ID: <20220211174909.27148-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 08389d888287c3823f80b0216766b71e17f0aba5 upstream.

Add a kconfig knob which allows for unprivileged bpf to be disabled by default.
If set, the knob sets /proc/sys/kernel/unprivileged_bpf_disabled to value of 2.

This still allows a transition of 2 -> {0,1} through an admin. Similarly,
this also still keeps 1 -> {1} behavior intact, so that once set to permanently
disabled, it cannot be undone aside from a reboot.

We've also added extra2 with max of 2 for the procfs handler, so that an admin
still has a chance to toggle between 0 <-> 2.

Either way, as an additional alternative, applications can make use of CAP_BPF
that we added a while ago.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/74ec548079189e4e4dffaeb42b8987bb3c852eee.1620765074.git.daniel@iogearbox.net
[fllinden@amazon.com: backported to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 Documentation/sysctl/kernel.txt | 21 +++++++++++++++++++++
 init/Kconfig                    | 10 ++++++++++
 kernel/bpf/syscall.c            |  3 ++-
 kernel/sysctl.c                 | 29 +++++++++++++++++++++++++----
 4 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 694968c7523c..3c8f5bfdf6da 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -91,6 +91,7 @@ show up in /proc/sys/kernel:
 - sysctl_writes_strict
 - tainted
 - threads-max
+- unprivileged_bpf_disabled
 - unknown_nmi_panic
 - watchdog
 - watchdog_thresh
@@ -999,6 +1000,26 @@ available RAM pages threads-max is reduced accordingly.
 
 ==============================================================
 
+unprivileged_bpf_disabled:
+
+Writing 1 to this entry will disable unprivileged calls to bpf();
+once disabled, calling bpf() without CAP_SYS_ADMIN will return
+-EPERM. Once set to 1, this can't be cleared from the running kernel
+anymore.
+
+Writing 2 to this entry will also disable unprivileged calls to bpf(),
+however, an admin can still change this setting later on, if needed, by
+writing 0 or 1 to this entry.
+
+If BPF_UNPRIV_DEFAULT_OFF is enabled in the kernel config, then this
+entry will default to 2 instead of 0.
+
+  0 - Unprivileged calls to bpf() are enabled
+  1 - Unprivileged calls to bpf() are disabled without recovery
+  2 - Unprivileged calls to bpf() are disabled
+
+==============================================================
+
 unknown_nmi_panic:
 
 The value in this file affects behavior of handling NMI. When the
diff --git a/init/Kconfig b/init/Kconfig
index be58f0449c68..c87858c434cc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1378,6 +1378,16 @@ config ADVISE_SYSCALLS
 	  applications use these syscalls, you can disable this option to save
 	  space.
 
+config BPF_UNPRIV_DEFAULT_OFF
+	bool "Disable unprivileged BPF by default"
+	depends on BPF_SYSCALL
+	help
+	  Disables unprivileged BPF by default by setting the corresponding
+	  /proc/sys/kernel/unprivileged_bpf_disabled knob to 2. An admin can
+	  still reenable it by setting it to 0 later on, or permanently
+	  disable it by setting it to 1 (from which no other transition to
+	  0 is possible anymore).
+
 config USERFAULTFD
 	bool "Enable userfaultfd() system call"
 	select ANON_INODES
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 21073682061d..59d44f1ad958 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -37,7 +37,8 @@ static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
 static DEFINE_SPINLOCK(map_idr_lock);
 
-int sysctl_unprivileged_bpf_disabled __read_mostly;
+int sysctl_unprivileged_bpf_disabled __read_mostly =
+	IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
 
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _ops)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74fc3a9d1923..c9a3e61c88f8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -242,6 +242,28 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 
 #endif
 
+#ifdef CONFIG_BPF_SYSCALL
+static int bpf_unpriv_handler(struct ctl_table *table, int write,
+                             void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, unpriv_enable = *(int *)table->data;
+	bool locked_state = unpriv_enable == 1;
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	tmp.data = &unpriv_enable;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret) {
+		if (locked_state && unpriv_enable != 1)
+			return -EPERM;
+		*(int *)table->data = unpriv_enable;
+	}
+	return ret;
+}
+#endif
+
 static struct ctl_table kern_table[];
 static struct ctl_table vm_table[];
 static struct ctl_table fs_table[];
@@ -1201,10 +1223,9 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_unprivileged_bpf_disabled,
 		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
 		.mode		= 0644,
-		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &one,
-		.extra2		= &one,
+		.proc_handler	= bpf_unpriv_handler,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 #endif
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
-- 
2.32.0

