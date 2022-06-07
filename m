Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAD7541AF1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378340AbiFGVmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381244AbiFGVkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA5223236C;
        Tue,  7 Jun 2022 12:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A7A617DA;
        Tue,  7 Jun 2022 19:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0835C385A2;
        Tue,  7 Jun 2022 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628761;
        bh=7BUSsPCv2pbS4QHIqmCypyI9AizY3jjKrtxtZUOl0cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIiIkwPbddpKn5o3BoExFqsb3M96mgHl/VOcmxRrqAp87vFnSgG/H4UWGtWHgCFHi
         V27RqMrUv7N/4vlPyAiYKsbADd+VGGQ+ab+457KWDsGRVHlPEmcYcHo2Ba+8QGT99M
         2T5O/WX54scipXqxD7MZBe/g79isGcxzoM9mHGZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 445/879] media: exynos4-is: Change clk_disable to clk_disable_unprepare
Date:   Tue,  7 Jun 2022 18:59:23 +0200
Message-Id: <20220607165015.788712679@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 9fadab72a6916c7507d7fedcd644859eef995078 ]

The corresponding API for clk_prepare_enable is clk_disable_unprepare,
other than clk_disable.

Fix this by changing clk_disable to clk_disable_unprepare.

Fixes: b4155d7d5b2c ("[media] exynos4-is: Ensure fimc-is clocks are not enabled until properly configured")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/fimc-is.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-is.c b/drivers/media/platform/samsung/exynos4-is/fimc-is.c
index 81b290dace3a..e3072d69c49f 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-is.c
@@ -140,7 +140,7 @@ static int fimc_is_enable_clocks(struct fimc_is *is)
 			dev_err(&is->pdev->dev, "clock %s enable failed\n",
 				fimc_is_clocks[i]);
 			for (--i; i >= 0; i--)
-				clk_disable(is->clocks[i]);
+				clk_disable_unprepare(is->clocks[i]);
 			return ret;
 		}
 		pr_debug("enabled clock: %s\n", fimc_is_clocks[i]);
-- 
2.35.1



