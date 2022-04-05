Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD264F392A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377670AbiDELaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352446AbiDEKEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:04:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1834A3F6;
        Tue,  5 Apr 2022 02:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E1CAB818F6;
        Tue,  5 Apr 2022 09:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6818DC385A1;
        Tue,  5 Apr 2022 09:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152394;
        bh=yD6j1fnTv8REaI/DYQ4/I9JyKfmStY72PLy1+LTQ6pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHnHRbrnPJ//FLPj0CrPgDiOc7L+yEt/g/yxGu79yvOzjJ93XwhmD2gXbsVoGF+xr
         TkFsQICyT6pUCh8QYKf8QvBggqzhioEaHVfdNaOqZBLV07egE95WqlzHVLLoFdnbiL
         60RQPrM039CxkEsTvJYOgTCRypRtQSSjZxa8jRvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 761/913] video: fbdev: sm712fb: Fix crash in smtcfb_write()
Date:   Tue,  5 Apr 2022 09:30:23 +0200
Message-Id: <20220405070402.643949346@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/video/fbdev/sm712fb.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1119,7 +1119,7 @@ static ssize_t smtcfb_write(struct fb_in
 		count = total_size - p;
 	}
 
-	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count, GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1137,24 +1137,11 @@ static ssize_t smtcfb_write(struct fb_in
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


