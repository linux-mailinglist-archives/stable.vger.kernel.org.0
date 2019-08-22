Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED4399CBE
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391556AbfHVRYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388119AbfHVRYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:47 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77EBF21743;
        Thu, 22 Aug 2019 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494686;
        bh=vCnG6nfAkHenqBbOG37dUmz84sjUM/PCLY/Ncld4Su4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwPyqHt64CQbCCAr7qPXFNaurOGGy52UmqqV4aU0WZX/EM7IgUB8EtlN+AbP32GB6
         xG64d1U7LA2/9cUS3qFtZwcy7zuODQ0pefT+U/OU+OnmZJtXfs+CYhCr9KY02n5Z56
         PJlIHGrrJ8Kr+giNrDpS8Jpyv+sutRTT6xLEshxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 06/71] bpf: restrict access to core bpf sysctls
Date:   Thu, 22 Aug 2019 10:18:41 -0700
Message-Id: <20190822171726.829659211@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sysctl_net_core.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -251,6 +251,41 @@ static int proc_do_rss_key(struct ctl_ta
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
@@ -326,7 +361,7 @@ static struct ctl_table net_core_table[]
 		.data		= &bpf_jit_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_bpf_enable,
 # ifdef CONFIG_BPF_JIT_ALWAYS_ON
 		.extra1		= &one,
 		.extra2		= &one,
@@ -341,7 +376,7 @@ static struct ctl_table net_core_table[]
 		.data		= &bpf_jit_harden,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -350,7 +385,7 @@ static struct ctl_table net_core_table[]
 		.data		= &bpf_jit_kallsyms,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},


