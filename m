Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F5835B890
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhDLCXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236617AbhDLCXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843126120D;
        Mon, 12 Apr 2021 02:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194197;
        bh=hFJXZFXetVaNr3IZQni1aNDSiiPTUjJob4vHZbFFkTE=;
        h=From:To:Subject:Date:From;
        b=vAoS7TzqJ8WhwzJ0PszcmssOYvKS40Ei+YtpyGp4uNUmlpkxKnunMebjuLI/WDeB5
         Fwnbmudyr1ca8EdEGtXgip0yVou2hvIZVxTVdhxXup8BMUWB42g5hpR+9NA8ahj+YQ
         GSw/6NthsqRlXfn/gcppmd2+sIqg69thEqFgyy1W/EdqbE1Fr8sjFJ+A6YXm5RQhTK
         V47tYjNemDEV+VTfZZF/y8s2/6jGZhUibbFve1kgM3KXhi+T8Z2aFUHTGhBN0W1UPW
         QamaHD3t98+6mFWplENgbDanr5Hz0//uSK+rCwJ2sgCDQ6SD/p59dN+SxlBFVHc9PV
         ddLHnEeSL/xWg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, steffen.klassert@secunet.com
Subject: FAILED: Patch "xfrm: Provide private skb extensions for segmented and hw offloaded ESP packets" failed to apply to 4.19-stable tree
Date:   Sun, 11 Apr 2021 22:23:16 -0400
Message-Id: <20210412022316.284101-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From c7dbf4c08868d9db89b8bfe8f8245ca61b01ed2f Mon Sep 17 00:00:00 2001
From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 26 Mar 2021 09:44:48 +0100
Subject: [PATCH] xfrm: Provide private skb extensions for segmented and hw
 offloaded ESP packets

Commit 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec
crypto offload.") added a XFRM_XMIT flag to avoid duplicate ESP trailer
insertion on HW offload. This flag is set on the secpath that is shared
amongst segments. This lead to a situation where some segments are
not transformed correctly when segmentation happens at layer 3.

Fix this by using private skb extensions for segmented and hw offloaded
ESP packets.

Fixes: 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto offload.")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 11 ++++++++++-
 net/ipv6/esp6_offload.c | 11 ++++++++++-
 net/xfrm/xfrm_device.c  |  2 --
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index ed3de486ea34..33687cf58286 100644
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




