Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8952312C51C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfL2Rds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:33:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfL2Rds (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4935520722;
        Sun, 29 Dec 2019 17:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640827;
        bh=7ykI0aqLu3LkA3XNZUr9JslSzNOIdEvWlxpxjeaUA/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yS0CCV+aL/76UfMwNGrmj3ePjcEowETifFV1fk9pTlHgzNIrXRMGGZnRFb3fG8EAy
         jd3wscvmaHq92vSu0dZgd3iuSK5Ii/NzxXuWbfkNajXv4kiHEKXXAbUnFzsqwTxN7E
         FJqQ/DGPPu/bxrz+gr4RupbvJ/H3fJgrHZuwgsXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eduard Hasenleithner <eduard@hasenleithner.at>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/219] nvme: Discard workaround for non-conformant devices
Date:   Sun, 29 Dec 2019 18:19:17 +0100
Message-Id: <20191229162531.968286289@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eduard Hasenleithner <eduard@hasenleithner.at>

[ Upstream commit 530436c45ef2e446c12538a400e465929a0b3ade ]

Users observe IOMMU related errors when performing discard on nvme from
non-compliant nvme devices reading beyond the end of the DMA mapped
ranges to discard.

Two different variants of this behavior have been observed: SM22XX
controllers round up the read size to a multiple of 512 bytes, and Phison
E12 unconditionally reads the maximum discard size allowed by the spec
(256 segments or 4kB).

Make nvme_setup_discard unconditionally allocate the maximum DSM buffer
so the driver DMA maps a memory range that will always succeed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=202665 many
Signed-off-by: Eduard Hasenleithner <eduard@hasenleithner.at>
[changelog, use existing define, kernel coding style]
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b2d9bd564960..b7bd89b3b2f9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -551,8 +551,14 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	struct nvme_dsm_range *range;
 	struct bio *bio;
 
-	range = kmalloc_array(segments, sizeof(*range),
-				GFP_ATOMIC | __GFP_NOWARN);
+	/*
+	 * Some devices do not consider the DSM 'Number of Ranges' field when
+	 * determining how much data to DMA. Always allocate memory for maximum
+	 * number of segments to prevent device reading beyond end of buffer.
+	 */
+	static const size_t alloc_size = sizeof(*range) * NVME_DSM_MAX_RANGES;
+
+	range = kzalloc(alloc_size, GFP_ATOMIC | __GFP_NOWARN);
 	if (!range) {
 		/*
 		 * If we fail allocation our range, fallback to the controller
@@ -593,7 +599,7 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 
 	req->special_vec.bv_page = virt_to_page(range);
 	req->special_vec.bv_offset = offset_in_page(range);
-	req->special_vec.bv_len = sizeof(*range) * segments;
+	req->special_vec.bv_len = alloc_size;
 	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	return BLK_STS_OK;
-- 
2.20.1



