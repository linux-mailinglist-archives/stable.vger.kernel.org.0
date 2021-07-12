Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A0A3C526C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346137AbhGLHqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343714AbhGLHne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87778611AD;
        Mon, 12 Jul 2021 07:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075629;
        bh=g0RAmx/OhfUFU/lJ7UUauvyrqdAsrgKN4egeA4Um7kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXDcjnvXAbpNnqvliHsA1AOMrtWSngrmvd34ElXcaXOwjKKNR2DUdn5YA9DNq4UvC
         06BlI+x6Uz3WQGz0mvWagPX/1pZVaU0H8Onk8S4XKT1fAw2p+ip9oq6NcN9K87Cfq4
         oMDuI4ESbt+Lh2/HvQ2O23Nt0y4SoDayUwtZcfRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 289/800] crypto: sa2ul - Use of_device_get_match_data() helper
Date:   Mon, 12 Jul 2021 08:05:12 +0200
Message-Id: <20210712060955.648292499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit d699c5d0bd811e48de72aeeb8e3872c63e957745 ]

Simplify the probe function by using the of_device_get_match_data()
helper instead of open coding. The logic is also moved up to fix the
missing pm_runtime cleanup in case of a match failure.

Fixes: 0bc42311cdff ("crypto: sa2ul - Add support for AM64")
Signed-off-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Tero Kristo <kristo@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index a215daedf78a..9f077ec9dbb7 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2388,7 +2388,6 @@ MODULE_DEVICE_TABLE(of, of_match);
 
 static int sa_ul_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
 	struct resource *res;
@@ -2400,6 +2399,10 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (!dev_data)
 		return -ENOMEM;
 
+	dev_data->match_data = of_device_get_match_data(dev);
+	if (!dev_data->match_data)
+		return -ENODEV;
+
 	sa_k3_dev = dev;
 	dev_data->dev = dev;
 	dev_data->pdev = pdev;
@@ -2420,13 +2423,6 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret)
 		goto destroy_dma_pool;
 
-	match = of_match_node(of_match, dev->of_node);
-	if (!match) {
-		dev_err(dev, "No compatible match found\n");
-		return -ENODEV;
-	}
-	dev_data->match_data = match->data;
-
 	spin_lock_init(&dev_data->scid_lock);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	saul_base = devm_ioremap_resource(dev, res);
-- 
2.30.2



