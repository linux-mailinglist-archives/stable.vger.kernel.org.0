Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90CD66C4EC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjAPQAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbjAPP7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:59:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED07D2385F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A22C9B81062
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057CBC433EF;
        Mon, 16 Jan 2023 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884772;
        bh=zcZbQURYp1IZ9FbIBuVxyn5sgoRJwWItAC98RqVTXAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRXzEu2PMAURdJvB0Jz/+wL15G9E5LxLGCu+PGrshq3Mu0ygrOimPV/i/r+1fewim
         BZCe62dqoAYD247F6JPTT7PRxtlNPK7gRWYZjZpALYANQocduBMHJMb5IwuSz2aWSY
         g6G3gnkNiUX6YVvITN020DwtvUShRDwapUATMFxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Richard Gobert <richardbgobert@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/183] gro: avoid checking for a failed search
Date:   Mon, 16 Jan 2023 16:50:55 +0100
Message-Id: <20230116154808.964447639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Richard Gobert <richardbgobert@gmail.com>

[ Upstream commit e081ecf084d31809242fb0b9f35484d5fb3a161a ]

After searching for a protocol handler in dev_gro_receive, checking for
failure is redundant. Skip the failure code after finding the
corresponding handler.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221108123320.GA59373@debian
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 7871f54e3dee ("gro: take care of DODGY packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 70 +++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index bc9451743307..8e0fe85a647d 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -489,45 +489,45 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ptype, head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_receive)
-			continue;
-
-		skb_set_network_header(skb, skb_gro_offset(skb));
-		skb_reset_mac_len(skb);
-		BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
-		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
-					 sizeof(u32))); /* Avoid slow unaligned acc */
-		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
-		NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
-		NAPI_GRO_CB(skb)->is_atomic = 1;
-		NAPI_GRO_CB(skb)->count = 1;
-		if (unlikely(skb_is_gso(skb))) {
-			NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
-			/* Only support TCP at the moment. */
-			if (!skb_is_gso_tcp(skb))
-				NAPI_GRO_CB(skb)->flush = 1;
-		}
-
-		/* Setup for GRO checksum validation */
-		switch (skb->ip_summed) {
-		case CHECKSUM_COMPLETE:
-			NAPI_GRO_CB(skb)->csum = skb->csum;
-			NAPI_GRO_CB(skb)->csum_valid = 1;
-			break;
-		case CHECKSUM_UNNECESSARY:
-			NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
-			break;
-		}
+		if (ptype->type == type && ptype->callbacks.gro_receive)
+			goto found_ptype;
+	}
+	rcu_read_unlock();
+	goto normal;
+
+found_ptype:
+	skb_set_network_header(skb, skb_gro_offset(skb));
+	skb_reset_mac_len(skb);
+	BUILD_BUG_ON(sizeof_field(struct napi_gro_cb, zeroed) != sizeof(u32));
+	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
+					sizeof(u32))); /* Avoid slow unaligned acc */
+	*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
+	NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
+	NAPI_GRO_CB(skb)->is_atomic = 1;
+	NAPI_GRO_CB(skb)->count = 1;
+	if (unlikely(skb_is_gso(skb))) {
+		NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
+		/* Only support TCP at the moment. */
+		if (!skb_is_gso_tcp(skb))
+			NAPI_GRO_CB(skb)->flush = 1;
+	}
 
-		pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
-					ipv6_gro_receive, inet_gro_receive,
-					&gro_list->list, skb);
+	/* Setup for GRO checksum validation */
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		NAPI_GRO_CB(skb)->csum = skb->csum;
+		NAPI_GRO_CB(skb)->csum_valid = 1;
+		break;
+	case CHECKSUM_UNNECESSARY:
+		NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
 		break;
 	}
-	rcu_read_unlock();
 
-	if (&ptype->list == head)
-		goto normal;
+	pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
+				ipv6_gro_receive, inet_gro_receive,
+				&gro_list->list, skb);
+
+	rcu_read_unlock();
 
 	if (PTR_ERR(pp) == -EINPROGRESS) {
 		ret = GRO_CONSUMED;
-- 
2.35.1



