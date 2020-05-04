Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645F91C44C3
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgEDSFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731874AbgEDSFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B8162073B;
        Mon,  4 May 2020 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615550;
        bh=SsXvhzbB2jWYNJpRGiFkqDvIr0NI17B/xvS9oHi+tsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAJ8NtWU4zA6E0vC75PooTJliRkCG0LnG6iv4CkxvSZBzgsTkeoy+q5EDpOrDBgEK
         REFqM2wMGB6eKoJoIORpH3qsrXFo35RZWsdYuyV9yJy/E0T9on+sw38K/9qXr7GUMR
         cBpOIP8sVpjcjwPRGnTlb99LX8almsb+4e3p0UIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 26/73] ALSA: line6: Fix POD HD500 audio playback
Date:   Mon,  4 May 2020 19:57:29 +0200
Message-Id: <20200504165507.022626692@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

commit cc18b2f4f3f1d7ed3125ac1840794f9feab0325c upstream.

Apparently interface 1 is control interface akin to HD500X,
setting LINE6_CAP_CONTROL and choosing it as ctrl_if fixes
audio playback on POD HD500.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200425201115.3430-1-anarsoul@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/podhd.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -21,8 +21,7 @@
 enum {
 	LINE6_PODHD300,
 	LINE6_PODHD400,
-	LINE6_PODHD500_0,
-	LINE6_PODHD500_1,
+	LINE6_PODHD500,
 	LINE6_PODX3,
 	LINE6_PODX3LIVE,
 	LINE6_PODHD500X,
@@ -318,8 +317,7 @@ static const struct usb_device_id podhd_
 	/* TODO: no need to alloc data interfaces when only audio is used */
 	{ LINE6_DEVICE(0x5057),    .driver_info = LINE6_PODHD300 },
 	{ LINE6_DEVICE(0x5058),    .driver_info = LINE6_PODHD400 },
-	{ LINE6_IF_NUM(0x414D, 0), .driver_info = LINE6_PODHD500_0 },
-	{ LINE6_IF_NUM(0x414D, 1), .driver_info = LINE6_PODHD500_1 },
+	{ LINE6_IF_NUM(0x414D, 0), .driver_info = LINE6_PODHD500 },
 	{ LINE6_IF_NUM(0x414A, 0), .driver_info = LINE6_PODX3 },
 	{ LINE6_IF_NUM(0x414B, 0), .driver_info = LINE6_PODX3LIVE },
 	{ LINE6_IF_NUM(0x4159, 0), .driver_info = LINE6_PODHD500X },
@@ -352,23 +350,13 @@ static const struct line6_properties pod
 		.ep_audio_r = 0x82,
 		.ep_audio_w = 0x01,
 	},
-	[LINE6_PODHD500_0] = {
+	[LINE6_PODHD500] = {
 		.id = "PODHD500",
 		.name = "POD HD500",
-		.capabilities	= LINE6_CAP_PCM
+		.capabilities	= LINE6_CAP_PCM | LINE6_CAP_CONTROL
 				| LINE6_CAP_HWMON,
 		.altsetting = 1,
-		.ep_ctrl_r = 0x81,
-		.ep_ctrl_w = 0x01,
-		.ep_audio_r = 0x86,
-		.ep_audio_w = 0x02,
-	},
-	[LINE6_PODHD500_1] = {
-		.id = "PODHD500",
-		.name = "POD HD500",
-		.capabilities	= LINE6_CAP_PCM
-				| LINE6_CAP_HWMON,
-		.altsetting = 0,
+		.ctrl_if = 1,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
 		.ep_audio_r = 0x86,


