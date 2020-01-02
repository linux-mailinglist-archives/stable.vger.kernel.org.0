Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4458212F0E5
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgABW40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgABWSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE2B722B48;
        Thu,  2 Jan 2020 22:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003500;
        bh=JS4nCumSHXOPnUPaodSkpRD8uMS2vX+hdTN30K62b4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfXNHHhPhdhr+/g2XDIljxJTg7avrW0vG72NZtz1Gnmffm3iAxcagvM2wNjLR7a+S
         /qBn4xpZR2w2Mxq1psKkuxwDqxGeyt33Ow9tAzJM+k2TJ7v/tmO6eX2IkgIlrGze8S
         XArgYdNjOJmT4VM98GhHDrJYg5bSk3d93MQc0HcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 187/191] net: phylink: fix interface passed to mac_link_up
Date:   Thu,  2 Jan 2020 23:07:49 +0100
Message-Id: <20200102215849.625414474@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 9b2079c046a9d6c9c73a4ec33816678565ee01f3 ]

A mismerge between the following two commits:

c678726305b9 ("net: phylink: ensure consistent phy interface mode")
27755ff88c0e ("net: phylink: Add phylink_mac_link_{up, down} wrapper functions")

resulted in the wrong interface being passed to the mac_link_up()
function. Fix this up.

Fixes: b4b12b0d2f02 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -444,8 +444,7 @@ static void phylink_mac_link_up(struct p
 
 	pl->cur_interface = link_state.interface;
 	pl->ops->mac_link_up(pl->config, pl->link_an_mode,
-			     pl->phy_state.interface,
-			     pl->phydev);
+			     pl->cur_interface, pl->phydev);
 
 	if (ndev)
 		netif_carrier_on(ndev);


