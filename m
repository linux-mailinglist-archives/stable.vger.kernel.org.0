Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39A96675C9
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbjALOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjALOYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:24:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E7355873
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:16:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54BC060A69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4F7C433D2;
        Thu, 12 Jan 2023 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532975;
        bh=5pID0J6smr0rwgMjNuusAWZx8gUTXzLrVgKuW/eg/64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptIsm0+abghkYwAeF1yVs4WUUwZeqA48oPIdxbSa9CfzsNnByiciLznmAYw2arF6f
         AdrHG2ZbS/SzsrR+d4iXrD2k0jqfJnc4EMJTY3IvJSZlA269eOygjXgLz97Ut/uarR
         E6KQWLjQ4Wq9HXIp2KV5CRFK6xYDyl995zggj/KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/783] crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
Date:   Thu, 12 Jan 2023 14:50:46 +0100
Message-Id: <20230112135539.608830317@linuxfoundation.org>
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
index 48f78e34cf8d..5a57617441b8 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2130,7 +2130,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_irq_safe(dev);
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		goto err_pm;
-- 
2.35.1



