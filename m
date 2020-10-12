Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A906228B66A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388883AbgJLNda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgJLNdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:33:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 386832074F;
        Mon, 12 Oct 2020 13:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509593;
        bh=zL9izJMJB54pG1Dl+LvC5fpuv1reHJnvEC2ws5mv0Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxgYE0FOs/WsM4fdhxcV3HWsdDB6vRfqSMQfv0qtGZ+ioefiXR3RIS5N9kvH/pfBJ
         jVuhLY8F50/crCX5Up4z6ASlQPRURRdFdyXnOZn60npKSZfyDC57l2FloF5nVAkLre
         lCqlI1uriUnL3MX8uPqaEcJKdT3L7CT4ty+WkPzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        syzbot+29d4ed7f3bdedf2aa2fd@syzkaller.appspotmail.com
Subject: [PATCH 4.4 20/39] fbcon: Fix global-out-of-bounds read in fbcon_get_font()
Date:   Mon, 12 Oct 2020 15:26:50 +0200
Message-Id: <20201012132629.081507692@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 5af08640795b2b9a940c9266c0260455377ae262 upstream.

fbcon_get_font() is reading out-of-bounds. A malicious user may resize
`vc->vc_font.height` to a large value, causing fbcon_get_font() to
read out of `fontdata`.

fbcon_get_font() handles both built-in and user-provided fonts.
Fortunately, recently we have added FONT_EXTRA_WORDS support for built-in
fonts, so fix it by adding range checks using FNTSIZE().

This patch depends on patch "fbdev, newport_con: Move FONT_EXTRA_WORDS
macros into linux/font.h", and patch "Fonts: Support FONT_EXTRA_WORDS
macros for built-in fonts".

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+29d4ed7f3bdedf2aa2fd@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=08b8be45afea11888776f897895aef9ad1c3ecfd
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/b34544687a1a09d6de630659eb7a773f4953238b.1600953813.git.yepeilin.cs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/fbcon.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2234,6 +2234,9 @@ static int fbcon_get_font(struct vc_data
 
 	if (font->width <= 8) {
 		j = vc->vc_font.height;
+		if (font->charcount * j > FNTSIZE(fontdata))
+			return -EINVAL;
+
 		for (i = 0; i < font->charcount; i++) {
 			memcpy(data, fontdata, j);
 			memset(data + j, 0, 32 - j);
@@ -2242,6 +2245,9 @@ static int fbcon_get_font(struct vc_data
 		}
 	} else if (font->width <= 16) {
 		j = vc->vc_font.height * 2;
+		if (font->charcount * j > FNTSIZE(fontdata))
+			return -EINVAL;
+
 		for (i = 0; i < font->charcount; i++) {
 			memcpy(data, fontdata, j);
 			memset(data + j, 0, 64 - j);
@@ -2249,6 +2255,9 @@ static int fbcon_get_font(struct vc_data
 			fontdata += j;
 		}
 	} else if (font->width <= 24) {
+		if (font->charcount * (vc->vc_font.height * sizeof(u32)) > FNTSIZE(fontdata))
+			return -EINVAL;
+
 		for (i = 0; i < font->charcount; i++) {
 			for (j = 0; j < vc->vc_font.height; j++) {
 				*data++ = fontdata[0];
@@ -2261,6 +2270,9 @@ static int fbcon_get_font(struct vc_data
 		}
 	} else {
 		j = vc->vc_font.height * 4;
+		if (font->charcount * j > FNTSIZE(fontdata))
+			return -EINVAL;
+
 		for (i = 0; i < font->charcount; i++) {
 			memcpy(data, fontdata, j);
 			memset(data + j, 0, 128 - j);


