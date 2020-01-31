Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7703814ED3A
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 14:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgAaN3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 08:29:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:49858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728514AbgAaN3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 08:29:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 107B7AC9D;
        Fri, 31 Jan 2020 13:29:02 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linuxppc-dev@lists.ozlabs.org,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Libor Pechacek <lpechacek@suse.cz>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Suchanek <msuchanek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Leonardo Bras <leonardo@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH v2] powerpc: drmem: avoid NULL pointer dereference when drmem is unavailable
Date:   Fri, 31 Jan 2020 14:28:29 +0100
Message-Id: <20200131132829.10281-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200128101945.GA20336@fm.suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Libor Pechacek <lpechacek@suse.cz>

In guests without hotplugagble memory drmem structure is only zero
initialized. Trying to manipulate DLPAR parameters results in a crash.

$ echo "memory add count 1" > /sys/kernel/dlpar
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: af_packet(E) rfkill(E) nvram(E) vmx_crypto(E)
gf128mul(E) e1000(E) virtio_balloon(E) rtc_generic(E) crct10dif_vpmsum(E)
btrfs(E) blake2b_generic(E) libcrc32c(E) xor(E) raid6_pq(E) virtio_rng(E)
virtio_blk(E) ohci_pci(E) ehci_pci(E) ohci_hcd(E) ehci_hcd(E)
crc32c_vpmsum(E) usbcore(E) virtio_pci(E) virtio_ring(E) virtio(E) sg(E)
dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E)
scsi_mod(E)
CPU: 1 PID: 4114 Comm: bash Kdump: loaded Tainted: G            E     5.5.0-rc6-2-default #1
NIP:  c0000000000ff294 LR: c0000000000ff248 CTR: 0000000000000000
REGS: c0000000fb9d3880 TRAP: 0300   Tainted: G            E      (5.5.0-rc6-2-default)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28242428  XER: 20000000
CFAR: c0000000009a6c10 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
GPR00: c0000000000ff248 c0000000fb9d3b10 c000000001682e00 0000000000000033
GPR04: c0000000ff30bf90 c0000000ff394800 0000000000005110 ffffffffffffffe8
GPR08: 0000000000000000 0000000000000000 00000000fe1c0000 0000000000000000
GPR12: 0000000000002200 c00000003fffee00 0000000000000000 000000011cbc37c0
GPR16: 000000011cb27ed0 0000000000000000 000000011cb6dd10 0000000000000000
GPR20: 000000011cb7db28 000001003ce035f0 000000011cbc7828 000000011cbc6c70
GPR24: 000001003cf01210 0000000000000000 c0000000ffade4e0 c000000002d7216b
GPR28: 0000000000000001 c000000002d78560 0000000000000000 c0000000015458d0
NIP [c0000000000ff294] dlpar_memory+0x6e4/0xd00
LR [c0000000000ff248] dlpar_memory+0x698/0xd00
Call Trace:
[c0000000fb9d3b10] [c0000000000ff248] dlpar_memory+0x698/0xd00 (unreliable)
[c0000000fb9d3ba0] [c0000000000f5990] handle_dlpar_errorlog+0xc0/0x190
[c0000000fb9d3c10] [c0000000000f5c58] dlpar_store+0x198/0x4a0
[c0000000fb9d3cd0] [c000000000c4cb00] kobj_attr_store+0x30/0x50
[c0000000fb9d3cf0] [c0000000005a37b4] sysfs_kf_write+0x64/0x90
[c0000000fb9d3d10] [c0000000005a2c90] kernfs_fop_write+0x1b0/0x290
[c0000000fb9d3d60] [c0000000004a2bec] __vfs_write+0x3c/0x70
[c0000000fb9d3d80] [c0000000004a6560] vfs_write+0xd0/0x260
[c0000000fb9d3dd0] [c0000000004a69ac] ksys_write+0xdc/0x130
[c0000000fb9d3e20] [c00000000000b478] system_call+0x5c/0x68
Instruction dump:
ebc90000 1ce70018 38e7ffe8 7cfe3a14 7fbe3840 419dff14 fb610068 7fc9f378
39000000 4800000c 60000000 4195fef4 <81490010> 39290018 38c80001 7ea93840
---[ end trace cc2dd8152608c295 ]---

Taking closer look at the code, I can see that for_each_drmem_lmb is a
macro expanding into `for (lmb = &drmem_info->lmbs[0]; lmb <=
&drmem_info->lmbs[drmem_info->n_lmbs - 1]; lmb++)`. When drmem_info->lmbs
is NULL, the loop would iterate through the whole address range if it
weren't stopped by the NULL pointer dereference on the next line.

This patch aligns for_each_drmem_lmb and for_each_drmem_lmb_in_range macro
behavior with the common C semantics, where the end marker does not belong
to the scanned range, and alters get_lmb_range() semantics. As a side
effect, the wraparound observed in the crash is prevented.

Fixes: 6c6ea53725b3 ("powerpc/mm: Separate ibm, dynamic-memory data from DT format")
Cc: Michal Suchanek <msuchanek@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
v2: rename last_lmb -> limit, clarify error condition.
---
 arch/powerpc/include/asm/drmem.h                | 4 ++--
 arch/powerpc/platforms/pseries/hotplug-memory.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/drmem.h b/arch/powerpc/include/asm/drmem.h
index 3d76e1c388c2..28c3d936fdf3 100644
--- a/arch/powerpc/include/asm/drmem.h
+++ b/arch/powerpc/include/asm/drmem.h
@@ -27,12 +27,12 @@ struct drmem_lmb_info {
 extern struct drmem_lmb_info *drmem_info;
 
 #define for_each_drmem_lmb_in_range(lmb, start, end)		\
-	for ((lmb) = (start); (lmb) <= (end); (lmb)++)
+	for ((lmb) = (start); (lmb) < (end); (lmb)++)
 
 #define for_each_drmem_lmb(lmb)					\
 	for_each_drmem_lmb_in_range((lmb),			\
 		&drmem_info->lmbs[0],				\
-		&drmem_info->lmbs[drmem_info->n_lmbs - 1])
+		&drmem_info->lmbs[drmem_info->n_lmbs])
 
 /*
  * The of_drconf_cell_v1 struct defines the layout of the LMB data
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index c126b94d1943..a6b207dd1d7d 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -223,7 +223,7 @@ static int get_lmb_range(u32 drc_index, int n_lmbs,
 			 struct drmem_lmb **end_lmb)
 {
 	struct drmem_lmb *lmb, *start, *end;
-	struct drmem_lmb *last_lmb;
+	struct drmem_lmb *limit;
 
 	start = NULL;
 	for_each_drmem_lmb(lmb) {
@@ -236,10 +236,10 @@ static int get_lmb_range(u32 drc_index, int n_lmbs,
 	if (!start)
 		return -EINVAL;
 
-	end = &start[n_lmbs - 1];
+	end = &start[n_lmbs];
 
-	last_lmb = &drmem_info->lmbs[drmem_info->n_lmbs - 1];
-	if (end > last_lmb)
+	limit = &drmem_info->lmbs[drmem_info->n_lmbs];
+	if (end > limit)
 		return -EINVAL;
 
 	*start_lmb = start;
-- 
2.23.0

