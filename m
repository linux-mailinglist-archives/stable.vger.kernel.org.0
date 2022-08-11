Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9995900CC
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiHKPq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236339AbiHKPpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:45:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5DA9568D;
        Thu, 11 Aug 2022 08:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF95F6148F;
        Thu, 11 Aug 2022 15:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CC3C43140;
        Thu, 11 Aug 2022 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232376;
        bh=uBbdPrkQnNq5sVsrdMiCei9SdKxa/e8fnHqBZoUb4Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dR6v0jW+ORGDJDdxE0+y1hsQ9u2yp+r2tTq6rCrulcCOPSHFkn5UowPz95ow93REb
         veYgFwrQ4wyMKRr08eIl0+BjQGGWw44hiqFWgo3GL1PbzKma5h5nLWuzxPD4LTUPuN
         82wsL/nFtMG/JMb9wkff59WVbcT73R7uBYQew3l5jYPdMBqgwy6q/vKgJYQNY9qXF3
         9cY40Bmxh0QS4d6dX89mbcljGyhw/ISF19GyzpiM5YEf1gCQGZMcHObeg4LLy7Q/Kx
         2t0Jn0WM+jBLNnlgwRl2YbyQiVapSTVbd7qPOO5RA8YouDN/1C42X1/TV0r8X/MBqH
         oPcyUJMQsYOUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 074/105] media: rkisp1: Disable runtime PM in probe error path
Date:   Thu, 11 Aug 2022 11:27:58 -0400
Message-Id: <20220811152851.1520029-74-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 13c9810281f8b24af9b7712cd84a1fce61843e93 ]

If the v4l2_device_register() call fails, runtime PM is left enabled.
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
index 3f5cfa7eb937..471226d95dbf 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -552,7 +552,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 
 	ret = v4l2_device_register(rkisp1->dev, &rkisp1->v4l2_dev);
 	if (ret)
-		return ret;
+		goto err_pm_runtime_disable;
 
 	ret = media_device_register(&rkisp1->media_dev);
 	if (ret) {
@@ -572,6 +572,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 	media_device_unregister(&rkisp1->media_dev);
 err_unreg_v4l2_dev:
 	v4l2_device_unregister(&rkisp1->v4l2_dev);
+err_pm_runtime_disable:
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
-- 
2.35.1

