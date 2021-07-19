Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1763CDCE2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhGSOyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241222AbhGSOv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9092611CE;
        Mon, 19 Jul 2021 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708708;
        bh=IROkhotbn8xzNqoeKJ4VtFkJvRI1T9V6UNapqUsSAY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1e1MuVhiLsNQVSRDyWPKa7oK+X8D8rki8VVIT4e0Le7wWU4c2TVV+HMcAYYxYqVd
         j+M1EudfbV6SaH+uqI9KHUPlqbLF3x/jhtZBzOnSyb8HyelErD0e9DgBU8vXu3Cxkk
         cEMVBkc1jTq8lcqCmsrO7QIvDUh7Kik/+zJp8Svo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/421] pata_rb532_cf: fix deferred probing
Date:   Mon, 19 Jul 2021 16:48:29 +0200
Message-Id: <20210719144950.014610375@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 653b9a0bf727..0416a390b94c 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -120,10 +120,12 @@ static int rb532_pata_driver_probe(struct platform_device *pdev)
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
 
 	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
-- 
2.30.2



