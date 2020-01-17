Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185F0141213
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 21:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgAQUFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 15:05:43 -0500
Received: from first.geanix.com ([116.203.34.67]:54894 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbgAQUFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 15:05:43 -0500
Received: from localhost (87-49-44-45-mobile.dk.customer.tdc.net [87.49.44.45])
        by first.geanix.com (Postfix) with ESMTPSA id 4DADBAB870;
        Fri, 17 Jan 2020 20:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1579291492; bh=xCGrTy0HVPAotxr0/+n4SsgbLUiKQHIExIJ8+yhvuBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PxJt/cehWVZ08wPGe6GCrLvLxXMBYbDmadtfAUILLc9GpY9gXhCNuiigqc5k7/8hF
         EbkBjOc3QSKNqg9dgklyomCvlsSlXzrKnROZ7D82DzCldn7IByUgN1eDqoOxB0F+/w
         9OsRcU4HqbvDP/sC/+MNIsYbvwL6TH7zLobtt5H6M3W6bVLy+A1zOujkeo4FaF/EJG
         WLvkQA63lrvP/HRge9JNjvvwD2fWX7FRc8t6pkTxC1DiHZACTJb4rQ84VX8wYbLUKl
         cvbWe2PkDi134iI5UJpQ54oSgZ8YGAZT0Bejt2Wgw4rbtBrgG92oOcx7kVu5JmH/hV
         SNxObh0rNoJ0Q==
From:   Esben Haabendal <esben@geanix.com>
To:     linux-mtd@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] mtd: rawnand: gpmi: Restore nfc timing setup after suspend/resume
Date:   Fri, 17 Jan 2020 21:05:37 +0100
Message-Id: <20200117200537.9279-3-esben@geanix.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200117200537.9279-1-esben@geanix.com>
References: <20200117200537.9279-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on ea2d15de10a4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As we reset the GPMI block at resume, the timing parameters setup by a
previous exec_op is lost.  Rewriting GPMI timing registers on first exec_op
after resume fixes the problem.

Fixes: ef347c0cfd61 ("mtd: rawnand: gpmi: Implement exec_op")
Cc: stable@vger.kernel.org
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 879df8402446..b9d5d55a5edb 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -2727,6 +2727,10 @@ static int gpmi_pm_resume(struct device *dev)
 		return ret;
 	}
 
+	/* Set flag to get timing setup restored for next exec_op */
+	if (this->hw.clk_rate)
+		this->hw.must_apply_timings = true;
+
 	/* re-init the BCH registers */
 	ret = bch_set_geometry(this);
 	if (ret) {
-- 
2.25.0

