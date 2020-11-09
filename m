Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556D82ABB39
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbgKINZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732531AbgKINRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D75206D8;
        Mon,  9 Nov 2020 13:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927841;
        bh=tzG8aeK6c6SEBJMFTmnK1dxRhxpk02RmeRg9fVEBMGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tROMvRuYeznyxNG2U7QvR6L0Lkv+UaEKtLKJ+6N4NFLRg0yhcLlGT1ee4wnnIQQsN
         VCg3m47S8A53s89s+TzChycBGGqzAQfbA2a6qsbpiBtRPLYjXNpy9d0aKrUT/b0Q1w
         8ulQ3Xdz3q6uq7D6icW6b8vK0uH9gcmgxD9a8twU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 040/133] net: dsa: qca8k: Fix port MTU setting
Date:   Mon,  9 Nov 2020 13:55:02 +0100
Message-Id: <20201109125032.639079509@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

[ Upstream commit 99cab7107d914a71c57f5a4e6d34292425fbbb61 ]

The qca8k only supports a switch-wide MTU setting, and the code to take
the max of all ports was only looking at the port currently being set.
Fix to examine all ports.

Reported-by: DENG Qingfang <dqfext@gmail.com>
Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
Signed-off-by: Jonathan McDowell <noodles@earth.li>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20201030183315.GA6736@earth.li
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca8k.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1219,8 +1219,8 @@ qca8k_port_change_mtu(struct dsa_switch
 	priv->port_mtu[port] = new_mtu;
 
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		if (priv->port_mtu[port] > mtu)
-			mtu = priv->port_mtu[port];
+		if (priv->port_mtu[i] > mtu)
+			mtu = priv->port_mtu[i];
 
 	/* Include L2 header / FCS length */
 	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);


