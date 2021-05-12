Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A906937C990
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhELQT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239511AbhELQJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:09:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ECAA61D3F;
        Wed, 12 May 2021 15:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834001;
        bh=UWW9+BAM+LXgqtj/HB8pbk3FYOu9y4je8Aitgu8lXW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEBnQwrkpy5meudNTJlwmEul2AG6svRil+vYFEZ3JrFlR1GiNYYxL+Q+4DAcVaMke
         fZq6aYr0PWv2ZW7Fy96aGHd0ndVwsTFVdDS6Q3CcZf8rxEIajqJD+D2J1cUmMjofF9
         qdqROJComiEslJYW4XsOV5XhyCzkO30Rc4P/m+S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 336/601] pata_ipx4xx_cf: fix IRQ check
Date:   Wed, 12 May 2021 16:46:53 +0200
Message-Id: <20210512144838.865757608@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit e379b40cc0f179403ce0b82b7e539f635a568da5 ]

The driver's probe() method is written as if platform_get_irq() returns 0
on error, while actually it returns a negative error code (with all the
other values considered valid IRQs).  Rewrite the driver's IRQ checking
code to pass the positive IRQ #s to ata_host_activate(), propagate errors
upstream, and treat IRQ0 as error, returning -EINVAL, as the libata code
treats 0  as  an indication that polling should be used anyway...

Fixes: 0df0d0a0ea9f ("[libata] ARM: add ixp4xx PATA driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_ixp4xx_cf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index d1644a8ef9fa..abc0e87ca1a8 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -165,8 +165,12 @@ static int ixp4xx_pata_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq)
+	if (irq > 0)
 		irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
+	else if (irq < 0)
+		return irq;
+	else
+		return -EINVAL;
 
 	/* Setup expansion bus chip selects */
 	*data->cs0_cfg = data->cs0_bits;
-- 
2.30.2



