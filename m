Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82104994EA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388918AbiAXUtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:49:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33246 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355652AbiAXUh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:37:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E9876152F;
        Mon, 24 Jan 2022 20:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6CDC340E8;
        Mon, 24 Jan 2022 20:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056675;
        bh=Dw55RYZD/DX3A6O8uk0ifo8PqWSjLQRn9YgpgdbiIv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfVCsIhFnxQzSfA8dcgeOtxyFoQsbpl+4b5vbkZAu8Ew9kXtTmj0A+5jjk0em2Tfg
         XbKFj01X1LZ6L7E9eZio3l8Lg7Y/2nG9CfiY6kOq6ZHLsToyaTCXmXQGz2z7bkbZD2
         luRVALvylEL9v1k6U+aiiZRXhREpbv8u0Qji6njw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/846] crypto: hisilicon/hpre - fix memory leak in hpre_curve25519_src_init()
Date:   Mon, 24 Jan 2022 19:41:20 +0100
Message-Id: <20220124184120.454213089@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



