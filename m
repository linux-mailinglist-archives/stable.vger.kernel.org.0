Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326D418B7F9
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCSNhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbgCSNI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47EFB20789;
        Thu, 19 Mar 2020 13:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623308;
        bh=PXYai1ZiJAgW5vL3Zh/m08qdMjBroO5ouphz7+nA/oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0MhjwdQyoq9ifv6rbKAEPJYaZkHp2zValX5aOtRbqkqx0BDbAG3zqr314mq+xRoY
         UobdhL6wAbGiroiXBOLcAyRwWlkZIkM1RTD2f0oNpaoL7YmnfM2Jb0aSMWVCdqKLL2
         6W27gE+m51a3BfrCz+lCy+qtOBgPja0adHphQ9LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 62/93] batman-adv: Fix double free during fragment merge error
Date:   Thu, 19 Mar 2020 14:00:06 +0100
Message-Id: <20200319123944.598841370@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 248e23b50e2da0753f3b5faa068939cbe9f8a75a upstream.

The function batadv_frag_skb_buffer was supposed not to consume the skbuff
on errors. This was followed in the helper function
batadv_frag_insert_packet when the skb would potentially be inserted in the
fragment queue. But it could happen that the next helper function
batadv_frag_merge_packets would try to merge the fragments and fail. This
results in a kfree_skb of all the enqueued fragments (including the just
inserted one). batadv_recv_frag_packet would detect the error in
batadv_frag_skb_buffer and try to free the skb again.

The behavior of batadv_frag_skb_buffer (and its helper
batadv_frag_insert_packet) must therefore be changed to always consume the
skbuff to have a common behavior and avoid the double kfree_skb.

Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    6 ++++--
 net/batman-adv/routing.c       |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -233,8 +233,10 @@ err_unlock:
 	spin_unlock_bh(&chain->lock);
 
 err:
-	if (!ret)
+	if (!ret) {
 		kfree(frag_entry_new);
+		kfree_skb(skb);
+	}
 
 	return ret;
 }
@@ -329,9 +331,9 @@ bool batadv_frag_skb_buffer(struct sk_bu
 		goto out_err;
 
 out:
-	*skb = skb_out;
 	ret = true;
 out_err:
+	*skb = skb_out;
 	return ret;
 }
 
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1053,6 +1053,12 @@ int batadv_recv_frag_packet(struct sk_bu
 	batadv_inc_counter(bat_priv, BATADV_CNT_FRAG_RX);
 	batadv_add_counter(bat_priv, BATADV_CNT_FRAG_RX_BYTES, skb->len);
 
+	/* batadv_frag_skb_buffer will always consume the skb and
+	 * the caller should therefore never try to free the
+	 * skb after this point
+	 */
+	ret = NET_RX_SUCCESS;
+
 	/* Add fragment to buffer and merge if possible. */
 	if (!batadv_frag_skb_buffer(&skb, orig_node_src))
 		goto out;


