Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A4A33B531
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCONxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhCONxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD33964E89;
        Mon, 15 Mar 2021 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816394;
        bh=/8R6R06lhlNFIZDBwF3ujdYr58JUCq8f0opCZTPs2JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvFzEFd/kafs54uSrTGWLoyQgp9pR9bBScqJz0sAAxTqzBA5Mo+QDl2EmBVCKndDa
         fuFY8m36cj9rNmcUd7OJQ0dDs/uOCopD9f+3trvg8lPKXhiUNPYlDV9F+Zrk/4rvje
         Kjtj6+ibKvmxSYcqUO9aPG/6WSlv2V0LO17bnvzk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 14/78] net: lapbether: Remove netif_start_queue / netif_stop_queue
Date:   Mon, 15 Mar 2021 14:51:37 +0100
Message-Id: <20210315135212.534633267@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Xie He <xie.he.0141@gmail.com>

commit f7d9d4854519fdf4d45c70a4d953438cd88e7e58 upstream.

For the devices in this driver, the default qdisc is "noqueue",
because their "tx_queue_len" is 0.

In function "__dev_queue_xmit" in "net/core/dev.c", devices with the
"noqueue" qdisc are specially handled. Packets are transmitted without
being queued after a "dev->flags & IFF_UP" check. However, it's possible
that even if this check succeeds, "ops->ndo_stop" may still have already
been called. This is because in "__dev_close_many", "ops->ndo_stop" is
called before clearing the "IFF_UP" flag.

If we call "netif_stop_queue" in "ops->ndo_stop", then it's possible in
"__dev_queue_xmit", it sees the "IFF_UP" flag is present, and then it
checks "netif_xmit_stopped" and finds that the queue is already stopped.
In this case, it will complain that:
"Virtual device ... asks to queue packet!"

To prevent "__dev_queue_xmit" from generating this complaint, we should
not call "netif_stop_queue" in "ops->ndo_stop".

We also don't need to call "netif_start_queue" in "ops->ndo_open",
because after a netdev is allocated and registered, the
"__QUEUE_STATE_DRV_XOFF" flag is initially not set, so there is no need
to call "netif_start_queue" to clear it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/lapbether.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -286,7 +286,6 @@ static int lapbeth_open(struct net_devic
 		return -ENODEV;
 	}
 
-	netif_start_queue(dev);
 	return 0;
 }
 
@@ -294,8 +293,6 @@ static int lapbeth_close(struct net_devi
 {
 	int err;
 
-	netif_stop_queue(dev);
-
 	if ((err = lapb_unregister(dev)) != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 


