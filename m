Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E2A960B7
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbfHTNnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730322AbfHTNnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:43:00 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B315E22DD3;
        Tue, 20 Aug 2019 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308579;
        bh=SM8FAR6Uo4ZQUbBUB9QabMO0xPsWSBlj7dMEFIUHKVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2N0NTuhfgLq7neTqi6T9n8PDXn7FRdjXYK2cUJmleg0b4wl3i9BTjfxfOaGD9RmM
         3cymuc4mVBYrkUl6sDtJo1Lkz5RppcCQpDOt9UqZv7nYvkJhgsLQalc1C1UF5fcbKg
         79Slg0bSo3VW3Hn8yaBhlc0aXtogMETzincn8Koc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 04/12] iommu/dma: Handle SG length overflow better
Date:   Tue, 20 Aug 2019 09:42:45 -0400
Message-Id: <20190820134253.11562-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134253.11562-1-sashal@kernel.org>
References: <20190820134253.11562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit ab2cbeb0ed301a9f0460078e91b09f39958212ef ]

Since scatterlist dimensions are all unsigned ints, in the relatively
rare cases where a device's max_segment_size is set to UINT_MAX, then
the "cur_len + s_length <= max_len" check in __finalise_sg() will always
return true. As a result, the corner case of such a device mapping an
excessively large scatterlist which is mergeable to or beyond a total
length of 4GB can lead to overflow and a bogus truncated dma_length in
the resulting segment.

As we already assume that any single segment must be no longer than
max_len to begin with, this can easily be addressed by reshuffling the
comparison.

Fixes: 809eac54cdd6 ("iommu/dma: Implement scatterlist segment merging")
Reported-by: Nicolin Chen <nicoleotsuka@gmail.com>
Tested-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 9d1cebe7f6cbb..c87764a4e2126 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -684,7 +684,7 @@ static int __finalise_sg(struct device *dev, struct scatterlist *sg, int nents,
 		 * - and wouldn't make the resulting output segment too long
 		 */
 		if (cur_len && !s_iova_off && (dma_addr & seg_mask) &&
-		    (cur_len + s_length <= max_len)) {
+		    (max_len - cur_len >= s_length)) {
 			/* ...then concatenate it with the previous one */
 			cur_len += s_length;
 		} else {
-- 
2.20.1

