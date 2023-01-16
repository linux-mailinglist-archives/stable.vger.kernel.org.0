Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC666CAA2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbjAPREv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjAPREH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:04:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44BE5C0D8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74BD7B8108F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DD0C433EF;
        Mon, 16 Jan 2023 16:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887587;
        bh=3umGfoUesU0Bpc2kWu35atFs2Nf2q8EV/o6o+K/LdK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSgap1Tj44+Nhal+S8oozgbxTaw7/9dVvHQtHuH7ZOaE2ZvGAtfpt1GsX1bmHWGge
         1xuzNjthZObaZboJurvAsuK0X2q3doKTyojfFifdPJGx/ACa4N1dt9kxPAsZS8Bie1
         e2kHBpHou4MKmuYiJw21ZrA4QGFij6CQMLIIn+sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 206/521] hwrng: geode - Fix PCI device refcount leak
Date:   Mon, 16 Jan 2023 16:47:48 +0100
Message-Id: <20230116154856.353626170@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index e1d421a36a13..207272979f23 100644
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
@@ -90,6 +94,7 @@ static int __init mod_init(void)
 	const struct pci_device_id *ent;
 	void __iomem *mem;
 	unsigned long rng_base;
+	struct amd_geode_priv *priv;
 
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pci_tbl, pdev);
@@ -97,17 +102,26 @@ static int __init mod_init(void)
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
@@ -116,20 +130,26 @@ static int __init mod_init(void)
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
 
 static void __exit mod_exit(void)
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
 
 module_init(mod_init);
-- 
2.35.1



