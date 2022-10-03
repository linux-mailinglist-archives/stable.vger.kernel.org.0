Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC0C5F2A87
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiJCHhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiJCHgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:36:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6207A52FFA;
        Mon,  3 Oct 2022 00:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A601B80E8A;
        Mon,  3 Oct 2022 07:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EF9C43141;
        Mon,  3 Oct 2022 07:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781721;
        bh=JABYIPv91GI+S0ua6dZSI1yJNmbGkgRRzkrWid95eYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09iJRUrEmQaGbBAFYUXtuvo5qsrUXkSoGXBmQg4LNTWsK8eIu9WERr7IXWvEvoSHy
         yGCaFZBzHOKOSu9qPDUFLsB2j2N/IBTDEpZ/mtmiqTIAvd2JnngVeB6AxfC6DPifqn
         Keg3ot3TxQnn5bgx65eInGDpueb2xb+FevA8HDIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/52] Input: melfas_mip4 - fix return value check in mip4_probe()
Date:   Mon,  3 Oct 2022 09:11:47 +0200
Message-Id: <20221003070719.929247894@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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
index f67efdd040b2..43fcc8c84e2f 100644
--- a/drivers/input/touchscreen/melfas_mip4.c
+++ b/drivers/input/touchscreen/melfas_mip4.c
@@ -1453,7 +1453,7 @@ static int mip4_probe(struct i2c_client *client, const struct i2c_device_id *id)
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



