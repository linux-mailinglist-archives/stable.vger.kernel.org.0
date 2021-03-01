Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EFC328685
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbhCARLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:11:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236597AbhCARFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:05:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D8764FFA;
        Mon,  1 Mar 2021 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616787;
        bh=yvjFdbONkkPvf9o3v729y/eyUUPYQglsL8utVPipRf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZiVnXJDVu+DtGGLxmrwvedSZpiMJ7fYJHoAWfAhWO9+gC1CrvN+Kh5FMbhDyURd4
         Nt2XBCTDEb+VOTZoi8qqxr2q9rfj3BR7lBqB2U9r0w0s6bHYUR+l0cR8kVyVX6gpZp
         WfNTt9ed8GTQBHh9cM8ZY2jOfp/4IXsurOqKTsXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/247] ibmvnic: add memory barrier to protect long term buffer
Date:   Mon,  1 Mar 2021 17:11:26 +0100
Message-Id: <20210301161034.904386944@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 42557dab78edc8235aba5b441f2eb35f725a0ede ]

dma_rmb() barrier is added to load the long term buffer before copying
it to socket buffer; and dma_wmb() barrier is added to update the
long term buffer before it being accessed by VIOS (virtual i/o server).

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5518b56c2a967..788d944b3b51b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1521,6 +1521,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		skb_copy_from_linear_data(skb, dst, skb->len);
 	}
 
+	/* post changes to long_term_buff *dst before VIOS accessing it */
+	dma_wmb();
+
 	tx_pool->consumer_index =
 	    (tx_pool->consumer_index + 1) % tx_pool->num_buffers;
 
@@ -2186,6 +2189,8 @@ restart_poll:
 		offset = be16_to_cpu(next->rx_comp.off_frame_data);
 		flags = next->rx_comp.flags;
 		skb = rx_buff->skb;
+		/* load long_term_buff before copying to skb */
+		dma_rmb();
 		skb_copy_to_linear_data(skb, rx_buff->data + offset,
 					length);
 
-- 
2.27.0



