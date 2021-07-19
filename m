Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07EE3CD92A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243660AbhGSO1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243532AbhGSOZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53B8461002;
        Mon, 19 Jul 2021 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707187;
        bh=R6an2BvtrbhdpPoiwSKHxmHmT2qSaPHK+o3UeHw4fmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dR6RVIEuIJy7LYlBnxNKqKdL1WfFVOBqzspBHkcuVsbNNBAWk7ITbXxm59N204S2O
         AikXZHzEtNdqknL7IJrW2xbTLLrZAggGJW+Q0Um2AkTJW/ZCly8pgZelk0nckF5zS6
         vKCRu9PX4OCwEYF4qBSj+b/D16PmqrxenrzvdViE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 061/245] pata_rb532_cf: fix deferred probing
Date:   Mon, 19 Jul 2021 16:50:03 +0200
Message-Id: <20210719144942.380571966@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index c8b6a780a290..76c550e160f6 100644
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



