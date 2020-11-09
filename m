Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E172ABD51
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbgKINpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbgKIM6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:58:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41CA2084C;
        Mon,  9 Nov 2020 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926722;
        bh=JM8xHKIfsxaqL7UNLhAks+xIK/g6aUSoPpDjthCpzl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnuGE8MvL5iLUXwg5n9FIKvqdkuiJAVL/Nuauq2t4ElMXDtA4qstcetxZpBGl/8Lo
         5BHbmCtz4CJ0e7BMoiX8hgRzVgAxCNOVP7bq1bHiRd1ZN+fkbpHtKue7adACBEt7gd
         QXcnSRBnJ6WBCWxzPLaiV1J1tvBY+pZK3mAhOEUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Lee Jones <lee.jones@linaro.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.4 68/86] Fonts: Replace discarded const qualifier
Date:   Mon,  9 Nov 2020 13:55:15 +0100
Message-Id: <20201109125024.045611061@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

commit 9522750c66c689b739e151fcdf895420dc81efc0 upstream.

Commit 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in
fonts") introduced the following error when building rpc_defconfig (only
this build appears to be affected):

 `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
    defined in discarded section `.data' of arch/arm/boot/compressed/font.o
 `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
    defined in discarded section `.data' of arch/arm/boot/compressed/font.o
 make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
 make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
 make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2

The .data section is discarded at link time.  Reinstating acorndata_8x8 as
const ensures it is still available after linking.  Do the same for the
other 12 built-in fonts as well, for consistency purposes.

Cc: <stable@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Co-developed-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20201102183242.2031659-1-yepeilin.cs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/fonts/font_10x18.c     |    2 +-
 lib/fonts/font_6x10.c      |    2 +-
 lib/fonts/font_6x11.c      |    2 +-
 lib/fonts/font_7x14.c      |    2 +-
 lib/fonts/font_8x16.c      |    2 +-
 lib/fonts/font_8x8.c       |    2 +-
 lib/fonts/font_acorn_8x8.c |    2 +-
 lib/fonts/font_mini_4x6.c  |    2 +-
 lib/fonts/font_pearl_8x8.c |    2 +-
 lib/fonts/font_sun12x22.c  |    2 +-
 lib/fonts/font_sun8x16.c   |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

--- a/lib/fonts/font_10x18.c
+++ b/lib/fonts/font_10x18.c
@@ -7,7 +7,7 @@
 
 #define FONTDATAMAX 9216
 
-static struct font_data fontdata_10x18 = {
+static const struct font_data fontdata_10x18 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, 0x00, /* 0000000000 */
--- a/lib/fonts/font_6x10.c
+++ b/lib/fonts/font_6x10.c
@@ -2,7 +2,7 @@
 
 #define FONTDATAMAX 2560
 
-static struct font_data fontdata_6x10 = {
+static const struct font_data fontdata_6x10 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
--- a/lib/fonts/font_6x11.c
+++ b/lib/fonts/font_6x11.c
@@ -8,7 +8,7 @@
 
 #define FONTDATAMAX (11*256)
 
-static struct font_data fontdata_6x11 = {
+static const struct font_data fontdata_6x11 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
--- a/lib/fonts/font_7x14.c
+++ b/lib/fonts/font_7x14.c
@@ -7,7 +7,7 @@
 
 #define FONTDATAMAX 3584
 
-static struct font_data fontdata_7x14 = {
+static const struct font_data fontdata_7x14 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 0000000 */
--- a/lib/fonts/font_8x16.c
+++ b/lib/fonts/font_8x16.c
@@ -9,7 +9,7 @@
 
 #define FONTDATAMAX 4096
 
-static struct font_data fontdata_8x16 = {
+static const struct font_data fontdata_8x16 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
--- a/lib/fonts/font_8x8.c
+++ b/lib/fonts/font_8x8.c
@@ -8,7 +8,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data fontdata_8x8 = {
+static const struct font_data fontdata_8x8 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
--- a/lib/fonts/font_acorn_8x8.c
+++ b/lib/fonts/font_acorn_8x8.c
@@ -4,7 +4,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data acorndata_8x8 = {
+static const struct font_data acorndata_8x8 = {
 { 0, 0, FONTDATAMAX, 0 }, {
 /* 00 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* ^@ */
 /* 01 */  0x7e, 0x81, 0xa5, 0x81, 0xbd, 0x99, 0x81, 0x7e, /* ^A */
--- a/lib/fonts/font_mini_4x6.c
+++ b/lib/fonts/font_mini_4x6.c
@@ -43,7 +43,7 @@ __END__;
 
 #define FONTDATAMAX 1536
 
-static struct font_data fontdata_mini_4x6 = {
+static const struct font_data fontdata_mini_4x6 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/*{*/
 	  	/*   Char 0: ' '  */
--- a/lib/fonts/font_pearl_8x8.c
+++ b/lib/fonts/font_pearl_8x8.c
@@ -13,7 +13,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data fontdata_pearl8x8 = {
+static const struct font_data fontdata_pearl8x8 = {
    { 0, 0, FONTDATAMAX, 0 }, {
    /* 0 0x00 '^@' */
    0x00, /* 00000000 */
--- a/lib/fonts/font_sun12x22.c
+++ b/lib/fonts/font_sun12x22.c
@@ -2,7 +2,7 @@
 
 #define FONTDATAMAX 11264
 
-static struct font_data fontdata_sun12x22 = {
+static const struct font_data fontdata_sun12x22 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, 0x00, /* 000000000000 */
--- a/lib/fonts/font_sun8x16.c
+++ b/lib/fonts/font_sun8x16.c
@@ -2,7 +2,7 @@
 
 #define FONTDATAMAX 4096
 
-static struct font_data fontdata_sun8x16 = {
+static const struct font_data fontdata_sun8x16 = {
 { 0, 0, FONTDATAMAX, 0 }, {
 /* */ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
 /* */ 0x00,0x00,0x7e,0x81,0xa5,0x81,0x81,0xbd,0x99,0x81,0x81,0x7e,0x00,0x00,0x00,0x00,


