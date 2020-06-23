Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BB82063E6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391193AbgFWVMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391088AbgFWUa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:30:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A7A206C3;
        Tue, 23 Jun 2020 20:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944256;
        bh=/44GbRVFyzkusa5BAVSVz2mQoKHA5iPo6BBEtM4Gp6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSAyTzqXWu4G2gl9G4zNypzMRVMWENsu3pwmWrxyIyqWc8iO9TZ/udCzlrdy0MnM6
         bWWFWQX7OJOdCnmRwK1hi5bQZNuMHNu/9HMYKaac1dkUjzhWS5ReKqYxhorvNX6tu/
         eBbBdjHvhjEaFnKYWfffzWZmOeEE47awINjqshds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/314] extcon: adc-jack: Fix an error handling path in adc_jack_probe()
Date:   Tue, 23 Jun 2020 21:56:37 +0200
Message-Id: <20200623195348.559816218@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ad02dc6747a43..0317b614b6805 100644
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



