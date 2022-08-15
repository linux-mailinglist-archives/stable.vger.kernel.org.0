Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E3859472C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245295AbiHOX3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245313AbiHOXZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:25:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C592BA158;
        Mon, 15 Aug 2022 13:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B26E4B80EA8;
        Mon, 15 Aug 2022 20:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AEDC433D6;
        Mon, 15 Aug 2022 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593959;
        bh=+83nn2Vmra04i9vGT7jKTSovy3N5iVDyO+3QwXpaetQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j22rfsS4EHktNElLY1/DHBQFpMAcoDvK5CwF/ysnPRMLDdQKXZeAszgOfIHlyR0sA
         fPcc2naNqnUNTDk8c9f8BPD2E24a/GHfL5ZsmXBznfhnhRDy9cFswya0uhBhjWwayN
         yjMGU5TLRBB0ku6CQ34MhXiJIalQo6QX2OR/mxS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Wu <wupeng58@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0354/1157] crypto: sun8i-ss - fix a NULL vs IS_ERR() check in sun8i_ss_hashkey
Date:   Mon, 15 Aug 2022 19:55:10 +0200
Message-Id: <20220815180453.869574638@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Peng Wu <wupeng58@huawei.com>

[ Upstream commit 7e8df1fc2d669d04c1f8a9e2d61d7afba1b43df4 ]

The crypto_alloc_shash() function never returns NULL. It returns error
pointers.

Fixes: 801b7d572c0a ("crypto: sun8i-ss - add hmac(sha1)")
Signed-off-by: Peng Wu <wupeng58@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 845019bd9591..36a82b22953c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -30,8 +30,8 @@ static int sun8i_ss_hashkey(struct sun8i_ss_hash_tfm_ctx *tfmctx, const u8 *key,
 	int ret = 0;
 
 	xtfm = crypto_alloc_shash("sha1", 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (!xtfm)
-		return -ENOMEM;
+	if (IS_ERR(xtfm))
+		return PTR_ERR(xtfm);
 
 	len = sizeof(*sdesc) + crypto_shash_descsize(xtfm);
 	sdesc = kmalloc(len, GFP_KERNEL);
-- 
2.35.1



