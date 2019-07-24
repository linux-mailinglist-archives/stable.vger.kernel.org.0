Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD94A73C42
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392355AbfGXUHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392398AbfGXUDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:03:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0306820665;
        Wed, 24 Jul 2019 20:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998630;
        bh=XqNTJ6gJjakadmsSqjLeH2NXZj7sjsHmv1w8+jLZtzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehnYqNT4hPkwPUn7fgAzD5p65rBqjYH7Bj4Hz/eI+BcGeV5Sb2NmtJCXdhOoLSjMf
         G+T36C8FAMTgMdMukmOoawnBfK4E5pphZ6bsMK4KnKamVwwJh0NpdT1EgXxflql36Z
         GfSDAynRWrODHWBvG12gf3Vp60kpue2F9vTnqCeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/271] iommu: Fix a leak in iommu_insert_resv_region
Date:   Wed, 24 Jul 2019 21:18:49 +0200
Message-Id: <20190724191700.310720499@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



