Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A1859D614
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240031AbiHWJFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243417AbiHWJFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3554074B8F;
        Tue, 23 Aug 2022 01:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07BF8B81C48;
        Tue, 23 Aug 2022 08:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CDDC433D6;
        Tue, 23 Aug 2022 08:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243285;
        bh=0kRc/kQ7IVCbJ2ZgeyLpv5oI5kf4VZzx/zouu/0Opm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCj642yJQMEfTDgTiQ+I0WG8rZPEPs/K7Q+6TqGZr0ILYZscnzFbn/I9aY7Q7Nlef
         JGy92gTASqFk5E1d57VwEWL5qJHXoQlbAXtiH2gEGbULI2dxTWOLoWX3DLxP6dmHbo
         PeKE8EFphC3Ourzc4TW2CJx5hV5t20k+WHKRn4T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 201/365] netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END
Date:   Tue, 23 Aug 2022 10:01:42 +0200
Message-Id: <20220823080126.628524897@linuxfoundation.org>
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

commit fc0ae524b5fd2938c94d56da3f749f11eb3273d5 upstream.

These flags are mutually exclusive, report EINVAL in this case.

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5198,6 +5198,9 @@ static int nft_setelem_parse_flags(const
 	if (!(set->flags & NFT_SET_INTERVAL) &&
 	    *flags & NFT_SET_ELEM_INTERVAL_END)
 		return -EINVAL;
+	if ((*flags & (NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL)) ==
+	    (NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL))
+		return -EINVAL;
 
 	return 0;
 }


