Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6781549260
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378649AbiFMNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379226AbiFMNkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E00D101;
        Mon, 13 Jun 2022 04:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 58C98CE118D;
        Mon, 13 Jun 2022 11:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8E4C34114;
        Mon, 13 Jun 2022 11:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119837;
        bh=ynOFQ8Z5PHk22tFvFXyTLb5N/IoZjn9NfGABCiTAL7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pknfhRid3PqIPjG8BA2CivZEMZS0YAX507d/WBOYz6b1ZO20eJdKLCJQY+n3ul5OQ
         5BVV/9GnWz0/AvF8+IRVdJ/zz3deoqlC6ajVWrO9ATAFqoABy3L6k9dI1JEZ9ERH1g
         ORxkUGUtTqyZde3U6lICBxkfe/8V4EdHXXxvty3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 137/339] net: ping6: Fix ping -6 with interface name
Date:   Mon, 13 Jun 2022 12:09:22 +0200
Message-Id: <20220613094930.837070203@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit e6652a8ef3e64d953168a95878fe29b934ad78ac ]

When passing interface parameter to ping -6:
$ ping -6 ::11:141:84:9 -I eth2
Results in:
PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
ping: sendmsg: Invalid argument
ping: sendmsg: Invalid argument

Initialize the fl6's outgoing interface (OIF) before triggering
ip6_datagram_send_ctl. Don't wipe fl6 after ip6_datagram_send_ctl() as
changes in fl6 that may happen in the function are overwritten explicitly.
Update comment accordingly.

Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220531084544.15126-1-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ping.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ff033d16549e..ecf3a553a0dc 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -101,6 +101,9 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.flowi6_oif = oif;
+
 	if (msg->msg_controllen) {
 		struct ipv6_txoptions opt = {};
 
@@ -112,17 +115,14 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			return err;
 
 		/* Changes to txoptions and flow info are not implemented, yet.
-		 * Drop the options, fl6 is wiped below.
+		 * Drop the options.
 		 */
 		ipc6.opt = NULL;
 	}
 
-	memset(&fl6, 0, sizeof(fl6));
-
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
 	fl6.saddr = np->saddr;
 	fl6.daddr = *daddr;
-	fl6.flowi6_oif = oif;
 	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.flowi6_uid = sk->sk_uid;
 	fl6.fl6_icmp_type = user_icmph.icmp6_type;
-- 
2.35.1



