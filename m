Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2325363DE3A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiK3SfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiK3Sez (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:34:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB6894910
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FDCBB81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818ACC433C1;
        Wed, 30 Nov 2022 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833291;
        bh=3FEH4svVzkYeoaa6ZutCgXlK7jfyfHYi9LMUFaXwG4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ga9y3eovc2gtOfTZsP+PMj6p6LrQurDU1ZbkniSiGk/Y8104uOYHMyNd4N0NJSgxK
         jwpBNLa44jT/g8+eF4o0AuhF8UkL+32SBQ/wV5xYQ0qN9GGzvR68+nVWuwkbJh+MMw
         nPVB5X10sdxA51SOWdOGz7TLkhQiJhoRAb1U4rSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Monil Patel <monil191989@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/206] xfrm: fix "disable_policy" on ipv4 early demux
Date:   Wed, 30 Nov 2022 19:21:47 +0100
Message-Id: <20221130180534.399820717@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index 459d7e630cb0..124bf8fdf924 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -364,6 +364,11 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
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



