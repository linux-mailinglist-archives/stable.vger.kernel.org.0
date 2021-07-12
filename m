Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691CB3C5246
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343802AbhGLHpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245121AbhGLHmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFE1761153;
        Mon, 12 Jul 2021 07:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075583;
        bh=xqLbUWE0Glgdkr+prAfvahE76PW29P/frvM5EFO9vLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2XJLNijcjPwUxMFZggx7bBUo0+yfJF2A/SUGGt6sj/BolJspVfsu8R28VC/ODEL2
         L8hfTqXCgCmQfNIfc1bYVvNSw/Wz2FRVq9Lz7M0dZzSbDiEDmqI/d3/IGeDHN6XBBj
         bgiTrP+r6hQUQuiYVw2qjBFF+G4TdjxtpihNx1ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 275/800] crypto: ux500 - Fix error return code in hash_hw_final()
Date:   Mon, 12 Jul 2021 08:04:58 +0200
Message-Id: <20210712060953.587176499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit b01360384009ab066940b45f34880991ea7ccbfb ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 8a63b1994c50 ("crypto: ux500 - Add driver for HASH hardware")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index ecb7412e84e3..51a6e1a42434 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1011,6 +1011,7 @@ static int hash_hw_final(struct ahash_request *req)
 			goto out;
 		}
 	} else if (req->nbytes == 0 && ctx->keylen > 0) {
+		ret = -EPERM;
 		dev_err(device_data->dev, "%s: Empty message with keylength > 0, NOT supported\n",
 			__func__);
 		goto out;
-- 
2.30.2



