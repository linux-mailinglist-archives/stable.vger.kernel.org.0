Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6664339D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiLETiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiLEThh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:37:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E5527DEF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E157D612C5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CFEC433B5;
        Mon,  5 Dec 2022 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268873;
        bh=VkOFT7DBQT7Up2BTSVl1Iqk88N6FZaJHKY6oqZRsDbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhZ36DLu03Nmx7yM6ULFjDBK0VxzVO15Z0UNzXHY237BziSQ4fJBcmOhnlozplZqr
         FWkAsPYWmXwFR+SJp3hzKRboE8JlIBF4we7XXfIZ1TXXc5vkzJdtS5b/La2Z9zJdm/
         0rRd0mU1dVFIuW77Wcl0TF/hLrL9QPzYUoSHCYXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/120] can: m_can: Add check for devm_clk_get
Date:   Mon,  5 Dec 2022 20:09:42 +0100
Message-Id: <20221205190807.801435141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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
index c4596fbe6d2f..46ab6155795c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1931,7 +1931,7 @@ int m_can_class_get_clocks(struct m_can_classdev *cdev)
 	cdev->hclk = devm_clk_get(cdev->dev, "hclk");
 	cdev->cclk = devm_clk_get(cdev->dev, "cclk");
 
-	if (IS_ERR(cdev->cclk)) {
+	if (IS_ERR(cdev->hclk) || IS_ERR(cdev->cclk)) {
 		dev_err(cdev->dev, "no clock found\n");
 		ret = -ENODEV;
 	}
-- 
2.35.1



