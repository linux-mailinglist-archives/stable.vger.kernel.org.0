Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8254F3AB4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiDELqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355365AbiDEKTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A700327FEC;
        Tue,  5 Apr 2022 03:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38758B81BC0;
        Tue,  5 Apr 2022 10:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEDFC385A2;
        Tue,  5 Apr 2022 10:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153086;
        bh=Cw2NlYAm/sub3uTEA3b2qIyrR3JDeMkKrC26amsoKtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHAJy/+PL51AzoM/nN/TOBZmwl/pMjG3u2J+3waXchDLT4BF3+Xkz/WUVQCjvJBad
         /uLI/rAHmHXnoYQAzr0HqhdXf6s4kt4800yKn+4529B/4tEaq5RupOeEanG4VroTQ4
         48mr4uFudAR+p/Jo8BT5Z4O4xtAz9IsNhLXR3uRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 097/599] video: fbdev: sm712fb: Fix crash in smtcfb_read()
Date:   Tue,  5 Apr 2022 09:26:31 +0200
Message-Id: <20220405070301.717839647@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit bd771cf5c4254511cc4abb88f3dab3bd58bdf8e8 upstream.

Zheyu Ma reported this crash in the sm712fb driver when reading
three bytes from the framebuffer:

 BUG: unable to handle page fault for address: ffffc90001ffffff
 RIP: 0010:smtcfb_read+0x230/0x3e0
 Call Trace:
  vfs_read+0x198/0xa00
  ? do_sys_openat2+0x27d/0x350
  ? __fget_light+0x54/0x340
  ksys_read+0xce/0x190
  do_syscall_64+0x43/0x90

Fix it by removing the open-coded endianess fixup-code and
by moving the pointer post decrement out the fb_readl() function.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: Zheyu Ma <zheyuma97@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/sm712fb.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1047,7 +1047,7 @@ static ssize_t smtcfb_read(struct fb_inf
 	if (count + p > total_size)
 		count = total_size - p;
 
-	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count, GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1059,25 +1059,14 @@ static ssize_t smtcfb_read(struct fb_inf
 	while (count) {
 		c = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		dst = buffer;
-		for (i = c >> 2; i--;) {
-			*dst = fb_readl(src++);
-			*dst = big_swap(*dst);
+		for (i = (c + 3) >> 2; i--;) {
+			u32 val;
+
+			val = fb_readl(src);
+			*dst = big_swap(val);
+			src++;
 			dst++;
 		}
-		if (c & 3) {
-			u8 *dst8 = (u8 *)dst;
-			u8 __iomem *src8 = (u8 __iomem *)src;
-
-			for (i = c & 3; i--;) {
-				if (i & 1) {
-					*dst8++ = fb_readb(++src8);
-				} else {
-					*dst8++ = fb_readb(--src8);
-					src8 += 2;
-				}
-			}
-			src = (u32 __iomem *)src8;
-		}
 
 		if (copy_to_user(buf, buffer, c)) {
 			err = -EFAULT;


