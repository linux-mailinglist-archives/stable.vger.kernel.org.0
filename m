Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5427C807
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgI2L6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgI2LmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F5A3206A5;
        Tue, 29 Sep 2020 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379730;
        bh=OZBRK2VLGNUKvLPFgd5TqEh2BcN//uJryGvXEeZgT54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLCqFjrZ+Kwu2pofJgf++besf0EePX9K6+/KzIXNYGKSlE6Do7sv40QrD+RUY+y1H
         rFvVa0toKIwQ59ctNV4Ycem6IZJb0/ffOG0vQqJw2ue0aIUUIoYqGQ64YNHUPhQkDr
         xllzJ4AD630HBs6NeoBVvw/P47+yP16b6ms2dxX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 293/388] mtd: rawnand: gpmi: Fix runtime PM imbalance on error
Date:   Tue, 29 Sep 2020 13:00:24 +0200
Message-Id: <20200929110024.651770999@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 550e68ea36a6671a96576c0531685ce6e6c0d19d ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200522095139.19653-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index b9d5d55a5edb9..ef89947ee3191 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -540,8 +540,10 @@ static int bch_set_geometry(struct gpmi_nand_data *this)
 		return ret;
 
 	ret = pm_runtime_get_sync(this->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(this->dev);
 		return ret;
+	}
 
 	/*
 	* Due to erratum #2847 of the MX23, the BCH cannot be soft reset on this
-- 
2.25.1



