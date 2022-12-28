Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E91657B88
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiL1PXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiL1PWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0F713F41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F75C6155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9158BC433D2;
        Wed, 28 Dec 2022 15:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240956;
        bh=AwSq+tNbqhVUBJhHq2Il+ctNtr0VGa4hvH3SnZp8t+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePAuHV8ahBS18vjL0ldMjGOIQlEULLHNoXaM6ng2SFmpZy+CMsfIHtcZEQk8ViduA
         ue+tn6JUe5qOMV/NeoMM0yRF/mM/3JATGogo1i43MvefxshMW9U+ipUSPmebob6io/
         Ij2d91yoCpYNixDQvx+aO/vTYKxhKarQhMooBI14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/731] crypto: amlogic - Remove kcalloc without check
Date:   Wed, 28 Dec 2022 15:38:48 +0100
Message-Id: <20221228144308.774532774@linuxfoundation.org>
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



