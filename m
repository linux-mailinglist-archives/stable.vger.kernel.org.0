Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E14F3C48B5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhGLGkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238137AbhGLGj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE0DD6121E;
        Mon, 12 Jul 2021 06:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071777;
        bh=obXfwdfgfnX/URfyq+fECvSq1NSWtujCIhTIwSwwAZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYJihDeX6GmKnXYQTJy7/FsAectgOJK4nX6YIxlX7ReVgZmj77jnkBjXVJItRsdoZ
         +DM+ZSfGqbza0EV6S0I6HuLp+8ZSIp3ZGdLJYPCI37z7q79CBttqd+QSyzQEymSmHX
         zEW2oMNzGFCjvS8oAYmpEB6KwTgkr27QWz5QQWe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/593] crypto: ux500 - Fix error return code in hash_hw_final()
Date:   Mon, 12 Jul 2021 08:06:16 +0200
Message-Id: <20210712060906.681873615@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 3d407eebb2ba..1e2daf403032 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1009,6 +1009,7 @@ static int hash_hw_final(struct ahash_request *req)
 			goto out;
 		}
 	} else if (req->nbytes == 0 && ctx->keylen > 0) {
+		ret = -EPERM;
 		dev_err(device_data->dev, "%s: Empty message with keylength > 0, NOT supported\n",
 			__func__);
 		goto out;
-- 
2.30.2



