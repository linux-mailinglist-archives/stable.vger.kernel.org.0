Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955BCACEA4
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfIHMoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729846AbfIHMoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:44:38 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD9B218AF;
        Sun,  8 Sep 2019 12:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946677;
        bh=/Q7HlGJnekc1Ftvo7Rzqe8mCBBoL7JmB5U5mLKnD57U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEHrAR1bmByBnaXjo7gQvsPLWO/dIUxop0trqCtY5soG759IElzvh+h9vXkS7noe1
         pFMkO9H1wcYuc1EeSuNATpyIChmrMqtpfun4Z0mH41frtTnt501h6xS4eEs3H967db
         knMGE1VcAWDJwzq+Dhv9pLdP7rL368eZXhDJ5CAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 25/26] tcp: inherit timestamp on mtu probe
Date:   Sun,  8 Sep 2019 13:42:04 +0100
Message-Id: <20190908121111.224659994@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121057.216802689@linuxfoundation.org>
References: <20190908121057.216802689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 888a5c53c0d8be6e98bc85b677f179f77a647873 ]

TCP associates tx timestamp requests with a byte in the bytestream.
If merging skbs in tcp_mtu_probe, migrate the tstamp request.

Similar to MSG_EOR, do not allow moving a timestamp from any segment
in the probe but the last. This to avoid merging multiple timestamps.

Tested with the packetdrill script at
https://github.com/wdebruij/packetdrill/commits/mtu_probe-1

Link: http://patchwork.ozlabs.org/patch/1143278/#2232897
Fixes: 4ed2d765dfac ("net-timestamp: TCP timestamping")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1943,7 +1943,7 @@ static bool tcp_can_coalesce_send_queue_
 		if (len <= skb->len)
 			break;
 
-		if (unlikely(TCP_SKB_CB(skb)->eor))
+		if (unlikely(TCP_SKB_CB(skb)->eor) || tcp_has_tx_tstamp(skb))
 			return false;
 
 		len -= skb->len;
@@ -2066,6 +2066,7 @@ static int tcp_mtu_probe(struct sock *sk
 			 * we need to propagate it to the new skb.
 			 */
 			TCP_SKB_CB(nskb)->eor = TCP_SKB_CB(skb)->eor;
+			tcp_skb_collapse_tstamp(nskb, skb);
 			tcp_unlink_write_queue(skb, sk);
 			sk_wmem_free_skb(sk, skb);
 		} else {


