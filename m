Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056E42B6010
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgKQNGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgKQNGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E96223C7;
        Tue, 17 Nov 2020 13:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618369;
        bh=46gzMgkM/rMhCRHomVeMogv0BDioIGD8e1ucSlOFFSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qjMuhaGPD0599rlXrf/1CLL2JLfj5qzY7kOVCakCuMtQ9HiDuF7MOvGQMQMcuuGe
         mnH68s9lNpL1C3+XlmaL+bWzLuM2HZhvXVmUZHSqSv1Y0q45+6B3wUNKjKkv1zHiLw
         ZgY2EOiM+uMFQay2/1ZFSSJQiVeIDwvjiGMqzyrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/64] can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames
Date:   Tue, 17 Nov 2020 14:04:33 +0100
Message-Id: <20201117122106.648247143@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit ed3320cec279407a86bc4c72edc4a39eb49165ec ]

The can_get_echo_skb() function returns the number of received bytes to
be used for netdev statistics. In the case of RTR frames we get a valid
(potential non-zero) data length value which has to be passed for further
operations. But on the wire RTR frames have no payload length. Therefore
the value to be used in the statistics has to be zero for RTR frames.

Reported-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201020064443.80164-1-socketcan@hartkopp.net
Fixes: cf5046b309b3 ("can: dev: let can_get_echo_skb() return dlc of CAN frame")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 3c0f141262ad5..9579dae54af29 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -439,9 +439,13 @@ struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int idx, u8
 		 */
 		struct sk_buff *skb = priv->echo_skb[idx];
 		struct canfd_frame *cf = (struct canfd_frame *)skb->data;
-		u8 len = cf->len;
 
-		*len_ptr = len;
+		/* get the real payload length for netdev statistics */
+		if (cf->can_id & CAN_RTR_FLAG)
+			*len_ptr = 0;
+		else
+			*len_ptr = cf->len;
+
 		priv->echo_skb[idx] = NULL;
 
 		return skb;
-- 
2.27.0



