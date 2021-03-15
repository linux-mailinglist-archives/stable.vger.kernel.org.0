Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D224733B6E4
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhCON7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232248AbhCON6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A4E064F00;
        Mon, 15 Mar 2021 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816695;
        bh=Ov6u9T/JWMCotOW2MjbG0C0kwpWxaSG1R7viYH1j3pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucoxnC04E/KyfWSAiR+SKer5TKBuxjrFj6p2IfcUTd7FGX20ZSpriVSCXFIq27q2/
         n5MTCCoGiCkr0/mt3njTkGiCR7uVrpG6jtnCxIc4tHCJOXgsXtInEkESimVD8rbmOn
         4L3bekWHuErPE6S5JQt+bwG4H4dj2XECV+720rSE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 069/306] net: davicom: Fix regulator not turned off on driver removal
Date:   Mon, 15 Mar 2021 14:52:12 +0100
Message-Id: <20210315135509.980665286@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Paul Cercueil <paul@crapouillou.net>

commit cf9e60aa69ae6c40d3e3e4c94dd6c8de31674e9b upstream.

We must disable the regulator that was enabled in the probe function.

Fixes: 7994fe55a4a2 ("dm9000: Add regulator and reset support to dm9000")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/davicom/dm9000.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -133,6 +133,8 @@ struct board_info {
 	u32		wake_state;
 
 	int		ip_summed;
+
+	struct regulator *power_supply;
 };
 
 /* debug code */
@@ -1481,6 +1483,8 @@ dm9000_probe(struct platform_device *pde
 
 	db->dev = &pdev->dev;
 	db->ndev = ndev;
+	if (!IS_ERR(power))
+		db->power_supply = power;
 
 	spin_lock_init(&db->lock);
 	mutex_init(&db->addr_lock);
@@ -1766,10 +1770,13 @@ static int
 dm9000_drv_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct board_info *dm = to_dm9000_board(ndev);
 
 	unregister_netdev(ndev);
-	dm9000_release_board(pdev, netdev_priv(ndev));
+	dm9000_release_board(pdev, dm);
 	free_netdev(ndev);		/* free device structure */
+	if (dm->power_supply)
+		regulator_disable(dm->power_supply);
 
 	dev_dbg(&pdev->dev, "released and freed device\n");
 	return 0;


