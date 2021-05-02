Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF56370C0E
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhEBOFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232260AbhEBOEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9478613C6;
        Sun,  2 May 2021 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964243;
        bh=P+MciOeJe4AEg7XLz9vY9+C/A9tx5y4O7vzUZ5zAoKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/j0zsblJFFNkhdxlxv9d58U8yvB1ZM+WYSFCOKiqskdgWZ08bOevNBPI2/oKt3lN
         h9FseTRa7IRtyY2+txt5BVJTuv94E79jjNRtHksGrejHb5/kE65po0KBixF9JnzQSB
         7niJcXsPYe1SPfOrTnVZXlsK6ykGTSzDrsv7Mm6TGF6q5jkfbxDxzsGK9+qhBwaDps
         MzeBFTMhTd7sVbiEfj6ggVNCFn49nVxNJYLOktS3BoyUA1GIL+/16P+HekpSUy7IPI
         TUEJ/ZeU9wRMbaQK71txNB7MLc6VzzwAbEqzwbCZSsNzl5K2iBAjhKnbvpaXKnTvEJ
         nHUxa9Yn++p7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Longfang Liu <liulongfang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 13/70] crypto: hisilicon/sec - fixes a printing error
Date:   Sun,  2 May 2021 10:02:47 -0400
Message-Id: <20210502140344.2719040-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140344.2719040-1-sashal@kernel.org>
References: <20210502140344.2719040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 4b7aef0230418345be1fb77abbb1592801869901 ]

When the log is output here, the device has not
been initialized yet.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 2eaa516b3231..8adcbb327126 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -546,7 +546,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_req));
 	ctx->c_ctx.ivsize = crypto_skcipher_ivsize(tfm);
 	if (ctx->c_ctx.ivsize > SEC_IV_SIZE) {
-		dev_err(SEC_CTX_DEV(ctx), "get error skcipher iv size!\n");
+		pr_err("get error skcipher iv size!\n");
 		return -EINVAL;
 	}
 
-- 
2.30.2

