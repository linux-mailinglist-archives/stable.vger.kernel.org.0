Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CEA2268AB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbgGTQJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387546AbgGTQJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D437D2064B;
        Mon, 20 Jul 2020 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261378;
        bh=1lqTScJTf6nGwyPfZGfVqVtvs86oQGhZkVVIYwgFbOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMy2d/EZ1bFTpYEnJhtQPm9wPMcBE8WUbOfh1P7ZH7vuN6iBn4U9y5vfO0hgJKZEu
         156ql6mcMBIdO107xIZjvE2Da4pY+d2gFNcLHbQK8yMm0rpLjqtKVes3orfwikCnKO
         Rfnq5scXQ14PSIn3mctsHPbOKEy+ctgtmMO+q62k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Renato Lui Geh <renatogeh@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 094/244] iio: adc: ad7780: Fix a resource handling path in ad7780_probe()
Date:   Mon, 20 Jul 2020 17:36:05 +0200
Message-Id: <20200720152830.303629930@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b0536f9826a5ed3328d527b4fc1686867a9f3041 ]

If 'ad7780_init_gpios()' fails, we must not release some resources that
have not been allocated yet. Return directly instead.

Fixes: 5bb30e7daf00 ("staging: iio: ad7780: move regulator to after GPIO init")
Fixes: 9085daa4abcc ("staging: iio: ad7780: add gain & filter gpio support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Renato Lui Geh <renatogeh@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7780.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7780.c b/drivers/iio/adc/ad7780.c
index 291c1a898129d..643771ed3f835 100644
--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -310,7 +310,7 @@ static int ad7780_probe(struct spi_device *spi)
 
 	ret = ad7780_init_gpios(&spi->dev, st);
 	if (ret)
-		goto error_cleanup_buffer_and_trigger;
+		return ret;
 
 	st->reg = devm_regulator_get(&spi->dev, "avdd");
 	if (IS_ERR(st->reg))
-- 
2.25.1



