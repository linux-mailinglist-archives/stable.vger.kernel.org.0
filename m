Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50CC582E7C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbiG0RNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241532AbiG0RMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:12:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA7A5141E;
        Wed, 27 Jul 2022 09:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 854FDB821D7;
        Wed, 27 Jul 2022 16:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FE6C433C1;
        Wed, 27 Jul 2022 16:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940110;
        bh=dX2+usKkMs6QVDHsG9LU9bsX+tJXsNK7ZQnTcmsdsNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBevXiK/YNMuk4afnU7hC2fZ1D12Ti2Mmv+rW59POCjyr75Swfvz85JSepTqyr4V5
         dgZrF9f8nhXIso8LOxiwVdfMJL3o6yfTz3fQbLzx8DQvJtWWPCck/2gFlycEGBgLV4
         lCdGkSRHeaPA6/RxJFffjOIUi30esBaC+plMGmWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/201] net: socket: rename SKB_DROP_REASON_SOCKET_FILTER
Date:   Wed, 27 Jul 2022 18:09:41 +0200
Message-Id: <20220727161030.135220141@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit 364df53c081d93fcfd6b91085ff2650c7f17b3c7 ]

Rename SKB_DROP_REASON_SOCKET_FILTER, which is used
as the reason of skb drop out of socket filter before
it's part of a released kernel. It will be used for
more protocols than just TCP in future series.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/all/20220127091308.91401-2-imagedong@tencent.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h     | 2 +-
 include/trace/events/skb.h | 2 +-
 net/ipv4/tcp_ipv4.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 66aac2006868..f92f05c9d72d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -315,7 +315,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_NO_SOCKET,
 	SKB_DROP_REASON_PKT_TOO_SMALL,
 	SKB_DROP_REASON_TCP_CSUM,
-	SKB_DROP_REASON_TCP_FILTER,
+	SKB_DROP_REASON_SOCKET_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
 	SKB_DROP_REASON_MAX,
 };
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3e042ca2cedb..a8a64b97504d 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -14,7 +14,7 @@
 	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
 	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
-	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
+	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d901858aa440..235ae91bfd5a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2098,7 +2098,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb)) {
-		drop_reason = SKB_DROP_REASON_TCP_FILTER;
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
 	}
 	th = (const struct tcphdr *)skb->data;
-- 
2.35.1



