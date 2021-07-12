Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425073C4D5F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbhGLHM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244235AbhGLHKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961C260FE7;
        Mon, 12 Jul 2021 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073639;
        bh=3KBamJziqWM1gjAHRVWgeK8tl5GhP7KQcl75Bslf1q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqxDV3Z/fQfUza1da4RlzNRtrpgcwFAc+Ac1EZV+KQMPjGYcIMf3UygYMGmnwK9Hv
         XYl/+VbfDc6rpOzTNX/q+zmBpbpmt53P/gXLj2NWXTq6WI+Xpvp1GFKymMNxOx/Y+h
         6GrEkg2Pb7nFWaIJmrDNbtMx48dNLxLWG2VMIB9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 256/700] crypto: ux500 - Fix error return code in hash_hw_final()
Date:   Mon, 12 Jul 2021 08:05:39 +0200
Message-Id: <20210712061003.245068477@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index da284b0ea1b2..243515df609b 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1010,6 +1010,7 @@ static int hash_hw_final(struct ahash_request *req)
 			goto out;
 		}
 	} else if (req->nbytes == 0 && ctx->keylen > 0) {
+		ret = -EPERM;
 		dev_err(device_data->dev, "%s: Empty message with keylength > 0, NOT supported\n",
 			__func__);
 		goto out;
-- 
2.30.2



