Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8E1FE3D3
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgFRCN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730435AbgFRBVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:21:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86C2921927;
        Thu, 18 Jun 2020 01:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443261;
        bh=qSWUva7WVPHlE3RKgcRXLdCFyKWBerSDst6rVbst7qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pxbm2gFy0l68grFPD+eiH7+R5Y5u8jT5n7KMkArOCkUdNlalg89XoaHAZGfW7cgSV
         T9vFB2xABLktnWsEXu2iDf3+Sjwy1OpzGa4NkIsYHeZdjAVaishuQnICSZ/WVhO6+F
         e7+diAK4omEQc9QNhiuWk9X0DX3zyYMvLEt4q7J0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 208/266] extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'
Date:   Wed, 17 Jun 2020 21:15:33 -0400
Message-Id: <20200618011631.604574-208-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit bc84cff2c92ae5ccb2c37da73756e7174b1b430f ]

In some error handling paths, a call to 'iio_channel_get()' is not balanced
by a corresponding call to 'iio_channel_release()'.

This can be achieved easily by using the devm_ variant of
'iio_channel_get()'.

This has the extra benefit to simplify the remove function.

Fixes: 19939860dcae ("extcon: adc_jack: adc-jack driver to support 3.5 pi or simliar devices")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-adc-jack.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index ad02dc6747a4..0317b614b680 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -124,7 +124,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 	for (i = 0; data->adc_conditions[i].id != EXTCON_NONE; i++);
 	data->num_conditions = i;
 
-	data->chan = iio_channel_get(&pdev->dev, pdata->consumer_channel);
+	data->chan = devm_iio_channel_get(&pdev->dev, pdata->consumer_channel);
 	if (IS_ERR(data->chan))
 		return PTR_ERR(data->chan);
 
@@ -164,7 +164,6 @@ static int adc_jack_remove(struct platform_device *pdev)
 
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
-	iio_channel_release(data->chan);
 
 	return 0;
 }
-- 
2.25.1

