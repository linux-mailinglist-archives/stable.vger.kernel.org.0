Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18A3579B02
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbiGSMX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239562AbiGSMXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:23:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE875E315;
        Tue, 19 Jul 2022 05:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4AB50CE1BE6;
        Tue, 19 Jul 2022 12:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F94C341C6;
        Tue, 19 Jul 2022 12:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232470;
        bh=F+g/UHoFgRdUMKnO5CFsIPv3T1WPhvjiuE9ygdi1nt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT5Amh+HFUZ9eG8Okt2t8ZT0m18vIP0pvR+s+agMThnleMtanBO3aQmz+DaQ3vnxS
         CAjhDUqL/0irNdajHMec0+51DpXKLopknnfkjqV1/mwHVWrEJvocHUZjifx+p9Tgvc
         pKTJN6VZsHUaKNFyRp77vHw/2qtCPXhfaYzV2Rck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/112] seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
Date:   Tue, 19 Jul 2022 13:54:02 +0200
Message-Id: <20220719114633.167685719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
index eba23279912d..11f7da4139f6 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -435,7 +435,6 @@ static int input_action_end_b6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	seg6_lookup_nexthop(skb, NULL, 0);
@@ -467,7 +466,6 @@ static int input_action_end_b6_encap(struct sk_buff *skb,
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	seg6_lookup_nexthop(skb, NULL, 0);
-- 
2.35.1



