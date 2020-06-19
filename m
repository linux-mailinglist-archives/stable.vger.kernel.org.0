Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80366201437
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390840AbgFSPFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390855AbgFSPFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:05:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CA4021941;
        Fri, 19 Jun 2020 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579147;
        bh=Z16FR46Wfib9ObRljsI1+fcv3Z7krEYvl7iFsM+AQ1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eY3fch+CpF56DAPp/ZGiQcFpnBjsXEMhXYOvSYVRNW20jmmKRmW1F+eJo/I8KaLlQ
         ELy5xitj6BfW3uEwxzOJErA0bcwF0ZAZEODUmNQQv9vBizHKRCFXiLnTZlPAT2cjZp
         HZIVY0NlI72B3HFr5A7VGeUH4TS3bEnHqE++roWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bingbu Cao <bingbu.cao@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/261] media: staging: imgu: do not hold spinlock during freeing mmu page table
Date:   Fri, 19 Jun 2020 16:30:16 +0200
Message-Id: <20200619141650.151003073@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit e1ebe9f9c88e5a78fcc4670a9063c9b3cd87dda4 ]

ImgU need set the mmu page table in memory as uncached, and set back
to write-back when free the page table by set_memory_wb(),
set_memory_wb() can not do flushing without interrupt, so the spinlock
should not be hold during ImgU page alloc and free, the interrupt
should be enabled during memory cache flush.

This patch release spinlock before freeing pages table.

Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-mmu.c b/drivers/staging/media/ipu3/ipu3-mmu.c
index 3d969b0522ab..abcf1f3e5f63 100644
--- a/drivers/staging/media/ipu3/ipu3-mmu.c
+++ b/drivers/staging/media/ipu3/ipu3-mmu.c
@@ -174,8 +174,10 @@ static u32 *imgu_mmu_get_l2pt(struct imgu_mmu *mmu, u32 l1pt_idx)
 	spin_lock_irqsave(&mmu->lock, flags);
 
 	l2pt = mmu->l2pts[l1pt_idx];
-	if (l2pt)
-		goto done;
+	if (l2pt) {
+		spin_unlock_irqrestore(&mmu->lock, flags);
+		return l2pt;
+	}
 
 	spin_unlock_irqrestore(&mmu->lock, flags);
 
@@ -190,8 +192,9 @@ static u32 *imgu_mmu_get_l2pt(struct imgu_mmu *mmu, u32 l1pt_idx)
 
 	l2pt = mmu->l2pts[l1pt_idx];
 	if (l2pt) {
+		spin_unlock_irqrestore(&mmu->lock, flags);
 		imgu_mmu_free_page_table(new_l2pt);
-		goto done;
+		return l2pt;
 	}
 
 	l2pt = new_l2pt;
@@ -200,7 +203,6 @@ static u32 *imgu_mmu_get_l2pt(struct imgu_mmu *mmu, u32 l1pt_idx)
 	pteval = IPU3_ADDR2PTE(virt_to_phys(new_l2pt));
 	mmu->l1pt[l1pt_idx] = pteval;
 
-done:
 	spin_unlock_irqrestore(&mmu->lock, flags);
 	return l2pt;
 }
-- 
2.25.1



