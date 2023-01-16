Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788DD66C7AF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbjAPQdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbjAPQdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:33:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56481F76B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8CD16104E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE76BC433EF;
        Mon, 16 Jan 2023 16:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886059;
        bh=qAED3E+ETI0Gk4E1R5vEDZalUETGgXiNJd6eun3DykM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHGhdBbR9aNgVXgI8PSQbLqrcV79o2tVLszbg8Rprnd4jp4fTDBKEKX40LaWOgPKc
         V37SvElcsgJHt5EWufEKKz5N3X367vz+2kHFmZU7HgPUhA5VJnt6fpkKaxwVARQAtW
         T6SKJ0iQzOjud12UwD+PJ0AKGHj4caP9XqTrZDlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Yiqun <zhangyiqun@phytium.com.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 257/658] crypto: tcrypt - Fix multibuffer skcipher speed test mem leak
Date:   Mon, 16 Jan 2023 16:45:45 +0100
Message-Id: <20230116154921.334097275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yiqun <zhangyiqun@phytium.com.cn>

[ Upstream commit 1aa33fc8d4032227253ceb736f47c52b859d9683 ]

In the past, the data for mb-skcipher test has been allocated
twice, that means the first allcated memory area is without
free, which may cause a potential memory leakage. So this
patch is to remove one allocation to fix this error.

Fixes: e161c5930c15 ("crypto: tcrypt - add multibuf skcipher...")
Signed-off-by: Zhang Yiqun <zhangyiqun@phytium.com.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0cece1f883eb..12dab10d36b2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1281,15 +1281,6 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 			goto out_free_tfm;
 		}
 
-
-	for (i = 0; i < num_mb; ++i)
-		if (testmgr_alloc_buf(data[i].xbuf)) {
-			while (i--)
-				testmgr_free_buf(data[i].xbuf);
-			goto out_free_tfm;
-		}
-
-
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = skcipher_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-- 
2.35.1



