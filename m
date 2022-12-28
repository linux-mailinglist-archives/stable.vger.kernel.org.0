Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1242765805E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiL1QRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbiL1QQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5065B1AA06
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E15BF61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1421C433EF;
        Wed, 28 Dec 2022 16:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244051;
        bh=AwSq+tNbqhVUBJhHq2Il+ctNtr0VGa4hvH3SnZp8t+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntilzkX0zgrdg2b0bFVC9caglELrwlsrqzWeh4W8L2pCh3JhsLxfdNWqJautr4tM7
         pgPgrl+IXhQwD1NI3+I3364U9s+7inb2FIBQsBCCBcwbydOmOvb+QZ8kLawJ0s93AQ
         agaE+x0dWk4/iPc/Oum+9SAoyRvImgZ5u/hexJH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0638/1073] crypto: amlogic - Remove kcalloc without check
Date:   Wed, 28 Dec 2022 15:37:06 +0100
Message-Id: <20221228144345.369720398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3d780c8a9850ad60dee47a8d971ba7888f3d1bd3 ]

There is no real point in allocating dedicated memory for the irqs array.
MAXFLOW is only 2, so it is easier to allocated the needed space
directly within the 'meson_dev' structure.

This saves some memory allocation and avoids an indirection when using the
irqs array.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator...")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 1 -
 drivers/crypto/amlogic/amlogic-gxl.h      | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 6e7ae896717c..937187027ad5 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -237,7 +237,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	mc->irqs = devm_kcalloc(mc->dev, MAXFLOW, sizeof(int), GFP_KERNEL);
 	for (i = 0; i < MAXFLOW; i++) {
 		mc->irqs[i] = platform_get_irq(pdev, i);
 		if (mc->irqs[i] < 0)
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index dc0f142324a3..8c0746a1d6d4 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -95,7 +95,7 @@ struct meson_dev {
 	struct device *dev;
 	struct meson_flow *chanlist;
 	atomic_t flow;
-	int *irqs;
+	int irqs[MAXFLOW];
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
 	struct dentry *dbgfs_dir;
 #endif
-- 
2.35.1



