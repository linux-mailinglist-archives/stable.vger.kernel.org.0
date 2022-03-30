Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A484EC0EE
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344537AbiC3L4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344888AbiC3Lxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25F12706FB;
        Wed, 30 Mar 2022 04:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C7B8B81C34;
        Wed, 30 Mar 2022 11:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30378C340F2;
        Wed, 30 Mar 2022 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640984;
        bh=9A522rPgTeH0BLQe8vYOfJKRowXSm5djhJZvpnvcLJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjrVS2SI8kOoHyZ2ONfU/kurd6oAXcJcaV7M8O63xkXQf/O0UYNeh/XTwFTwDy7/b
         DpDYR+YWTaUbbk6BbcX3fPmUBvjh+67FQEa+wW2UWlvPKVEInFDQMf6n/btEfIoHOF
         XTk9vzVT8AQcgz0ZPVVc1Ug0tjk4/300aNUexUyBIFWfiRSYftyYEWZCRmBmm4qz+d
         j+AsDzm98HmZWe/E2QuI2bUB4OhohviDgfx3Iiwj14bK5ijO58c1YkejOUEgJYfyRQ
         6WMd+eSEMIZvSlG9pUAHPZJ6tTE5YE745ayU6dDZBDWmuplYo3jt9Lvfmwd2DB4GXt
         lKhH6/6j7aV/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, sudipm.mukherjee@gmail.com,
        teddy.wang@siliconmotion.com, tomi.valkeinen@ti.com,
        linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 46/59] video: fbdev: sm712fb: Fix crash in smtcfb_write()
Date:   Wed, 30 Mar 2022 07:48:18 -0400
Message-Id: <20220330114831.1670235-46-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 4f01d09b2bbfbcb47b3eb305560a7f4857a32260 ]

When the sm712fb driver writes three bytes to the framebuffer, the
driver will crash:

    BUG: unable to handle page fault for address: ffffc90001ffffff
    RIP: 0010:smtcfb_write+0x454/0x5b0
    Call Trace:
     vfs_write+0x291/0xd60
     ? do_sys_openat2+0x27d/0x350
     ? __fget_light+0x54/0x340
     ksys_write+0xce/0x190
     do_syscall_64+0x43/0x90
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Fix it by removing the open-coded endianness fixup-code.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sm712fb.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/video/fbdev/sm712fb.c b/drivers/video/fbdev/sm712fb.c
index 0dbc6bf8268a..e355089ac7d6 100644
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1130,7 +1130,7 @@ static ssize_t smtcfb_write(struct fb_info *info, const char __user *buf,
 		count = total_size - p;
 	}
 
-	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count, GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1148,24 +1148,11 @@ static ssize_t smtcfb_write(struct fb_info *info, const char __user *buf,
 			break;
 		}
 
-		for (i = c >> 2; i--;) {
-			fb_writel(big_swap(*src), dst++);
+		for (i = (c + 3) >> 2; i--;) {
+			fb_writel(big_swap(*src), dst);
+			dst++;
 			src++;
 		}
-		if (c & 3) {
-			u8 *src8 = (u8 *)src;
-			u8 __iomem *dst8 = (u8 __iomem *)dst;
-
-			for (i = c & 3; i--;) {
-				if (i & 1) {
-					fb_writeb(*src8++, ++dst8);
-				} else {
-					fb_writeb(*src8++, --dst8);
-					dst8 += 2;
-				}
-			}
-			dst = (u32 __iomem *)dst8;
-		}
 
 		*ppos += c;
 		buf += c;
-- 
2.34.1

