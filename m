Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389BC6F360
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfGUNTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:19:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbfGUNTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 09:19:22 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DA4D308FE9A;
        Sun, 21 Jul 2019 13:19:21 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A4D660BFB;
        Sun, 21 Jul 2019 13:19:20 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] efifb: BGRT: Improve efifb_bgrt_sanity_check
Date:   Sun, 21 Jul 2019 15:19:18 +0200
Message-Id: <20190721131918.10115-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Sun, 21 Jul 2019 13:19:22 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For various reasons, at least with x86 EFI firmwares, the xoffset and
yoffset in the BGRT info are not always reliable.

Extensive testing has shown that when the info is correct, the
BGRT image is always exactly centered horizontally (the yoffset variable
is more variable and not always predictable).

This commit simplifies / improves the bgrt_sanity_check to simply
check that the BGRT image is exactly centered horizontally and skips
(re)drawing it when it is not.

This fixes the BGRT image sometimes being drawn in the wrong place.

Cc: stable@vger.kernel.org
Fixes: 88fe4ceb2447 ("efifb: BGRT: Do not copy the boot graphics for non native resolutions")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/video/fbdev/efifb.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index dfa8dd47d19d..5b3cef9bf794 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -122,28 +122,13 @@ static void efifb_copy_bmp(u8 *src, u32 *dst, int width, struct screen_info *si)
  */
 static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)
 {
-	static const int default_resolutions[][2] = {
-		{  800,  600 },
-		{ 1024,  768 },
-		{ 1280, 1024 },
-	};
-	u32 i, right_margin;
-
-	for (i = 0; i < ARRAY_SIZE(default_resolutions); i++) {
-		if (default_resolutions[i][0] == si->lfb_width &&
-		    default_resolutions[i][1] == si->lfb_height)
-			break;
-	}
-	/* If not a default resolution used for textmode, this should be fine */
-	if (i >= ARRAY_SIZE(default_resolutions))
-		return true;
-
-	/* If the right margin is 5 times smaller then the left one, reject */
-	right_margin = si->lfb_width - (bgrt_tab.image_offset_x + bmp_width);
-	if (right_margin < (bgrt_tab.image_offset_x / 5))
-		return false;
+	/*
+	 * All x86 firmwares horizontally center the image (the yoffset
+	 * calculations differ between boards, but xoffset is predictable).
+	 */
+	u32 expected_xoffset = (si->lfb_width - bmp_width) / 2;
 
-	return true;
+	return bgrt_tab.image_offset_x == expected_xoffset;
 }
 #else
 static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)
-- 
2.21.0

