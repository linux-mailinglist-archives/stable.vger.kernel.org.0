Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DF95EA35A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbiIZLYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiIZLXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:23:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB4CE0E5;
        Mon, 26 Sep 2022 03:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0895060C0B;
        Mon, 26 Sep 2022 10:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126E6C433D6;
        Mon, 26 Sep 2022 10:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188722;
        bh=T5PF9Z5HInciAt1NoxqJnOZA+Y+OU/V35RoIsjOjHXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVfaXDyX0pHXQc/XGj7UxCMPJcvQrjSeFyaBuxabc9GbbqIdRCynTJJHcb3uV/U+1
         R1clnbmd6QxSbrvI+TJwzuq9IxR4z1JSrM/9BBzp4BpoFkNUzRaoFuFfxF1h68hsFv
         7udYh8EeBbFqSbhdqj2ObxTaYzUOWZ9GTgeLXpBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/148] netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()
Date:   Mon, 26 Sep 2022 12:12:15 +0200
Message-Id: <20220926100759.874916140@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 9a4d6dd554b86e65581ef6b6638a39ae079b17ac ]

It seems to me that percpu memory for chain stats started leaking since
commit 3bc158f8d0330f0a ("netfilter: nf_tables: map basechain priority to
hardware priority") when nft_chain_offload_priority() returned an error.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 3bc158f8d0330f0a ("netfilter: nf_tables: map basechain priority to hardware priority")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d8e66467c06c..460ad341d160 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2148,6 +2148,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (err < 0) {
 			nft_chain_release_hook(&hook);
 			kfree(basechain);
+			free_percpu(stats);
 			return err;
 		}
 		if (stats)
-- 
2.35.1



