Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5548065B086
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjABLYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbjABLX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:23:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487E86153
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:23:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9DA5ECE0E1D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937F9C433F2;
        Mon,  2 Jan 2023 11:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658632;
        bh=u0tD76QRYzEq+J3wGOBYxeS9BkF2bX9aPEXWQFHQ0Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBvoTbCuLfxCiK9Lp0uJ+vqTUC2iEjblP7mqM0kX1zQgVKnCtg6rFxQ+iDpy93Ta+
         7tsgXvjjc6DHat1vZtP4esJ+gv02wH2Due1PhHB8lnl3xvIBkOefFCpsDkNIz4qbct
         YkOrefwoW+bA5b+TOXD8rKDedmsOlWbMQOI8df3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>,
        Klaus Jensen <k.jensen@samsung.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/71] nvme-pci: fix doorbell buffer value endianness
Date:   Mon,  2 Jan 2023 12:21:29 +0100
Message-Id: <20230102110551.690453038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Klaus Jensen <k.jensen@samsung.com>

[ Upstream commit b5f96cb719d8ba220b565ddd3ba4ac0d8bcfb130 ]

When using shadow doorbells, the event index and the doorbell values are
written to host memory. Prior to this patch, the values written would
erroneously be written in host endianness. This causes trouble on
big-endian platforms. Fix this by adding missing endian conversions.

This issue was noticed by Guenter while testing various big-endian
platforms under QEMU[1]. A similar fix required for hw/nvme in QEMU is
up for review as well[2].

  [1]: https://lore.kernel.org/qemu-devel/20221209110022.GA3396194@roeck-us.net/
  [2]: https://lore.kernel.org/qemu-devel/20221212114409.34972-4-its@irrelevant.dk/

Fixes: f9f38e33389c ("nvme: improve performance for virtual NVMe devices")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Klaus Jensen <k.jensen@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 488ad7dabeb8..4ed8a14e2803 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -144,9 +144,9 @@ struct nvme_dev {
 	mempool_t *iod_mempool;
 
 	/* shadow doorbell buffer support: */
-	u32 *dbbuf_dbs;
+	__le32 *dbbuf_dbs;
 	dma_addr_t dbbuf_dbs_dma_addr;
-	u32 *dbbuf_eis;
+	__le32 *dbbuf_eis;
 	dma_addr_t dbbuf_eis_dma_addr;
 
 	/* host memory buffer support: */
@@ -210,10 +210,10 @@ struct nvme_queue {
 #define NVMEQ_SQ_CMB		1
 #define NVMEQ_DELETE_ERROR	2
 #define NVMEQ_POLLED		3
-	u32 *dbbuf_sq_db;
-	u32 *dbbuf_cq_db;
-	u32 *dbbuf_sq_ei;
-	u32 *dbbuf_cq_ei;
+	__le32 *dbbuf_sq_db;
+	__le32 *dbbuf_cq_db;
+	__le32 *dbbuf_sq_ei;
+	__le32 *dbbuf_cq_ei;
 	struct completion delete_done;
 };
 
@@ -340,11 +340,11 @@ static inline int nvme_dbbuf_need_event(u16 event_idx, u16 new_idx, u16 old)
 }
 
 /* Update dbbuf and return true if an MMIO is required */
-static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
-					      volatile u32 *dbbuf_ei)
+static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
+					      volatile __le32 *dbbuf_ei)
 {
 	if (dbbuf_db) {
-		u16 old_value;
+		u16 old_value, event_idx;
 
 		/*
 		 * Ensure that the queue is written before updating
@@ -352,8 +352,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
 		 */
 		wmb();
 
-		old_value = *dbbuf_db;
-		*dbbuf_db = value;
+		old_value = le32_to_cpu(*dbbuf_db);
+		*dbbuf_db = cpu_to_le32(value);
 
 		/*
 		 * Ensure that the doorbell is updated before reading the event
@@ -363,7 +363,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
 		 */
 		mb();
 
-		if (!nvme_dbbuf_need_event(*dbbuf_ei, value, old_value))
+		event_idx = le32_to_cpu(*dbbuf_ei);
+		if (!nvme_dbbuf_need_event(event_idx, value, old_value))
 			return false;
 	}
 
-- 
2.35.1



