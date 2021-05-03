Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB6E3714F3
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhECMDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234122AbhECMCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B707261249;
        Mon,  3 May 2021 12:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043285;
        bh=FjgRy3LbQ5R6fhTMkrxeHZfE0dybG9CT8NVNTbrJ6ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjgySv1q7WL8EONWlSFhe3V6l/D91/uJg6JKlgP7PxtFQ4cvtiVGUf2KOpMhxkIXl
         my5AEyAk5VRZTDEATEo06634B90KznhZGCercAxjyvZuZeab2fp0ViRSDMzYXyHQfl
         0KXA9060WOW49rFVZ8tQjUCjmFnofb/wQJ+lYnGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Igor Matheus Andrade Torrente <igormtorrente@gmail.com>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 39/69] video: hgafb: fix potential NULL pointer dereference
Date:   Mon,  3 May 2021 13:57:06 +0200
Message-Id: <20210503115736.2104747-40-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>

The return of ioremap if not checked, and can lead to a NULL to be
assigned to hga_vram. Potentially leading to a NULL pointer
dereference.

The fix adds code to deal with this case in the error label and
changes how the hgafb_probe handles the return of hga_card_detect.

Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hgafb.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index fca29f219f8b..cc8e62ae93f6 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -285,6 +285,8 @@ static int hga_card_detect(void)
 	hga_vram_len  = 0x08000;
 
 	hga_vram = ioremap(0xb0000, hga_vram_len);
+	if (!hga_vram)
+		return -ENOMEM;
 
 	if (request_region(0x3b0, 12, "hgafb"))
 		release_io_ports = 1;
@@ -344,13 +346,18 @@ static int hga_card_detect(void)
 			hga_type_name = "Hercules";
 			break;
 	}
-	return 1;
+	return 0;
 error:
 	if (release_io_ports)
 		release_region(0x3b0, 12);
 	if (release_io_port)
 		release_region(0x3bf, 1);
-	return 0;
+
+	iounmap(hga_vram);
+
+	pr_err("hgafb: HGA card not detected.\n");
+
+	return -EINVAL;
 }
 
 /**
@@ -548,13 +555,11 @@ static const struct fb_ops hgafb_ops = {
 static int hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
+	int ret;
 
-	if (! hga_card_detect()) {
-		printk(KERN_INFO "hgafb: HGA card not detected.\n");
-		if (hga_vram)
-			iounmap(hga_vram);
-		return -EINVAL;
-	}
+	ret = hga_card_detect();
+	if (!ret)
+		return ret;
 
 	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
 		hga_type_name, hga_vram_len/1024);
-- 
2.31.1

