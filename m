Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D21DA903D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbfIDSI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389792AbfIDSI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:08:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF84920870;
        Wed,  4 Sep 2019 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620507;
        bh=/rTf8DzgI8IYrGf5cmSkPBb6QTLA+lA/qUe2mdsLGio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2w4FVPiTe5T4ewtXEYttoikhzILNPjXVnhwxjzx9JzFRtkccvspU8G/rSDmyVwDp
         9vt7bsKlXMAxq1FmGLcXHmQr8F+RGWSPuoltdz5haRK9DXIm+LfAERyYSEdj3uQum+
         onjE3mrq6He4pG30PIUB3LjuAzyex5ZZH75KVuXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 82/93] mac80211: Dont memset RXCB prior to PAE intercept
Date:   Wed,  4 Sep 2019 19:54:24 +0200
Message-Id: <20190904175310.180060830@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Kenzior <denkenz@gmail.com>

commit c8a41c6afa27b8c3f61622dfd882b912da9d6721 upstream.

In ieee80211_deliver_skb_to_local_stack intercepts EAPoL frames if
mac80211 is configured to do so and forwards the contents over nl80211.
During this process some additional data is also forwarded, including
whether the frame was received encrypted or not.  Unfortunately just
prior to the call to ieee80211_deliver_skb_to_local_stack, skb->cb is
cleared, resulting in incorrect data being exposed over nl80211.

Fixes: 018f6fbf540d ("mac80211: Send control port frames over nl80211")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Link: https://lore.kernel.org/r/20190827224120.14545-2-denkenz@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2377,6 +2377,8 @@ static void ieee80211_deliver_skb_to_loc
 		cfg80211_rx_control_port(dev, skb, noencrypt);
 		dev_kfree_skb(skb);
 	} else {
+		memset(skb->cb, 0, sizeof(skb->cb));
+
 		/* deliver to local stack */
 		if (rx->napi)
 			napi_gro_receive(rx->napi, skb);
@@ -2470,8 +2472,6 @@ ieee80211_deliver_skb(struct ieee80211_r
 
 	if (skb) {
 		skb->protocol = eth_type_trans(skb, dev);
-		memset(skb->cb, 0, sizeof(skb->cb));
-
 		ieee80211_deliver_skb_to_local_stack(skb, rx);
 	}
 


