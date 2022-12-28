Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72874657B8C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiL1PXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiL1PWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4071401D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C0CC6152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3082CC433EF;
        Wed, 28 Dec 2022 15:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240967;
        bh=VsAfz6RwV2NWd5fjLXoz7wWwuvsmCnqCERCZA5jhWnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJKpJKDGoyEzG1UgBPquNu4yKPcjBG/xFlVUFS37OMEuyUqcgaYoHm5HbWrJCvlCq
         W8bGFq35SkII+dB9tdX05TERgh2jM2YZsctc0H//50CCUmnay6KIxYoZikFN5L7vWb
         mWRzVy6MYMWoKtoEPpmBhRnMnb8OdeoQGmZwX3y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 422/731] crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
Date:   Wed, 28 Dec 2022 15:38:49 +0100
Message-Id: <20221228144308.802772275@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 7bcceb4c9896b1b672b636ae70fe75110d6bf1ad ]

omap_sham_probe() calls pm_runtime_get_sync() and calls
pm_runtime_put_sync() latter to put usage_counter. However,
pm_runtime_get_sync() will increment usage_counter even it failed. Fix
it by replacing it with pm_runtime_resume_and_get() to keep usage
counter balanced.

Fixes: b359f034c8bf ("crypto: omap-sham - Convert to use pm_runtime API")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Acked-by: Mark Greer <mgreer@animalcreek.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index f6bf53c00b61..4ec6949a7ca9 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2114,7 +2114,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		goto err_pm;
-- 
2.35.1



