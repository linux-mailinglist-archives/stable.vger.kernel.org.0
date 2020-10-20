Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E2A28C0AC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbgJLTFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391324AbgJLTEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:04:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 807052222F;
        Mon, 12 Oct 2020 19:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529446;
        bh=ExFaKH18wvRgVDPOD9/sVbjT/ogMhKoFhXvzCRb5Nd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2/Fga9oIooFcFLicvS4AREqLXFoDHw+YRtkOMkPQqKyaN7cKHdGnhkQ1BwLFW3Or
         35SAH7VIVhcNi4x1NhwEeu4+CvFspThxvsRIhkM3vn2p3atWPDs0hXZ7dLNnG6Jzk4
         ujT6/TDUV8MkRW4Hw81uYLXOL62W0NgP4zkZQSys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 10/11] arm/arm64: xen: Fix to convert percpu address to gfn correctly
Date:   Mon, 12 Oct 2020 15:03:52 -0400
Message-Id: <20201012190353.3279662-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190353.3279662-1-sashal@kernel.org>
References: <20201012190353.3279662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 5a0677110b73dd3e1766f89159701bfe8ac06808 ]

Use per_cpu_ptr_to_phys() instead of virt_to_phys() for per-cpu
address conversion.

In xen_starting_cpu(), per-cpu xen_vcpu_info address is converted
to gfn by virt_to_gfn() macro. However, since the virt_to_gfn(v)
assumes the given virtual address is in linear mapped kernel memory
area, it can not convert the per-cpu memory if it is allocated on
vmalloc area.

This depends on CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK.
If it is enabled, the first chunk of percpu memory is linear mapped.
In the other case, that is allocated from vmalloc area. Moreover,
if the first chunk of percpu has run out until allocating
xen_vcpu_info, it will be allocated on the 2nd chunk, which is
based on kernel memory or vmalloc memory (depends on
CONFIG_NEED_PER_CPU_KM).

Without this fix and kernel configured to use vmalloc area for
the percpu memory, the Dom0 kernel will fail to boot with following
errors.

[    0.466172] Xen: initializing cpu0
[    0.469601] ------------[ cut here ]------------
[    0.474295] WARNING: CPU: 0 PID: 1 at arch/arm64/xen/../../arm/xen/enlighten.c:153 xen_starting_cpu+0x160/0x180
[    0.484435] Modules linked in:
[    0.487565] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc4+ #4
[    0.493895] Hardware name: Socionext Developer Box (DT)
[    0.499194] pstate: 00000005 (nzcv daif -PAN -UAO BTYPE=--)
[    0.504836] pc : xen_starting_cpu+0x160/0x180
[    0.509263] lr : xen_starting_cpu+0xb0/0x180
[    0.513599] sp : ffff8000116cbb60
[    0.516984] x29: ffff8000116cbb60 x28: ffff80000abec000
[    0.522366] x27: 0000000000000000 x26: 0000000000000000
[    0.527754] x25: ffff80001156c000 x24: fffffdffbfcdb600
[    0.533129] x23: 0000000000000000 x22: 0000000000000000
[    0.538511] x21: ffff8000113a99c8 x20: ffff800010fe4f68
[    0.543892] x19: ffff8000113a9988 x18: 0000000000000010
[    0.549274] x17: 0000000094fe0f81 x16: 00000000deadbeef
[    0.554655] x15: ffffffffffffffff x14: 0720072007200720
[    0.560037] x13: 0720072007200720 x12: 0720072007200720
[    0.565418] x11: 0720072007200720 x10: 0720072007200720
[    0.570801] x9 : ffff8000100fbdc0 x8 : ffff800010715208
[    0.576182] x7 : 0000000000000054 x6 : ffff00001b790f00
[    0.581564] x5 : ffff800010bbf880 x4 : 0000000000000000
[    0.586945] x3 : 0000000000000000 x2 : ffff80000abec000
[    0.592327] x1 : 000000000000002f x0 : 0000800000000000
[    0.597716] Call trace:
[    0.600232]  xen_starting_cpu+0x160/0x180
[    0.604309]  cpuhp_invoke_callback+0xac/0x640
[    0.608736]  cpuhp_issue_call+0xf4/0x150
[    0.612728]  __cpuhp_setup_state_cpuslocked+0x128/0x2c8
[    0.618030]  __cpuhp_setup_state+0x84/0xf8
[    0.622192]  xen_guest_init+0x324/0x364
[    0.626097]  do_one_initcall+0x54/0x250
[    0.630003]  kernel_init_freeable+0x12c/0x2c8
[    0.634428]  kernel_init+0x1c/0x128
[    0.637988]  ret_from_fork+0x10/0x18
[    0.641635] ---[ end trace d95b5309a33f8b27 ]---
[    0.646337] ------------[ cut here ]------------
[    0.651005] kernel BUG at arch/arm64/xen/../../arm/xen/enlighten.c:158!
[    0.657697] Internal error: Oops - BUG: 0 [#1] SMP
[    0.662548] Modules linked in:
[    0.665676] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.9.0-rc4+ #4
[    0.673398] Hardware name: Socionext Developer Box (DT)
[    0.678695] pstate: 00000005 (nzcv daif -PAN -UAO BTYPE=--)
[    0.684338] pc : xen_starting_cpu+0x178/0x180
[    0.688765] lr : xen_starting_cpu+0x144/0x180
[    0.693188] sp : ffff8000116cbb60
[    0.696573] x29: ffff8000116cbb60 x28: ffff80000abec000
[    0.701955] x27: 0000000000000000 x26: 0000000000000000
[    0.707344] x25: ffff80001156c000 x24: fffffdffbfcdb600
[    0.712718] x23: 0000000000000000 x22: 0000000000000000
[    0.718107] x21: ffff8000113a99c8 x20: ffff800010fe4f68
[    0.723481] x19: ffff8000113a9988 x18: 0000000000000010
[    0.728863] x17: 0000000094fe0f81 x16: 00000000deadbeef
[    0.734245] x15: ffffffffffffffff x14: 0720072007200720
[    0.739626] x13: 0720072007200720 x12: 0720072007200720
[    0.745008] x11: 0720072007200720 x10: 0720072007200720
[    0.750390] x9 : ffff8000100fbdc0 x8 : ffff800010715208
[    0.755771] x7 : 0000000000000054 x6 : ffff00001b790f00
[    0.761153] x5 : ffff800010bbf880 x4 : 0000000000000000
[    0.766534] x3 : 0000000000000000 x2 : 00000000deadbeef
[    0.771916] x1 : 00000000deadbeef x0 : ffffffffffffffea
[    0.777304] Call trace:
[    0.779819]  xen_starting_cpu+0x178/0x180
[    0.783898]  cpuhp_invoke_callback+0xac/0x640
[    0.788325]  cpuhp_issue_call+0xf4/0x150
[    0.792317]  __cpuhp_setup_state_cpuslocked+0x128/0x2c8
[    0.797619]  __cpuhp_setup_state+0x84/0xf8
[    0.801779]  xen_guest_init+0x324/0x364
[    0.805683]  do_one_initcall+0x54/0x250
[    0.809590]  kernel_init_freeable+0x12c/0x2c8
[    0.814016]  kernel_init+0x1c/0x128
[    0.817583]  ret_from_fork+0x10/0x18
[    0.821226] Code: d0006980 f9427c00 cb000300 17ffffea (d4210000)
[    0.827415] ---[ end trace d95b5309a33f8b28 ]---
[    0.832076] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    0.839815] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/160196697165.60224.17470743378683334995.stgit@devnote2
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/xen/enlighten.c | 2 +-
 include/xen/arm/page.h   | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index ba7f4c8f5c3e4..b473318da5967 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -170,7 +170,7 @@ static int xen_starting_cpu(unsigned int cpu)
 	pr_info("Xen: initializing cpu%d\n", cpu);
 	vcpup = per_cpu_ptr(xen_vcpu_info, cpu);
 
-	info.mfn = virt_to_gfn(vcpup);
+	info.mfn = percpu_to_gfn(vcpup);
 	info.offset = xen_offset_in_page(vcpup);
 
 	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, xen_vcpu_nr(cpu),
diff --git a/include/xen/arm/page.h b/include/xen/arm/page.h
index f77dcbcba5a60..27d08d4a853c2 100644
--- a/include/xen/arm/page.h
+++ b/include/xen/arm/page.h
@@ -79,6 +79,9 @@ static inline unsigned long bfn_to_pfn(unsigned long bfn)
 #define virt_to_gfn(v)		(pfn_to_gfn(virt_to_phys(v) >> XEN_PAGE_SHIFT))
 #define gfn_to_virt(m)		(__va(gfn_to_pfn(m) << XEN_PAGE_SHIFT))
 
+#define percpu_to_gfn(v)	\
+	(pfn_to_gfn(per_cpu_ptr_to_phys(v) >> XEN_PAGE_SHIFT))
+
 /* Only used in PV code. But ARM guests are always HVM. */
 static inline xmaddr_t arbitrary_virt_to_machine(void *vaddr)
 {
-- 
2.25.1

