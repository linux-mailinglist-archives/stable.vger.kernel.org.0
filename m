Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D895A6AB7
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiH3Rc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiH3Rbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:31:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E6D12EC74;
        Tue, 30 Aug 2022 10:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3701FB81D1A;
        Tue, 30 Aug 2022 17:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084A6C433D6;
        Tue, 30 Aug 2022 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880378;
        bh=dKlYcbJg8jJBwPyfgtu+Hl0XHma2r9ZCS4XvcIUHs8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPlRpzzf9kS1DuO8k9642AjN5s5vqDVPHLMQI0dp2OcQSvqeUuqYectzA2rPpWs50
         dbePTQy5cOiVwTMEXXvtx9ZfU9INlFuyIBopbqE2uWZ1JgGKrXMXoPD9ALJ1e7zifG
         Bg96I5QLj/aULc4zrP49pY6t+Hc5KC+Q1eEBX1QpL5GQfJVt1PzjrofnVUYOagxgtY
         yRZlTQO4a9AoZBoFf2J0rs2v/pkmCpwwrTWUz92XUEgw18y5eHiQ2ZGFFJJcAr1ALX
         1voZiSC/wOpDrabgIikcRbXm6buw5RkL78K002OnKF33ivgma42ol1yCrMsNs+SqBq
         MctjdnfZ38KWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        baihaowen@meizu.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 08/10] fbdev: fb_pm2fb: Avoid potential divide by zero error
Date:   Tue, 30 Aug 2022 13:25:39 -0400
Message-Id: <20220830172541.581820-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172541.581820-1-sashal@kernel.org>
References: <20220830172541.581820-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Letu Ren <fantasquex@gmail.com>

[ Upstream commit 19f953e7435644b81332dd632ba1b2d80b1e37af ]

In `do_fb_ioctl()` of fbmem.c, if cmd is FBIOPUT_VSCREENINFO, var will be
copied from user, then go through `fb_set_var()` and
`info->fbops->fb_check_var()` which could may be `pm2fb_check_var()`.
Along the path, `var->pixclock` won't be modified. This function checks
whether reciprocal of `var->pixclock` is too high. If `var->pixclock` is
zero, there will be a divide by zero error. So, it is necessary to check
whether denominator is zero to avoid crash. As this bug is found by
Syzkaller, logs are listed below.

divide error in pm2fb_check_var
Call Trace:
 <TASK>
 fb_set_var+0x367/0xeb0 drivers/video/fbdev/core/fbmem.c:1015
 do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1110
 fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1189

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pm2fb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index 1dcf02e12af4f..8ae010f07d7da 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -616,6 +616,11 @@ static int pm2fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		return -EINVAL;
 	}
 
+	if (!var->pixclock) {
+		DPRINTK("pixclock is zero\n");
+		return -EINVAL;
+	}
+
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));
-- 
2.35.1

