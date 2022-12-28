Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209A66579D1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiL1PFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiL1PFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5DF13D58
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEF49B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE05C433EF;
        Wed, 28 Dec 2022 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239901;
        bh=UYZmhVnYuPPa3z3HlgyKhcTx8yA7jk3Yjvzy6Bl7XT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEjLWP8eyLMFVGk+TqB0aghxGh5ew9ppNpsBNZXRHo8O6k/g2DfJrqYxqLB6Vrhg/
         VqfcFIJc/5BKqkmX8DkqOKvFfmwSrbi2kJ+hbqiBeSiVzxZQYu4B5R73AJxUWB8roK
         OXkpUr+uRcdEd/dt7BLvmvkDTjsVtG8Bu+sjV2iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0056/1146] soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe
Date:   Wed, 28 Dec 2022 15:26:35 +0100
Message-Id: <20221228144331.683018710@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit e961c0f19450fd4a26bd043dd2979990bf12caf6 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes: 41f93af900a2 ("soc: ti: add Keystone Navigator QMSS driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221108080322.52268-2-zhangqilong3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 16a6d530a0d4..8fb76908be70 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1785,6 +1785,7 @@ static int knav_queue_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
+		pm_runtime_disable(&pdev->dev);
 		dev_err(dev, "Failed to enable QMSS\n");
 		return ret;
 	}
-- 
2.35.1



