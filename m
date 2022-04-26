Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF34E50F3DC
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbiDZI3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344711AbiDZI1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:27:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11C53DDD5;
        Tue, 26 Apr 2022 01:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E129B81CFE;
        Tue, 26 Apr 2022 08:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62054C385A0;
        Tue, 26 Apr 2022 08:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961438;
        bh=y5gL0drNcpQgXl80MBpt3bCUErZEwymK2/f/YuqhL/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEf4UqnBTT2Eah56Ltm/KZHAoBnDCrCbVledC+0SsCCToDrqIK3QGfU1wVwJPUSg1
         MuS6zbZyokDCTBI/qG7yPYFM9gm73WNKxS9aohcqElQyyJMRyjzj+8+CKlElwzFeJK
         jgJnn/9lzwGtwFO9aoH07k75a/EYPbV/xkbHlSs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Flavio Leitner <fbl@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/43] net/packet: fix packet_sock xmit return value checking
Date:   Tue, 26 Apr 2022 10:20:53 +0200
Message-Id: <20220426081734.851239352@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 29e8e659f984be00d75ec5fef4e37c88def72712 ]

packet_sock xmit could be dev_queue_xmit, which also returns negative
errors. So only checking positive errors is not enough, or userspace
sendmsg may return success while packet is not send out.

Move the net_xmit_errno() assignment in the braces as checkpatch.pl said
do not use assignment in if condition.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b0dd17d1992e..61093ce76b61 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2829,8 +2829,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		status = TP_STATUS_SEND_REQUEST;
 		err = po->xmit(skb);
-		if (unlikely(err > 0)) {
-			err = net_xmit_errno(err);
+		if (unlikely(err != 0)) {
+			if (err > 0)
+				err = net_xmit_errno(err);
 			if (err && __packet_get_status(po, ph) ==
 				   TP_STATUS_AVAILABLE) {
 				/* skb was destructed already */
@@ -3029,8 +3030,12 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		skb->no_fcs = 1;
 
 	err = po->xmit(skb);
-	if (err > 0 && (err = net_xmit_errno(err)) != 0)
-		goto out_unlock;
+	if (unlikely(err != 0)) {
+		if (err > 0)
+			err = net_xmit_errno(err);
+		if (err)
+			goto out_unlock;
+	}
 
 	dev_put(dev);
 
-- 
2.35.1



