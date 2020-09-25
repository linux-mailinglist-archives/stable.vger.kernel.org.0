Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2B02787CF
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgIYMug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729078AbgIYMue (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46D82072E;
        Fri, 25 Sep 2020 12:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038234;
        bh=zJTh3y6CnXhO6A+1Wcu28/kBt1nZVRDCq44XvQSmP/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKo/IjGH8jWPurFAu7c5KnXZOvuHA9Gqh89bhbmTPL1NQTwqwKrA1IPZNj57SUBii
         I+SnggbJM0+rxYyxC+pp4R8CVVRwI5jBPYTUenkLi3mkfa+zkvoHPydMhzvMm3jAnX
         gC6g9iq6FFrzFJNWPmF8qwlNXvwPHRqBwQwsv3HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parshuram Thombare <pthombar@cadence.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 52/56] net: macb: fix for pause frame receive enable bit
Date:   Fri, 25 Sep 2020 14:48:42 +0200
Message-Id: <20200925124735.594188685@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parshuram Thombare <pthombar@cadence.com>

[ Upstream commit d7739b0b6d15ef9ad5c79424736b8ded5ed3e913 ]

PAE bit of NCFGR register, when set, pauses transmission
if a non-zero 802.3 classic pause frame is received.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -647,8 +647,7 @@ static void macb_mac_link_up(struct phyl
 				ctrl |= GEM_BIT(GBE);
 		}
 
-		/* We do not support MLO_PAUSE_RX yet */
-		if (tx_pause)
+		if (rx_pause)
 			ctrl |= MACB_BIT(PAE);
 
 		macb_set_tx_clk(bp->tx_clk, speed, ndev);


