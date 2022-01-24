Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F264999B5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455340AbiAXVfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452725AbiAXV0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:26:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57BE60C44;
        Mon, 24 Jan 2022 21:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96497C340E4;
        Mon, 24 Jan 2022 21:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059581;
        bh=Dw55RYZD/DX3A6O8uk0ifo8PqWSjLQRn9YgpgdbiIv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDRj38sS7wJolM/k8uFq+jJ0K4CBIFQyiqV22TFQ1oPdzllA66Qiuy+1pSjakejCT
         NT4ppXrSraSO8lvbb22kP5n3jfjHoJV9KdexP9r1Ir+U5PCGbsOCclEeaiUDddw2pC
         xMIDHOa3rUFCCchmeoTRsm6Y9jryzNBVqgcHBZcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0664/1039] crypto: hisilicon/hpre - fix memory leak in hpre_curve25519_src_init()
Date:   Mon, 24 Jan 2022 19:40:53 +0100
Message-Id: <20220124184147.696415350@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



