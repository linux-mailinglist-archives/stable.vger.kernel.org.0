Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570CF6432A8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiLET2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiLET1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:27:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA727FE2
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A70FB612D8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC5C433C1;
        Mon,  5 Dec 2022 19:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268276;
        bh=IptsQPsjwnuQGBlRZzG3uTTy+8or39/mkD5ZRVBWo9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTt6l9uo/kiMkmogLcnUaGbe8BLTyg/kddlSbexqTX/VPIQvO0mmkV/jqnlxuzD4b
         G5AIJ7Bx2jD7Vn8WsyGm9Yj6pqaKCqB6QpROrwDAChgwbT93PR4egVjCRuiE6tElQq
         n14rHOBwMEa48lLpPAKllFRbGGGqt0wm95kc9Ogk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 043/124] can: m_can: Add check for devm_clk_get
Date:   Mon,  5 Dec 2022 20:09:09 +0100
Message-Id: <20221205190809.665662358@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 68b4f9e0bdd0f920d7303d07bfe226cd0976961d ]

Since the devm_clk_get may return error,
it should be better to add check for the cdev->hclk,
as same as cdev->cclk.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/all/20221123063651.26199-1-jiasheng@iscas.ac.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4dc67fdfcdb9..153d8fd08bd8 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1910,7 +1910,7 @@ int m_can_class_get_clocks(struct m_can_classdev *cdev)
 	cdev->hclk = devm_clk_get(cdev->dev, "hclk");
 	cdev->cclk = devm_clk_get(cdev->dev, "cclk");
 
-	if (IS_ERR(cdev->cclk)) {
+	if (IS_ERR(cdev->hclk) || IS_ERR(cdev->cclk)) {
 		dev_err(cdev->dev, "no clock found\n");
 		ret = -ENODEV;
 	}
-- 
2.35.1



