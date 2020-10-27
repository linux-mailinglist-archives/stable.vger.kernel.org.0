Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982DC29C333
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902155AbgJ0ObE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896687AbgJ0O3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D17320780;
        Tue, 27 Oct 2020 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808953;
        bh=V7dREi8fC+dA9++ovT36KVgbZ66sB5aTseBMqv1pjpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjpQYtNLKwb47Zu0HTXZA0xqBYbUUTU2MzzB8ZfQ+uy0GTcQE/bEFV6oqsnG25yn+
         ji8eDrqwHzci5z2utDf89DP6LBP5I+lPKkDyMeShd6ymMhLs/HkM2haayjQAquxstD
         fF8eP/RR4SQDwWIzYxRBcjh9Qth9ls68enV1dfPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com
Subject: [PATCH 5.4 014/408] can: j1935: j1939_tp_tx_dat_new(): fix missing initialization of skbcnt
Date:   Tue, 27 Oct 2020 14:49:12 +0100
Message-Id: <20201027135455.716376899@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit e009f95b1543e26606dca2f7e6e9f0f9174538e5 ]

This fixes an uninit-value warning:
BUG: KMSAN: uninit-value in can_receive+0x26b/0x630 net/can/af_can.c:650

Reported-and-tested-by: syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: Robin van der Gracht <robin@protonic.nl>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://lore.kernel.org/r/20201008061821.24663-1-xiyou.wangcong@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -580,6 +580,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j193
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 


