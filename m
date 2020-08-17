Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C8824768B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbgHQTis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729835AbgHQP06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88EEC2344C;
        Mon, 17 Aug 2020 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678018;
        bh=h+tYd+bZNAwHmeZmlBWeOiSqa8F/jt2io4cs8+AGino=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG/2SX6SjsMucDnLQtj0947+vOfROfcIWm1dPVktowS6X7AnNDXLSfPIF4ZXwoLny
         sYjBseSgC1lDyh3W1J0Ejvos6ndtSgIjwhsGFZw7MGyBQBj8pCNDbgwOYAyJVtYXzB
         w6lMtTkUE0mulfAPsquFr+aLgv1MqhpxSwEkjALI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 160/464] iio: amplifiers: ad8366: Change devm_gpiod_get() to optional and add the missed check
Date:   Mon, 17 Aug 2020 17:11:53 +0200
Message-Id: <20200817143841.473404871@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 9ca39411f9a9c833727750431da8dfd96ff80005 ]

Since if there is no GPIO, nothing happens, replace devm_gpiod_get()
with devm_gpiod_get_optional().
Also add IS_ERR() to fix the missing-check warning.

Fixes: cee211f4e5a0 ("iio: amplifiers: ad8366: Add support for the ADA4961 DGA")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/amplifiers/ad8366.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/amplifiers/ad8366.c b/drivers/iio/amplifiers/ad8366.c
index 62167b87caea8..8345ba65d41d8 100644
--- a/drivers/iio/amplifiers/ad8366.c
+++ b/drivers/iio/amplifiers/ad8366.c
@@ -262,8 +262,11 @@ static int ad8366_probe(struct spi_device *spi)
 	case ID_ADA4961:
 	case ID_ADL5240:
 	case ID_HMC1119:
-		st->reset_gpio = devm_gpiod_get(&spi->dev, "reset",
-			GPIOD_OUT_HIGH);
+		st->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset", GPIOD_OUT_HIGH);
+		if (IS_ERR(st->reset_gpio)) {
+			ret = PTR_ERR(st->reset_gpio);
+			goto error_disable_reg;
+		}
 		indio_dev->channels = ada4961_channels;
 		indio_dev->num_channels = ARRAY_SIZE(ada4961_channels);
 		break;
-- 
2.25.1



