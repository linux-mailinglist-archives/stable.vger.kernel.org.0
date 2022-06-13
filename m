Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A047548FDF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352397AbiFMLRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353635AbiFMLQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FFF387BF;
        Mon, 13 Jun 2022 03:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 872CCB80EA8;
        Mon, 13 Jun 2022 10:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C5CC34114;
        Mon, 13 Jun 2022 10:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116716;
        bh=7gLmPXzMhNy7D2VimkqVQcs4oFEM8KSRbDToOpCrFlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePrL+w1/es/rMuAXu+t7BghilnrFjpmT6wTZ4zB+9dEb01lVQZPBF4UZidPxeNg5e
         qAN0y+dGMfUtH4Jw2VzlRyl9YXusKDdSxvXiFQYR6c7nlJukl4MIf0PINxfnlHPquW
         A29WyU/Vk/9ClAEmoYQxq3vvmh6UobPcyYSkErKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/411] thermal/drivers/broadcom: Fix potential NULL dereference in sr_thermal_probe
Date:   Mon, 13 Jun 2022 12:07:00 +0200
Message-Id: <20220613094933.076080458@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit e20d136ec7d6f309989c447638365840d3424c8e ]

platform_get_resource() may return NULL, add proper check to
avoid potential NULL dereferencing.

Fixes: 250e211057c72 ("thermal: broadcom: Add Stingray thermal driver")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Link: https://lore.kernel.org/r/20220425092929.90412-1-zhengyongjun3@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/broadcom/sr-thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/broadcom/sr-thermal.c b/drivers/thermal/broadcom/sr-thermal.c
index 475ce2900771..85ab9edd580c 100644
--- a/drivers/thermal/broadcom/sr-thermal.c
+++ b/drivers/thermal/broadcom/sr-thermal.c
@@ -60,6 +60,9 @@ static int sr_thermal_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+
 	sr_thermal->regs = (void __iomem *)devm_memremap(&pdev->dev, res->start,
 							 resource_size(res),
 							 MEMREMAP_WB);
-- 
2.35.1



