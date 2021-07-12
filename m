Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461DB3C52AA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345022AbhGLHsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346518AbhGLHqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30E7361154;
        Mon, 12 Jul 2021 07:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075719;
        bh=y5VGwTrzuQwT2plzHSrl2/5rCfn4r0bcXrI0UDrKkDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4kaWNcqIqAIIn1MbU486dWnuSmFNrHznbka0BRYcgn/tYx1npOGL4DC8R7/BIifY
         dMTxIRfxHv2FvVwN5aLPSCujmZNkqM6STVNVLAbRcYPYcX+Upz4jIbD51UlRGP8xPG
         lwy9LzggQ9c5e7corwsMZpacW2myVsde82pXFVms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 293/800] pata_ep93xx: fix deferred probing
Date:   Mon, 12 Jul 2021 08:05:16 +0200
Message-Id: <20210712060956.243896857@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 5c8121262484d99bffb598f39a0df445cecd8efb ]

The driver overrides the error codes returned by platform_get_irq() to
-ENXIO, so if it returns -EPROBE_DEFER, the driver would fail the probe
permanently instead of the deferred probing.  Propagate the error code
upstream, as it should have been done from the start...

Fixes: 2fff27512600 ("PATA host controller driver for ep93xx")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Link: https://lore.kernel.org/r/509fda88-2e0d-2cc7-f411-695d7e94b136@omprussia.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_ep93xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index badab6708893..46208ececbb6 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -928,7 +928,7 @@ static int ep93xx_pata_probe(struct platform_device *pdev)
 	/* INT[3] (IRQ_EP93XX_EXT3) line connected as pull down */
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		err = -ENXIO;
+		err = irq;
 		goto err_rel_gpio;
 	}
 
-- 
2.30.2



