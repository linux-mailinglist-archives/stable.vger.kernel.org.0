Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F49F657820
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiL1OsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbiL1Orm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1355120BA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90C24B816D6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CD4C433F0;
        Wed, 28 Dec 2022 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238835;
        bh=DSg1xLLUt4wNylwLdrlmaXZWI/6c1MsLDTdq8VQq5as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTpnuEqSTCoIuPbtD1f4C36RFcKGcV0vgLKaYoZ+4rtmTJnCutJM75vyTaDBxu9z+
         wOMp/y3RZ4KGxs11+Tdin2vZQLbIOaPUd9yqO07azk0qoGLYZGDIdMdMME2JUzi1TW
         AFO93NXDfWhFcGvNlzaEQFM3alWnKxmNQp4hQW1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/731] soc: ti: knav_qmss_queue: Use pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 28 Dec 2022 15:32:15 +0100
Message-Id: <20221228144257.362365282@linuxfoundation.org>
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

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit 12eeb74925da70eb39d90abead9de9793be3d4c8 ]

Using pm_runtime_resume_and_get is more appropriate for simplifying
code.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20220418062955.2557949-1-chi.minghao@zte.com.cn
Stable-dep-of: e961c0f19450 ("soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 920eca809084..de11f2b8db0f 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1785,9 +1785,8 @@ static int knav_queue_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&kdev->pdsps);
 
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
 		dev_err(dev, "Failed to enable QMSS\n");
 		return ret;
 	}
-- 
2.35.1



