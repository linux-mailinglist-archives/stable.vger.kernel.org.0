Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAD0582E28
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiG0RIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241451AbiG0RH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1061658D;
        Wed, 27 Jul 2022 09:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B6A601CE;
        Wed, 27 Jul 2022 16:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63E8C433C1;
        Wed, 27 Jul 2022 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940021;
        bh=B28QdpMn8RV/RTfUkpe7kvUhoTVi3QlwDrWpHF7ZnbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFVGA9RXG/FSAzOFiROn3vNbK4fG26lys57yx9EG8W9BGHSWxnEbR/BdWZ+EMiC5n
         0Ji/GEzYtDlpGlbwie1hr+Z0gJpzJ7ijaCyLr8FnGrSEUU5hH9wbxjWKjZ0RSzKwmk
         eufznZSqz2pJsv2zCDM6xbY+KzzljBj9Fgt9T2h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/201] net: netfilter: use kfree_drop_reason() for NF_DROP
Date:   Wed, 27 Jul 2022 18:09:43 +0200
Message-Id: <20220727161030.222475094@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit 2df3041ba3be950376e8c25a8f6da22f7fcc765c ]

Replace kfree_skb() with kfree_skb_reason() in nf_hook_slow() when
skb is dropped by reason of NF_DROP. Following new drop reasons
are introduced:

SKB_DROP_REASON_NETFILTER_DROP

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/netfilter/core.c       | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f329c617eb96..b63da0d1a4b2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -317,6 +317,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
+	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a8a64b97504d..3d89f7b09a43 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -16,6 +16,7 @@
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
+	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 60332fdb6dd4..cca0762a9010 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -592,7 +592,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		case NF_ACCEPT:
 			break;
 		case NF_DROP:
-			kfree_skb(skb);
+			kfree_skb_reason(skb,
+					 SKB_DROP_REASON_NETFILTER_DROP);
 			ret = NF_DROP_GETERR(verdict);
 			if (ret == 0)
 				ret = -EPERM;
-- 
2.35.1



