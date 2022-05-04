Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C9051A8F4
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355068AbiEDRQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355038AbiEDRLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:11:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A13E4B845;
        Wed,  4 May 2022 09:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2655B827A3;
        Wed,  4 May 2022 16:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCCDC385A4;
        Wed,  4 May 2022 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683454;
        bh=uNDN8A8qsXZol7TTIOtlrkvOZ9SMvxddG+IitYyh9TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHD4GxcyXiTgSz/4w15AFC6QR5mSyYgFDLrHZegkvw72N6ZWMqGNGlVSDqFWkYoav
         +Wz4WPwdqlobyDBUbCda7SjxbAO2yUwP7PGirlhuMOcHzVP1cTIsmvgJlERNDDEIS6
         mCw/2e/Ny/kBzHhkvQDn5ls05tDc6bYUAGAWoo6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 121/225] ip_gre: Make o_seqno start from 0 in native mode
Date:   Wed,  4 May 2022 18:45:59 +0200
Message-Id: <20220504153121.269949239@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 99db2e41ed10..ca70b92e80d9 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -459,14 +459,12 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
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



