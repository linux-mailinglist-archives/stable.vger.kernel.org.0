Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3753785A6
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhEJLBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234494AbhEJK4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A709961878;
        Mon, 10 May 2021 10:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643583;
        bh=P+MciOeJe4AEg7XLz9vY9+C/A9tx5y4O7vzUZ5zAoKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOQlkeyOeaGNimxNCXHQfmBvswEM4S4JVIWQGFnztsvIZU+7y7xH8nIPpWJ9UFPbs
         PsM+zXBP3Lxs8ZSz8uJZKSIdy74rLaD1mTkXI/V71dKq85hMwFKI5Y5AvJXM/kpEDU
         2M537McHtdEcLM7g/m+IlaCZzZ62+kAGMKXqmRjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 074/342] crypto: hisilicon/sec - fixes a printing error
Date:   Mon, 10 May 2021 12:17:44 +0200
Message-Id: <20210510102012.560462762@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



