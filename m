Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9D3CD797
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241947AbhGSOR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241908AbhGSOR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:17:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB4246113E;
        Mon, 19 Jul 2021 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706685;
        bh=ayvlCRoW97D6v0qnTXQ69qDY/Q6dbXPXUQfbfxDivLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/u8OVJaLyaGm2srFL2qJLhzwQjWBzMdLHBXzz4vDkBkxNpJQxOOoNbRF7AJdHRrA
         pzb/HUMCUNqaSnBnKwDYnQOwPAavtvb9A7xeMZMHt2U+QkIAaYG1CTMEWZF/yO1WxN
         JZoGZGVI8cMRTDWllbKm7CSDumQUPtoX5i0WQzk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 054/188] pata_ep93xx: fix deferred probing
Date:   Mon, 19 Jul 2021 16:50:38 +0200
Message-Id: <20210719144925.640069129@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index 634c814cbeda..ebdd2dfabbeb 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -927,7 +927,7 @@ static int ep93xx_pata_probe(struct platform_device *pdev)
 	/* INT[3] (IRQ_EP93XX_EXT3) line connected as pull down */
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		err = -ENXIO;
+		err = irq;
 		goto err_rel_gpio;
 	}
 
-- 
2.30.2



