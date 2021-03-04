Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F40E32D2C0
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 13:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbhCDMUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 07:20:33 -0500
Received: from 8bytes.org ([81.169.241.247]:57604 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240421AbhCDMUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 07:20:24 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A4A0722E; Thu,  4 Mar 2021 13:19:42 +0100 (CET)
Date:   Thu, 4 Mar 2021 13:19:41 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     Will Deacon <will@kernel.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        valesini@yandex-team.ru, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: Fix sleeping in atomic in
 increase_address_space()
Message-ID: <20210304121941.GB26414@8bytes.org>
References: <20210217143004.19165-1-arbn@yandex-team.com>
 <20210217181002.GC4304@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217181002.GC4304@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 06:10:02PM +0000, Will Deacon wrote:
> >  drivers/iommu/amd/iommu.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> Acked-by: Will Deacon <will@kernel.org>

Applied for v5.12, thanks.

There were some conflicts which I resolved, can you please check the
result, Andrey? The updated patch is attached.

From 140456f994195b568ecd7fc2287a34eadffef3ca Mon Sep 17 00:00:00 2001
From: Andrey Ryabinin <arbn@yandex-team.com>
Date: Wed, 17 Feb 2021 17:30:04 +0300
Subject: [PATCH] iommu/amd: Fix sleeping in atomic in increase_address_space()

increase_address_space() calls get_zeroed_page(gfp) under spin_lock with
disabled interrupts. gfp flags passed to increase_address_space() may allow
sleeping, so it comes to this:

 BUG: sleeping function called from invalid context at mm/page_alloc.c:4342
 in_atomic(): 1, irqs_disabled(): 1, pid: 21555, name: epdcbbf1qnhbsd8

 Call Trace:
  dump_stack+0x66/0x8b
  ___might_sleep+0xec/0x110
  __alloc_pages_nodemask+0x104/0x300
  get_zeroed_page+0x15/0x40
  iommu_map_page+0xdd/0x3e0
  amd_iommu_map+0x50/0x70
  iommu_map+0x106/0x220
  vfio_iommu_type1_ioctl+0x76e/0x950 [vfio_iommu_type1]
  do_vfs_ioctl+0xa3/0x6f0
  ksys_ioctl+0x66/0x70
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x4e/0x100
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by moving get_zeroed_page() out of spin_lock/unlock section.

Fixes: 754265bcab ("iommu/amd: Fix race in increase_address_space()")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210217143004.19165-1-arbn@yandex-team.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd/io_pgtable.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 1c4961e05c12..bb0ee5c9fde7 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -182,6 +182,10 @@ static bool increase_address_space(struct protection_domain *domain,
 	bool ret = true;
 	u64 *pte;
 
+	pte = (void *)get_zeroed_page(gfp);
+	if (!pte)
+		return false;
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	if (address <= PM_LEVEL_SIZE(domain->iop.mode))
@@ -191,10 +195,6 @@ static bool increase_address_space(struct protection_domain *domain,
 	if (WARN_ON_ONCE(domain->iop.mode == PAGE_MODE_6_LEVEL))
 		goto out;
 
-	pte = (void *)get_zeroed_page(gfp);
-	if (!pte)
-		goto out;
-
 	*pte = PM_LEVEL_PDE(domain->iop.mode, iommu_virt_to_phys(domain->iop.root));
 
 	domain->iop.root  = pte;
@@ -208,10 +208,12 @@ static bool increase_address_space(struct protection_domain *domain,
 	 */
 	amd_iommu_domain_set_pgtable(domain, pte, domain->iop.mode);
 
+	pte = NULL;
 	ret = true;
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
+	free_page((unsigned long)pte);
 
 	return ret;
 }
-- 
2.26.2

