Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D7B4EC224
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345189AbiC3L6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345966AbiC3LzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70252BB0B;
        Wed, 30 Mar 2022 04:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D358B81C29;
        Wed, 30 Mar 2022 11:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6B2C340F3;
        Wed, 30 Mar 2022 11:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641210;
        bh=bkZOOo4OTLPt/6iak3xmqexQD+t/tDVRYpkeLEA+SSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHXgdjq4LqzfXp3VJV3j29trvrqW8QFtnVDMHATDPTAufV4gWbzk2v30nwLESJLif
         HlkbNCD4zoKsnQIupCej5g2pR8RuEflgLJvzTCRqessbkz6xgMRHKlcJ4OJvItjwha
         QRZul2Il/ME3e6FSPR1HsVX+PU01+oO6xKaXdeX2NtOH4aPtggbiq4L79dPlHRxXaa
         aKioB1M/ok+baZwru2LOZuXUXhHaIPkMgh0rmj4eOBo5yEr/WnXrCbFYRH41RTQkaO
         U1UyDczcLAmKQDTjcYnnfduq1+2aADB23PmcTawxtK4OKLIJ4UcxW1NJQi5xtWBbi2
         maC6lL5Mbx+AA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, sudipm.mukherjee@gmail.com,
        teddy.wang@siliconmotion.com, tomi.valkeinen@ti.com,
        linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/22] video: fbdev: sm712fb: Fix crash in smtcfb_write()
Date:   Wed, 30 Mar 2022 07:52:58 -0400
Message-Id: <20220330115303.1672616-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115303.1672616-1-sashal@kernel.org>
References: <20220330115303.1672616-1-sashal@kernel.org>
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
index 1781ca697f66..76b1866dfa95 100644
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

