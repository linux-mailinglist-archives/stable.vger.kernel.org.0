Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1410659D8B5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbiHWJMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348571AbiHWJKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9C86D558;
        Tue, 23 Aug 2022 01:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 615B6B81C3B;
        Tue, 23 Aug 2022 08:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F55C433D6;
        Tue, 23 Aug 2022 08:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242759;
        bh=vHPGp8AEhZpZ/FwWx4QLugFFEi7ycBigP5bAFx4OfiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQuo9d7xnRiIb5Ewwsd4H7m5CQid4fGBpyU9a+53okIAOxjMwVfXG1lhforGrbzp3
         iFjRl5NQsLpVwczifhymKGus4WrTikDgJsM0T0ZheYI/Fmrnd5NyjVp1ib1iv8P5HP
         tKk/ZMz1l79WPbFgEOBqgQP/tZiNz/ssCs+d3ldg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 191/365] netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag
Date:   Tue, 23 Aug 2022 10:01:32 +0200
Message-Id: <20220823080126.208106436@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -5855,6 +5855,7 @@ static int nft_add_set_elem(struct nft_c
 	      nla[NFTA_SET_ELEM_EXPIRATION] ||
 	      nla[NFTA_SET_ELEM_USERDATA] ||
 	      nla[NFTA_SET_ELEM_EXPR] ||
+	      nla[NFTA_SET_ELEM_KEY_END] ||
 	      nla[NFTA_SET_ELEM_EXPRESSIONS]))
 		return -EINVAL;
 


