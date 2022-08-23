Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64F59DF7F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352936AbiHWKJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352558AbiHWKIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:08:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1C45A2E8;
        Tue, 23 Aug 2022 01:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1A036150F;
        Tue, 23 Aug 2022 08:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3474C433D6;
        Tue, 23 Aug 2022 08:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244863;
        bh=GEkDlFdYejgeBRE8yTQaw/+MTKzDAMTi3p29YjlsrMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nh9XG+JhwsHb/LfruR06+fRs8aT7Bl7L79CyK4hTg/N/UUVsNo8qS0WgMXLljRNTF
         Glm+uDjU13XzMIICMfO7cczdnZ0GSexPTRZCl/e8NpzuhV/HL4nxJEMPruWwFc0bqx
         I1yApGaja+HfKjcKVAMmSGv66+L7EwDHl9qu5rvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 203/229] netfilter: nf_tables: really skip inactive sets when allocating name
Date:   Tue, 23 Aug 2022 10:26:04 +0200
Message-Id: <20220823080100.902840174@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

commit 271c5ca826e0c3c53e0eb4032f8eaedea1ee391c upstream.

While looping to build the bitmap of used anonymous set names, check the
current set in the iteration, instead of the one that is being created.

Fixes: 37a9cc525525 ("netfilter: nf_tables: add generation mask to sets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2797,7 +2797,7 @@ cont:
 		list_for_each_entry(i, &ctx->table->sets, list) {
 			int tmp;
 
-			if (!nft_is_active_next(ctx->net, set))
+			if (!nft_is_active_next(ctx->net, i))
 				continue;
 			if (!sscanf(i->name, name, &tmp))
 				continue;


