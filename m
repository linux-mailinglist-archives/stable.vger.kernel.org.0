Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F876581E8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbiL1QcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiL1Qbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310EEB30
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C026DB81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A96C433D2;
        Wed, 28 Dec 2022 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244898;
        bh=MtJxME0daBU8mxhlgoTcfsB+TZFPAlcvqI2POhUuFIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NP6b/ZYRJ3CSbdPUWUpMp8DDv0tVc+SKA2h9rvfwyn83JxVF58ogvdHfGTRaWYsGc
         EozlR9bI24NEurBu4rVqda0TgHwA6OsA2IQ+EHuX6Vulf88vHlr0HYzP2nmXkzluTF
         UnyLi0tBeCsWgMOJg6zMdKWgbQkIk0uV2+6SCHT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0758/1146] fbdev: ep93xx-fb: Add missing clk_disable_unprepare in ep93xxfb_probe()
Date:   Wed, 28 Dec 2022 15:38:17 +0100
Message-Id: <20221228144350.732963002@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit c84bf485a5aaf9aa0764a58832b7ef4375c29f03 ]

The clk_disable_unprepare() should be called in the error handling
of register_framebuffer(), fix it.

Fixes: 0937a7b3625d ("video: ep93xx: Prepare clock before using it")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ep93xx-fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ep93xx-fb.c b/drivers/video/fbdev/ep93xx-fb.c
index 2398b3d48fed..305f1587bd89 100644
--- a/drivers/video/fbdev/ep93xx-fb.c
+++ b/drivers/video/fbdev/ep93xx-fb.c
@@ -552,12 +552,14 @@ static int ep93xxfb_probe(struct platform_device *pdev)
 
 	err = register_framebuffer(info);
 	if (err)
-		goto failed_check;
+		goto failed_framebuffer;
 
 	dev_info(info->dev, "registered. Mode = %dx%d-%d\n",
 		 info->var.xres, info->var.yres, info->var.bits_per_pixel);
 	return 0;
 
+failed_framebuffer:
+	clk_disable_unprepare(fbi->clk);
 failed_check:
 	if (fbi->mach_info->teardown)
 		fbi->mach_info->teardown(pdev);
-- 
2.35.1



