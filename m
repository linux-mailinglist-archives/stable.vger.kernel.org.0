Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3B3CD925
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbhGSO1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243411AbhGSOZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05158611CE;
        Mon, 19 Jul 2021 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707182;
        bh=X2EDxjvK0rOqzWQFst1vMJ4Jfp9h5hDeMfQyj/fXr0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LML9kxOoOW+U2wKree8wJ20v8RhMK84/cGNjklzOFVz6v7cxv6ePfw4byMe9yJWGO
         EzpdzTYBjfMUeQUQZwjc0xy7rjYGXl+Lym0Nw7dNk8EZWH5PiF8bfER8QzxotXkqu0
         HhR5wXgpepBHVZoefN0ToZAxaFE8dWdOPzlCe/j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 059/245] crypto: ux500 - Fix error return code in hash_hw_final()
Date:   Mon, 19 Jul 2021 16:50:01 +0200
Message-Id: <20210719144942.309463689@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index 17c8e2b28c42..7500ec9efa6a 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1006,6 +1006,7 @@ static int hash_hw_final(struct ahash_request *req)
 			goto out;
 		}
 	} else if (req->nbytes == 0 && ctx->keylen > 0) {
+		ret = -EPERM;
 		dev_err(device_data->dev, "%s: Empty message with keylength > 0, NOT supported\n",
 			__func__);
 		goto out;
-- 
2.30.2



