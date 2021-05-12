Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E0637C1DC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhELPFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232454AbhELPDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E9FA6188B;
        Wed, 12 May 2021 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831512;
        bh=UWW9+BAM+LXgqtj/HB8pbk3FYOu9y4je8Aitgu8lXW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeEEZssZ8rQwuHXTYhdPYsE/pUGTqpY3Hkq2DOKSnXfv30PSQq9dJQdOOpUTWToKK
         NIlYaJw2XzBwSTc2N/fupy2+A41lPHDblvJpl2yoALUUZDHg6YwqMOY/fwX0nXZwcF
         sqh6z0u0ZY3WwlIoimArqbudz2WuQ0puX/WILglY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/244] pata_ipx4xx_cf: fix IRQ check
Date:   Wed, 12 May 2021 16:48:39 +0200
Message-Id: <20210512144747.745574809@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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



