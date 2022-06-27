Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0844D55DE7F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237715AbiF0LtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238418AbiF0LsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E38FD39;
        Mon, 27 Jun 2022 04:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 748DAB81123;
        Mon, 27 Jun 2022 11:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51F3C3411D;
        Mon, 27 Jun 2022 11:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330075;
        bh=4M6/LgjfkYIQkAY4gTnqSLIOWKBiQFCtYcUKZIJRxKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5coTcIj2IeQQc3razdM7IOYc4rP8v9rpdhKpedDj9s6mBJ4yNUrufVUHREohPEYj
         IJAbcEnkYDnAokStGmO1McHRvSBwifrYEQNiingsmCKNNnOOWsFfmVCtl31Yo1hW1x
         Sz6CXNHYCkmq15IaxgVFQnTs7E3Bw0pus5Ufp70g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 048/181] xsk: Fix generic transmit when completion queue reservation fails
Date:   Mon, 27 Jun 2022 13:20:21 +0200
Message-Id: <20220627111945.957686172@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

[ Upstream commit a6e944f25cdbe6b82275402b8bc9a55ad7aac10b ]

Two points of potential failure in the generic transmit function are:

  1. completion queue (cq) reservation failure.
  2. skb allocation failure

Originally the cq reservation was performed first, followed by the skb
allocation. Commit 675716400da6 ("xdp: fix possible cq entry leak")
reversed the order because at the time there was no mechanism available
to undo the cq reservation which could have led to possible cq entry leaks
in the event of skb allocation failure. However if the skb allocation is
performed first and the cq reservation then fails, the xsk skb destructor
is called which blindly adds the skb address to the already full cq leading
to undefined behavior.

This commit restores the original order (cq reservation followed by skb
allocation) and uses the xskq_prod_cancel helper to undo the cq reserve
in event of skb allocation failure.

Fixes: 675716400da6 ("xdp: fix possible cq entry leak")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220614070746.8871-1-ciara.loftus@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index d6bcdbfd0fc5..9b12ea3ab85a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -538,12 +538,6 @@ static int xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
-		skb = xsk_build_skb(xs, &desc);
-		if (IS_ERR(skb)) {
-			err = PTR_ERR(skb);
-			goto out;
-		}
-
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
@@ -552,11 +546,19 @@ static int xsk_generic_xmit(struct sock *sk)
 		spin_lock_irqsave(&xs->pool->cq_lock, flags);
 		if (xskq_prod_reserve(xs->pool->cq)) {
 			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
-			kfree_skb(skb);
 			goto out;
 		}
 		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
+		skb = xsk_build_skb(xs, &desc);
+		if (IS_ERR(skb)) {
+			err = PTR_ERR(skb);
+			spin_lock_irqsave(&xs->pool->cq_lock, flags);
+			xskq_prod_cancel(xs->pool->cq);
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+			goto out;
+		}
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
-- 
2.35.1



