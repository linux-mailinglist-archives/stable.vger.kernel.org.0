Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1B746FFEA
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbhLJLfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:35:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52784 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbhLJLfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:35:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 21A17CE29C8
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE49C00446;
        Fri, 10 Dec 2021 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639135928;
        bh=fA71mBortxkpqgNBKjqfcW0f81gVyituCtW7i+WCNW4=;
        h=Subject:To:Cc:From:Date:From;
        b=vLWTmRDHY0ThrB0SXC+3c2UZZCAvhxKoNrjF+IX5EDYqi72WB98+kf4T7s9O+QnP+
         mY2GW93QMULszixEHjHdKSyMuHIzCObBhtvKvtvlyDcLgUaKpi56Lb1Mg0CJmO63wv
         q0+eNvhhJU7OvEIbn9nj19P9r4QhX2etPBozdrF0=
Subject: FAILED: patch "[PATCH] can: pch_can: pch_can_rx_normal: fix use after free" failed to apply to 4.4-stable tree
To:     mailhol.vincent@wanadoo.fr, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:32:05 +0100
Message-ID: <163913592520369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 94cddf1e9227a171b27292509d59691819c458db Mon Sep 17 00:00:00 2001
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Date: Tue, 23 Nov 2021 20:16:54 +0900
Subject: [PATCH] can: pch_can: pch_can_rx_normal: fix use after free

After calling netif_receive_skb(skb), dereferencing skb is unsafe.
Especially, the can_frame cf which aliases skb memory is dereferenced
just after the call netif_receive_skb(skb).

Reordering the lines solves the issue.

Fixes: b21d18b51b31 ("can: Topcliff: Add PCH_CAN driver.")
Link: https://lore.kernel.org/all/20211123111654.621610-1-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 92a54a5fd4c5..964c8a09226a 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -692,11 +692,11 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 			cf->data[i + 1] = data_reg >> 8;
 		}
 
-		netif_receive_skb(skb);
 		rcv_pkts++;
 		stats->rx_packets++;
 		quota--;
 		stats->rx_bytes += cf->len;
+		netif_receive_skb(skb);
 
 		pch_fifo_thresh(priv, obj_num);
 		obj_num++;

