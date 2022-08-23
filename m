Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87159DFEC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358625AbiHWLxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358642AbiHWLwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BAED5980;
        Tue, 23 Aug 2022 02:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92FC9B8105C;
        Tue, 23 Aug 2022 09:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC60DC433D6;
        Tue, 23 Aug 2022 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247158;
        bh=+dGsXXUzWfY49oCGU7uvrd9pRam1ngxeyH+kljj5MNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rIvDi114LHl+W9DriSHMHiZWB/1f/QalfsE4MDbUIz/qWIIxhbKG0PvboCutSE2v
         5+bzGqEIx/JOvHtvzFqmwuiJILGpo9HIPJ8D6Ibvb6VwzC6UFGtHhSWbmb08ke5n0r
         SB05+1/1pL9/Db/YtTn8qXOxkzu2jrFwWPgSjtuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 337/389] netfilter: nf_tables: really skip inactive sets when allocating name
Date:   Tue, 23 Aug 2022 10:26:55 +0200
Message-Id: <20220823080129.597683392@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -3253,7 +3253,7 @@ cont:
 		list_for_each_entry(i, &ctx->table->sets, list) {
 			int tmp;
 
-			if (!nft_is_active_next(ctx->net, set))
+			if (!nft_is_active_next(ctx->net, i))
 				continue;
 			if (!sscanf(i->name, name, &tmp))
 				continue;


