Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFFC38ED76
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhEXPiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhEXPgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E088B6140D;
        Mon, 24 May 2021 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870353;
        bh=Wjlwndu3maWl4Pu3r737cwkled+6HVuNMWTYCHealns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXFyX0YBUyxMyS4hb9eVID7NzZHNjJX9mBrvHnq0qt3nInYSSvm5iqljfjEadNarz
         pz5Xozw4p3m3AefHkg/ek2F1M1y+8pa6EJB7Ek5+YYlfsnDDOGx6aTJOJew4BvZo+B
         jI421uaLCioDzmfCv+62kBud0Gd2F7W6PEhmcUA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Subject: [PATCH 4.9 32/36] video: hgafb: fix potential NULL pointer dereference
Date:   Mon, 24 May 2021 17:25:17 +0200
Message-Id: <20210524152325.193367564@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
References: <20210524152324.158146731@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>

commit dc13cac4862cc68ec74348a80b6942532b7735fa upstream.

The return of ioremap if not checked, and can lead to a NULL to be
assigned to hga_vram. Potentially leading to a NULL pointer
dereference.

The fix adds code to deal with this case in the error label and
changes how the hgafb_probe handles the return of hga_card_detect.

Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-40-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hgafb.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

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
@@ -548,13 +555,11 @@ static struct fb_ops hgafb_ops = {
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


