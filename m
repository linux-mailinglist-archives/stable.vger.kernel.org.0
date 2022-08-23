Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2766459D615
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbiHWI7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242382AbiHWI7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:59:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091D47390D;
        Tue, 23 Aug 2022 01:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F9FE6132D;
        Tue, 23 Aug 2022 08:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9620EC433C1;
        Tue, 23 Aug 2022 08:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242780;
        bh=XlMZgAVmfzFK13clljcDaBlkofv50XjrF8t/pOrnWB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02JmD+6zlWbV8ucyrKGnxopIWxMIOa3Eu92BjLeo8jDw/l5+kBtSRbnpMCv4ap8BG
         YKEaswPB+NkA8eS6dcPBgOIdY9VmMDzkSuMr5ml8ojl/Idfk/ekgGFKe8m6ofv17GQ
         Re84frg140FpQNhXjRlhbyDzH40m6TOwLIz1isg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 196/365] netfilter: nf_tables: possible module reference underflow in error path
Date:   Tue, 23 Aug 2022 10:01:37 +0200
Message-Id: <20220823080126.432710514@linuxfoundation.org>
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
@@ -5566,7 +5566,7 @@ int nft_set_elem_expr_clone(const struct
 
 		err = nft_expr_clone(expr, set->exprs[i]);
 		if (err < 0) {
-			nft_expr_destroy(ctx, expr);
+			kfree(expr);
 			goto err_expr;
 		}
 		expr_array[i] = expr;


