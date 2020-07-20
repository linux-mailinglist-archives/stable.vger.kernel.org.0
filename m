Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C7622663E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732539AbgGTQBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbgGTQBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB2CA22D02;
        Mon, 20 Jul 2020 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260891;
        bh=03I4/cVaQmrkswviRdPNtFlcOl81leKqOafE+i78oiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ml2gD/BY151+vHRu4tfPq0IXBVue0DurRlWpJ20mbeDm6LCwOlLadc1MoheuaV5Nk
         EQUdA3i3Fo3CoKWF61fRXyYys+GLFPqlSIqURVOHujeabutsYeUgWoElbCihZCVWbP
         gPP6p6paizZ/aPOGkfXtvNrFLTgyC1lozFOMt8Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Renato Lui Geh <renatogeh@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/215] iio: adc: ad7780: Fix a resource handling path in ad7780_probe()
Date:   Mon, 20 Jul 2020 17:36:24 +0200
Message-Id: <20200720152825.059287518@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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
index 217a5a5c3c6d9..7e741294de7b8 100644
--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -309,7 +309,7 @@ static int ad7780_probe(struct spi_device *spi)
 
 	ret = ad7780_init_gpios(&spi->dev, st);
 	if (ret)
-		goto error_cleanup_buffer_and_trigger;
+		return ret;
 
 	st->reg = devm_regulator_get(&spi->dev, "avdd");
 	if (IS_ERR(st->reg))
-- 
2.25.1



