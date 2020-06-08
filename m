Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3C41F2219
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgFHXGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgFHXGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D02F20812;
        Mon,  8 Jun 2020 23:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657577;
        bh=EKcNGXPVsXSo798RYkf9ibs72j1OBs1xifDbNicZdtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhnVAD6CsmlWxXOjH/NTd2dB+dcBM+KF5x478dLyosgMmjGuSHZ/GE6/aSLCOj8Fd
         raGXBcjYZkN5/7CWHnatcOBrNZ1R753eyeSkr6Z06ycFYx5RArMnYm2GQK7tFny5cu
         ZXatgC74TS/k4CMyuo9yr9FDje03ZKU6Mqw+TrC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bingbu Cao <bingbu.cao@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.7 007/274] media: staging: imgu: do not hold spinlock during freeing mmu page table
Date:   Mon,  8 Jun 2020 19:01:40 -0400
Message-Id: <20200608230607.3361041-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5f3ff964f3e7..cb9bf5fb29a5 100644
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

