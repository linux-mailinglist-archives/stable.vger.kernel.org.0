Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846D95A4871
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiH2LK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiH2LJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:09:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350F2647CB;
        Mon, 29 Aug 2022 04:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F273B80F10;
        Mon, 29 Aug 2022 11:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EECC433C1;
        Mon, 29 Aug 2022 11:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771217;
        bh=CUlCn9VQFgTQ/9wOrPWdNUeDKrblzrGrdFxsFdpSrlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfY8xkbQDqiqwwgSlSLJruL12ke9RRJrKxem8dcqhTXGWdCD+2XH0Je3WVcoD+qUS
         Mr77rQmWwFQ7JSpyZoGzIoA/qZZwNPu3iDT/Z1OCtf1nXXDTs04t2iTNvwdx0CuliA
         bQbYKKbIaBnsxPl97n8Flbhgtd3l9HtpXP1BdZLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/86] netfilter: bitwise: improve error goto labels
Date:   Mon, 29 Aug 2022 12:59:06 +0200
Message-Id: <20220829105758.194750451@linuxfoundation.org>
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

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 00bd435208e5201eb935d273052930bd3b272b6f ]

Replace two labels (`err1` and `err2`) with more informative ones.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_bitwise.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 47b0dba95054f..d0c648b64cd40 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -109,22 +109,23 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 		return err;
 	if (mask.type != NFT_DATA_VALUE || mask.len != priv->len) {
 		err = -EINVAL;
-		goto err1;
+		goto err_mask_release;
 	}
 
 	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &xor,
 			    tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
-		goto err1;
+		goto err_mask_release;
 	if (xor.type != NFT_DATA_VALUE || xor.len != priv->len) {
 		err = -EINVAL;
-		goto err2;
+		goto err_xor_release;
 	}
 
 	return 0;
-err2:
+
+err_xor_release:
 	nft_data_release(&priv->xor, xor.type);
-err1:
+err_mask_release:
 	nft_data_release(&priv->mask, mask.type);
 	return err;
 }
-- 
2.35.1



