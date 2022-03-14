Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC3B4D8323
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbiCNMMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242392AbiCNMJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58D56404;
        Mon, 14 Mar 2022 05:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 744B5B80DED;
        Mon, 14 Mar 2022 12:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9096C340EC;
        Mon, 14 Mar 2022 12:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259668;
        bh=dQE9AN0W3xhOOojm4d6cc0ZVs/VcgoMmZFSyfL9v3+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2H3d7uU+57Zd59ZIej/qiKmal169BeekIH6tY1uFdYkQmbuOszYGvDNcgTacdPzFQ
         Ax6HMtCuQp5s0XFKJpUpBrnbn/MBsjT20w6aGvRwD+5kAmVOXx+IMRWQUG8lkqbfFK
         ly2uVu5Uit+gXjAO4u4XjISlHEhHm5GggT0irB8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/110] tipc: fix incorrect order of state message data sanity check
Date:   Mon, 14 Mar 2022 12:53:37 +0100
Message-Id: <20220314112744.017934814@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

[ Upstream commit c79fcc27be90b308b3fa90811aefafdd4078668c ]

When receiving a state message, function tipc_link_validate_msg()
is called to validate its header portion. Then, its data portion
is validated before it can be accessed correctly. However, current
data sanity  check is done after the message header is accessed to
update some link variables.

This commit fixes this issue by moving the data sanity check to
the beginning of state message handling and right after the header
sanity check.

Fixes: 9aa422ad3266 ("tipc: improve size validations for received domain records")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Link: https://lore.kernel.org/r/20220308021200.9245-1-tung.q.nguyen@dektech.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 4e7936d9b442..115a4a7950f5 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2285,6 +2285,11 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		break;
 
 	case STATE_MSG:
+		/* Validate Gap ACK blocks, drop if invalid */
+		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
+		if (glen > dlen)
+			break;
+
 		l->rcv_nxt_state = msg_seqno(hdr) + 1;
 
 		/* Update own tolerance if peer indicates a non-zero value */
@@ -2310,10 +2315,6 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 			break;
 		}
 
-		/* Receive Gap ACK blocks from peer if any */
-		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
-		if(glen > dlen)
-			break;
 		tipc_mon_rcv(l->net, data + glen, dlen - glen, l->addr,
 			     &l->mon_state, l->bearer_id);
 
-- 
2.34.1



