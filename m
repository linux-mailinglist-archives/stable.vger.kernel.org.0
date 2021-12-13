Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B9C472717
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhLMJ6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39308 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235989AbhLMJzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:55:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0333BB80E3B;
        Mon, 13 Dec 2021 09:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BEEC34601;
        Mon, 13 Dec 2021 09:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389318;
        bh=SbzTYLnL4/tOcC4s8QeoIOhesxrhUiUKqPl2TsmCxtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsq7Y+XxqCy9dm3OOwH8ru5Ro1wpMwUolBsDx/OGfBEE+WmIgNvb04C+BSTYxOj9w
         LHG3gYupv2ovP3azniVn7Ac7LNv4o49uhxwj1VjXjkhSzfoWsWLgKoPoNBRO4Pt3um
         AbF0suqFi/3QBackxB9XWbtYeorelCnLEkS2ZsUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Kline <matt@bitbashing.io>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 025/171] can: m_can: m_can_read_fifo: fix memory leak in error branch
Date:   Mon, 13 Dec 2021 10:29:00 +0100
Message-Id: <20211213092945.914154890@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit 31cb32a590d62b18f69a9a6d433f4e69c74fdd56 upstream.

In m_can_read_fifo(), if the second call to m_can_fifo_read() fails,
the function jump to the out_fail label and returns without calling
m_can_receive_skb(). This means that the skb previously allocated by
alloc_can_skb() is not freed. In other terms, this is a memory leak.

This patch adds a goto label to destroy the skb if an error occurs.

Issue was found with GCC -fanalyzer, please follow the link below for
details.

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
Link: https://lore.kernel.org/all/20211107050755.70655-1-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Cc: Matt Kline <matt@bitbashing.io>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -517,7 +517,7 @@ static int m_can_read_fifo(struct net_de
 		err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA,
 				      cf->data, DIV_ROUND_UP(cf->len, 4));
 		if (err)
-			goto out_fail;
+			goto out_free_skb;
 	}
 
 	/* acknowledge rx fifo 0 */
@@ -532,6 +532,8 @@ static int m_can_read_fifo(struct net_de
 
 	return 0;
 
+out_free_skb:
+	kfree_skb(skb);
 out_fail:
 	netdev_err(dev, "FIFO read returned %d\n", err);
 	return err;


