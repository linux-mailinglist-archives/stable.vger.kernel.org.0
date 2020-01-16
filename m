Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0884813F675
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388688AbgAPTEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:04:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387934AbgAPRCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BAA720730;
        Thu, 16 Jan 2020 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194141;
        bh=Arr1726Id5mEVcSp5PE/MtW4ooJu4KwJFMqCkc++vG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBA4yWuW2SPxELObiTIT9AOZ2+XzAAwuGz3AHJP7VVH9r2IwVDGFjzm9MkMUah01g
         CMFuI41pt4osmvHshFtv2C1aoyymgELT85AN7PQz8uFnVvkytQYwBfPdef1iUIxSn7
         r9dgI1qUR80yNRaFVo88iguEBxhXtmAbbQy8yju4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 228/671] hwrng: bcm2835 - fix probe as platform device
Date:   Thu, 16 Jan 2020 11:52:17 -0500
Message-Id: <20200116165940.10720-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6767d965c36c..19bde680aee1 100644
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

