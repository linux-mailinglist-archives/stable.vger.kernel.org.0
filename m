Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B462349163D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244981AbiARCdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344674AbiARCai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE5BC06118A;
        Mon, 17 Jan 2022 18:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606B46114D;
        Tue, 18 Jan 2022 02:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E5C36AF2;
        Tue, 18 Jan 2022 02:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472830;
        bh=Dw55RYZD/DX3A6O8uk0ifo8PqWSjLQRn9YgpgdbiIv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j32ina20Od0Ei5V43mxeJ+xVf1EPcxhaSRAsUPW3PDFfMjzwcjKggIaTTjE8SnkiG
         gWhW54uvYbbE2BqdRtyt/Fc9jDinUOU6rOX7iFCllrD70O5nQBHp6rbMSIUalr7R9E
         VmyPNPF/GH5bpDPJV+R6RwCivwr99xYnRPeFwR/afyyEfIrd1+dkexcEKKuwgDUL5k
         rkrhBgwRpEMrZb5YXwkTrt/RWfmI66mf6P5hPyNCGrqYkqtbndJ53nS+3MP9hl34xo
         WVJYqTnz0HjAJRyKGiPUvJ9tYOg8b4jiYpmOxKnnrf3vM0JrEUj/VCyoWtABEJsZsV
         kUgsgZgP+ojFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, xuzaibo@huawei.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 147/217] crypto: hisilicon/hpre - fix memory leak in hpre_curve25519_src_init()
Date:   Mon, 17 Jan 2022 21:18:30 -0500
Message-Id: <20220118021940.1942199-147-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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

