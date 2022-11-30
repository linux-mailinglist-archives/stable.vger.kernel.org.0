Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8149463DF68
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiK3SrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiK3Sqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:46:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB73193A61
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:46:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FE9061D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911DDC433D6;
        Wed, 30 Nov 2022 18:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833998;
        bh=qoMvzlw7yvjvpldZmzc3+vZZx6RfL/sb/cPK0BUFb4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9Ck/tvqjBACCPkhdn80MScneeN3VZgSeocJQBaxigvF2Sqv7Pulm+afOfXnCUY1I
         gLyZhGSSgkIaS67oP5m+yQkhZ+KnPq0DjudZjoSQJdAIw6oe2CA3FCWpbnBpxvLAEs
         BZ1lRO0JWohfg4vTyuEEvjoooF+4/vA6CalqKpRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 092/289] net: mvpp2: fix possible invalid pointer dereference
Date:   Wed, 30 Nov 2022 19:21:17 +0100
Message-Id: <20221130180546.229746722@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit cbe867685386af1f0a2648f5279f6e4c74bfd17f ]

It will cause invalid pointer dereference to priv->cm3_base behind,
if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().

Fixes: e54ad1e01c00 ("net: mvpp2: add CM3 SRAM memory map")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Link: https://lore.kernel.org/r/20221117084032.101144-1-tanghui20@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index eaa51cd7456b..8f86be995092 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7352,6 +7352,7 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 			  struct mvpp2 *priv)
 {
 	struct resource *res;
+	void __iomem *base;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
 	if (!res) {
@@ -7362,9 +7363,12 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 		return 0;
 	}
 
-	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
-	return PTR_ERR_OR_ZERO(priv->cm3_base);
+	priv->cm3_base = base;
+	return 0;
 }
 
 static int mvpp2_probe(struct platform_device *pdev)
-- 
2.35.1



