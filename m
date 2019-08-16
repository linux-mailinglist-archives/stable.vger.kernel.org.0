Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4581890AB4
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 00:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfHPWFl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 16 Aug 2019 18:05:41 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:50878 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbfHPWFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 18:05:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hykLp-0003ur-MB; Fri, 16 Aug 2019 23:05:37 +0100
Date:   Fri, 16 Aug 2019 23:05:36 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.14 3/4] bpf: add bpf_jit_limit knob to restrict unpriv
 allocations
Message-ID: <20190816220536.GC9843@xylophone.i.decadent.org.uk>
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
---
 Documentation/sysctl/net.txt |  8 ++++++
 include/linux/filter.h       |  1 +
 kernel/bpf/core.c            | 49 +++++++++++++++++++++++++++++++++---
 net/core/sysctl_net_core.c   | 10 ++++++--
 4 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/Documentation/sysctl/net.txt b/Documentation/sysctl/net.txt
index b67044a2575f..e12b39f40a6b 100644
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
 
diff --git a/include/linux/filter.h b/include/linux/filter.h
index ac2272778f2e..b0b00cdff433 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -729,6 +729,7 @@ struct sock *do_sk_redirect_map(struct sk_buff *skb);
 extern int bpf_jit_enable;
 extern int bpf_jit_harden;
 extern int bpf_jit_kallsyms;
+extern int bpf_jit_limit;
 
 typedef void (*bpf_jit_fill_hole_t)(void *area, unsigned int size);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 661fb837b168..2c40159038ef 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -290,10 +290,13 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
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
@@ -489,27 +492,64 @@ int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
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
@@ -522,7 +562,10 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 
 void bpf_jit_binary_free(struct bpf_binary_header *hdr)
 {
+	u32 pages = hdr->pages;
+
 	module_memfree(hdr);
+	bpf_jit_uncharge_modmem(pages);
 }
 
 /* This symbol is only overridden by archs that have different
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index b57d29388e34..b10d839aeee7 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -272,7 +272,6 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	return ret;
 }
 
-# ifdef CONFIG_HAVE_EBPF_JIT
 static int
 proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				    void __user *buffer, size_t *lenp,
@@ -283,7 +282,6 @@ proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
-# endif
 #endif
 
 static struct ctl_table net_core_table[] = {
@@ -390,6 +388,14 @@ static struct ctl_table net_core_table[] = {
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
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


