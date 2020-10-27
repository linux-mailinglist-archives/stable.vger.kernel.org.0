Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B2F29BD76
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811019AbgJ0Qgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800621AbgJ0Pr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A29D122281;
        Tue, 27 Oct 2020 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813679;
        bh=AKyPY349U9WCK7iDViI2NHhJ3+ZEh7+CjXBxE82DSqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJHN+y5TZLmOk4ghrVbnKrFt9E7Q04hluI8Db/XC3eUP+lFfT4t+SaaAfTH5xzb0l
         nOm26XCQ3BdRQHTmsYtovelrUnYZkAskIxiYyG+lfEQ8AccI3ilM8O70ls+n13+2I/
         lrHGn1X+UuAHwNLnFsuu801golUmk572LafwzZno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 633/757] nvmet: limit passthru MTDS by BIO_MAX_PAGES
Date:   Tue, 27 Oct 2020 14:54:43 +0100
Message-Id: <20201027135520.242133566@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit df06047d54276f73782c9d97882b305fca745d3f ]

nvmet_passthru_map_sg() only supports mapping a single BIO, not a chain
so the effective maximum transfer should also be limitted by
BIO_MAX_PAGES (presently this works out to 1MB).

For PCI passthru devices the max_sectors would typically be more
limitting than BIO_MAX_PAGES, but this may not be true for all passthru
devices.

Fixes: c1fef73f793b ("nvmet: add passthru code to process commands")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index dacfa7435d0b2..1ab88df3310f6 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -26,7 +26,7 @@ static u16 nvmet_passthru_override_id_ctrl(struct nvmet_req *req)
 	struct nvme_ctrl *pctrl = ctrl->subsys->passthru_ctrl;
 	u16 status = NVME_SC_SUCCESS;
 	struct nvme_id_ctrl *id;
-	u32 max_hw_sectors;
+	int max_hw_sectors;
 	int page_shift;
 
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
@@ -48,6 +48,13 @@ static u16 nvmet_passthru_override_id_ctrl(struct nvmet_req *req)
 	max_hw_sectors = min_not_zero(pctrl->max_segments << (PAGE_SHIFT - 9),
 				      pctrl->max_hw_sectors);
 
+	/*
+	 * nvmet_passthru_map_sg is limitted to using a single bio so limit
+	 * the mdts based on BIO_MAX_PAGES as well
+	 */
+	max_hw_sectors = min_not_zero(BIO_MAX_PAGES << (PAGE_SHIFT - 9),
+				      max_hw_sectors);
+
 	page_shift = NVME_CAP_MPSMIN(ctrl->cap) + 12;
 
 	id->mdts = ilog2(max_hw_sectors) + 9 - page_shift;
-- 
2.25.1



