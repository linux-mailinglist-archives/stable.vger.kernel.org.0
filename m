Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E0382E8B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhEQOIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238019AbhEQOHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:07:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DCE46135C;
        Mon, 17 May 2021 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260354;
        bh=DOfZvo4CKUnUhyiFQqb2bJV2N7uJhWIYyvNwVyHWo/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9pzuuAY5u+Ei0X4pyTchYt/rMG3MtIrw8mNt8IFdYExoVbobd7a6cAGltZZWwF5l
         35gph8exDPS1++7q41SAouL5L30rziRSmAgftrSvtE0fg5iULkfltnznuPqJY+id7E
         ck1JhrRk3VkvZbyK527m09nhXWFpYzoAPSYv9Tlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 044/363] can: dev: can_free_echo_skb(): dont crash the kernel if can_priv::echo_skb is accessed out of bounds
Date:   Mon, 17 May 2021 15:58:30 +0200
Message-Id: <20210517140304.093695566@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 4168d079aa41498639b2c64b4583375bcdf360d9 ]

A out of bounds access to "struct can_priv::echo_skb" leads to a
kernel crash. Better print a sensible warning message instead and try
to recover.

This patch is similar to:

| e7a6994d043a ("can: dev: __can_get_echo_skb(): Don't crash the kernel
|               if can_priv::echo_skb is accessed out of bounds")

Link: https://lore.kernel.org/r/20210319142700.305648-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 6a64fe410987..c3508109263e 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -151,7 +151,11 @@ void can_free_echo_skb(struct net_device *dev, unsigned int idx)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
-	BUG_ON(idx >= priv->echo_skb_max);
+	if (idx >= priv->echo_skb_max) {
+		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bounds (%u/max %u)\n",
+			   __func__, idx, priv->echo_skb_max);
+		return;
+	}
 
 	if (priv->echo_skb[idx]) {
 		dev_kfree_skb_any(priv->echo_skb[idx]);
-- 
2.30.2



