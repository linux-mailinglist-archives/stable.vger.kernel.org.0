Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF04859DA0B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352173AbiHWKEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352728AbiHWKCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622677C527;
        Tue, 23 Aug 2022 01:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC92461377;
        Tue, 23 Aug 2022 08:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D50C433C1;
        Tue, 23 Aug 2022 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244635;
        bh=z1UAbFAEBCVO/+MvUTbYWvY6QVA8Oi88OBcKimNBt8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mAsYmkv3DokyukLm/jC84fXeTWh8We4mkk3W8IDQXojaWNzQVECfO4ucMuy2UDsJ
         4NdelBXU0wovNUbDEJGLP6hDJuOH7kRqD+jordOagHVKlOAFjhNmHajIaK+MgvgocT
         KA1cBaf/yFXy0JpRqHMZc18RBtHL5PvAihthMwyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 126/244] netfilter: nf_tables: possible module reference underflow in error path
Date:   Tue, 23 Aug 2022 10:24:45 +0200
Message-Id: <20220823080103.290641883@linuxfoundation.org>
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

commit c485c35ff6783ccd12c160fcac6a0e504e83e0bf upstream.

dst->ops is set on when nft_expr_clone() fails, but module refcount has
not been bumped yet, therefore nft_expr_destroy() leads to module
reference underflow.

Fixes: 8cfd9b0f8515 ("netfilter: nftables: generalize set expressions support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5479,7 +5479,7 @@ int nft_set_elem_expr_clone(const struct
 
 		err = nft_expr_clone(expr, set->exprs[i]);
 		if (err < 0) {
-			nft_expr_destroy(ctx, expr);
+			kfree(expr);
 			goto err_expr;
 		}
 		expr_array[i] = expr;


