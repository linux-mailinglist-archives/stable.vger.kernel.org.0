Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5244428BA07
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbgJLOFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730797AbgJLNfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B856221FC;
        Mon, 12 Oct 2020 13:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509716;
        bh=3hi9m9Cnj4WTgtPvSnSz+apK7xXQCPwDRaPgs7QdrGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZytaSl5JyUzuIfDR1pa2uemMlfA2m7XlyYCXRLPsyYvGACLI7pyL2aaTufPvWs/n
         mHPduohZ3iaYhdfKUAGQN9pwEkkf+UIOJOeUIRjne8PhnanuV4DmD6jj9j2u3/zeHl
         4vSJowi9EKEUPc0vh9boNtcOyghNnwgK9fg2Cd9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.9 24/54] Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts
Date:   Mon, 12 Oct 2020 15:26:46 +0200
Message-Id: <20201012132630.700226039@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 6735b4632def0640dbdf4eb9f99816aca18c4f16 upstream.

syzbot has reported an issue in the framebuffer layer, where a malicious
user may overflow our built-in font data buffers.

In order to perform a reliable range check, subsystems need to know
`FONTDATAMAX` for each built-in font. Unfortunately, our font descriptor,
`struct console_font` does not contain `FONTDATAMAX`, and is part of the
UAPI, making it infeasible to modify it.

For user-provided fonts, the framebuffer layer resolves this issue by
reserving four extra words at the beginning of data buffers. Later,
whenever a function needs to access them, it simply uses the following
macros:

Recently we have gathered all the above macros to <linux/font.h>. Let us
do the same thing for built-in fonts, prepend four extra words (including
`FONTDATAMAX`) to their data buffers, so that subsystems can use these
macros for all fonts, no matter built-in or user-provided.

This patch depends on patch "fbdev, newport_con: Move FONT_EXTRA_WORDS
macros into linux/font.h".

Cc: stable@vger.kernel.org
Link: https://syzkaller.appspot.com/bug?id=08b8be45afea11888776f897895aef9ad1c3ecfd
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/ef18af00c35fb3cc826048a5f70924ed6ddce95b.1600953813.git.yepeilin.cs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/font.h       |    5 +++++
 lib/fonts/font_10x18.c     |    9 ++++-----
 lib/fonts/font_6x10.c      |    9 +++++----
 lib/fonts/font_6x11.c      |    9 ++++-----
 lib/fonts/font_7x14.c      |    9 ++++-----
 lib/fonts/font_8x16.c      |    9 ++++-----
 lib/fonts/font_8x8.c       |    9 ++++-----
 lib/fonts/font_acorn_8x8.c |    9 ++++++---
 lib/fonts/font_mini_4x6.c  |    8 ++++----
 lib/fonts/font_pearl_8x8.c |    9 ++++-----
 lib/fonts/font_sun12x22.c  |    9 ++++-----
 lib/fonts/font_sun8x16.c   |    7 ++++---
 12 files changed, 52 insertions(+), 49 deletions(-)

--- a/include/linux/font.h
+++ b/include/linux/font.h
@@ -65,4 +65,9 @@ extern const struct font_desc *get_defau
 
 #define FONT_EXTRA_WORDS 4
 
+struct font_data {
+	unsigned int extra[FONT_EXTRA_WORDS];
+	const unsigned char data[];
+} __packed;
+
 #endif /* _VIDEO_FONT_H */
--- a/lib/fonts/font_10x18.c
+++ b/lib/fonts/font_10x18.c
@@ -7,8 +7,8 @@
 
 #define FONTDATAMAX 9216
 
-static const unsigned char fontdata_10x18[FONTDATAMAX] = {
-
+static struct font_data fontdata_10x18 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, 0x00, /* 0000000000 */
 	0x00, 0x00, /* 0000000000 */
@@ -5128,8 +5128,7 @@ static const unsigned char fontdata_10x1
 	0x00, 0x00, /* 0000000000 */
 	0x00, 0x00, /* 0000000000 */
 	0x00, 0x00, /* 0000000000 */
-
-};
+} };
 
 
 const struct font_desc font_10x18 = {
@@ -5137,7 +5136,7 @@ const struct font_desc font_10x18 = {
 	.name	= "10x18",
 	.width	= 10,
 	.height	= 18,
-	.data	= fontdata_10x18,
+	.data	= fontdata_10x18.data,
 #ifdef __sparc__
 	.pref	= 5,
 #else
--- a/lib/fonts/font_6x10.c
+++ b/lib/fonts/font_6x10.c
@@ -1,7 +1,9 @@
 #include <linux/font.h>
 
-static const unsigned char fontdata_6x10[] = {
+#define FONTDATAMAX 2560
 
+static struct font_data fontdata_6x10 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
@@ -3073,14 +3075,13 @@ static const unsigned char fontdata_6x10
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
-
-};
+} };
 
 const struct font_desc font_6x10 = {
 	.idx	= FONT6x10_IDX,
 	.name	= "6x10",
 	.width	= 6,
 	.height	= 10,
-	.data	= fontdata_6x10,
+	.data	= fontdata_6x10.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_6x11.c
+++ b/lib/fonts/font_6x11.c
@@ -8,8 +8,8 @@
 
 #define FONTDATAMAX (11*256)
 
-static const unsigned char fontdata_6x11[FONTDATAMAX] = {
-
+static struct font_data fontdata_6x11 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
@@ -3337,8 +3337,7 @@ static const unsigned char fontdata_6x11
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
-
-};
+} };
 
 
 const struct font_desc font_vga_6x11 = {
@@ -3346,7 +3345,7 @@ const struct font_desc font_vga_6x11 = {
 	.name	= "ProFont6x11",
 	.width	= 6,
 	.height	= 11,
-	.data	= fontdata_6x11,
+	.data	= fontdata_6x11.data,
 	/* Try avoiding this font if possible unless on MAC */
 	.pref	= -2000,
 };
--- a/lib/fonts/font_7x14.c
+++ b/lib/fonts/font_7x14.c
@@ -7,8 +7,8 @@
 
 #define FONTDATAMAX 3584
 
-static const unsigned char fontdata_7x14[FONTDATAMAX] = {
-
+static struct font_data fontdata_7x14 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 0000000 */
 	0x00, /* 0000000 */
@@ -4104,8 +4104,7 @@ static const unsigned char fontdata_7x14
 	0x00, /* 0000000 */
 	0x00, /* 0000000 */
 	0x00, /* 0000000 */
-
-};
+} };
 
 
 const struct font_desc font_7x14 = {
@@ -4113,6 +4112,6 @@ const struct font_desc font_7x14 = {
 	.name	= "7x14",
 	.width	= 7,
 	.height	= 14,
-	.data	= fontdata_7x14,
+	.data	= fontdata_7x14.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_8x16.c
+++ b/lib/fonts/font_8x16.c
@@ -9,8 +9,8 @@
 
 #define FONTDATAMAX 4096
 
-static const unsigned char fontdata_8x16[FONTDATAMAX] = {
-
+static struct font_data fontdata_8x16 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
@@ -4618,8 +4618,7 @@ static const unsigned char fontdata_8x16
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
-
-};
+} };
 
 
 const struct font_desc font_vga_8x16 = {
@@ -4627,7 +4626,7 @@ const struct font_desc font_vga_8x16 = {
 	.name	= "VGA8x16",
 	.width	= 8,
 	.height	= 16,
-	.data	= fontdata_8x16,
+	.data	= fontdata_8x16.data,
 	.pref	= 0,
 };
 EXPORT_SYMBOL(font_vga_8x16);
--- a/lib/fonts/font_8x8.c
+++ b/lib/fonts/font_8x8.c
@@ -8,8 +8,8 @@
 
 #define FONTDATAMAX 2048
 
-static const unsigned char fontdata_8x8[FONTDATAMAX] = {
-
+static struct font_data fontdata_8x8 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
@@ -2569,8 +2569,7 @@ static const unsigned char fontdata_8x8[
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
 	0x00, /* 00000000 */
-
-};
+} };
 
 
 const struct font_desc font_vga_8x8 = {
@@ -2578,6 +2577,6 @@ const struct font_desc font_vga_8x8 = {
 	.name	= "VGA8x8",
 	.width	= 8,
 	.height	= 8,
-	.data	= fontdata_8x8,
+	.data	= fontdata_8x8.data,
 	.pref	= 0,
 };
--- a/lib/fonts/font_acorn_8x8.c
+++ b/lib/fonts/font_acorn_8x8.c
@@ -2,7 +2,10 @@
 
 #include <linux/font.h>
 
-static const unsigned char acorndata_8x8[] = {
+#define FONTDATAMAX 2048
+
+static struct font_data acorndata_8x8 = {
+{ 0, 0, FONTDATAMAX, 0 }, {
 /* 00 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* ^@ */
 /* 01 */  0x7e, 0x81, 0xa5, 0x81, 0xbd, 0x99, 0x81, 0x7e, /* ^A */
 /* 02 */  0x7e, 0xff, 0xbd, 0xff, 0xc3, 0xe7, 0xff, 0x7e, /* ^B */
@@ -259,14 +262,14 @@ static const unsigned char acorndata_8x8
 /* FD */  0x38, 0x04, 0x18, 0x20, 0x3c, 0x00, 0x00, 0x00,
 /* FE */  0x00, 0x00, 0x3c, 0x3c, 0x3c, 0x3c, 0x00, 0x00,
 /* FF */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
-};
+} };
 
 const struct font_desc font_acorn_8x8 = {
 	.idx	= ACORN8x8_IDX,
 	.name	= "Acorn8x8",
 	.width	= 8,
 	.height	= 8,
-	.data	= acorndata_8x8,
+	.data	= acorndata_8x8.data,
 #ifdef CONFIG_ARCH_ACORN
 	.pref	= 20,
 #else
--- a/lib/fonts/font_mini_4x6.c
+++ b/lib/fonts/font_mini_4x6.c
@@ -43,8 +43,8 @@ __END__;
 
 #define FONTDATAMAX 1536
 
-static const unsigned char fontdata_mini_4x6[FONTDATAMAX] = {
-
+static struct font_data fontdata_mini_4x6 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/*{*/
 	  	/*   Char 0: ' '  */
 	0xee,	/*=  [*** ]       */
@@ -2145,14 +2145,14 @@ static const unsigned char fontdata_mini
 	0xee,	/*=   [*** ]        */
 	0x00,	/*=   [    ]        */
 	/*}*/
-};
+} };
 
 const struct font_desc font_mini_4x6 = {
 	.idx	= MINI4x6_IDX,
 	.name	= "MINI4x6",
 	.width	= 4,
 	.height	= 6,
-	.data	= fontdata_mini_4x6,
+	.data	= fontdata_mini_4x6.data,
 	.pref	= 3,
 };
 
--- a/lib/fonts/font_pearl_8x8.c
+++ b/lib/fonts/font_pearl_8x8.c
@@ -13,8 +13,8 @@
 
 #define FONTDATAMAX 2048
 
-static const unsigned char fontdata_pearl8x8[FONTDATAMAX] = {
-
+static struct font_data fontdata_pearl8x8 = {
+   { 0, 0, FONTDATAMAX, 0 }, {
    /* 0 0x00 '^@' */
    0x00, /* 00000000 */
    0x00, /* 00000000 */
@@ -2574,14 +2574,13 @@ static const unsigned char fontdata_pear
    0x00, /* 00000000 */
    0x00, /* 00000000 */
    0x00, /* 00000000 */
-
-};
+} };
 
 const struct font_desc font_pearl_8x8 = {
 	.idx	= PEARL8x8_IDX,
 	.name	= "PEARL8x8",
 	.width	= 8,
 	.height	= 8,
-	.data	= fontdata_pearl8x8,
+	.data	= fontdata_pearl8x8.data,
 	.pref	= 2,
 };
--- a/lib/fonts/font_sun12x22.c
+++ b/lib/fonts/font_sun12x22.c
@@ -2,8 +2,8 @@
 
 #define FONTDATAMAX 11264
 
-static const unsigned char fontdata_sun12x22[FONTDATAMAX] = {
-
+static struct font_data fontdata_sun12x22 = {
+	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, 0x00, /* 000000000000 */
 	0x00, 0x00, /* 000000000000 */
@@ -6147,8 +6147,7 @@ static const unsigned char fontdata_sun1
 	0x00, 0x00, /* 000000000000 */
 	0x00, 0x00, /* 000000000000 */
 	0x00, 0x00, /* 000000000000 */
-
-};
+} };
 
 
 const struct font_desc font_sun_12x22 = {
@@ -6156,7 +6155,7 @@ const struct font_desc font_sun_12x22 =
 	.name	= "SUN12x22",
 	.width	= 12,
 	.height	= 22,
-	.data	= fontdata_sun12x22,
+	.data	= fontdata_sun12x22.data,
 #ifdef __sparc__
 	.pref	= 5,
 #else
--- a/lib/fonts/font_sun8x16.c
+++ b/lib/fonts/font_sun8x16.c
@@ -2,7 +2,8 @@
 
 #define FONTDATAMAX 4096
 
-static const unsigned char fontdata_sun8x16[FONTDATAMAX] = {
+static struct font_data fontdata_sun8x16 = {
+{ 0, 0, FONTDATAMAX, 0 }, {
 /* */ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
 /* */ 0x00,0x00,0x7e,0x81,0xa5,0x81,0x81,0xbd,0x99,0x81,0x81,0x7e,0x00,0x00,0x00,0x00,
 /* */ 0x00,0x00,0x7e,0xff,0xdb,0xff,0xff,0xc3,0xe7,0xff,0xff,0x7e,0x00,0x00,0x00,0x00,
@@ -259,14 +260,14 @@ static const unsigned char fontdata_sun8
 /* */ 0x00,0x70,0xd8,0x30,0x60,0xc8,0xf8,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
 /* */ 0x00,0x00,0x00,0x00,0x7c,0x7c,0x7c,0x7c,0x7c,0x7c,0x7c,0x00,0x00,0x00,0x00,0x00,
 /* */ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-};
+} };
 
 const struct font_desc font_sun_8x16 = {
 	.idx	= SUN8x16_IDX,
 	.name	= "SUN8x16",
 	.width	= 8,
 	.height	= 16,
-	.data	= fontdata_sun8x16,
+	.data	= fontdata_sun8x16.data,
 #ifdef __sparc__
 	.pref	= 10,
 #else


