Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111CC5A496D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiH2LYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiH2LXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42021208E;
        Mon, 29 Aug 2022 04:15:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 595AAB80F00;
        Mon, 29 Aug 2022 11:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B598C433D6;
        Mon, 29 Aug 2022 11:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771055;
        bh=IOjqcHeflpnbKlkEEE7LINxAisCrYJnMtE2cW17fZvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGarHegpd+CVjLpeR4ZzAqksgXXMWXwTqlNbdPiFXNoSADxy7tv37WuHUcGCLB6zi
         ZiWgk1UB0VTcEPByKeXd9tVjN3p8mR6J3jelgFbc+ZjQzJ0OwNnsWH4tHqZaz8Kf7h
         C1n+IwTh6fq/3EVc3hllOv8cVkV72edBnf+PcmIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/86] af_key: Do not call xfrm_probe_algs in parallel
Date:   Mon, 29 Aug 2022 12:58:40 +0200
Message-Id: <20220829105757.105259253@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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
index 2aa16a171285b..05e2710988883 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1701,9 +1701,12 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
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



