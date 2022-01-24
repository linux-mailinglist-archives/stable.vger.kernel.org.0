Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60975498E8A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345639AbiAXTmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:42:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37858 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346790AbiAXTkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E231C61482;
        Mon, 24 Jan 2022 19:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5442C340E5;
        Mon, 24 Jan 2022 19:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053242;
        bh=EUR/jm+L4HhFA2yHUvgPJ9P9all3a0iZt49RZndztp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SySatmMEHsZtz4Qu0ParYqmjrQg1KWMOaMykWUiF98jfPODw/eKmklVIQl6ULaK9X
         7MENS89s6pf5NMB5XO7Ca9y58Kbw046tgOUIyRQCo0/k2AMKbLmBixSiKiGR6gea0P
         9IOe4dpC5OsPdfrGRp8F4bQ4ZcRokkY8dU7icBsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 312/320] bcmgenet: add WOL IRQ check
Date:   Mon, 24 Jan 2022 19:44:56 +0100
Message-Id: <20220124184004.548338336@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 9deb48b53e7f4056c2eaa2dc2ee3338df619e4f6 upstream.

The driver neglects to check the result of platform_get_irq_optional()'s
call and blithely passes the negative error codes to devm_request_irq()
(which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
Stop calling devm_request_irq() with the invalid IRQ #s.

Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3507,10 +3507,12 @@ static int bcmgenet_probe(struct platfor
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
-	err = devm_request_irq(&pdev->dev, priv->wol_irq, bcmgenet_wol_isr, 0,
-			       dev->name, priv);
-	if (!err)
-		device_set_wakeup_capable(&pdev->dev, 1);
+	if (priv->wol_irq > 0) {
+		err = devm_request_irq(&pdev->dev, priv->wol_irq,
+				       bcmgenet_wol_isr, 0, dev->name, priv);
+		if (!err)
+			device_set_wakeup_capable(&pdev->dev, 1);
+	}
 
 	/* Set the needed headroom to account for any possible
 	 * features enabling/disabling at runtime


