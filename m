Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E3A37C7AC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhELQBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238013AbhELP5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0DE61C23;
        Wed, 12 May 2021 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833379;
        bh=852qT1Vn/ixcMvbdXJNUUvHb/frKRi6V5zweyT7Ez5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNkfLjgiBTE/qq8oyAIsD9h1NR+moXxieZ5/9qJ+06mlr1gdYB04A9m+XxRdCRlBs
         UXWPqXs72YhNQmjj09xHXMNFnw9aKL3JwLGMhG0x8DpgNBQOhstSR6XXpvzQ7QY/wD
         4lMw7E7U/j6IWCywI6+znt3wbY/f+9UaEeY26m+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 126/601] crypto: keembay-ocs-aes - Fix error return code in kmb_ocs_aes_probe()
Date:   Wed, 12 May 2021 16:43:23 +0200
Message-Id: <20210512144831.979111411@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 2eee428d8212265af09d349b74746be03513382e ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-aes-core.c b/drivers/crypto/keembay/keembay-ocs-aes-core.c
index b6b25d994af3..2ef312866338 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1649,8 +1649,10 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 
 	/* Initialize crypto engine */
 	aes_dev->engine = crypto_engine_alloc_init(dev, true);
-	if (!aes_dev->engine)
+	if (!aes_dev->engine) {
+		rc = -ENOMEM;
 		goto list_del;
+	}
 
 	rc = crypto_engine_start(aes_dev->engine);
 	if (rc) {
-- 
2.30.2



