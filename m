Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB849188D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345992AbiARCq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245488AbiARCoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:44:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF19C0612B2;
        Mon, 17 Jan 2022 18:37:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 143D3B811D6;
        Tue, 18 Jan 2022 02:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E637C36AF2;
        Tue, 18 Jan 2022 02:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473460;
        bh=Dw55RYZD/DX3A6O8uk0ifo8PqWSjLQRn9YgpgdbiIv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaGWrNo/8Isz7DuHLwcwBsdHidmOJDTVV96k14Vu6ZDS/BD3UhS9FFFQfehtcWlnZ
         8fDLvGPCu0O7cV+kubjLU9fXz3BafWBJCc5oFxDrZv+7trBIKnq9ZXTbYak6BuuyLc
         UCvZZK7OOEGZ6rJJOwH6nwPf6XNidgeYCggo3kOOD9MUZtJTS9mil5uTW1ci6su+8B
         mQHdP9mav1xhLqAu3Ed2F/xCIY85MGXo667VY+9MiUytnQltm4+9Mksq4Azu8THk8/
         jlzTeSFc4jfgvSwdDxiIk6H66zofu6v95knfb89cCJCVuNl9KmABVexhdv51aRZ0nP
         CsNKTn5wzCRFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, xuzaibo@huawei.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 126/188] crypto: hisilicon/hpre - fix memory leak in hpre_curve25519_src_init()
Date:   Mon, 17 Jan 2022 21:30:50 -0500
Message-Id: <20220118023152.1948105-126-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 51fa916b81e5f406a74f14a31a3a228c3cc060ad ]

hpre_curve25519_src_init() allocates memory for 'ptr' before calling
memcmp(). If memcmp() returns 0, the function will return '-EINVAL'
without freeing memory.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index a032c192ef1d6..7ba7641723a0b 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1865,7 +1865,7 @@ static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
 	 */
 	if (memcmp(ptr, p, ctx->key_sz) == 0) {
 		dev_err(dev, "gx is p!\n");
-		return -EINVAL;
+		goto err;
 	} else if (memcmp(ptr, p, ctx->key_sz) > 0) {
 		hpre_curve25519_src_modulo_p(ptr);
 	}
-- 
2.34.1

