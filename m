Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB56E49899D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344357AbiAXS5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344628AbiAXSyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EF8C061365;
        Mon, 24 Jan 2022 10:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4805161507;
        Mon, 24 Jan 2022 18:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C909C340E8;
        Mon, 24 Jan 2022 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050424;
        bh=XyB6tBQRGSlyvJTRw3bhsJ6pQSHWxE71MEwmOka4C64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztXXCONDJxHbAz0xjaZNkOICZr16176JPpD3IFaTvSPMSxR0Ckd26+D5n8R4YBWC4
         myjeTNnfrHqtt0mixhgrsFaC423AHurWiGEhQFnhqLm90N/1nVAa/2xA8vHUBAhiBi
         5ph3ev9WCgYxa2tm8Gdo9um2VWsvpfiTKN/Oa0d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 113/114] bcmgenet: add WOL IRQ check
Date:   Mon, 24 Jan 2022 19:43:28 +0100
Message-Id: <20220124183930.591414342@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
@@ -3443,10 +3443,12 @@ static int bcmgenet_probe(struct platfor
 
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


