Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D7233B6B8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhCON6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231759AbhCON6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A728864EFD;
        Mon, 15 Mar 2021 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816668;
        bh=ELjwP/jwcHd8mrRlC8sIWye42NMT0i7kSsJeJ66LizE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDvgpowItMZ7D4Gpwf+Mfl9GHlQzsX5Ye3Samg6fUiN3BlvJVEM9cxJy0kFIZ43oS
         F3dwFA0SdiUscGV6qGbA5reLJyDkCUUjapZ5nkypuB0oqaub/kx82zNghlZDueM1jU
         Q79UOr5SkzyvxjLY5qnU9ovyaubUyFATB6+TU/P4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 036/168] net: davicom: Fix regulator not turned off on driver removal
Date:   Mon, 15 Mar 2021 14:54:28 +0100
Message-Id: <20210315135551.526948188@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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
@@ -134,6 +134,8 @@ struct board_info {
 	u32		wake_state;
 
 	int		ip_summed;
+
+	struct regulator *power_supply;
 };
 
 /* debug code */
@@ -1486,6 +1488,8 @@ dm9000_probe(struct platform_device *pde
 
 	db->dev = &pdev->dev;
 	db->ndev = ndev;
+	if (!IS_ERR(power))
+		db->power_supply = power;
 
 	spin_lock_init(&db->lock);
 	mutex_init(&db->addr_lock);
@@ -1771,10 +1775,13 @@ static int
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


