Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC28C63534D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbiKWIyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbiKWIyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:54:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC11F2C37
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 505D6B81EED
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7729EC433C1;
        Wed, 23 Nov 2022 08:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193638;
        bh=edHHhhyaSRG8UU1YJs5iEYdsUNLH3my41z3iQZV3wO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjNdIPJjiMJjIRkVrXTRvHEVELhG0fBA6sBdF130VF6cxwjpQuKWU0PjCHUP8Akv1
         zATskYLXrb7xDV9uvrCH/aWzXTyIn52FCjEnjxKV2890PGkFVDlPOTIpkAF6CerSZx
         mKoucrDXoQiuSFa+REn6UbDh1KQd5lzQRM8ZLm+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Benc <jbenc@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/76] net: gso: fix panic on frag_list with mixed head alloc types
Date:   Wed, 23 Nov 2022 09:50:01 +0100
Message-Id: <20221123084546.824545159@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 9e4b7a99a03aefd37ba7bb1f022c8efab5019165 ]

Since commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when
splitting gso_size mangled skb having linear-headed frag_list"), it is
allowed to change gso_size of a GRO packet. However, that commit assumes
that "checking the first list_skb member suffices; i.e if either of the
list_skb members have non head_frag head, then the first one has too".

It turns out this assumption does not hold. We've seen BUG_ON being hit
in skb_segment when skbs on the frag_list had differing head_frag with
the vmxnet3 driver. This happens because __netdev_alloc_skb and
__napi_alloc_skb can return a skb that is page backed or kmalloced
depending on the requested size. As the result, the last small skb in
the GRO packet can be kmalloced.

There are three different locations where this can be fixed:

(1) We could check head_frag in GRO and not allow GROing skbs with
    different head_frag. However, that would lead to performance
    regression on normal forward paths with unmodified gso_size, where
    !head_frag in the last packet is not a problem.

(2) Set a flag in bpf_skb_net_grow and bpf_skb_net_shrink indicating
    that NETIF_F_SG is undesirable. That would need to eat a bit in
    sk_buff. Furthermore, that flag can be unset when all skbs on the
    frag_list are page backed. To retain good performance,
    bpf_skb_net_grow/shrink would have to walk the frag_list.

(3) Walk the frag_list in skb_segment when determining whether
    NETIF_F_SG should be cleared. This of course slows things down.

This patch implements (3). To limit the performance impact in
skb_segment, the list is walked only for skbs with SKB_GSO_DODGY set
that have gso_size changed. Normal paths thus will not hit it.

We could check only the last skb but since we need to walk the whole
list anyway, let's stay on the safe side.

Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/e04426a6a91baf4d1081e1b478c82b5de25fdf21.1667407944.git.jbenc@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 022e26c18024..5dcdbffdee49 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3125,23 +3125,25 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	int pos;
 	int dummy;
 
-	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
-	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
-		/* gso_size is untrusted, and we have a frag_list with a linear
-		 * non head_frag head.
-		 *
-		 * (we assume checking the first list_skb member suffices;
-		 * i.e if either of the list_skb members have non head_frag
-		 * head, then the first one has too).
-		 *
-		 * If head_skb's headlen does not fit requested gso_size, it
-		 * means that the frag_list members do NOT terminate on exact
-		 * gso_size boundaries. Hence we cannot perform skb_frag_t page
-		 * sharing. Therefore we must fallback to copying the frag_list
-		 * skbs; we do so by disabling SG.
-		 */
-		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
-			features &= ~NETIF_F_SG;
+	if ((skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY) &&
+	    mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb)) {
+		struct sk_buff *check_skb;
+
+		for (check_skb = list_skb; check_skb; check_skb = check_skb->next) {
+			if (skb_headlen(check_skb) && !check_skb->head_frag) {
+				/* gso_size is untrusted, and we have a frag_list with
+				 * a linear non head_frag item.
+				 *
+				 * If head_skb's headlen does not fit requested gso_size,
+				 * it means that the frag_list members do NOT terminate
+				 * on exact gso_size boundaries. Hence we cannot perform
+				 * skb_frag_t page sharing. Therefore we must fallback to
+				 * copying the frag_list skbs; we do so by disabling SG.
+				 */
+				features &= ~NETIF_F_SG;
+				break;
+			}
+		}
 	}
 
 	__skb_push(head_skb, doffset);
-- 
2.35.1



