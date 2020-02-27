Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F43171A7E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgB0NyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:54:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731846AbgB0NyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:54:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEE682469D;
        Thu, 27 Feb 2020 13:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811655;
        bh=7RRHpMykAdOs5O0+EcuC9a2h+AH/pE0k9fVN9Vx7LXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b713NFkPx2YbN6n4w7VsMGSRKyhlp61wqpt2++YMppE7CHKIfd6/rQY/UoYR/fSBc
         PAJOOG+L1WSUYhUKohCzTv8m9TLzPUNgXNbtEElN/W/Q+4iPdvfp3M+wnVQ4CYHdYh
         /IztS/pLJZP7N3UyTdiiyByPU7MHu+3KFDTYz1Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 050/237] gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpio_irq_map/unmap()
Date:   Thu, 27 Feb 2020 14:34:24 +0100
Message-Id: <20200227132300.420182645@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit e36eaf94be8f7bc4e686246eed3cf92d845e2ef8 ]

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/gpio/gpio-grgpio.c, 261:
	request_irq in grgpio_irq_map
drivers/gpio/gpio-grgpio.c, 255:
	_raw_spin_lock_irqsave in grgpio_irq_map

drivers/gpio/gpio-grgpio.c, 318:
	free_irq in grgpio_irq_unmap
drivers/gpio/gpio-grgpio.c, 299:
	_raw_spin_lock_irqsave in grgpio_irq_unmap

request_irq() and free_irq() can sleep at runtime.

To fix these bugs, request_irq() and free_irq() are called without
holding the spinlock.

These bugs are found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20191218132605.10594-1-baijiaju1990@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-grgpio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 6544a16ab02e9..7541bd327e6c5 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -259,17 +259,16 @@ static int grgpio_irq_map(struct irq_domain *d, unsigned int irq,
 	lirq->irq = irq;
 	uirq = &priv->uirqs[lirq->index];
 	if (uirq->refcnt == 0) {
+		spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 		ret = request_irq(uirq->uirq, grgpio_irq_handler, 0,
 				  dev_name(priv->dev), priv);
 		if (ret) {
 			dev_err(priv->dev,
 				"Could not request underlying irq %d\n",
 				uirq->uirq);
-
-			spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
-
 			return ret;
 		}
+		spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 	}
 	uirq->refcnt++;
 
@@ -315,8 +314,11 @@ static void grgpio_irq_unmap(struct irq_domain *d, unsigned int irq)
 	if (index >= 0) {
 		uirq = &priv->uirqs[lirq->index];
 		uirq->refcnt--;
-		if (uirq->refcnt == 0)
+		if (uirq->refcnt == 0) {
+			spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 			free_irq(uirq->uirq, priv);
+			return;
+		}
 	}
 
 	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
-- 
2.20.1



