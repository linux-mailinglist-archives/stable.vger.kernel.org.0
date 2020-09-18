Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AC226F1DD
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgIRCHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgIRCHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F5A823770;
        Fri, 18 Sep 2020 02:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394845;
        bh=OZBRK2VLGNUKvLPFgd5TqEh2BcN//uJryGvXEeZgT54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvoS2XUU2VF77jIoONcIb4idPQTSAqUomTAOb6BJeyP1+Z61gNeRJsdhc0S3y1NAV
         1XxoIuDHt7/ynUfLa1ZSZh63JAA7C5LKlWpH4EHlhAYSww0MmfsDSAthpn7HeJ9RH7
         GOUIboTjwBrWyL0nQp1QYTzEvcjsdxEh7A/ise4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 302/330] mtd: rawnand: gpmi: Fix runtime PM imbalance on error
Date:   Thu, 17 Sep 2020 22:00:42 -0400
Message-Id: <20200918020110.2063155-302-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

