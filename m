Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758FF69CD25
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjBTNq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjBTNq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A292E1DBBD
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:46:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41407B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BAFC433EF;
        Mon, 20 Feb 2023 13:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900794;
        bh=sjjvzl52zYqSDB625U4onxPmGf5PMlSIDqywr2iwUuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFsrIhu3IHea0h77zoEXDcSZyPXSHaPlgrnEUKu6DxQpT7WqU7tUpXWb4g/qiT7Ma
         /u4Z8V9P15oolLh4SB68F3kXL3dY+qmSi1qxE7uuBK7FQN9e+qN8wm4akw1GdQED+c
         ItnsVUwkGUr0DHeQws/WxK7/NIMGuF6e3wRupvSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Hopps <chopps@chopps.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/156] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
Date:   Mon, 20 Feb 2023 14:35:13 +0100
Message-Id: <20230220133605.250817223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hopps <chopps@chopps.org>

[ Upstream commit 6028da3f125fec34425dbd5fec18e85d372b2af6 ]

When copying the DSCP bits for decap-dscp into IPv6 don't assume the
outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
the DSCP bits from the correctly saved "tos" value in the control block.

Fixes: 227620e29509 ("[IPSEC]: Separate inner/outer mode processing on input")
Signed-off-by: Christian Hopps <chopps@chopps.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index e120df0a6da13..4d8d7cf3d1994 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -274,8 +274,7 @@ static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
-			       ipipv6_hdr(skb));
+		ipv6_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipipv6_hdr(skb));
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip6_ecn_decapsulate(skb);
 
-- 
2.39.0



