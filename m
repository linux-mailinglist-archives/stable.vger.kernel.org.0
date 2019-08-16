Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E26290AB3
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 00:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfHPWFY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 16 Aug 2019 18:05:24 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:50869 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfHPWFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 18:05:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hykLZ-0003uA-KZ; Fri, 16 Aug 2019 23:05:21 +0100
Date:   Fri, 16 Aug 2019 23:05:20 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.14 2/4] bpf: restrict access to core bpf sysctls
Message-ID: <20190816220520.GB9843@xylophone.i.decadent.org.uk>
References: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 2e4a30983b0f9b19b59e38bbf7427d7fdd480d98 upstream.

Given BPF reaches far beyond just networking these days, it was
never intended to allow setting and in some cases reading those
knobs out of a user namespace root running without CAP_SYS_ADMIN,
thus tighten such access.

Also the bpf_jit_enable = 2 debugging mode should only be allowed
if kptr_restrict is not set since it otherwise can leak addresses
to the kernel log. Dump a note to the kernel log that this is for
debugging JITs only when enabled.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[bwh: Backported to 4.14: We don't have bpf_dump_raw_ok(), so drop the
 condition based on it. This condition only made it a bit harder for a
 privileged user to do something silly.]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 net/core/sysctl_net_core.c | 41 +++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 6d39b4c01fc6..b57d29388e34 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -251,6 +251,41 @@ static int proc_do_rss_key(struct ctl_table *table, int write,
 	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
 }
 
+#ifdef CONFIG_BPF_JIT
+static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
+					   void __user *buffer, size_t *lenp,
+					   loff_t *ppos)
+{
+	int ret, jit_enable = *(int *)table->data;
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	tmp.data = &jit_enable;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret) {
+		*(int *)table->data = jit_enable;
+		if (jit_enable == 2)
+			pr_warn("bpf_jit_enable = 2 was set! NEVER use this in production, only for JIT debugging!\n");
+	}
+	return ret;
+}
+
+# ifdef CONFIG_HAVE_EBPF_JIT
+static int
+proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
+				    void __user *buffer, size_t *lenp,
+				    loff_t *ppos)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+# endif
+#endif
+
 static struct ctl_table net_core_table[] = {
 #ifdef CONFIG_NET
 	{
@@ -326,7 +361,7 @@ static struct ctl_table net_core_table[] = {
 		.data		= &bpf_jit_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_bpf_enable,
 # ifdef CONFIG_BPF_JIT_ALWAYS_ON
 		.extra1		= &one,
 		.extra2		= &one,
@@ -341,7 +376,7 @@ static struct ctl_table net_core_table[] = {
 		.data		= &bpf_jit_harden,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -350,7 +385,7 @@ static struct ctl_table net_core_table[] = {
 		.data		= &bpf_jit_kallsyms,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


