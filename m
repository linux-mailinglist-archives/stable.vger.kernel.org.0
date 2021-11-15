Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10C2451442
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349438AbhKOUHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:07:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344511AbhKOTYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D467663284;
        Mon, 15 Nov 2021 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002742;
        bh=/n8wCvhgkkLbX4iynyRqxx6C7QkFXUin7z+21XOAiXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eZ86mJUvkLWIwC3+nRFPe2xpJamJAWay7ub2eL4ebe2XG5eimtCikbhu9xiyI9pw
         8vfXPYcXKmB2TdLDW6ZFnnULLxFjF2Qz1ELG/ejvQ55Grf1LOSWQrn6LUYyFUd6qwQ
         DBio/1nD/RdOzdqvDKVq4ln+oXjsWMF8S1J6sIG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marshall Midden <marshallmidden@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 681/917] iommu/dma: Fix incorrect error return on iommu deferred attach
Date:   Mon, 15 Nov 2021 18:02:56 +0100
Message-Id: <20211115165451.988641206@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit ac315f96b3bd6f6b8f18f387816c7c2cc6b32e02 ]

scsi_dma_map() was reporting a failure during boot on an AMD machine
with the IOMMU enabled.

  scsi_dma_map failed: request for 36 bytes!

The issue was tracked down to a mistake in logic: should not return
an error if iommu_deferred_attach() returns zero.

Reported-by: Marshall Midden <marshallmidden@gmail.com>
Fixes: dabb16f67215 ("iommu/dma: return error code from iommu_dma_map_sg()")
Link: https://lore.kernel.org/all/CAD2CkAWjS8=kKwEEN4cgVNjyFORUibzEiCUA-X+SMtbo0JoMmA@mail.gmail.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20211027174757.119755-1-logang@deltatee.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 19bebacbf1780..2d60216440009 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1007,7 +1007,8 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 
 	if (static_branch_unlikely(&iommu_deferred_attach_enabled)) {
 		ret = iommu_deferred_attach(dev, domain);
-		goto out;
+		if (ret)
+			goto out;
 	}
 
 	if (dev_is_untrusted(dev))
-- 
2.33.0



