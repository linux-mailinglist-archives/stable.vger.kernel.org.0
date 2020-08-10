Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70B724095F
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgHJPac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728072AbgHJPab (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 546DD22B4E;
        Mon, 10 Aug 2020 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073430;
        bh=2QRROI2k7MJ+DKbhUfFPfn4ahpH62ukiBkER15FU9wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gc5fJNi8zFXKAame3rXCG3r4YAIYvd9jPiYK3Svj/MffsTMCrajO9/Uk8mFZaGRxn
         mnwv8BIlAmaaHC5RkVDSsY6/LENUPnxBb91vxRt9ERskaFSsDl2L4H7OBXIs/uw4oN
         py4bAKp4skGGhdWqX7f9HIluXXLHD/nGZphr0nFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Shah, Ashish N" <ashish.n.shah@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 37/48] hv_netvsc: do not use VF device if link is down
Date:   Mon, 10 Aug 2020 17:21:59 +0200
Message-Id: <20200810151806.042873899@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 7c9864bbccc23e1812ac82966555d68c13ea4006 ]

If the accelerated networking SRIOV VF device has lost carrier
use the synthetic network device which is available as backup
path. This is a rare case since if VF link goes down, normally
the VMBus device will also loose external connectivity as well.
But if the communication is between two VM's on the same host
the VMBus device will still work.

Reported-by: "Shah, Ashish N" <ashish.n.shah@intel.com>
Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -543,12 +543,13 @@ static int netvsc_start_xmit(struct sk_b
 	u32 hash;
 	struct hv_page_buffer pb[MAX_PAGE_BUFFER_COUNT];
 
-	/* if VF is present and up then redirect packets
-	 * already called with rcu_read_lock_bh
+	/* If VF is present and up then redirect packets to it.
+	 * Skip the VF if it is marked down or has no carrier.
+	 * If netpoll is in uses, then VF can not be used either.
 	 */
 	vf_netdev = rcu_dereference_bh(net_device_ctx->vf_netdev);
 	if (vf_netdev && netif_running(vf_netdev) &&
-	    !netpoll_tx_running(net))
+	    netif_carrier_ok(vf_netdev) && !netpoll_tx_running(net))
 		return netvsc_vf_xmit(net, vf_netdev, skb);
 
 	/* We will atmost need two pages to describe the rndis


