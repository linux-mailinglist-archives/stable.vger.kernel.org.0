Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9561891FF
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCQX17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:59 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53636 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgCQX17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0CZ5FiC9gp6P7Sb0uFTXY5AGUgxQGYJjecNvUxSx+0=;
        b=pUmNHm//HeXsrfEQ/livqn2tgiSXVNbh51/0Itbx2f8z0vvBS9w6sNmS8gVApQ5h92/3uZ
        pskKUFXbsMHPw/9tcwoLaz3YPC26plQei93HgnMJi7FgYI9F+kBsaR/AwIlxl+TYNXDWXY
        zcVd+RKL/L3jw/SzWP5jT9fmg7GVSb8=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 16/48] batman-adv: Avoid nullptr dereference in bla after vlan_insert_tag
Date:   Wed, 18 Mar 2020 00:27:02 +0100
Message-Id: <20200317232734.6127-17-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 10c78f5854d361ded4736c1831948e0a5f67b932 upstream.

vlan_insert_tag can return NULL on errors. The bridge loop avoidance code
therefore has to check the return value of vlan_insert_tag for NULL before
it can safely operate on this pointer.

Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index c5208136e3fc..6749fe7e0321 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -352,9 +352,12 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 		break;
 	}
 
-	if (vid & BATADV_VLAN_HAS_TAG)
+	if (vid & BATADV_VLAN_HAS_TAG) {
 		skb = vlan_insert_tag(skb, htons(ETH_P_8021Q),
 				      vid & VLAN_VID_MASK);
+		if (!skb)
+			goto out;
+	}
 
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_type_trans(skb, soft_iface);
-- 
2.20.1

