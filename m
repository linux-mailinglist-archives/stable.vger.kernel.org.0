Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9688F1AEE7B
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgDROMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbgDROJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:09:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2107522264;
        Sat, 18 Apr 2020 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587218999;
        bh=0PJdmnhUCsTCwdTxrc85iviAyXqH9RK8DKfgmt6eieQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GF99DJLxjgb8F3Zw68GMFbCqfpTCAQU65Iju5OKE+HwzWlunh1A3TVAnHnuxrVHqh
         lNf57hWtDp0gN+K8m6g2I9i+owesuK82thXD9Ti7zhMozwm2I2LoQmBdqClpUnrffN
         xEg7QBtPdbiiwZqQGqWVZ/TEoSa79q0J02uFR1Ik=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 38/75] powerpc/pseries: Fix MCE handling on pseries
Date:   Sat, 18 Apr 2020 10:08:33 -0400
Message-Id: <20200418140910.8280-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

[ Upstream commit a95a0a1654f16366360399574e10efd87e867b39 ]

MCE handling on pSeries platform fails as recent rework to use common
code for pSeries and PowerNV in machine check error handling tries to
access per-cpu variables in realmode. The per-cpu variables may be
outside the RMO region on pSeries platform and needs translation to be
enabled for access. Just moving these per-cpu variable into RMO region
did'nt help because we queue some work to workqueues in real mode, which
again tries to touch per-cpu variables. Also fwnmi_release_errinfo()
cannot be called when translation is not enabled.

This patch fixes this by enabling translation in the exception handler
when all required real mode handling is done. This change only affects
the pSeries platform.

Without this fix below kernel crash is seen on injecting
SLB multihit:

BUG: Unable to handle kernel data access on read at 0xc00000027b205950
Faulting instruction address: 0xc00000000003b7e0
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: mcetest_slb(OE+) af_packet(E) xt_tcpudp(E) ip6t_rpfilter(E) ip6t_REJECT(E) ipt_REJECT(E) xt_conntrack(E) ip_set(E) nfnetlink(E) ebtable_nat(E) ebtable_broute(E) ip6table_nat(E) ip6table_mangle(E) ip6table_raw(E) ip6table_security(E) iptable_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) iptable_mangle(E) iptable_raw(E) iptable_security(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) x_tables(E) xfs(E) ibmveth(E) vmx_crypto(E) gf128mul(E) uio_pdrv_genirq(E) uio(E) crct10dif_vpmsum(E) rtc_generic(E) btrfs(E) libcrc32c(E) xor(E) zstd_decompress(E) zstd_compress(E) raid6_pq(E) sr_mod(E) sd_mod(E) cdrom(E) ibmvscsi(E) scsi_transport_srp(E) crc32c_vpmsum(E) dm_mod(E) sg(E) scsi_mod(E)
CPU: 34 PID: 8154 Comm: insmod Kdump: loaded Tainted: G OE 5.5.0-mahesh #1
NIP: c00000000003b7e0 LR: c0000000000f2218 CTR: 0000000000000000
REGS: c000000007dcb960 TRAP: 0300 Tainted: G OE (5.5.0-mahesh)
MSR: 8000000000001003 <SF,ME,RI,LE> CR: 28002428 XER: 20040000
CFAR: c0000000000f2214 DAR: c00000027b205950 DSISR: 40000000 IRQMASK: 0
GPR00: c0000000000f2218 c000000007dcbbf0 c000000001544800 c000000007dcbd70
GPR04: 0000000000000001 c000000007dcbc98 c008000000d00258 c0080000011c0000
GPR08: 0000000000000000 0000000300000003 c000000001035950 0000000003000048
GPR12: 000000027a1d0000 c000000007f9c000 0000000000000558 0000000000000000
GPR16: 0000000000000540 c008000001110000 c008000001110540 0000000000000000
GPR20: c00000000022af10 c00000025480fd70 c008000001280000 c00000004bfbb300
GPR24: c000000001442330 c00800000800000d c008000008000000 4009287a77000510
GPR28: 0000000000000000 0000000000000002 c000000001033d30 0000000000000001
NIP [c00000000003b7e0] save_mce_event+0x30/0x240
LR [c0000000000f2218] pseries_machine_check_realmode+0x2c8/0x4f0
Call Trace:
Instruction dump:
3c4c0151 38429050 7c0802a6 60000000 fbc1fff0 fbe1fff8 f821ffd1 3d42ffaf
3fc2ffaf e98d0030 394a1150 3bdef530 <7d6a62aa> 1d2b0048 2f8b0063 380b0001
---[ end trace 46fd63f36bbdd940 ]---

Fixes: 9ca766f9891d ("powerpc/64s/pseries: machine check convert to use common event code")
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200320110119.10207-1-ganeshgr@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/ras.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 1d7f973c647b3..43710b69e09eb 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -683,6 +683,17 @@ static int mce_handle_error(struct pt_regs *regs, struct rtas_error_log *errp)
 #endif
 
 out:
+	/*
+	 * Enable translation as we will be accessing per-cpu variables
+	 * in save_mce_event() which may fall outside RMO region, also
+	 * leave it enabled because subsequently we will be queuing work
+	 * to workqueues where again per-cpu variables accessed, besides
+	 * fwnmi_release_errinfo() crashes when called in realmode on
+	 * pseries.
+	 * Note: All the realmode handling like flushing SLB entries for
+	 *       SLB multihit is done by now.
+	 */
+	mtmsr(mfmsr() | MSR_IR | MSR_DR);
 	save_mce_event(regs, disposition == RTAS_DISP_FULLY_RECOVERED,
 			&mce_err, regs->nip, eaddr, paddr);
 
-- 
2.20.1

