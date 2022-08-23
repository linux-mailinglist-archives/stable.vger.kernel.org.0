Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973F759DA08
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352139AbiHWKEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352696AbiHWKCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770417C741;
        Tue, 23 Aug 2022 01:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0635F6122F;
        Tue, 23 Aug 2022 08:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D687C433D6;
        Tue, 23 Aug 2022 08:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244629;
        bh=7XvzYG1/pjFVKJRC1vdT57a3gpQ/VTg3095N79BMJe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wqm2P+kjjpAQ0i09Ovk+mC2xEgzXV/213ZKlnaQ6rfIEpimk6WuLxI2aa3WRTqHZA
         5CERb7Jix20PbRvsY7IuQf0WgcOEmGFae3E6UYOa6CizFz/GBm8p5M6FzPwu/up4Da
         XPV5PqCCiBa0kbCQaJWyOlk43IUeZSIfjkzZC0oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 125/244] netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag
Date:   Tue, 23 Aug 2022 10:24:44 +0200
Message-Id: <20220823080103.250852622@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4963674c2e71fc062f8f089f0f58ffbb5533060b upstream.

These are mutually exclusive, actually NFTA_SET_ELEM_KEY_END replaces
the flag notation.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5768,6 +5768,7 @@ static int nft_add_set_elem(struct nft_c
 	      nla[NFTA_SET_ELEM_EXPIRATION] ||
 	      nla[NFTA_SET_ELEM_USERDATA] ||
 	      nla[NFTA_SET_ELEM_EXPR] ||
+	      nla[NFTA_SET_ELEM_KEY_END] ||
 	      nla[NFTA_SET_ELEM_EXPRESSIONS]))
 		return -EINVAL;
 


