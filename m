Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A36C5EA310
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiIZLTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiIZLSJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:18:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C766610D;
        Mon, 26 Sep 2022 03:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F325A60BB7;
        Mon, 26 Sep 2022 10:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B105C433C1;
        Mon, 26 Sep 2022 10:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188304;
        bh=gvkZWypXOh4rePqQv6nflT5PDiq3Lx826yWj1qul/5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnWgKIXD8NkX5xq6s4w4asWUT9JVDMC9zWUG08elYL/xKd5+U/T7ixAZh0kkA2LzK
         RJu6d/T5985tKarYTlRY+tl1UO+YdJnHPhf1VCxe7bhEUJXQ6ddzm4LxqPWNwHDN1K
         P46Bm7GDZMp+B4U1OCBR6Suzaw7841qK97kLd4OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/141] netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()
Date:   Mon, 26 Sep 2022 12:12:12 +0200
Message-Id: <20220926100758.282294291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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
index d65c47bcbfc9..810995d712ac 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2045,6 +2045,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (err < 0) {
 			nft_chain_release_hook(&hook);
 			kfree(basechain);
+			free_percpu(stats);
 			return err;
 		}
 		if (stats)
-- 
2.35.1



