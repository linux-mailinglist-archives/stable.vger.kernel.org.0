Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AD74B47DB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiBNJln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:41:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244720AbiBNJkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:40:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8291AD97;
        Mon, 14 Feb 2022 01:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 406C4B80DCB;
        Mon, 14 Feb 2022 09:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E30C340EF;
        Mon, 14 Feb 2022 09:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831352;
        bh=K/bO3DZjQwPyq1SoGO2MLeqecuuRLDydeAd+NpzgE+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORGpbHGzbInoC8ASSQ80NfJuzmIA/XEovrrPzqbbA3kVo1NNUAvA9KLWzCU1XGwqM
         ukjqEVxSGYNbwSAiLu6omd2II1bmUH2EaIocuH5x90528Ws/IYWbb40o+T9PAh78Ep
         8ptDdXzqxbfG/rHWXohwHFgbDOXRg15TqWFLRrw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 5.4 26/71] bpf: Add kconfig knob for disabling unpriv bpf by default
Date:   Mon, 14 Feb 2022 10:25:54 +0100
Message-Id: <20220214092452.893556675@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
[fllinden@amazon.com: backported to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/kernel.rst |   21 ++++++++++++++++++++
 init/Kconfig                                |   10 +++++++++
 kernel/bpf/syscall.c                        |    3 +-
 kernel/sysctl.c                             |   29 ++++++++++++++++++++++++----
 4 files changed, 58 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1125,6 +1125,27 @@ NMI switch that most IA32 servers have f
 example.  If a system hangs up, try pressing the NMI switch.
 
 
+unprivileged_bpf_disabled:
+==========================
+
+Writing 1 to this entry will disable unprivileged calls to ``bpf()``;
+once disabled, calling ``bpf()`` without ``CAP_SYS_ADMIN`` will return
+``-EPERM``. Once set to 1, this can't be cleared from the running kernel
+anymore.
+
+Writing 2 to this entry will also disable unprivileged calls to ``bpf()``,
+however, an admin can still change this setting later on, if needed, by
+writing 0 or 1 to this entry.
+
+If ``BPF_UNPRIV_DEFAULT_OFF`` is enabled in the kernel config, then this
+entry will default to 2 instead of 0.
+
+= =============================================================
+0 Unprivileged calls to ``bpf()`` are enabled
+1 Unprivileged calls to ``bpf()`` are disabled without recovery
+2 Unprivileged calls to ``bpf()`` are disabled
+= =============================================================
+
 watchdog:
 =========
 
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1609,6 +1609,16 @@ config BPF_JIT_ALWAYS_ON
 	  Enables BPF JIT and removes BPF interpreter to avoid
 	  speculative execution of BPF instructions by the interpreter
 
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
 	depends on MMU
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -39,7 +39,8 @@ static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
 static DEFINE_SPINLOCK(map_idr_lock);
 
-int sysctl_unprivileged_bpf_disabled __read_mostly;
+int sysctl_unprivileged_bpf_disabled __read_mostly =
+	IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
 
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _ops)
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -250,6 +250,28 @@ static int sysrq_sysctl_handler(struct c
 
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
@@ -1255,10 +1277,9 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_unprivileged_bpf_disabled,
 		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
 		.mode		= 0644,
-		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_ONE,
+		.proc_handler	= bpf_unpriv_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "bpf_stats_enabled",


