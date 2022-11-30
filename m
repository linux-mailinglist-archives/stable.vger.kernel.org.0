Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A660C63DF34
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiK3So6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiK3Soj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82BF9701C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42979CE1ADA
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A16DC433C1;
        Wed, 30 Nov 2022 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833870;
        bh=/61q8hi+SyRLOLvmX+OkbAP5jWYFwYSKyAUDP1tCgLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XF87I9u0VjlpAWcj3uitCQDNCh1OMlOWYmk/Vl38l+MhMlnoevOWkK9GN5cJdBJtp
         WTHeQY03TiBPMc+fYV2/UgZdr/zTYbIpaTN5NT8SbuXSlXpZZzDXep4ci9KzmduslD
         gjGEzlRgB+o030xgbJQBIrYWriuCujL1gDfUclVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Monil Patel <monil191989@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 044/289] xfrm: fix "disable_policy" on ipv4 early demux
Date:   Wed, 30 Nov 2022 19:20:29 +0100
Message-Id: <20221130180545.130081576@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit 3a5913183aa1b14148c723bda030e6102ad73008 ]

The commit in the "Fixes" tag tried to avoid a case where policy check
is ignored due to dst caching in next hops.

However, when the traffic is locally consumed, the dst may be cached
in a local TCP or UDP socket as part of early demux. In this case the
"disable_policy" flag is not checked as ip_route_input_noref() was only
called before caching, and thus, packets after the initial packet in a
flow will be dropped if not matching policies.

Fix by checking the "disable_policy" flag also when a valid dst is
already available.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216557
Reported-by: Monil Patel <monil191989@gmail.com>
Fixes: e6175a2ed1f1 ("xfrm: fix "disable_policy" flag use when arriving from different devices")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

v2: use dev instead of skb->dev
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_input.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 1b512390b3cf..e880ce77322a 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -366,6 +366,11 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 					   iph->tos, dev);
 		if (unlikely(err))
 			goto drop_error;
+	} else {
+		struct in_device *in_dev = __in_dev_get_rcu(dev);
+
+		if (in_dev && IN_DEV_ORCONF(in_dev, NOPOLICY))
+			IPCB(skb)->flags |= IPSKB_NOPOLICY;
 	}
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-- 
2.35.1



