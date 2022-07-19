Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9283579931
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiGSMAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbiGSL7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349134507F;
        Tue, 19 Jul 2022 04:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0CB615AC;
        Tue, 19 Jul 2022 11:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D98C341C6;
        Tue, 19 Jul 2022 11:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231863;
        bh=YWGmD7EOXOZMv1GFRNn3KAWHs8vkGobCT8D4A5x8278=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNiXMkzmlcnUIfMs/SB7I5rBF1VEBnxydxWdhm0WWSCMhi5uXRzeI8+YbpvEMRjq7
         x+icfpCj1fLUtx3JbtDGZhP+5rLAfDkQI6JidX1/xAscfh5l6y5ffJV4+FyfUVLVWv
         eogghyRUZFXDdIt62q1ZQbHqm9F8TZPQoMB/tMbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/43] seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
Date:   Tue, 19 Jul 2022 13:53:54 +0200
Message-Id: <20220719114524.009871092@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit f048880fc77058d864aff5c674af7918b30f312a ]

The SRv6 End.B6 and End.B6.Encaps behaviors rely on functions
seg6_do_srh_{encap,inline}() to, respectively: i) encapsulate the
packet within an outer IPv6 header with the specified Segment Routing
Header (SRH); ii) insert the specified SRH directly after the IPv6
header of the packet.

This patch removes the initialization of the IPv6 header payload length
from the input_action_end_b6{_encap}() functions, as it is now handled
properly by seg6_do_srh_{encap,inline}() to avoid corruption of the skb
checksum.

Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_local.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 9a01f72d907f..8f8ea7a76b99 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -405,7 +405,6 @@ static int input_action_end_b6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	lookup_nexthop(skb, NULL, 0);
@@ -437,7 +436,6 @@ static int input_action_end_b6_encap(struct sk_buff *skb,
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	lookup_nexthop(skb, NULL, 0);
-- 
2.35.1



