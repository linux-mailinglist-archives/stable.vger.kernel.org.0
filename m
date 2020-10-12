Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B6628B860
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbgJLNvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbgJLNsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5941922203;
        Mon, 12 Oct 2020 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510410;
        bh=lqy9zMIdrd2s2GoZTXAWb0n02zcclt83JEZSTh/cBNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCAmx9oz5wuwqQ1lJALMS19x5HLb5CFUdMbXRhV5s5d8mIJV+Zhi6D1nHnA9jwRIu
         suxgAWPtOTFOneWZTCu/juLrTcv9x5dza/X6IYr4halI33dH3HX7AgT7Oz4XvVj1J3
         y1A4jq7g7/DFjNFzxLV7cowmesihz2SOiSNFgdrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arkadiusz Zema <A.Zema@falconvsystems.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 057/124] xsk: Do not discard packet when NETDEV_TX_BUSY
Date:   Mon, 12 Oct 2020 15:31:01 +0200
Message-Id: <20201012133149.619495048@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 642e450b6b5955f2059d0ae372183f7c6323f951 ]

In the skb Tx path, transmission of a packet is performed with
dev_direct_xmit(). When NETDEV_TX_BUSY is set in the drivers, it
signifies that it was not possible to send the packet right now,
please try later. Unfortunately, the xsk transmit code discarded the
packet and returned EBUSY to the application. Fix this unnecessary
packet loss, by not discarding the packet in the Tx ring and return
EAGAIN. As EAGAIN is returned to the application, it can then retry
the send operation later and the packet will then likely be sent as
the driver will then likely have space/resources to send the packet.

In summary, EAGAIN tells the application that the packet was not
discarded from the Tx ring and that it needs to call send()
again. EBUSY, on the other hand, signifies that the packet was not
sent and discarded from the Tx ring. The application needs to put
the packet on the Tx ring again if it wants it to be sent.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/bpf/1600257625-2353-1-git-send-email-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3700266229f63..dcce888b8ef54 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -375,15 +375,30 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
 		skb->destructor = xsk_destruct_skb;
 
+		/* Hinder dev_direct_xmit from freeing the packet and
+		 * therefore completing it in the destructor
+		 */
+		refcount_inc(&skb->users);
 		err = dev_direct_xmit(skb, xs->queue_id);
+		if  (err == NETDEV_TX_BUSY) {
+			/* Tell user-space to retry the send */
+			skb->destructor = sock_wfree;
+			/* Free skb without triggering the perf drop trace */
+			consume_skb(skb);
+			err = -EAGAIN;
+			goto out;
+		}
+
 		xskq_cons_release(xs->tx);
 		/* Ignore NET_XMIT_CN as packet might have been sent */
-		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
+		if (err == NET_XMIT_DROP) {
 			/* SKB completed but not sent */
+			kfree_skb(skb);
 			err = -EBUSY;
 			goto out;
 		}
 
+		consume_skb(skb);
 		sent_frame = true;
 	}
 
-- 
2.25.1



