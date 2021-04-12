Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013E235BE50
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbhDLI5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239032AbhDLIzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0060A61262;
        Mon, 12 Apr 2021 08:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217702;
        bh=TilFfatGDQ8WsvWrUqOg9gPOx2fJy+GBEncMx4C+mAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bT1oInWw3G28zB0jK6v2v8dlz5azJmvsSMZHqSB8u+QASxOBNhGJLReaPCK2H0W+u
         FgBHNHQk7gpb98CfW1ldBqUVL5AcLuvvVbACWKDa9Mv20kEWvoQF+V/WDVqGn9I2uX
         MQNuxnsOtRA2OEwBAUvOjS09OU+XMy7JnhXrbpCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/188] xfrm: Provide private skb extensions for segmented and hw offloaded ESP packets
Date:   Mon, 12 Apr 2021 10:40:29 +0200
Message-Id: <20210412084017.476445404@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit c7dbf4c08868d9db89b8bfe8f8245ca61b01ed2f ]

Commit 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec
crypto offload.") added a XFRM_XMIT flag to avoid duplicate ESP trailer
insertion on HW offload. This flag is set on the secpath that is shared
amongst segments. This lead to a situation where some segments are
not transformed correctly when segmentation happens at layer 3.

Fix this by using private skb extensions for segmented and hw offloaded
ESP packets.

Fixes: 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto offload.")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 11 ++++++++++-
 net/ipv6/esp6_offload.c | 11 ++++++++++-
 net/xfrm/xfrm_device.c  |  2 --
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index d5c0f5a2a551..5aa7344dbec7 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -314,8 +314,17 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	ip_hdr(skb)->tot_len = htons(skb->len);
 	ip_send_check(ip_hdr(skb));
 
-	if (hw_offload)
+	if (hw_offload) {
+		if (!skb_ext_add(skb, SKB_EXT_SEC_PATH))
+			return -ENOMEM;
+
+		xo = xfrm_offload(skb);
+		if (!xo)
+			return -EINVAL;
+
+		xo->flags |= XFRM_XMIT;
 		return 0;
+	}
 
 	err = esp_output_tail(x, skb, &esp);
 	if (err)
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index f35203ab39f5..4af56affaafd 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -348,8 +348,17 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 
 	ipv6_hdr(skb)->payload_len = htons(len);
 
-	if (hw_offload)
+	if (hw_offload) {
+		if (!skb_ext_add(skb, SKB_EXT_SEC_PATH))
+			return -ENOMEM;
+
+		xo = xfrm_offload(skb);
+		if (!xo)
+			return -EINVAL;
+
+		xo->flags |= XFRM_XMIT;
 		return 0;
+	}
 
 	err = esp6_output_tail(x, skb, &esp);
 	if (err)
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index edf11893dbe8..6d6917b68856 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -134,8 +134,6 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	xo->flags |= XFRM_XMIT;
-
 	if (skb_is_gso(skb) && unlikely(x->xso.dev != dev)) {
 		struct sk_buff *segs;
 
-- 
2.30.2



