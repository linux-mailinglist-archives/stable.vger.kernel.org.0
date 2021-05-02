Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F70E370C30
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhEBOFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhEBOFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A20FB613D7;
        Sun,  2 May 2021 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964267;
        bh=qvepuzUd2M5/wOW1s57kH7TsdtEDE4yT+qZGWuCSelg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0EJTuDNcF183wyyhk1hRwa87Abc3tqN841uuqiV3sXgxvK1+TVfw/rUCRZavbRA/
         KeoeNXzq9LcTQIggxTPqK2qvgPmudhXUZTN8ITmsoPZN6pmKmsFrgL37Iu+WkOpGPa
         YG8+Ig1v9S/MO3MTpdms90kPfUBGI39QHODxxro5SxupvC+4XwFkBbchNOp0UZm3DK
         nbbuYCzlGhSfsmAAgJKUEdQEGqB+nauNNm6eMq/OZmeucZnoPaWUyjyBZnmtQ1hymT
         UiuYH9wgEC86+6XjeHsM7huV6tX84eCQEr07FIUFaChdYPkP7/zBTIQhNRh6zTdzF0
         M5oEvh4OpPUtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Longfang Liu <liulongfang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/66] crypto: hisilicon/sec - fixes a printing error
Date:   Sun,  2 May 2021 10:03:17 -0400
Message-Id: <20210502140411.2719301-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140411.2719301-1-sashal@kernel.org>
References: <20210502140411.2719301-1-sashal@kernel.org>
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
index bb493423668c..41f1fcacb280 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -544,7 +544,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_req));
 	ctx->c_ctx.ivsize = crypto_skcipher_ivsize(tfm);
 	if (ctx->c_ctx.ivsize > SEC_IV_SIZE) {
-		dev_err(SEC_CTX_DEV(ctx), "get error skcipher iv size!\n");
+		pr_err("get error skcipher iv size!\n");
 		return -EINVAL;
 	}
 
-- 
2.30.2

