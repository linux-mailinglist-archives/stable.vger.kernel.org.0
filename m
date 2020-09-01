Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E41025935B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgIAPYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729977AbgIAPYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:24:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E6420BED;
        Tue,  1 Sep 2020 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973884;
        bh=t1LNtG/Jdd0VPLwGJg2Ezz0CbpvnD31LnWJbbEwRVp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHemctS5EaXdPEhcmLN5DFvyTl2ZM+W4C7NtFi9k8WT9QyTQQxA7zUaMQyB/HXqHb
         ZaRdRtxOhXVo2JbF7QNoKZxuhgWakRM02NCTp5YhDYZmRBv+w7Njxe4r4Jko209fKL
         BzRC2x9rVhSnaRUhGpiIsJ5ULi43VlD6EXncboBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com
Subject: [PATCH 4.19 085/125] fbcon: prevent user font height or width change from causing potential out-of-bounds access
Date:   Tue,  1 Sep 2020 17:10:40 +0200
Message-Id: <20200901150938.740748818@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

commit 39b3cffb8cf3111738ea993e2757ab382253d86a upstream.

Add a check to fbcon_resize() to ensure that a possible change to user font
height or user font width will not allow a font data out-of-bounds access.
NOTE: must use original charcount in calculation as font charcount can
change and cannot be used to determine the font data allocated size.

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/1596213192-6635-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/fbcon.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2152,6 +2152,9 @@ static void updatescrollmode(struct disp
 	}
 }
 
+#define PITCH(w) (((w) + 7) >> 3)
+#define CALC_FONTSZ(h, p, c) ((h) * (p) * (c)) /* size = height * pitch * charcount */
+
 static int fbcon_resize(struct vc_data *vc, unsigned int width, 
 			unsigned int height, unsigned int user)
 {
@@ -2161,6 +2164,24 @@ static int fbcon_resize(struct vc_data *
 	struct fb_var_screeninfo var = info->var;
 	int x_diff, y_diff, virt_w, virt_h, virt_fw, virt_fh;
 
+	if (ops->p && ops->p->userfont && FNTSIZE(vc->vc_font.data)) {
+		int size;
+		int pitch = PITCH(vc->vc_font.width);
+
+		/*
+		 * If user font, ensure that a possible change to user font
+		 * height or width will not allow a font data out-of-bounds access.
+		 * NOTE: must use original charcount in calculation as font
+		 * charcount can change and cannot be used to determine the
+		 * font data allocated size.
+		 */
+		if (pitch <= 0)
+			return -EINVAL;
+		size = CALC_FONTSZ(vc->vc_font.height, pitch, FNTCHARCNT(vc->vc_font.data));
+		if (size > FNTSIZE(vc->vc_font.data))
+			return -EINVAL;
+	}
+
 	virt_w = FBCON_SWAP(ops->rotate, width, height);
 	virt_h = FBCON_SWAP(ops->rotate, height, width);
 	virt_fw = FBCON_SWAP(ops->rotate, vc->vc_font.width,
@@ -2623,7 +2644,7 @@ static int fbcon_set_font(struct vc_data
 	int size;
 	int i, csum;
 	u8 *new_data, *data = font->data;
-	int pitch = (font->width+7) >> 3;
+	int pitch = PITCH(font->width);
 
 	/* Is there a reason why fbconsole couldn't handle any charcount >256?
 	 * If not this check should be changed to charcount < 256 */
@@ -2639,7 +2660,7 @@ static int fbcon_set_font(struct vc_data
 	if (fbcon_invalid_charcount(info, charcount))
 		return -EINVAL;
 
-	size = h * pitch * charcount;
+	size = CALC_FONTSZ(h, pitch, charcount);
 
 	new_data = kmalloc(FONT_EXTRA_WORDS * sizeof(int) + size, GFP_USER);
 


