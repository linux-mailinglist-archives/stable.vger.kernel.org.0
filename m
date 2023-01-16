Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36CD66C73C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjAPQ3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbjAPQ25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:28:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7763C2DE5F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:17:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12DCF61031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F27C433F1;
        Mon, 16 Jan 2023 16:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885824;
        bh=OKgMLBtalK0k5CakQRomu8g3tXNf8j69gW0svN2QNOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lH0ishxfhfK/cxLNA7Mma7IRfTGNXoW6R8i+XHnK8Hw3f+7AMCDsyp9ED2aBkgaue
         +B/DZg5rBs86EF2wkKfyc6Q/LM8iYC4dD24YPbVBtoLLKAoG5AtKWtW6BTqEQ0FBdj
         KugX4dCx8kQEiiOs58HRF9TRL6GRmhgslYJ4AfOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/658] mmc: meson-gx: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:44:46 +0100
Message-Id: <20230116154918.494247111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 90935f16f2650ab7416fa2ffbe5c28cb39cf3f1e ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

Fix this by checking the return value and goto error path which
will call mmc_free_host().

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20221108123417.479045-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-gx-mmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 9044faf0050a..95a8ba4cf3da 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1289,7 +1289,9 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	}
 
 	mmc->ops = &meson_mmc_ops;
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto err_free_irq;
 
 	return 0;
 
-- 
2.35.1



