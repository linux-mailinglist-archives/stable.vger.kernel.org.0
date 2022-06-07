Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E64B540B49
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350598AbiFGS1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352464AbiFGSVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:21:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC1C3191E;
        Tue,  7 Jun 2022 10:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B25AFB82366;
        Tue,  7 Jun 2022 17:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27638C36AFF;
        Tue,  7 Jun 2022 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624429;
        bh=21hBvAqjWgZPVZ41EoxFTaicryQRjHH9kB2zenjleVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZmRam3DTKrOiINls+eI4YbNbT6+n+sqQNoEl1rcnuow4s5gM0aMimP2vWvq7UOpv
         twAWV9FfLz/oMcPyidquWAZudjnvkdxyUhzHJ9UI7PuOutPdykzWNreKv/sivfECvI
         UlZ1kLGRy76fgKOlOj3I17356kjpastWJZMmnJBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/667] media: exynos4-is: Change clk_disable to clk_disable_unprepare
Date:   Tue,  7 Jun 2022 18:59:49 +0200
Message-Id: <20220607164944.487258214@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
 drivers/media/platform/exynos4-is/fimc-is.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 81b290dace3a..e3072d69c49f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
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



