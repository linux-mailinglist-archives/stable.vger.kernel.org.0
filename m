Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5326F1FDF62
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732369AbgFRB3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732363AbgFRB3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:29:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C7622241;
        Thu, 18 Jun 2020 01:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443787;
        bh=G4bkkyjWj86w3yp7WUpYpiW55fqCz919jo6I3uzBYmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+7pprY8yg1BnImuHXjgjD4EL2aBIo5KmxsBLKDQ3GjhuL3EcaHw7lnf238DVKmFA
         /WDYvfhFmbIXRP1YB+QdKx5yUcfV752VyxqnYZS5G/7GQiy71/UwrMKrwlrAjlSiJw
         cjHdbaJi/mnIe5PMro6kYLhAzy4Oe/8bvcBvgA+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 68/80] extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'
Date:   Wed, 17 Jun 2020 21:28:07 -0400
Message-Id: <20200618012819.609778-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
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
index bc538708c753..cdee6d6d5453 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -128,7 +128,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 	for (i = 0; data->adc_conditions[i].id != EXTCON_NONE; i++);
 	data->num_conditions = i;
 
-	data->chan = iio_channel_get(&pdev->dev, pdata->consumer_channel);
+	data->chan = devm_iio_channel_get(&pdev->dev, pdata->consumer_channel);
 	if (IS_ERR(data->chan))
 		return PTR_ERR(data->chan);
 
@@ -170,7 +170,6 @@ static int adc_jack_remove(struct platform_device *pdev)
 
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
-	iio_channel_release(data->chan);
 
 	return 0;
 }
-- 
2.25.1

