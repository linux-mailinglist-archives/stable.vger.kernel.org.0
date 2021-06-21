Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002103AF26A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhFURye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhFURy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDBE061026;
        Mon, 21 Jun 2021 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297931;
        bh=7FejGutx7qigxlPOnRTPF0t+VREiWTptDfU4R0WFxNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABkbAJVzhe1qx8+pKOJdi4GG2HGGVgFVIGPj01gzlvpJEx7r5AM4K3GlBZdodcZNd
         Rnl8PbGfdCS7M2wI/4XPHYCa/BdOiFnhfEq8nLO/xb7yXrfAt9RnvgLq47lNKIoMAA
         h0yAzixR+59pc2uFrDe84LE1y3E4qAbKDGxa6KiV99euVUHPBzXhnl2k2uKaMzFnUG
         y1+1qtfyqKqgeyKY6YueYfIHxWoyn5u0l+mG+6Zpaf1cV7I0OkpysabXNJqlB1+ED5
         v5n6z7XgMftKp1ppzjCtscDKJFqZ/gpOAryQ65Ddqh3CSti5Kydk4DbAIKFhMpt4EL
         knIiuR86J+SCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 08/39] dmaengine: idxd: Fix missing error code in idxd_cdev_open()
Date:   Mon, 21 Jun 2021 13:51:24 -0400
Message-Id: <20210621175156.735062-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 99b18e88a1cf737ae924123d63b46d9a3d17b1af ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc'.

Eliminate the follow smatch warning:

drivers/dma/idxd/cdev.c:113 idxd_cdev_open() warn: missing error code
'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/1622628446-87909-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 1d8a3876b745..5ba8e8bc609f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -110,6 +110,7 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 		pasid = iommu_sva_get_pasid(sva);
 		if (pasid == IOMMU_PASID_INVALID) {
 			iommu_sva_unbind_device(sva);
+			rc = -EINVAL;
 			goto failed;
 		}
 
-- 
2.30.2

