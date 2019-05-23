Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4BA28A53
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388449AbfEWTMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388427AbfEWTMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:12:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D5D420863;
        Thu, 23 May 2019 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638743;
        bh=9oY+pI8ykV1BKLM3bhcwgDCHMon/QrsSj3NZSK0i6N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyFslSxny82JyzetEqVPJMuym57TPbiagQa8YRO+zI0o6o+L5jxQWW5SCTC0OxNWC
         MFrEnMa5EAXqF8i45djmS/Y7f6nNJ3e+j1hZtqW2HkF+wX6HZBLnu0sVy6C4Lvsru9
         P1T/fgWBPsyE11NXBy23wRADrXuCEOc7vvs4PG88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.14 48/77] fbdev: sm712fb: fix crashes and garbled display during DPMS modesetting
Date:   Thu, 23 May 2019 21:06:06 +0200
Message-Id: <20190523181726.698424132@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit f627caf55b8e735dcec8fa6538e9668632b55276 upstream.

On a Thinkpad s30 (Pentium III / i440MX, Lynx3DM), blanking the display
or starting the X server will crash and freeze the system, or garble the
display.

Experiments showed this problem can mostly be solved by adjusting the
order of register writes. Also, sm712fb failed to consider the difference
of clock frequency when unblanking the display, and programs the clock for
SM712 to SM720.

Fix them by adjusting the order of register writes, and adding an
additional check for SM720 for programming the clock frequency.

Signed-off-by: Yifeng Li <tomli@tomli.me>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: <stable@vger.kernel.org>  # v4.4+
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/sm712fb.c |   64 ++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -886,67 +886,79 @@ static inline unsigned int chan_to_field
 
 static int smtc_blank(int blank_mode, struct fb_info *info)
 {
+	struct smtcfb_info *sfb = info->par;
+
 	/* clear DPMS setting */
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
 		/* Screen On: HSync: On, VSync : On */
+
+		switch (sfb->chip_id) {
+		case 0x710:
+		case 0x712:
+			smtc_seqw(0x6a, 0x16);
+			smtc_seqw(0x6b, 0x02);
+		case 0x720:
+			smtc_seqw(0x6a, 0x0d);
+			smtc_seqw(0x6b, 0x02);
+			break;
+		}
+
+		smtc_seqw(0x23, (smtc_seqr(0x23) & (~0xc0)));
 		smtc_seqw(0x01, (smtc_seqr(0x01) & (~0x20)));
-		smtc_seqw(0x6a, 0x16);
-		smtc_seqw(0x6b, 0x02);
 		smtc_seqw(0x21, (smtc_seqr(0x21) & 0x77));
 		smtc_seqw(0x22, (smtc_seqr(0x22) & (~0x30)));
-		smtc_seqw(0x23, (smtc_seqr(0x23) & (~0xc0)));
-		smtc_seqw(0x24, (smtc_seqr(0x24) | 0x01));
 		smtc_seqw(0x31, (smtc_seqr(0x31) | 0x03));
+		smtc_seqw(0x24, (smtc_seqr(0x24) | 0x01));
 		break;
 	case FB_BLANK_NORMAL:
 		/* Screen Off: HSync: On, VSync : On   Soft blank */
+		smtc_seqw(0x24, (smtc_seqr(0x24) | 0x01));
+		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
+		smtc_seqw(0x23, (smtc_seqr(0x23) & (~0xc0)));
 		smtc_seqw(0x01, (smtc_seqr(0x01) & (~0x20)));
+		smtc_seqw(0x22, (smtc_seqr(0x22) & (~0x30)));
 		smtc_seqw(0x6a, 0x16);
 		smtc_seqw(0x6b, 0x02);
-		smtc_seqw(0x22, (smtc_seqr(0x22) & (~0x30)));
-		smtc_seqw(0x23, (smtc_seqr(0x23) & (~0xc0)));
-		smtc_seqw(0x24, (smtc_seqr(0x24) | 0x01));
-		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
 		/* Screen On: HSync: On, VSync : Off */
+		smtc_seqw(0x24, (smtc_seqr(0x24) & (~0x01)));
+		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
+		smtc_seqw(0x23, ((smtc_seqr(0x23) & (~0xc0)) | 0x20));
 		smtc_seqw(0x01, (smtc_seqr(0x01) | 0x20));
-		smtc_seqw(0x20, (smtc_seqr(0x20) & (~0xB0)));
-		smtc_seqw(0x6a, 0x0c);
-		smtc_seqw(0x6b, 0x02);
 		smtc_seqw(0x21, (smtc_seqr(0x21) | 0x88));
+		smtc_seqw(0x20, (smtc_seqr(0x20) & (~0xB0)));
 		smtc_seqw(0x22, ((smtc_seqr(0x22) & (~0x30)) | 0x20));
-		smtc_seqw(0x23, ((smtc_seqr(0x23) & (~0xc0)) | 0x20));
-		smtc_seqw(0x24, (smtc_seqr(0x24) & (~0x01)));
-		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
 		smtc_seqw(0x34, (smtc_seqr(0x34) | 0x80));
+		smtc_seqw(0x6a, 0x0c);
+		smtc_seqw(0x6b, 0x02);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
 		/* Screen On: HSync: Off, VSync : On */
+		smtc_seqw(0x24, (smtc_seqr(0x24) & (~0x01)));
+		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
+		smtc_seqw(0x23, ((smtc_seqr(0x23) & (~0xc0)) | 0xD8));
 		smtc_seqw(0x01, (smtc_seqr(0x01) | 0x20));
-		smtc_seqw(0x20, (smtc_seqr(0x20) & (~0xB0)));
-		smtc_seqw(0x6a, 0x0c);
-		smtc_seqw(0x6b, 0x02);
 		smtc_seqw(0x21, (smtc_seqr(0x21) | 0x88));
+		smtc_seqw(0x20, (smtc_seqr(0x20) & (~0xB0)));
 		smtc_seqw(0x22, ((smtc_seqr(0x22) & (~0x30)) | 0x10));
-		smtc_seqw(0x23, ((smtc_seqr(0x23) & (~0xc0)) | 0xD8));
-		smtc_seqw(0x24, (smtc_seqr(0x24) & (~0x01)));
-		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
 		smtc_seqw(0x34, (smtc_seqr(0x34) | 0x80));
+		smtc_seqw(0x6a, 0x0c);
+		smtc_seqw(0x6b, 0x02);
 		break;
 	case FB_BLANK_POWERDOWN:
 		/* Screen On: HSync: Off, VSync : Off */
+		smtc_seqw(0x24, (smtc_seqr(0x24) & (~0x01)));
+		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
+		smtc_seqw(0x23, ((smtc_seqr(0x23) & (~0xc0)) | 0xD8));
 		smtc_seqw(0x01, (smtc_seqr(0x01) | 0x20));
-		smtc_seqw(0x20, (smtc_seqr(0x20) & (~0xB0)));
-		smtc_seqw(0x6a, 0x0c);
-		smtc_seqw(0x6b, 0x02);
 		smtc_seqw(0x21, (smtc_seqr(0x21) | 0x88));
+		smtc_seqw(0x20, (smtc_seqr(0x20) & (~0xB0)));
 		smtc_seqw(0x22, ((smtc_seqr(0x22) & (~0x30)) | 0x30));
-		smtc_seqw(0x23, ((smtc_seqr(0x23) & (~0xc0)) | 0xD8));
-		smtc_seqw(0x24, (smtc_seqr(0x24) & (~0x01)));
-		smtc_seqw(0x31, ((smtc_seqr(0x31) & (~0x07)) | 0x00));
 		smtc_seqw(0x34, (smtc_seqr(0x34) | 0x80));
+		smtc_seqw(0x6a, 0x0c);
+		smtc_seqw(0x6b, 0x02);
 		break;
 	default:
 		return -EINVAL;


