Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1367694961
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjBMO6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjBMO62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006BD1CACE
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24786106F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8860C433EF;
        Mon, 13 Feb 2023 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300287;
        bh=fZcfUkkERprglAhrNHABuug0nOV5mncvohaavWBQdKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/IqFlv+sCUFuv/gM/nmaGtd9p+FQP2twXG4DT971xKXbfWT1Oc5IyRtsIKWurMX1
         lRJgSlhaA6Tn073v5q1cixBjG1dNcRYUKCIDa2TkOAgx8iRHwLOh0P0Rf3ZWPxUFWv
         64zQ3DIS6YDd4u99a5SQY0Io3AeVn+epqy+4h8BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Hopps <chopps@chopps.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/67] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
Date:   Mon, 13 Feb 2023 15:49:02 +0100
Message-Id: <20230213144733.370205097@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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
index 3d8668d62e639..7c5958a2eed46 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -278,8 +278,7 @@ static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
-			       ipipv6_hdr(skb));
+		ipv6_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipipv6_hdr(skb));
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip6_ecn_decapsulate(skb);
 
-- 
2.39.0



