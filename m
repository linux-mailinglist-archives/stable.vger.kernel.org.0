Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD0499FC5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842125AbiAXXA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836496AbiAXWjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C76C054875;
        Mon, 24 Jan 2022 13:01:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1327BB81057;
        Mon, 24 Jan 2022 21:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308A8C340E5;
        Mon, 24 Jan 2022 21:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058112;
        bh=3dX7I10Z+FMajBYHYlk7zmc2W2l3aPSNYjfvSrxzmw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlMHGj5LqkTOMZq+nuB4FeXq+0uzFGwQHgOll4B3XmBZin2jD0d2r7fuqcNHkdOhj
         DVVwZ1sSORhuEY0O4ZU+oFclgPTG/drzHkpEiuIQ1aV2yUGJfrBwqt/SUhHZJEsQC/
         iz4AnIKqoRLvyq+pzk+Tpa03StgrXoUWoRBK9fL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0158/1039] crypto: keembay-ocs-ecc - Fix error return code in kmb_ocs_ecc_probe()
Date:   Mon, 24 Jan 2022 19:32:27 +0100
Message-Id: <20220124184130.493179134@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 94ad2d19a97efdb603a21fcad0625f466f1cdd0f ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: c9f608c38009 ("crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC Driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/keembay/keembay-ocs-ecc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/keembay/keembay-ocs-ecc.c b/drivers/crypto/keembay/keembay-ocs-ecc.c
index 679e6ae295e0b..5d0785d3f1b55 100644
--- a/drivers/crypto/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/keembay/keembay-ocs-ecc.c
@@ -930,6 +930,7 @@ static int kmb_ocs_ecc_probe(struct platform_device *pdev)
 	ecc_dev->engine = crypto_engine_alloc_init(dev, 1);
 	if (!ecc_dev->engine) {
 		dev_err(dev, "Could not allocate crypto engine\n");
+		rc = -ENOMEM;
 		goto list_del;
 	}
 
-- 
2.34.1



