Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA2D69535
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfGOOVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732556AbfGOOVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:21:11 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D6C217D8;
        Mon, 15 Jul 2019 14:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200470;
        bh=4YIRLvZGbvpiij6S8R5TnMWb4Y//0G+ZUOF1GZm0qLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbgakwOsTLdIQ18owRlEciFKU+hB67vKdB/ZThyNOaUzQ9QO/jDVf/aNx0HMnOaeP
         XQGk4Ml6vVjXt0iO7i63W+qdi61D9JdAP7oQx5IhdvVXUNwWEnt4Y1f+p94qpGPkO8
         0jiT8miOoW+2giRBNA0niszqqdLb7cTT69k/If/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 058/158] iommu: Fix a leak in iommu_insert_resv_region
Date:   Mon, 15 Jul 2019 10:16:29 -0400
Message-Id: <20190715141809.8445-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit ad0834dedaa15c3a176f783c0373f836e44b4700 ]

In case we expand an existing region, we unlink
this latter and insert the larger one. In
that case we should free the original region after
the insertion. Also we can immediately return.

Fixes: 6c65fb318e8b ("iommu: iommu_get_group_resv_regions")

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8c15c5980299..bc14825edc9c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -211,18 +211,21 @@ static int iommu_insert_resv_region(struct iommu_resv_region *new,
 			pos = pos->next;
 		} else if ((start >= a) && (end <= b)) {
 			if (new->type == type)
-				goto done;
+				return 0;
 			else
 				pos = pos->next;
 		} else {
 			if (new->type == type) {
 				phys_addr_t new_start = min(a, start);
 				phys_addr_t new_end = max(b, end);
+				int ret;
 
 				list_del(&entry->list);
 				entry->start = new_start;
 				entry->length = new_end - new_start + 1;
-				iommu_insert_resv_region(entry, regions);
+				ret = iommu_insert_resv_region(entry, regions);
+				kfree(entry);
+				return ret;
 			} else {
 				pos = pos->next;
 			}
@@ -235,7 +238,6 @@ static int iommu_insert_resv_region(struct iommu_resv_region *new,
 		return -ENOMEM;
 
 	list_add_tail(&region->list, pos);
-done:
 	return 0;
 }
 
-- 
2.20.1

