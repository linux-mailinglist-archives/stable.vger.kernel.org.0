Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD4799CA3
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391611AbfHVRYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391602AbfHVRYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:53 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372CE23407;
        Thu, 22 Aug 2019 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494692;
        bh=UrRX+YAvAnzmTTdaf0EAwx3YweqXDSSy+g35XFQF+ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcsVHLCuwrFvIN+raKTxrMuTt1OR/j+Ms92j937ajJq/nlg8DVHkOdNkfyj6qCAn2
         XeyqJ+MkxZc2MCNP4I1yTPH+YE+y4GORDR0Vtvd4O4LvCjmzNXPgyjZavjnEXtZ0Vd
         FKsEEvKqAi20mcARDx0LbF7hqU4eTXhzau0Qz7lQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 4.14 07/71] bpf: add bpf_jit_limit knob to restrict unpriv allocations
Date:   Thu, 22 Aug 2019 10:18:42 -0700
Message-Id: <20190822171726.904054988@linuxfoundation.org>
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

commit ede95a63b5e84ddeea6b0c473b36ab8bfd8c6ce3 upstream.

Rick reported that the BPF JIT could potentially fill the entire module
space with BPF programs from unprivileged users which would prevent later
attempts to load normal kernel modules or privileged BPF programs, for
example. If JIT was enabled but unsuccessful to generate the image, then
before commit 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
we would always fall back to the BPF interpreter. Nowadays in the case
where the CONFIG_BPF_JIT_ALWAYS_ON could be set, then the load will abort
with a failure since the BPF interpreter was compiled out.

Add a global limit and enforce it for unprivileged users such that in case
of BPF interpreter compiled out we fail once the limit has been reached
or we fall back to BPF interpreter earlier w/o using module mem if latter
was compiled in. In a next step, fair share among unprivileged users can
be resolved in particular for the case where we would fail hard once limit
is reached.

Fixes: 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
Co-Developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sysctl/net.txt |    8 +++++++
 include/linux/filter.h       |    1 
 kernel/bpf/core.c            |   49 ++++++++++++++++++++++++++++++++++++++++---
 net/core/sysctl_net_core.c   |   10 +++++++-
 4 files changed, 63 insertions(+), 5 deletions(-)

--- a/Documentation/sysctl/net.txt
+++ b/Documentation/sysctl/net.txt
@@ -91,6 +91,14 @@ Values :
 	0 - disable JIT kallsyms export (default value)
 	1 - enable JIT kallsyms export for privileged users only
 
+bpf_jit_limit
+-------------
+
+This enforces a global limit for memory allocations to the BPF JIT
+compiler in order to reject unprivileged JIT requests once it has
+been surpassed. bpf_jit_limit contains the value of the global limit
+in bytes.
+
 dev_weight
 --------------
 
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -729,6 +729,7 @@ struct sock *do_sk_redirect_map(struct s
 extern int bpf_jit_enable;
 extern int bpf_jit_harden;
 extern int bpf_jit_kallsyms;
+extern int bpf_jit_limit;
 
 typedef void (*bpf_jit_fill_hole_t)(void *area, unsigned int size);
 
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -290,10 +290,13 @@ struct bpf_prog *bpf_patch_insn_single(s
 }
 
 #ifdef CONFIG_BPF_JIT
+# define BPF_JIT_LIMIT_DEFAULT	(PAGE_SIZE * 40000)
+
 /* All BPF JIT sysctl knobs here. */
 int bpf_jit_enable   __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_ALWAYS_ON);
 int bpf_jit_harden   __read_mostly;
 int bpf_jit_kallsyms __read_mostly;
+int bpf_jit_limit    __read_mostly = BPF_JIT_LIMIT_DEFAULT;
 
 static __always_inline void
 bpf_get_prog_addr_region(const struct bpf_prog *prog,
@@ -489,27 +492,64 @@ int bpf_get_kallsym(unsigned int symnum,
 	return ret;
 }
 
+static atomic_long_t bpf_jit_current;
+
+#if defined(MODULES_VADDR)
+static int __init bpf_jit_charge_init(void)
+{
+	/* Only used as heuristic here to derive limit. */
+	bpf_jit_limit = min_t(u64, round_up((MODULES_END - MODULES_VADDR) >> 2,
+					    PAGE_SIZE), INT_MAX);
+	return 0;
+}
+pure_initcall(bpf_jit_charge_init);
+#endif
+
+static int bpf_jit_charge_modmem(u32 pages)
+{
+	if (atomic_long_add_return(pages, &bpf_jit_current) >
+	    (bpf_jit_limit >> PAGE_SHIFT)) {
+		if (!capable(CAP_SYS_ADMIN)) {
+			atomic_long_sub(pages, &bpf_jit_current);
+			return -EPERM;
+		}
+	}
+
+	return 0;
+}
+
+static void bpf_jit_uncharge_modmem(u32 pages)
+{
+	atomic_long_sub(pages, &bpf_jit_current);
+}
+
 struct bpf_binary_header *
 bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 		     unsigned int alignment,
 		     bpf_jit_fill_hole_t bpf_fill_ill_insns)
 {
 	struct bpf_binary_header *hdr;
-	unsigned int size, hole, start;
+	u32 size, hole, start, pages;
 
 	/* Most of BPF filters are really small, but if some of them
 	 * fill a page, allow at least 128 extra bytes to insert a
 	 * random section of illegal instructions.
 	 */
 	size = round_up(proglen + sizeof(*hdr) + 128, PAGE_SIZE);
+	pages = size / PAGE_SIZE;
+
+	if (bpf_jit_charge_modmem(pages))
+		return NULL;
 	hdr = module_alloc(size);
-	if (hdr == NULL)
+	if (!hdr) {
+		bpf_jit_uncharge_modmem(pages);
 		return NULL;
+	}
 
 	/* Fill space with illegal/arch-dep instructions. */
 	bpf_fill_ill_insns(hdr, size);
 
-	hdr->pages = size / PAGE_SIZE;
+	hdr->pages = pages;
 	hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
 		     PAGE_SIZE - sizeof(*hdr));
 	start = (get_random_int() % hole) & ~(alignment - 1);
@@ -522,7 +562,10 @@ bpf_jit_binary_alloc(unsigned int progle
 
 void bpf_jit_binary_free(struct bpf_binary_header *hdr)
 {
+	u32 pages = hdr->pages;
+
 	module_memfree(hdr);
+	bpf_jit_uncharge_modmem(pages);
 }
 
 /* This symbol is only overridden by archs that have different
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -272,7 +272,6 @@ static int proc_dointvec_minmax_bpf_enab
 	return ret;
 }
 
-# ifdef CONFIG_HAVE_EBPF_JIT
 static int
 proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				    void __user *buffer, size_t *lenp,
@@ -283,7 +282,6 @@ proc_dointvec_minmax_bpf_restricted(stru
 
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
-# endif
 #endif
 
 static struct ctl_table net_core_table[] = {
@@ -390,6 +388,14 @@ static struct ctl_table net_core_table[]
 		.extra2		= &one,
 	},
 # endif
+	{
+		.procname	= "bpf_jit_limit",
+		.data		= &bpf_jit_limit,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
+		.extra1		= &one,
+	},
 #endif
 	{
 		.procname	= "netdev_tstamp_prequeue",


