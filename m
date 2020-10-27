Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140D229C1C9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818920AbgJ0RZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751686AbgJ0Owf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8BD220679;
        Tue, 27 Oct 2020 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810344;
        bh=oFzguebNLEhFeDGfuSs9IKduhhslEnjrkch0fj8EnKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFiKE2MpETFlGJMnW7sGOP3mF23Uw3tg8GkWYkQW9rldJnwh8egjFIE7eagKoMeKQ
         B4RMU2ye7ElJzbM0FLZEGRZnCMJqOigXlPBFHiE5GP7m545BMTqYUwbZ7gLoqmBNmA
         3sosVTq2m9JOYrlLEUliqDdZoE7TkLDSXav7jD3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 105/633] crypto: picoxcell - Fix potential race condition bug
Date:   Tue, 27 Oct 2020 14:47:28 +0100
Message-Id: <20201027135527.606837533@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 64f4a62e3b17f1e473f971127c2924cae42afc82 ]

engine->stat_irq_thresh was initialized after device_create_file() in
the probe function, the initialization may race with call to
spacc_stat_irq_thresh_store() which updates engine->stat_irq_thresh,
therefore initialize it before creating the file in probe function.

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: ce92136843cb ("crypto: picoxcell - add support for the...")
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Acked-by: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/picoxcell_crypto.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 7384e91c8b32b..0d32b641a7f9d 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1666,11 +1666,6 @@ static int spacc_probe(struct platform_device *pdev)
 		goto err_clk_put;
 	}
 
-	ret = device_create_file(&pdev->dev, &dev_attr_stat_irq_thresh);
-	if (ret)
-		goto err_clk_disable;
-
-
 	/*
 	 * Use an IRQ threshold of 50% as a default. This seems to be a
 	 * reasonable trade off of latency against throughput but can be
@@ -1678,6 +1673,10 @@ static int spacc_probe(struct platform_device *pdev)
 	 */
 	engine->stat_irq_thresh = (engine->fifo_sz / 2);
 
+	ret = device_create_file(&pdev->dev, &dev_attr_stat_irq_thresh);
+	if (ret)
+		goto err_clk_disable;
+
 	/*
 	 * Configure the interrupts. We only use the STAT_CNT interrupt as we
 	 * only submit a new packet for processing when we complete another in
-- 
2.25.1



