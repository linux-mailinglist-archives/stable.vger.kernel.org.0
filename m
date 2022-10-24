Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CB060A365
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiJXLzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiJXLyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD8D792EA;
        Mon, 24 Oct 2022 04:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA5AB81147;
        Mon, 24 Oct 2022 11:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1A0C433D6;
        Mon, 24 Oct 2022 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611949;
        bh=If2haa2kx6bY4bNNHjk4aARkFQXvhLrsziM+tWJAtCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaAVAT0njlsSwVwzUj0rNui1wuhRLODiST2P6hLy2V+LQDgBnEAPbvxypubr4Wy0k
         YVHCeZD/DgnSb1C8tSczry6jThehyRvkPwlMetFM8jChV2+GAgA5HNWrbWLAiJUCPd
         R/q3+LhyDZExnl3XPdgh5UsEDKL9zaFQpvhs3hTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 013/210] Input: melfas_mip4 - fix return value check in mip4_probe()
Date:   Mon, 24 Oct 2022 13:28:50 +0200
Message-Id: <20221024112957.346870488@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a54dc27bd25f20ee3ea2009584b3166d25178243 ]

devm_gpiod_get_optional() may return ERR_PTR(-EPROBE_DEFER),
add a minus sign to fix it.

Fixes: 6ccb1d8f78bd ("Input: add MELFAS MIP4 Touchscreen driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220924030715.1653538-1-yangyingliang@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/melfas_mip4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/melfas_mip4.c b/drivers/input/touchscreen/melfas_mip4.c
index 05108c2fea93..633d7e1dc7d6 100644
--- a/drivers/input/touchscreen/melfas_mip4.c
+++ b/drivers/input/touchscreen/melfas_mip4.c
@@ -1469,7 +1469,7 @@ static int mip4_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					      "ce", GPIOD_OUT_LOW);
 	if (IS_ERR(ts->gpio_ce)) {
 		error = PTR_ERR(ts->gpio_ce);
-		if (error != EPROBE_DEFER)
+		if (error != -EPROBE_DEFER)
 			dev_err(&client->dev,
 				"Failed to get gpio: %d\n", error);
 		return error;
-- 
2.35.1



