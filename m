Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05E9CA900
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404321AbfJCQfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404317AbfJCQfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:35:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A16D2070B;
        Thu,  3 Oct 2019 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120546;
        bh=OSDbZ+qnZK1aTfBoQCDkx4FU7CwedCYXzK82/thGqPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVckwURk/YxqZoOPnM9aLww+siUUDwPYHOLqz1duzvIO+8IPNbI/52qLn6geNaUhS
         oXB1Uvu1XbQrxKkR3sXfKS+6PpJ2uA6RlfAaBjtsAMxMe8kOXwlIeuxXBIc9/qg3NI
         kN8/tJgF1lz4EsGvV0P33uCOauuE4s4o6NJ67tVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH 5.2 262/313] efifb: BGRT: Improve efifb_bgrt_sanity_check
Date:   Thu,  3 Oct 2019 17:54:00 +0200
Message-Id: <20191003154558.839409242@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 51677dfcc17f88ed754143df670ff064eae67f84 upstream.

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
Cc: Peter Jones <pjones@redhat.com>,
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190721131918.10115-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/efifb.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -122,28 +122,13 @@ static void efifb_copy_bmp(u8 *src, u32
  */
 static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)
 {
-	static const int default_resolutions[][2] = {
-		{  800,  600 },
-		{ 1024,  768 },
-		{ 1280, 1024 },
-	};
-	u32 i, right_margin;
+	/*
+	 * All x86 firmwares horizontally center the image (the yoffset
+	 * calculations differ between boards, but xoffset is predictable).
+	 */
+	u32 expected_xoffset = (si->lfb_width - bmp_width) / 2;
 
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
-
-	return true;
+	return bgrt_tab.image_offset_x == expected_xoffset;
 }
 #else
 static bool efifb_bgrt_sanity_check(struct screen_info *si, u32 bmp_width)


