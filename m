Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB3C3C557C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhGLIKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353646AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF7561CF6;
        Mon, 12 Jul 2021 07:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076571;
        bh=xAqVfHI4k+NexhEUpXCrdsKR6P8/b714RynLcTm7cdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kW4lloyARqcZvYOfBlvN1ljbvFFvRDdssjZkp1wliPHa9kFPg4ZeI4tL+zTBsLy++
         5CMdrHNzG+xenO2qgElmr0n019Tm7UuoEVh3owk7Y6TqtS/WuSTr/bwvhymrEjYfv1
         PU460nNMdWGZ417I6VVg+lerIS+x01MnL+PU8i0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 698/800] ASoC: mediatek: mtk-btcvsd: Fix an error handling path in mtk_btcvsd_snd_probe()
Date:   Mon, 12 Jul 2021 08:12:01 +0200
Message-Id: <20210712061041.092797929@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b6052c3c7a78f5e2b9756c92ef77c0b56435f107 ]

If an error occurs after a successful 'of_iomap()' call, it must be undone
by a corresponding 'iounmap()' call, as already done in the remove
function.

While at it, remove the useless initialization of 'ret' at the beginning of
the function.

Fixes: 4bd8597dc36c ("ASoC: mediatek: add btcvsd driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0c2ba562c3364e61bfbd5b3013a99dfa0d9045d7.1622989685.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-btcvsd.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/common/mtk-btcvsd.c b/sound/soc/mediatek/common/mtk-btcvsd.c
index f85b5ea180ec..d884bb7c0fc7 100644
--- a/sound/soc/mediatek/common/mtk-btcvsd.c
+++ b/sound/soc/mediatek/common/mtk-btcvsd.c
@@ -1281,7 +1281,7 @@ static const struct snd_soc_component_driver mtk_btcvsd_snd_platform = {
 
 static int mtk_btcvsd_snd_probe(struct platform_device *pdev)
 {
-	int ret = 0;
+	int ret;
 	int irq_id;
 	u32 offset[5] = {0, 0, 0, 0, 0};
 	struct mtk_btcvsd_snd *btcvsd;
@@ -1337,7 +1337,8 @@ static int mtk_btcvsd_snd_probe(struct platform_device *pdev)
 	btcvsd->bt_sram_bank2_base = of_iomap(dev->of_node, 1);
 	if (!btcvsd->bt_sram_bank2_base) {
 		dev_err(dev, "iomap bt_sram_bank2_base fail\n");
-		return -EIO;
+		ret = -EIO;
+		goto unmap_pkv_err;
 	}
 
 	btcvsd->infra = syscon_regmap_lookup_by_phandle(dev->of_node,
@@ -1345,7 +1346,8 @@ static int mtk_btcvsd_snd_probe(struct platform_device *pdev)
 	if (IS_ERR(btcvsd->infra)) {
 		dev_err(dev, "cannot find infra controller: %ld\n",
 			PTR_ERR(btcvsd->infra));
-		return PTR_ERR(btcvsd->infra);
+		ret = PTR_ERR(btcvsd->infra);
+		goto unmap_bank2_err;
 	}
 
 	/* get offset */
@@ -1354,7 +1356,7 @@ static int mtk_btcvsd_snd_probe(struct platform_device *pdev)
 					 ARRAY_SIZE(offset));
 	if (ret) {
 		dev_warn(dev, "%s(), get offset fail, ret %d\n", __func__, ret);
-		return ret;
+		goto unmap_bank2_err;
 	}
 	btcvsd->infra_misc_offset = offset[0];
 	btcvsd->conn_bt_cvsd_mask = offset[1];
@@ -1373,8 +1375,18 @@ static int mtk_btcvsd_snd_probe(struct platform_device *pdev)
 	mtk_btcvsd_snd_set_state(btcvsd, btcvsd->tx, BT_SCO_STATE_IDLE);
 	mtk_btcvsd_snd_set_state(btcvsd, btcvsd->rx, BT_SCO_STATE_IDLE);
 
-	return devm_snd_soc_register_component(dev, &mtk_btcvsd_snd_platform,
-					       NULL, 0);
+	ret = devm_snd_soc_register_component(dev, &mtk_btcvsd_snd_platform,
+					      NULL, 0);
+	if (ret)
+		goto unmap_bank2_err;
+
+	return 0;
+
+unmap_bank2_err:
+	iounmap(btcvsd->bt_sram_bank2_base);
+unmap_pkv_err:
+	iounmap(btcvsd->bt_pkv_base);
+	return ret;
 }
 
 static int mtk_btcvsd_snd_remove(struct platform_device *pdev)
-- 
2.30.2



