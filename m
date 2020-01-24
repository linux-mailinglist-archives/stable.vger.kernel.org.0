Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628431481F3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389889AbgAXLYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388606AbgAXLYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:05 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE24B206D4;
        Fri, 24 Jan 2020 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865044;
        bh=Es0usgRGQeBd944Q1FKLgDJqnl08UMmid7IPySRschc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifo3gD+qdME5GIpq5bxwIaw64rMuIg0jMh9iGS+KZQOFGJu1W+cqxFwA/q6XfsA4R
         W3GMi7vg/zbhaX0dOt/tTD/SN7km+ERgLXah9I4Iu7+TR/djNFaE+PotiYAoKK8nYj
         3cDjPNPQJra1Y6aVl5lwr9IpeDHbWu0YnCXjxA0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 413/639] crypto: inside-secure - fix zeroing of the request in ahash_exit_inv
Date:   Fri, 24 Jan 2020 10:29:43 +0100
Message-Id: <20200124093138.765746594@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit b926213d6fede9c9427d7c12eaf7d9f0895deb4e ]

A request is zeroed in safexcel_ahash_exit_inv(). This request total
size is EIP197_AHASH_REQ_SIZE while the memset zeroing it uses
sizeof(struct ahash_request), which happens to be less than
EIP197_AHASH_REQ_SIZE. This patch fixes it.

Fixes: f6beaea30487 ("crypto: inside-secure - authenc(hmac(sha256), cbc(aes)) support")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ac9282c1a5ec1..9a02f64a45b96 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -486,7 +486,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
-	memset(req, 0, sizeof(struct ahash_request));
+	memset(req, 0, EIP197_AHASH_REQ_SIZE);
 
 	/* create invalidation request */
 	init_completion(&result.completion);
-- 
2.20.1



