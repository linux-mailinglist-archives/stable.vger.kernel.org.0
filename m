Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4312C3CDE2A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243260AbhGSPCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245684AbhGSO6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 082FE60551;
        Mon, 19 Jul 2021 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708987;
        bh=d+BjAf26BLz8CwqTbBxVk796C0W5RtEbjS6hgcD7VEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZvSP/MXiQwV1pqv9vCfgJus6ltHoJISMnB6T3/2YTaN24pGDaVGshckTbbmEy13y
         hT5mNZCs8EK0yJBXa2bnqYYPqlHn878ikV7dVT1Rx5y10RX+NQ6r2MfH50y0CqsdtD
         AHJi9fmdmOTOt90GeddJIPUPb1HpB7r05tDm9zGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/421] mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in marvell_nfc_resume()
Date:   Mon, 19 Jul 2021 16:50:20 +0200
Message-Id: <20210719144953.601531692@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ae94c49527aa9bd3b563349adc4b5617747ca6bd ]

Add clk_disable_unprepare() on error path in marvell_nfc_resume().

Fixes: bd9c3f9b3c00 ("mtd: rawnand: marvell: add suspend and resume hooks")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210601125814.3260364-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 00b1adcfad86..07bd41dd4356 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2880,8 +2880,10 @@ static int __maybe_unused marvell_nfc_resume(struct device *dev)
 		return ret;
 
 	ret = clk_prepare_enable(nfc->reg_clk);
-	if (ret < 0)
+	if (ret < 0) {
+		clk_disable_unprepare(nfc->core_clk);
 		return ret;
+	}
 
 	/*
 	 * Reset nfc->selected_chip so the next command will cause the timing
-- 
2.30.2



