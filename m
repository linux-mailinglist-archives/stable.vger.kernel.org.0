Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D4B5A4AB3
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiH2LtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiH2Lsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:48:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF96E7A76A;
        Mon, 29 Aug 2022 04:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA7A2B80EFF;
        Mon, 29 Aug 2022 11:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CD4C433C1;
        Mon, 29 Aug 2022 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771187;
        bh=a34mquwvDNCmths7L3NcKqLffOA6hamfkB0VPZqZCPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQJ94GVu6uhkSKYe5okZdqHNn/325Gs0DGQWwQAEcZn7I2IQF4jJeAxXUuxBb0clT
         84ZpVNfw/jPQUFsnz6v51PlyOfswnqAnFHFwZLqlKJM7FotkZ6+HBfqTwwMN8qhl6y
         E581YI78D1gxHaIQyNOK+35weCYiE1Gg+BLQ09LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/86] netfilter: nftables: remove redundant assignment of variable err
Date:   Mon, 29 Aug 2022 12:59:03 +0200
Message-Id: <20220829105758.084347625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 626899a02e6afcd4b2ce5c0551092e3554cec4aa ]

The variable err is being assigned a value that is never read,
the same error number is being returned at the error return
path via label err1.  Clean up the code by removing the assignment.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_cmp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index b529c0e865466..47b6d05f1ae69 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -303,10 +303,8 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (desc.type != NFT_DATA_VALUE) {
-		err = -EINVAL;
+	if (desc.type != NFT_DATA_VALUE)
 		goto err1;
-	}
 
 	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
 		return &nft_cmp_fast_ops;
-- 
2.35.1



