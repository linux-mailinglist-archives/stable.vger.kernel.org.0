Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44C95F9984
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiJJHNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbiJJHMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:12:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D843D581;
        Mon, 10 Oct 2022 00:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9F1BB80E5A;
        Mon, 10 Oct 2022 07:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150D6C43142;
        Mon, 10 Oct 2022 07:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385678;
        bh=nXpnHUemPMZd/uSdarw/+5i9ZWbahJz7ynIzHMImX1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkJSnonjxkqUQRUAw+7YUz/d9iSTBpiZIxi4eUbKE0Xl9K7wkcBF2z+2M+QUxdJxR
         PzUpIjN/ZvwkRmlt8CPYExdT1abCy4zzozh9RG+wQvddBv7ZlkL0A8YVmDDi0S6zr3
         o4CCi5Udeii3y5eq+HVZ0f0nBoYqfz13LWiIjH5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jalal Mostafa <jalal.a.mostapha@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: [PATCH 5.15 03/37] xsk: Inherit need_wakeup flag for shared sockets
Date:   Mon, 10 Oct 2022 09:05:22 +0200
Message-Id: <20221010070331.340024906@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
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

From: Jalal Mostafa <jalal.a.mostapha@gmail.com>

commit 60240bc26114543fcbfcd8a28466e67e77b20388 upstream.

The flag for need_wakeup is not set for xsks with `XDP_SHARED_UMEM`
flag and of different queue ids and/or devices. They should inherit
the flag from the first socket buffer pool since no flags can be
specified once `XDP_SHARED_UMEM` is specified.

Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")
Signed-off-by: Jalal Mostafa <jalal.a.mostapha@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220921135701.10199-1-jalal.a.mostapha@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xsk_buff_pool.h |    2 +-
 net/xdp/xsk.c               |    4 ++--
 net/xdp/xsk_buff_pool.c     |    5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -87,7 +87,7 @@ struct xsk_buff_pool *xp_create_and_assi
 						struct xdp_umem *umem);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
-int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 			 struct net_device *dev, u16 queue_id);
 int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 void xp_destroy(struct xsk_buff_pool *pool);
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -968,8 +968,8 @@ static int xsk_bind(struct socket *sock,
 				goto out_unlock;
 			}
 
-			err = xp_assign_dev_shared(xs->pool, umem_xs->umem,
-						   dev, qid);
+			err = xp_assign_dev_shared(xs->pool, umem_xs, dev,
+						   qid);
 			if (err) {
 				xp_destroy(xs->pool);
 				xs->pool = NULL;
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -206,17 +206,18 @@ err_unreg_pool:
 	return err;
 }
 
-int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 			 struct net_device *dev, u16 queue_id)
 {
 	u16 flags;
+	struct xdp_umem *umem = umem_xs->umem;
 
 	/* One fill and completion ring required for each queue id. */
 	if (!pool->fq || !pool->cq)
 		return -EINVAL;
 
 	flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
-	if (pool->uses_need_wakeup)
+	if (umem_xs->pool->uses_need_wakeup)
 		flags |= XDP_USE_NEED_WAKEUP;
 
 	return xp_assign_dev(pool, dev, queue_id, flags);


