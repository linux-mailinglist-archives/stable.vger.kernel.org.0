Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D854958A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358852AbiFMNLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357448AbiFMNHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:07:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9534C381BD;
        Mon, 13 Jun 2022 04:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75525B80EB1;
        Mon, 13 Jun 2022 11:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BD8C34114;
        Mon, 13 Jun 2022 11:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119122;
        bh=sEV7WN5gvPYHUR2+AlgrOnDLO7J8h7aP7imPvjQ0UJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtZQAd3VX+XjxFWIWZ2l4kERedIi+tNEaDxNOebs61qMS+m2/w3WpC2b5/Bg6UhWZ
         sNmELhkGrMycbbgum39Yn0Y+ZqM/DGVsiRnozQo6baSvhdxHpnCL8NbUK4wnZXge7n
         0a24iQwGZSacEdKm2lJrakfOGhOpVy6TikImI4dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/247] xsk: Fix handling of invalid descriptors in XSK TX batching API
Date:   Mon, 13 Jun 2022 12:10:51 +0200
Message-Id: <20220613094927.474546705@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit d678cbd2f867a564a3c5b276c454e873f43f02f8 ]

xdpxceiver run on a AF_XDP ZC enabled driver revealed a problem with XSK
Tx batching API. There is a test that checks how invalid Tx descriptors
are handled by AF_XDP. Each valid descriptor is followed by invalid one
on Tx side whereas the Rx side expects only to receive a set of valid
descriptors.

In current xsk_tx_peek_release_desc_batch() function, the amount of
available descriptors is hidden inside xskq_cons_peek_desc_batch(). This
can be problematic in cases where invalid descriptors are present due to
the fact that xskq_cons_peek_desc_batch() returns only a count of valid
descriptors. This means that it is impossible to properly update XSK
ring state when calling xskq_cons_release_n().

To address this issue, pull out the contents of
xskq_cons_peek_desc_batch() so that callers (currently only
xsk_tx_peek_release_desc_batch()) will always be able to update the
state of ring properly, as total count of entries is now available and
use this value as an argument in xskq_cons_release_n(). By
doing so, xskq_cons_peek_desc_batch() can be dropped altogether.

Fixes: 9349eb3a9d2a ("xsk: Introduce batched Tx descriptor interfaces")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220607142200.576735-1-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c       | 5 +++--
 net/xdp/xsk_queue.h | 8 --------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 404cbfde2f84..b9e70931c794 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -388,7 +388,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 		goto out;
 	}
 
-	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, pool, max_entries);
+	max_entries = xskq_cons_nb_entries(xs->tx, max_entries);
+	nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, max_entries);
 	if (!nb_pkts) {
 		xs->tx->queue_empty_descs++;
 		goto out;
@@ -404,7 +405,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 	if (!nb_pkts)
 		goto out;
 
-	xskq_cons_release_n(xs->tx, nb_pkts);
+	xskq_cons_release_n(xs->tx, max_entries);
 	__xskq_cons_release(xs->tx);
 	xs->sk.sk_write_space(&xs->sk);
 
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index b721795fe50c..491a18c1f786 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -278,14 +278,6 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 	return xskq_cons_read_desc(q, desc, pool);
 }
 
-static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
-					    u32 max)
-{
-	u32 entries = xskq_cons_nb_entries(q, max);
-
-	return xskq_cons_read_desc_batch(q, pool, entries);
-}
-
 /* To improve performance in the xskq_cons_release functions, only update local state here.
  * Reflect this to global state when we get new entries from the ring in
  * xskq_cons_get_entries() and whenever Rx or Tx processing are completed in the NAPI loop.
-- 
2.35.1



