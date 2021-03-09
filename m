Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF629332E34
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 19:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCISX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 13:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCISXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 13:23:15 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D56BC06174A;
        Tue,  9 Mar 2021 10:23:15 -0800 (PST)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 530DA2E15A0;
        Tue,  9 Mar 2021 21:23:10 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id yuCti61pxa-N8J88Z6Q;
        Tue, 09 Mar 2021 21:23:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1615314190; bh=ghIL96dAj+teO7QRVsuWgtcm+qr8fBxdtE412wvD4Ek=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=sTDWx4bwgzAXwWWRXuisf9SyPxZzUts6Rgolz27d+htGGZluzVR4b2WDTIPTjh427
         NiUR2gC0aFAQNjoomWKwzt+/l2IV89P8v2PwcFykiOYEMdCGSg7RIshDVj5X00ocIo
         rM7XIYCw+rXzWLb6pmZ1EssT7fWTEItGY8wo8vOk=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:203::1:15])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id T5bJwzP5HK-N8nWRD8I;
        Tue, 09 Mar 2021 21:23:08 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     jroedel@suse.de, will@kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH stable 4.9] iommu/amd: Fix sleeping in atomic in increase_address_space()
Date:   Tue,  9 Mar 2021 21:24:28 +0300
Message-Id: <20210309182430.18849-2-arbn@yandex-team.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210309182430.18849-1-arbn@yandex-team.com>
References: <161512522533161@kroah.com>
 <20210309182430.18849-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 140456f994195b568ecd7fc2287a34eadffef3ca upstream.

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
Link: https://lore.kernel.org/r/20210217143004.19165-1-arbn@yandex-team.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/iommu/amd_iommu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f4a15d9f2bbb2..8377bd388d673 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1331,24 +1331,26 @@ static void increase_address_space(struct protection_domain *domain,
 	unsigned long flags;
 	u64 *pte;
 
+	pte = (void *)get_zeroed_page(gfp);
+	if (!pte)
+		goto out;
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	if (WARN_ON_ONCE(domain->mode == PAGE_MODE_6_LEVEL))
 		/* address space already 64 bit large */
 		goto out;
 
-	pte = (void *)get_zeroed_page(gfp);
-	if (!pte)
-		goto out;
-
 	*pte             = PM_LEVEL_PDE(domain->mode,
 					virt_to_phys(domain->pt_root));
 	domain->pt_root  = pte;
 	domain->mode    += 1;
 	domain->updated  = true;
+	pte              = NULL;
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
+	free_page((unsigned long)pte);
 
 	return;
 }
-- 
2.26.2

