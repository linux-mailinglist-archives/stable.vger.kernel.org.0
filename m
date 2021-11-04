Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7923A44521F
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 12:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhKDLZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 07:25:59 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42170 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhKDLZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 07:25:58 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B66C9218D5;
        Thu,  4 Nov 2021 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636024999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGcDwxcHZ6yQzaHKGpzVjXWKCYv1lwlcl1SeEbfptKk=;
        b=e46N58s7jtPgQ2XIcSNKY8WrNYRNp2/tVsrxtaJ5Tpm66qeYMEA7hf111yUOjRhZhPsV++
        S9ZHj9RzmkBZ+c2/AX+RRt6ofQJ7mAwTkVD42WruRdTeXly1hZulNK09PI5ikO66VCS6gz
        6OgrlW7dBkXBYKC10X+A3XcLd5xYuN4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636024999;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGcDwxcHZ6yQzaHKGpzVjXWKCYv1lwlcl1SeEbfptKk=;
        b=iTrcKe/kDuWt536xoYI6f0yBb3mohMwyFY/Kieu0CIb4jIADbfhBGpGPujHi7kisYdXLO8
        /3kM9HaECRk2jSBg==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id A4AAD2C154;
        Thu,  4 Nov 2021 11:23:19 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.14.y 2/2] ALSA: usb-audio: Add Audient iD14 to mixer map quirk table
Date:   Thu,  4 Nov 2021 12:23:09 +0100
Message-Id: <20211104112309.30984-3-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211104112309.30984-1-tiwai@suse.de>
References: <20211104112309.30984-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit df0380b9539b04c1ae8854a984098da06d5f1e67 upstream.

This is a fix equivalent with the upstream commit df0380b9539b ("ALSA:
usb-audio: Add quirk for Audient iD14"), adapted to the earlier
kernels up to 5.14.y.  It adds the quirk entry with the old
ignore_ctl_error flag to the usbmix_ctl_maps, instead.

The original commit description says:
    Audient iD14 (2708:0002) may get a control message error that
    interferes the operation e.g. with alsactl.  Add the quirk to ignore
    such errors like other devices.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/usb/mixer_maps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 809ac6d18d2b..8f6823df944f 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -528,6 +528,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x2573, 0x0008),
 		.map = maya44_map,
 	},
+	{
+		.id = USB_ID(0x2708, 0x0002), /* Audient iD14 */
+		.ignore_ctl_error = 1,
+	},
 	{
 		/* KEF X300A */
 		.id = USB_ID(0x27ac, 0x1000),
-- 
2.31.1

