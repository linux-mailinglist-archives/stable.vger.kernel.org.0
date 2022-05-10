Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8B7521722
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbiEJNXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243742AbiEJNWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28D113F93D;
        Tue, 10 May 2022 06:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56F9D61574;
        Tue, 10 May 2022 13:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD78C385A6;
        Tue, 10 May 2022 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188605;
        bh=Aguhp1BFM4cMbxLn8rL9GAdEBOd9nfdi2j6i0pTxaxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXeYDqHuTmue6lROai3I/48qXWVZzGKhLP5JdCt3FkTNg8RmLwgXtz7tlqIuGoI5I
         iYcTAs3gQ1jzPkoEzsV9WKD5tpLI+DuY99zyWIQnnSOaswWo8R5HzzsTQO/WCgUCjS
         v+8VdcC90JMnFb9P7wC1Uqwze2EdW15PcWK0j9fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/78] ip_gre: Make o_seqno start from 0 in native mode
Date:   Tue, 10 May 2022 15:07:21 +0200
Message-Id: <20220510130733.574189963@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit ff827beb706ed719c766acf36449801ded0c17fc ]

For GRE and GRETAP devices, currently o_seqno starts from 1 in native
mode.  According to RFC 2890 2.2., "The first datagram is sent with a
sequence number of 0."  Fix it.

It is worth mentioning that o_seqno already starts from 0 in collect_md
mode, see gre_fb_xmit(), where tunnel->o_seqno is passed to
gre_build_header() before getting incremented.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 1a4d89f8361c..d916accd9783 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -429,14 +429,12 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 		       __be16 proto)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-
-	if (tunnel->parms.o_flags & TUNNEL_SEQ)
-		tunnel->o_seqno++;
+	__be16 flags = tunnel->parms.o_flags;
 
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
-			 tunnel->parms.o_flags, proto, tunnel->parms.o_key,
-			 htonl(tunnel->o_seqno));
+			 flags, proto, tunnel->parms.o_key,
+			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
 
 	ip_tunnel_xmit(skb, dev, tnl_params, tnl_params->protocol);
 }
-- 
2.35.1



