Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F83231D7C
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfFAN3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729346AbfFAN1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE48273CB;
        Sat,  1 Jun 2019 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395631;
        bh=IL/nGdSKktqzepUO//InfHWaBEuu+eKO2x3C+X1hdKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFCnXe6h5bvw6Ml7fasxMni6fxhJye9X7orj/1VzigUA8zMp2Rt0gsq+s5DamHI/s
         7evynRJ4czZ3Ed2kFxHjF5NZIk1+NwXU9Fvn0HgXiNHxhHnyNpm+kFsWzoCO+1Ky4u
         kYkGfwSmnX/1atPAggrcZWzboSy32D0a0TpcAQxM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 41/56] fbdev: sm712fb: fix crashes and garbled display during DPMS modesetting
Date:   Sat,  1 Jun 2019 09:25:45 -0400
Message-Id: <20190601132600.27427-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

[ Upstream commit f627caf55b8e735dcec8fa6538e9668632b55276 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sm712fb.c | 64 +++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/drivers/video/fbdev/sm712fb.c b/drivers/video/fbdev/sm712fb.c
index 86ae1d4556fc1..2539c1e6facb4 100644
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -827,67 +827,79 @@ static inline unsigned int chan_to_field(unsigned int chan,
 
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
-- 
2.20.1

