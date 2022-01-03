Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FA74832F2
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbiACOcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiACOaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA76C061785;
        Mon,  3 Jan 2022 06:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78BA8B80F00;
        Mon,  3 Jan 2022 14:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EF1C36AEB;
        Mon,  3 Jan 2022 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220218;
        bh=BBC47Rs6vZ7TU15uF7EK1i9XjclOZAi+HsNIJvWMS/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwdV48+DwWcvFEVKE3Z0oyS85ScOBzU9Os9mIFPrPVXb2gBjKQ7no0ogFWqmiz1Dr
         M0P+eflVTRZKbhi738UK0YYwdqSCOmSFjL+nE6VItHXzxV+10HrP8XsLJMx2GiXUPO
         6f9HmowD1sH0fV+U0YoK8QkGeUu5oaZOBOtc23A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 48/48] bpf: Add kconfig knob for disabling unpriv bpf by default
Date:   Mon,  3 Jan 2022 15:24:25 +0100
Message-Id: <20220103142055.095583337@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/kernel.rst |   17 +++++++++++++---
 init/Kconfig                                |   10 +++++++++
 kernel/bpf/syscall.c                        |    3 +-
 kernel/sysctl.c                             |   29 +++++++++++++++++++++++-----
 4 files changed, 50 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1457,11 +1457,22 @@ unprivileged_bpf_disabled
 =========================
 
 Writing 1 to this entry will disable unprivileged calls to ``bpf()``;
-once disabled, calling ``bpf()`` without ``CAP_SYS_ADMIN`` will return
-``-EPERM``.
+once disabled, calling ``bpf()`` without ``CAP_SYS_ADMIN`` or ``CAP_BPF``
+will return ``-EPERM``. Once set to 1, this can't be cleared from the
+running kernel anymore.
 
-Once set, this can't be cleared.
+Writing 2 to this entry will also disable unprivileged calls to ``bpf()``,
+however, an admin can still change this setting later on, if needed, by
+writing 0 or 1 to this entry.
 
+If ``BPF_UNPRIV_DEFAULT_OFF`` is enabled in the kernel config, then this
+entry will default to 2 instead of 0.
+
+= =============================================================
+0 Unprivileged calls to ``bpf()`` are enabled
+1 Unprivileged calls to ``bpf()`` are disabled without recovery
+2 Unprivileged calls to ``bpf()`` are disabled
+= =============================================================
 
 watchdog
 ========
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1722,6 +1722,16 @@ config BPF_JIT_DEFAULT_ON
 	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
 	depends on HAVE_EBPF_JIT && BPF_JIT
 
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
 source "kernel/bpf/preload/Kconfig"
 
 config USERFAULTFD
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -50,7 +50,8 @@ static DEFINE_SPINLOCK(map_idr_lock);
 static DEFINE_IDR(link_idr);
 static DEFINE_SPINLOCK(link_idr_lock);
 
-int sysctl_unprivileged_bpf_disabled __read_mostly;
+int sysctl_unprivileged_bpf_disabled __read_mostly =
+	IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
 
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -233,7 +233,27 @@ static int bpf_stats_handler(struct ctl_
 	mutex_unlock(&bpf_stats_enabled_mutex);
 	return ret;
 }
-#endif
+
+static int bpf_unpriv_handler(struct ctl_table *table, int write,
+			      void *buffer, size_t *lenp, loff_t *ppos)
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
+#endif /* CONFIG_BPF_SYSCALL && CONFIG_SYSCTL */
 
 /*
  * /proc/sys support
@@ -2626,10 +2646,9 @@ static struct ctl_table kern_table[] = {
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


