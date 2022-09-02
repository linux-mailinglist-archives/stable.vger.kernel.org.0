Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4965AAE3F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbiIBMVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbiIBMVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:21:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A851E5F126;
        Fri,  2 Sep 2022 05:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4006E620E6;
        Fri,  2 Sep 2022 12:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF5EC433C1;
        Fri,  2 Sep 2022 12:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121242;
        bh=yjFbBlaMaiW1xyHU4qJxXDx2fbTonaU5u23wM7iThqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QO10Ysz98stHZCAWoFD9yL01dBiz8wHxBu/cdrCwpnJQRCAxR/NPzuXfqHjrAQuv
         +rfB/0F9bTaxzSeDN75VRIyRiO8b/5Uhz4+Zb/BdPW3ybE/lzJWys8mBIntjKdj0wu
         gqBi65WytJoDm1IPc6AfZi3Q4VRpP2nxyU10DnoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/31] af_key: Do not call xfrm_probe_algs in parallel
Date:   Fri,  2 Sep 2022 14:18:29 +0200
Message-Id: <20220902121356.874120507@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ba953a9d89a00c078b85f4b190bc1dde66fe16b5 ]

When namespace support was added to xfrm/afkey, it caused the
previously single-threaded call to xfrm_probe_algs to become
multi-threaded.  This is buggy and needs to be fixed with a mutex.

Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Fixes: 283bc9f35bbb ("xfrm: Namespacify xfrm state/policy locks")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 0737fc7b7ebdb..88d4a3a02ab72 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1724,9 +1724,12 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 		pfk->registered |= (1<<hdr->sadb_msg_satype);
 	}
 
+	mutex_lock(&pfkey_mutex);
 	xfrm_probe_algs();
 
 	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
+	mutex_unlock(&pfkey_mutex);
+
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
-- 
2.35.1



