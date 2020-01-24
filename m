Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0BE4148099
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388660AbgAXLMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387873AbgAXLMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778BC20708;
        Fri, 24 Jan 2020 11:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864357;
        bh=MoWOsnciYOK+JyjADQzbCuFucghXhI9vTXl6OWQRkWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhumYcPuePyho76nj3KznQ3YMMt7zWYFWKMlfw7//ukYLhlwSXRD5GTxCQQlF1ZSw
         hIX4qlbUCheyABlFg66N11WecSiZKasM7J1huphmrVpATZjFoZ2BPh/YNzMLa9gSTg
         r2JTe1kzk+6Os3YGEPsYOArvew76xlDKsgqLQIMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 244/639] hwrng: bcm2835 - fix probe as platform device
Date:   Fri, 24 Jan 2020 10:26:54 +0100
Message-Id: <20200124093117.354297369@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 984798de671a927ac73da31096a150df42e6aaf3 ]

BCM63XX (MIPS) does not use device tree, so there cannot be any
of_device_id, causing the driver to fail on probe:

[    0.904564] bcm2835-rng: probe of bcm63xx-rng failed with error -22

Fix this by checking for match data only if we are probing from device
tree.

Fixes: 8705f24f7b57 ("hwrng: bcm2835 - Enable BCM2835 RNG to work on BCM63xx platforms")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 6767d965c36c5..19bde680aee1d 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -171,14 +171,16 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	priv->rng.read = bcm2835_rng_read;
 	priv->rng.cleanup = bcm2835_rng_cleanup;
 
-	rng_id = of_match_node(bcm2835_rng_of_match, np);
-	if (!rng_id)
-		return -EINVAL;
-
-	/* Check for rng init function, execute it */
-	of_data = rng_id->data;
-	if (of_data)
-		priv->mask_interrupts = of_data->mask_interrupts;
+	if (dev_of_node(dev)) {
+		rng_id = of_match_node(bcm2835_rng_of_match, np);
+		if (!rng_id)
+			return -EINVAL;
+
+		/* Check for rng init function, execute it */
+		of_data = rng_id->data;
+		if (of_data)
+			priv->mask_interrupts = of_data->mask_interrupts;
+	}
 
 	/* register driver */
 	err = devm_hwrng_register(dev, &priv->rng);
-- 
2.20.1



