Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191483C524E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344470AbhGLHp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346674AbhGLHmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C67D61130;
        Mon, 12 Jul 2021 07:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075587;
        bh=ZXY77PLvDVu3MEhWCd9R7fCDGiXD1+satb3QJr4c/vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpgTqxS2zJbuoGcmZnEzJG/GhAhxaBE8OnlxBH4DJje/YMV0vQ1lSSFMCyb5pSRWh
         1ucVHMB78entp8rzBfgZYsLJzqAY38pTkjbi3DZrm/ean97Q+5mbOveSP0OfXofPOg
         34UCerOY+BNoZ452Sy+Q+eQefzlePzWxuc21wA0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 277/800] pata_rb532_cf: fix deferred probing
Date:   Mon, 12 Jul 2021 08:05:00 +0200
Message-Id: <20210712060953.848256866@linuxfoundation.org>
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

[ Upstream commit 2d3a62fbae8e5badc2342388f65ab2191c209cc0 ]

The driver overrides the error codes returned by platform_get_irq() to
-ENOENT, so if it returns -EPROBE_DEFER, the driver would fail the probe
permanently instead of the deferred probing. Switch to propagating the
error code upstream, still checking/overriding IRQ0 as libata regards it
as "no IRQ" (thus polling) anyway...

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Link: https://lore.kernel.org/r/771ced55-3efb-21f5-f21c-b99920aae611@omprussia.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_rb532_cf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 479c4b29b856..303f8c375b3a 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -115,10 +115,12 @@ static int rb532_pata_driver_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ resource found\n");
-		return -ENOENT;
+		return irq;
 	}
+	if (!irq)
+		return -EINVAL;
 
 	gpiod = devm_gpiod_get(&pdev->dev, NULL, GPIOD_IN);
 	if (IS_ERR(gpiod)) {
-- 
2.30.2



