Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BDB59D5F7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbiHWIrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347241AbiHWIpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FACB6AA0C;
        Tue, 23 Aug 2022 01:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AB7361344;
        Tue, 23 Aug 2022 08:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A74C433B5;
        Tue, 23 Aug 2022 08:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242782;
        bh=E0HKijj/aYKxcTXDI4Rk1LFkMA9lUuelgim1kwX1ZEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hvnzZursvPNkPuFgte1iMJPLmOBW4Rtvb0TEmYeejdJ4OORqTXgTDEmIrvbUjWj5
         d94qk4nGNiYVaegtNAQocY5V9z6HxZCjqUBWIzvA113+rb0VltBGFBP5QBJpxKM3KN
         Oqku4reJcFpZutS6TJgI5COtpzhItl5w3SorW9E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 197/365] netfilter: nf_tables: really skip inactive sets when allocating name
Date:   Tue, 23 Aug 2022 10:01:38 +0200
Message-Id: <20220823080126.472216495@linuxfoundation.org>
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
@@ -3907,7 +3907,7 @@ cont:
 		list_for_each_entry(i, &ctx->table->sets, list) {
 			int tmp;
 
-			if (!nft_is_active_next(ctx->net, set))
+			if (!nft_is_active_next(ctx->net, i))
 				continue;
 			if (!sscanf(i->name, name, &tmp))
 				continue;


