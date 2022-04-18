Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD595056DC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242546AbiDRNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243535AbiDRNlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:41:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ED02FFE9;
        Mon, 18 Apr 2022 05:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 177C6612E4;
        Mon, 18 Apr 2022 12:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9D8C385A1;
        Mon, 18 Apr 2022 12:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286759;
        bh=wkWfM70BODSDCl/XojrcBlfzYnjeTE+/YGugU8Xmf+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMSA9RsT4C6zI/DHCZQM6uceu4wTyJzQyVyDKjPFqf37QIVYsW2BO/XTF4XJ6SVkB
         dCFf9RlBQfLeMu5JkBIq5YaJKiQnc/mYaxVmtc/NXqiYmcPkHzIq4V02sPoUXyI2HG
         Qf92YV+v8Tm8tXqpun+IOt61hCRnxU3tFvJPauwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 236/284] ipv6: add missing tx timestamping on IPPROTO_RAW
Date:   Mon, 18 Apr 2022 14:13:37 +0200
Message-Id: <20220418121218.423694271@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit fbfb2321e950918b430e7225546296b2dcadf725 ]

Raw sockets support tx timestamping, but one case is missing.

IPPROTO_RAW takes a separate packet construction path. raw_send_hdrinc
has an explicit call to sock_tx_timestamp, but rawv6_send_hdrinc does
not. Add it.

Fixes: 11878b40ed5c ("net-timestamp: SOCK_RAW and PING timestamping")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 3d9d20074203..f0d8b7e9a685 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -622,7 +622,7 @@ static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 
 static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 			struct flowi6 *fl6, struct dst_entry **dstp,
-			unsigned int flags)
+			unsigned int flags, const struct sockcm_cookie *sockc)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
@@ -659,6 +659,8 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
+	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
 
@@ -945,7 +947,8 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 back_from_confirm:
 	if (hdrincl)
-		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst, msg->msg_flags);
+		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst,
+					msg->msg_flags, &sockc);
 	else {
 		ipc6.opt = opt;
 		lock_sock(sk);
-- 
2.35.1



