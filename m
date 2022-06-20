Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C14E55199C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiFTNEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243690AbiFTNCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:02:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEF718E26;
        Mon, 20 Jun 2022 05:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA45861534;
        Mon, 20 Jun 2022 12:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71322C3411C;
        Mon, 20 Jun 2022 12:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729862;
        bh=2EXsQNU5hkSqQ9HUC7uN4v7vu7aEWBJKHFfKwSsQtMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4BpmIm/RdnwcIx0XRmTaKmpjHbiHbVC9axFh4/5bx/j68FVrgDWF4q0QZHx5B1vt
         A3yjhEelvH4bEVpLWp/Rmvbev8KfToXD9qdGT8WUGOapYa6KsdXCVDBIMEOgQIaqB2
         82pflJjcV68bwoCpK5yNVIhuoYn8mIFHrd3LHiy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 099/141] i2c: mediatek: Fix an error handling path in mtk_i2c_probe()
Date:   Mon, 20 Jun 2022 14:50:37 +0200
Message-Id: <20220620124732.471475976@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit de87b603b0919e31578c8fa312a3541f1fb37e1c ]

The clsk are prepared, enabled, then disabled. So if an error occurs after
the disable step, they are still prepared.

Add an error handling path to unprepare the clks in such a case, as already
done in the .remove function.

Fixes: 8b4fc246c3ff ("i2c: mediatek: Optimize master_xfer() and avoid circular locking")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index bdecb78bfc26..8e6985354fd5 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1420,17 +1420,22 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"Request I2C IRQ %d fail\n", irq);
-		return ret;
+		goto err_bulk_unprepare;
 	}
 
 	i2c_set_adapdata(&i2c->adap, i2c);
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret)
-		return ret;
+		goto err_bulk_unprepare;
 
 	platform_set_drvdata(pdev, i2c);
 
 	return 0;
+
+err_bulk_unprepare:
+	clk_bulk_unprepare(I2C_MT65XX_CLK_MAX, i2c->clocks);
+
+	return ret;
 }
 
 static int mtk_i2c_remove(struct platform_device *pdev)
-- 
2.35.1



