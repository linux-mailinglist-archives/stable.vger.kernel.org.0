Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEBD657BBA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiL1PYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbiL1PYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:24:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B31314038
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 180EA6155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAFBC433D2;
        Wed, 28 Dec 2022 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241082;
        bh=TXJz3PRK6h7jXubjekPXE6EvGPO4NqLFfK6TRIFVvgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dc7UEkdW59XS2rke5i8VS8BJ839koGKLBkcY70JrV/SK/X/ZkZNHIuMPmuFhN29i
         JIdio53Gz/ERKI9dSLAGR8ZbyjZm38AzOcJ0FRUvvb8ASk/LOq5+JhCbCW/9UqO669
         5bxzLKHMys8inNSTk6q7p7OI4yyrOoF9cLBr8EAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/731] hwrng: geode - Fix PCI device refcount leak
Date:   Wed, 28 Dec 2022 15:39:02 +0100
Message-Id: <20221228144309.171292955@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 9f6ec8dc574efb7f4f3d7ee9cd59ae307e78f445 ]

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. We add a new struct
'amd_geode_priv' to record pointer of the pci_dev and membase, and then
add missing pci_dev_put() for the normal and error path.

Fixes: ef5d862734b8 ("[PATCH] Add Geode HW RNG driver")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/geode-rng.c | 36 +++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 138ce434f86b..12fbe8091831 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -51,6 +51,10 @@ static const struct pci_device_id pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
+struct amd_geode_priv {
+	struct pci_dev *pcidev;
+	void __iomem *membase;
+};
 
 static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 {
@@ -90,6 +94,7 @@ static int __init geode_rng_init(void)
 	const struct pci_device_id *ent;
 	void __iomem *mem;
 	unsigned long rng_base;
+	struct amd_geode_priv *priv;
 
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pci_tbl, pdev);
@@ -97,17 +102,26 @@ static int __init geode_rng_init(void)
 			goto found;
 	}
 	/* Device not found. */
-	goto out;
+	return err;
 
 found:
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		err = -ENOMEM;
+		goto put_dev;
+	}
+
 	rng_base = pci_resource_start(pdev, 0);
 	if (rng_base == 0)
-		goto out;
+		goto free_priv;
 	err = -ENOMEM;
 	mem = ioremap(rng_base, 0x58);
 	if (!mem)
-		goto out;
-	geode_rng.priv = (unsigned long)mem;
+		goto free_priv;
+
+	geode_rng.priv = (unsigned long)priv;
+	priv->membase = mem;
+	priv->pcidev = pdev;
 
 	pr_info("AMD Geode RNG detected\n");
 	err = hwrng_register(&geode_rng);
@@ -116,20 +130,26 @@ static int __init geode_rng_init(void)
 		       err);
 		goto err_unmap;
 	}
-out:
 	return err;
 
 err_unmap:
 	iounmap(mem);
-	goto out;
+free_priv:
+	kfree(priv);
+put_dev:
+	pci_dev_put(pdev);
+	return err;
 }
 
 static void __exit geode_rng_exit(void)
 {
-	void __iomem *mem = (void __iomem *)geode_rng.priv;
+	struct amd_geode_priv *priv;
 
+	priv = (struct amd_geode_priv *)geode_rng.priv;
 	hwrng_unregister(&geode_rng);
-	iounmap(mem);
+	iounmap(priv->membase);
+	pci_dev_put(priv->pcidev);
+	kfree(priv);
 }
 
 module_init(geode_rng_init);
-- 
2.35.1



