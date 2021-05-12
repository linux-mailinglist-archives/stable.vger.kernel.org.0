Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8CE37CB62
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242652AbhELQfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241719AbhELQ14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7966F6143B;
        Wed, 12 May 2021 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834934;
        bh=jO1hsfP2Sy98SeNwNUkra2UWWkxqTKY1vaOAmONs2PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucp3SfzSpOYzUipnEsvwAAHgEwMoWWB4s8PDfLVU21AGqueqz7CnMcABOnhYNpCAT
         Z+oIOlaXre+vMpNdU8GKejmlcvJcVWPTJFGtEGqwLWM6POjF7QSf8t1bnJmpugTdC9
         KWKExGhgrFX11i/Tzz/J8RwaE0D44/PTkvE1zsvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 141/677] crypto: keembay-ocs-hcu - Fix error return code in kmb_ocs_hcu_probe()
Date:   Wed, 12 May 2021 16:43:07 +0200
Message-Id: <20210512144841.933727612@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 662c1c5618aaf71f99ada3105b99668a503605ae ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
index c4b97b4160e9..322c51a6936f 100644
--- a/drivers/crypto/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
@@ -1220,8 +1220,10 @@ static int kmb_ocs_hcu_probe(struct platform_device *pdev)
 
 	/* Initialize crypto engine */
 	hcu_dev->engine = crypto_engine_alloc_init(dev, 1);
-	if (!hcu_dev->engine)
+	if (!hcu_dev->engine) {
+		rc = -ENOMEM;
 		goto list_del;
+	}
 
 	rc = crypto_engine_start(hcu_dev->engine);
 	if (rc) {
-- 
2.30.2



