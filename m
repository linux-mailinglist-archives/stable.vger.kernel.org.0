Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926FF658178
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiL1Q2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiL1Q20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E432511C1D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62325B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3D4C433D2;
        Wed, 28 Dec 2022 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244668;
        bh=aglx1usQfBM6l0KL+69bpy35bIYjRlMNolD+5Qwgf44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAwY4kCpVky9iHElWRAkyMyij1IFhxK9KSz0D6QLJNROC4YUDE7GjO4C07IZj5Bi6
         Fc8BdyXvDJ3sJeE1sLLywzK1mxoobysoDtqObDjV2qpi4dVRUVoFaOXIp4AK8CxOox
         RLq8JkPpqGYYAP6xiU28vdSYP5AI+N1AtJxje/n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0681/1146] hwrng: amd - Fix PCI device refcount leak
Date:   Wed, 28 Dec 2022 15:37:00 +0100
Message-Id: <20221228144348.641459237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit ecadb5b0111ea19fc7c240bb25d424a94471eb7d ]

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. Add the missing
pci_dev_put() for the normal and error path.

Fixes: 96d63c0297cc ("[PATCH] Add AMD HW RNG driver")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/amd-rng.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index c22d4184bb61..0555e3838bce 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -143,15 +143,19 @@ static int __init amd_rng_mod_init(void)
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
 	if (err)
-		return err;
+		goto put_dev;
 
 	pmbase &= 0x0000FF00;
-	if (pmbase == 0)
-		return -EIO;
+	if (pmbase == 0) {
+		err = -EIO;
+		goto put_dev;
+	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		err = -ENOMEM;
+		goto put_dev;
+	}
 
 	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
 		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
@@ -185,6 +189,8 @@ static int __init amd_rng_mod_init(void)
 	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 out:
 	kfree(priv);
+put_dev:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -200,6 +206,8 @@ static void __exit amd_rng_mod_exit(void)
 
 	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 
+	pci_dev_put(priv->pcidev);
+
 	kfree(priv);
 }
 
-- 
2.35.1



