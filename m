Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBF11984F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfLJViq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727524AbfLJVfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB43122464;
        Tue, 10 Dec 2019 21:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013712;
        bh=hVLwqxTTnoHu9vdi6vsWB0Jc9NYZCRbLQz1JUSevkes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3DImD2Zuyy3dDXzY8j74sRoXjqrAhvegB9hbAnvbuuA5zPib3Bpl3yqnD7YAOrnG
         YfEpeyygqwA/5YWWey9+661q8TzXfupe/i8rltZ9kW+kjoanOqjHH7ZI2xJLYiFvYl
         iFn6GziJxeiiuCWoj0FYY37e/SsxDun5NhK4tHZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eduard Hasenleithner <eduard@hasenleithner.at>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 140/177] nvme: Discard workaround for non-conformant devices
Date:   Tue, 10 Dec 2019 16:31:44 -0500
Message-Id: <20191210213221.11921-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c4ff4f079448e..d4944d038a3ff 100644
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

