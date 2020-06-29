Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CB120D966
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgF2TrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387793AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 885782488B;
        Mon, 29 Jun 2020 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444387;
        bh=3CglZHuljkkADsd4TkG/kpq6POnEr9MsIg4EbCynKUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vb2nf2gxupDj+2Yx5ARvqPfoR3BWt8DW8sff9XKYCPqMZ+3lnspFWkTBefuvJ8XbB
         iA/BgV6vfsQ/izmGzmHSK1SY6o8sNHkM7Ng2boy5mLMKNB12AUcuxAGHrNKRwWqc/j
         8kF5AFvNPFgL2CuVgwTLhuZ+Cq3MXscNtVbJCV+A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huy Nguyen <huyn@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/178] xfrm: Fix double ESP trailer insertion in IPsec crypto offload.
Date:   Mon, 29 Jun 2020 11:23:29 -0400
Message-Id: <20200629152523.2494198-65-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

[ Upstream commit 94579ac3f6d0820adc83b5dc5358ead0158101e9 ]

During IPsec performance testing, we see bad ICMP checksum. The error packet
has duplicated ESP trailer due to double validate_xmit_xfrm calls. The first call
is from ip_output, but the packet cannot be sent because
netif_xmit_frozen_or_stopped is true and the packet gets dev_requeue_skb. The second
call is from NET_TX softirq. However after the first call, the packet already
has the ESP trailer.

Fix by marking the skb with XFRM_XMIT bit after the packet is handled by
validate_xmit_xfrm to avoid duplicate ESP trailer insertion.

Fixes: f6e27114a60a ("net: Add a xfrm validate function to validate_xmit_skb")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     | 1 +
 net/xfrm/xfrm_device.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index aa08a7a5f6ac5..fb391c00c19ac 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1012,6 +1012,7 @@ struct xfrm_offload {
 #define	XFRM_GRO		32
 #define	XFRM_ESP_NO_TRAILER	64
 #define	XFRM_DEV_RESUME		128
+#define	XFRM_XMIT		256
 
 	__u32			status;
 #define CRYPTO_SUCCESS				1
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c365b918be35c..bb2292b5260c2 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -82,7 +82,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
-	if (!xo)
+	if (!xo || (xo->flags & XFRM_XMIT))
 		return skb;
 
 	if (!(features & NETIF_F_HW_ESP))
@@ -103,6 +103,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
+	xo->flags |= XFRM_XMIT;
+
 	if (skb_is_gso(skb)) {
 		struct net_device *dev = skb->dev;
 
-- 
2.25.1

