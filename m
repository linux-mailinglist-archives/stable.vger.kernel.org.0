Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47B76675FF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbjALO2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbjALO1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:27:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5945CFA5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD1726202B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDC0C433EF;
        Thu, 12 Jan 2023 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533087;
        bh=kF+UJ2+GxPrysisT/BDB8fHKcqKuKNa+EmWQ2Nb8Tuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luA7QJEJEZ6HvbrzXRgosBidROtcgGCt6qw/nSK2WfdyCqFTDvjng8056dL722kcY
         BZBwUpcrjlJH5uisr4Y8ts1f5DtMflykOjS3OkSR08fZfqiUw68MVuixOQ5p7Iq3GT
         9y4/2YiZFcmpFNxfegb+kozqqRqKoQ1UO2ckN4mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/783] hwrng: amd - Fix PCI device refcount leak
Date:   Thu, 12 Jan 2023 14:50:54 +0100
Message-Id: <20230112135539.975409623@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 9959c762da2f..db3dd467194c 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -143,15 +143,19 @@ static int __init mod_init(void)
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
@@ -185,6 +189,8 @@ static int __init mod_init(void)
 	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 out:
 	kfree(priv);
+put_dev:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -200,6 +206,8 @@ static void __exit mod_exit(void)
 
 	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 
+	pci_dev_put(priv->pcidev);
+
 	kfree(priv);
 }
 
-- 
2.35.1



