Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65512C07AD
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733016AbgKWMnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:43:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733010AbgKWMnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D8C208FE;
        Mon, 23 Nov 2020 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135385;
        bh=0Afm/hazu4H8kER2bdocDreFZSyhKFRbDTBuhtrpynE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xf0LmW49PqL70ZAnPuqZKl4WtpM9+zoVmxzie8Y2VvtQnD9J5B4GNkm/SnDS2MUK9
         qiv1SMdx2E6QiI8Ylw8Dz4WNX/1CBCzaWCxpGRaO/sfJ0ju5cuhn80Q6MibUpQ0k1R
         dhiPEPVqOopjGOPhfHu2sAfa72pkYIlzASS3193g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 019/252] net: ethernet: ti: cpsw: fix cpts irq after suspend
Date:   Mon, 23 Nov 2020 13:19:29 +0100
Message-Id: <20201123121836.521892556@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 2b5668733050fca85f0ab458c5b91732f9496a38 ]

Depending on the SoC/platform the CPSW can completely lose context after a
suspend/resume cycle, including CPSW wrapper (WR) which will cause reset of
WR_C0_MISC_EN register, so CPTS IRQ will became disabled.

Fix it by moving CPTS IRQ enabling in cpsw_ndo_open() where CPTS is
actually started.

Fixes: 84ea9c0a95d7 ("net: ethernet: ti: cpsw: enable cpts irq")
Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20201112111546.20343-1-grygorii.strashko@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c     |   10 ++++++----
 drivers/net/ethernet/ti/cpsw_new.c |    9 ++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -838,9 +838,12 @@ static int cpsw_ndo_open(struct net_devi
 		if (ret < 0)
 			goto err_cleanup;
 
-		if (cpts_register(cpsw->cpts))
-			dev_err(priv->dev, "error registering cpts device\n");
-
+		if (cpsw->cpts) {
+			if (cpts_register(cpsw->cpts))
+				dev_err(priv->dev, "error registering cpts device\n");
+			else
+				writel(0x10, &cpsw->wr_regs->misc_en);
+		}
 	}
 
 	cpsw_restore(priv);
@@ -1722,7 +1725,6 @@ static int cpsw_probe(struct platform_de
 
 	/* Enable misc CPTS evnt_pend IRQ */
 	cpts_set_irqpoll(cpsw->cpts, false);
-	writel(0x10, &cpsw->wr_regs->misc_en);
 
 skip_cpts:
 	cpsw_notice(priv, probe,
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -873,8 +873,12 @@ static int cpsw_ndo_open(struct net_devi
 		if (ret < 0)
 			goto err_cleanup;
 
-		if (cpts_register(cpsw->cpts))
-			dev_err(priv->dev, "error registering cpts device\n");
+		if (cpsw->cpts) {
+			if (cpts_register(cpsw->cpts))
+				dev_err(priv->dev, "error registering cpts device\n");
+			else
+				writel(0x10, &cpsw->wr_regs->misc_en);
+		}
 
 		napi_enable(&cpsw->napi_rx);
 		napi_enable(&cpsw->napi_tx);
@@ -2009,7 +2013,6 @@ static int cpsw_probe(struct platform_de
 
 	/* Enable misc CPTS evnt_pend IRQ */
 	cpts_set_irqpoll(cpsw->cpts, false);
-	writel(0x10, &cpsw->wr_regs->misc_en);
 
 skip_cpts:
 	ret = cpsw_register_notifiers(cpsw);


