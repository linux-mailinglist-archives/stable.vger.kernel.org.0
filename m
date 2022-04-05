Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF54F2A0B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347625AbiDEJ1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244662AbiDEIwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B41D76CC;
        Tue,  5 Apr 2022 01:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A8461003;
        Tue,  5 Apr 2022 08:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1581AC385A0;
        Tue,  5 Apr 2022 08:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148102;
        bh=RAUViBvGmuS5RTbopXWh3hkvE9oXTfd0Ghbb8YE3plM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7fc5JXA5EqjYTWLw8E8svBtbLuxF+roA7fClz5AWc4UoRYTUmkhhBo9CuhF6jquG
         LrLpyBVFw7cVOzjyjMJA0TRsT2tBBa0+I0Usb+K+9QNqLIrPKeoDdX5NpbI1+vRtPD
         bvI2dOwLhxSYGCR3WNENhnviJdAuTMnPXLtTm3GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0236/1017] crypto: sun8i-ss - call finalize with bh disabled
Date:   Tue,  5 Apr 2022 09:19:09 +0200
Message-Id: <20220405070401.262566067@linuxfoundation.org>
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

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit b169b3766242b6f3336e24a6c8ee1522978b57a7 ]

Doing ipsec produces a spinlock recursion warning.
This is due to not disabling BH during crypto completion function.

Fixes: f08fcced6d00 ("crypto: allwinner - Add sun8i-ss cryptographic offloader")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 3 +++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 9ef1c85c4aaa..554e400d41ca 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -11,6 +11,7 @@
  * You could find a link for the datasheet in Documentation/arm/sunxi.rst
  */
 
+#include <linux/bottom_half.h>
 #include <linux/crypto.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
@@ -274,7 +275,9 @@ static int sun8i_ss_handle_cipher_request(struct crypto_engine *engine, void *ar
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
 
 	err = sun8i_ss_cipher(breq);
+	local_bh_disable();
 	crypto_finalize_skcipher_request(engine, breq, err);
+	local_bh_enable();
 
 	return 0;
 }
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 3c073eb3db03..1a71ed49d233 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -9,6 +9,7 @@
  *
  * You could find the datasheet in Documentation/arm/sunxi.rst
  */
+#include <linux/bottom_half.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
@@ -442,6 +443,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 theend:
 	kfree(pad);
 	kfree(result);
+	local_bh_disable();
 	crypto_finalize_hash_request(engine, breq, err);
+	local_bh_enable();
 	return 0;
 }
-- 
2.34.1



