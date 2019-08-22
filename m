Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A148A99D21
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405041AbfHVRjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404116AbfHVRYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:13 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27F462341B;
        Thu, 22 Aug 2019 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494651;
        bh=z/jrqLOwZfeRkKGPWu/9lY0+ojutoygLo5K6GFYjIPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hh3smm6pl1xAQZFo0/JLqC5VEMOe1/mgErdfMngU5qKHb8qqV02wYOUqm8ORKz1ay
         kegdS22ag4V0QK3glxocSqMVM+E8aRv/lruA0m74epMIWwPKba1VVg+8+WK4Y5utG7
         gAA3Fqx8CsyHH0AbPcfJziuQct2zOmdxwRUAz5xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 091/103] bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K
Date:   Thu, 22 Aug 2019 10:19:19 -0700
Message-Id: <20190822171732.856785363@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fdadd04931c2d7cd294dc5b2b342863f94be53a3 ]

Michael and Sandipan report:

  Commit ede95a63b5 introduced a bpf_jit_limit tuneable to limit BPF
  JIT allocations. At compile time it defaults to PAGE_SIZE * 40000,
  and is adjusted again at init time if MODULES_VADDR is defined.

  For ppc64 kernels, MODULES_VADDR isn't defined, so we're stuck with
  the compile-time default at boot-time, which is 0x9c400000 when
  using 64K page size. This overflows the signed 32-bit bpf_jit_limit
  value:

  root@ubuntu:/tmp# cat /proc/sys/net/core/bpf_jit_limit
  -1673527296

  and can cause various unexpected failures throughout the network
  stack. In one case `strace dhclient eth0` reported:

  setsockopt(5, SOL_SOCKET, SO_ATTACH_FILTER, {len=11, filter=0x105dd27f8},
             16) = -1 ENOTSUPP (Unknown error 524)

  and similar failures can be seen with tools like tcpdump. This doesn't
  always reproduce however, and I'm not sure why. The more consistent
  failure I've seen is an Ubuntu 18.04 KVM guest booted on a POWER9
  host would time out on systemd/netplan configuring a virtio-net NIC
  with no noticeable errors in the logs.

Given this and also given that in near future some architectures like
arm64 will have a custom area for BPF JIT image allocations we should
get rid of the BPF_JIT_LIMIT_DEFAULT fallback / default entirely. For
4.21, we have an overridable bpf_jit_alloc_exec(), bpf_jit_free_exec()
so therefore add another overridable bpf_jit_alloc_exec_limit() helper
function which returns the possible size of the memory area for deriving
the default heuristic in bpf_jit_charge_init().

Like bpf_jit_alloc_exec() and bpf_jit_free_exec(), the new
bpf_jit_alloc_exec_limit() assumes that module_alloc() is the default
JIT memory provider, and therefore in case archs implement their custom
module_alloc() we use MODULES_{END,_VADDR} for limits and otherwise for
vmalloc_exec() cases like on ppc64 we use VMALLOC_{END,_START}.

Additionally, for archs supporting large page sizes, we should change
the sysctl to be handled as long to not run into sysctl restrictions
in future.

Fixes: ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv allocations")
Reported-by: Sandipan Das <sandipan@linux.ibm.com>
Reported-by: Michael Roth <mdroth@linux.vnet.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Michael Roth <mdroth@linux.vnet.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h     |  2 +-
 kernel/bpf/core.c          | 21 +++++++++++++++------
 net/core/sysctl_net_core.c | 20 +++++++++++++++++---
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 689bba1020079..0837d904405a3 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -599,7 +599,7 @@ void bpf_warn_invalid_xdp_action(u32 act);
 #ifdef CONFIG_BPF_JIT
 extern int bpf_jit_enable;
 extern int bpf_jit_harden;
-extern int bpf_jit_limit;
+extern long bpf_jit_limit;
 
 typedef void (*bpf_jit_fill_hole_t)(void *area, unsigned int size);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 09df9bbfb48ed..df2ebce927ec4 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -208,25 +208,34 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 }
 
 #ifdef CONFIG_BPF_JIT
-# define BPF_JIT_LIMIT_DEFAULT	(PAGE_SIZE * 40000)
-
 /* All BPF JIT sysctl knobs here. */
 int bpf_jit_enable   __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_ALWAYS_ON);
 int bpf_jit_harden   __read_mostly;
-int bpf_jit_limit    __read_mostly = BPF_JIT_LIMIT_DEFAULT;
+long bpf_jit_limit   __read_mostly;
 
 static atomic_long_t bpf_jit_current;
 
+/* Can be overridden by an arch's JIT compiler if it has a custom,
+ * dedicated BPF backend memory area, or if neither of the two
+ * below apply.
+ */
+u64 __weak bpf_jit_alloc_exec_limit(void)
+{
 #if defined(MODULES_VADDR)
+	return MODULES_END - MODULES_VADDR;
+#else
+	return VMALLOC_END - VMALLOC_START;
+#endif
+}
+
 static int __init bpf_jit_charge_init(void)
 {
 	/* Only used as heuristic here to derive limit. */
-	bpf_jit_limit = min_t(u64, round_up((MODULES_END - MODULES_VADDR) >> 2,
-					    PAGE_SIZE), INT_MAX);
+	bpf_jit_limit = min_t(u64, round_up(bpf_jit_alloc_exec_limit() >> 2,
+					    PAGE_SIZE), LONG_MAX);
 	return 0;
 }
 pure_initcall(bpf_jit_charge_init);
-#endif
 
 static int bpf_jit_charge_modmem(u32 pages)
 {
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 58d76ca459377..a6fc82704f0c1 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -28,6 +28,8 @@ static int two __maybe_unused = 2;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
+static long long_one __maybe_unused = 1;
+static long long_max __maybe_unused = LONG_MAX;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
@@ -263,6 +265,17 @@ proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
+
+static int
+proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
+				     void __user *buffer, size_t *lenp,
+				     loff_t *ppos)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
+}
 #endif
 
 static struct ctl_table net_core_table[] = {
@@ -349,10 +362,11 @@ static struct ctl_table net_core_table[] = {
 	{
 		.procname	= "bpf_jit_limit",
 		.data		= &bpf_jit_limit,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(long),
 		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
-		.extra1		= &one,
+		.proc_handler	= proc_dolongvec_minmax_bpf_restricted,
+		.extra1		= &long_one,
+		.extra2		= &long_max,
 	},
 #endif
 	{
-- 
2.20.1



