Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC9E4F345F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiDEJKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244378AbiDEIwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03567D5566;
        Tue,  5 Apr 2022 01:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D25360FFB;
        Tue,  5 Apr 2022 08:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85956C385A0;
        Tue,  5 Apr 2022 08:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148027;
        bh=o2hdrjC/PgYjbZe3JzicMJHQaxwlPlqG/ztutGUT8Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caR0yiW2tAkJ2gxiBcA8lmYyZ2Auh8/Quu0V+8qSjWmISCaXNt49g5SHtBnX57whm
         hSVRE9VVASOtXPcoBdgEugyZ5/romho5LCC4qghp47yERZuhmkm4GDUTelIjjynOV+
         ixY6Z/syiB9Wk56ORk6sRT9tWAEyGG3ozp0DZrlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Paukrt <tomaspaukrt@email.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0208/1017] crypto: mxs-dcp - Fix scatterlist processing
Date:   Tue,  5 Apr 2022 09:18:41 +0200
Message-Id: <20220405070400.425105561@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tomas Paukrt <tomaspaukrt@email.cz>

[ Upstream commit 28e9b6d8199a3f124682b143800c2dacdc3d70dd ]

This patch fixes a bug in scatterlist processing that may cause incorrect AES block encryption/decryption.

Fixes: 2e6d793e1bf0 ("crypto: mxs-dcp - Use sg_mapping_iter to copy data")
Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d19e5ffb5104..d6f9e2fe863d 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -331,7 +331,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
 	}
 
-	for_each_sg(req->src, src, sg_nents(src), i) {
+	for_each_sg(req->src, src, sg_nents(req->src), i) {
 		src_buf = sg_virt(src);
 		len = sg_dma_len(src);
 		tlen += len;
-- 
2.34.1



