Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA16431E1
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiLETVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiLETVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:21:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CFF2A704
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:17:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 519BECE13A8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EBCC433D7;
        Mon,  5 Dec 2022 19:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267793;
        bh=FCW2VatGbSHdymSxJgiAs32uem4+W7Lh72B1bQ9sstM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LlnG04qK9XMcKozNh0msc0g+oPL/xopV9KN3TQryc1O+ZfVbNXqy3JuKh0eLfdoi
         1lGNSPkbKJa9slGWHpHML8ZVQ/DN7O7VndyKrcf0XGlp7FJgNgNxapvuNLl2w7I9eV
         dt1mw37qGjKsuZzNNlXByGkO5L2lDjY2pfZKBXm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 54/77] packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE
Date:   Mon,  5 Dec 2022 20:09:45 +0100
Message-Id: <20221205190802.780399569@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b85f628aa158a653c006e9c1405a117baef8c868 ]

CHECKSUM_COMPLETE signals that skb->csum stores the sum over the
entire packet. It does not imply that an embedded l4 checksum
field has been validated.

Fixes: 682f048bd494 ("af_packet: pass checksum validation status to the user")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20221128161812.640098-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 61093ce76b61..1be5fb6af017 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2248,8 +2248,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
 	else if (skb->pkt_type != PACKET_OUTGOING &&
-		 (skb->ip_summed == CHECKSUM_COMPLETE ||
-		  skb_csum_unnecessary(skb)))
+		 skb_csum_unnecessary(skb))
 		status |= TP_STATUS_CSUM_VALID;
 
 	if (snaplen > res)
@@ -3488,8 +3487,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			aux.tp_status |= TP_STATUS_CSUMNOTREADY;
 		else if (skb->pkt_type != PACKET_OUTGOING &&
-			 (skb->ip_summed == CHECKSUM_COMPLETE ||
-			  skb_csum_unnecessary(skb)))
+			 skb_csum_unnecessary(skb))
 			aux.tp_status |= TP_STATUS_CSUM_VALID;
 
 		aux.tp_len = origlen;
-- 
2.35.1



