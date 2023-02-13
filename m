Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B369694A29
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjBMPFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjBMPE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:04:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FA21E1D3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D447FCE0E93
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E525EC433D2;
        Mon, 13 Feb 2023 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300689;
        bh=zFDQpLbUokv2XeU5/69iNvCGBhCpJK09HRGt/XPvFiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yY5o3CMtUnsVQtTJhqJxDCOJudwwUn1P+WDXLQV+hWYrZA2fAqtqwdnzOdd6M6fgU
         Y711kQl6mKULYRrvI1aThhut3hiVoROa2xwK/a4AONi5RppFCJFbzEF6ow5ej03tPm
         omI3mvT/bMw8WvgV8fVQKKT0+S7wvYV5Oe0JtKWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Hopps <chopps@chopps.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/139] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
Date:   Mon, 13 Feb 2023 15:50:56 +0100
Message-Id: <20230213144751.744562816@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
index 77e82033ad700..fef99a1c5df10 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -277,8 +277,7 @@ static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
-			       ipipv6_hdr(skb));
+		ipv6_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipipv6_hdr(skb));
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip6_ecn_decapsulate(skb);
 
-- 
2.39.0



