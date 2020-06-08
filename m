Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC31E1F2E6F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgFIAlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgFHXMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 404C820E65;
        Mon,  8 Jun 2020 23:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657960;
        bh=y1k0L0u63nACylLO42kH0crZJWdOhL+v+GEltLADNhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ0DBiXZ7nu0u4b+MvLMjdBGfkCZ69oRW8nmQ+rXWUu5IS3pWWTsmX0nj2nXNx8zs
         ehDUV7nwnlXHzWU/Ub5G3nRQibD5NosH/Fkjk8NVwCxoopmizuCMwadQ+QsRX2Jcm1
         ZGXKZQlySK6K1JRr+mVaHyy43pSQD/9rrE9iZkd0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesus Ramos <jesus-ramos@live.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 025/606] ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset
Date:   Mon,  8 Jun 2020 19:02:30 -0400
Message-Id: <20200608231211.3363633-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesus Ramos <jesus-ramos@live.com>

commit 073919e09ca445d4486968e3f851372ff44cf2b5 upstream.

Kingston HyperX headset with 0951:16ad also needs the same quirk for
delaying the frequency controls.

Signed-off-by: Jesus Ramos <jesus-ramos@live.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/BY5PR19MB3634BA68C7CCA23D8DF428E796AF0@BY5PR19MB3634.namprd19.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 0686e056e39b..732580bdc6a4 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1592,13 +1592,14 @@ void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 
-	/* Zoom R16/24, Logitech H650e, Jabra 550a needs a tiny delay here,
-	 * otherwise requests like get/set frequency return as failed despite
-	 * actually succeeding.
+	/* Zoom R16/24, Logitech H650e, Jabra 550a, Kingston HyperX needs a tiny
+	 * delay here, otherwise requests like get/set frequency return as
+	 * failed despite actually succeeding.
 	 */
 	if ((chip->usb_id == USB_ID(0x1686, 0x00dd) ||
 	     chip->usb_id == USB_ID(0x046d, 0x0a46) ||
-	     chip->usb_id == USB_ID(0x0b0e, 0x0349)) &&
+	     chip->usb_id == USB_ID(0x0b0e, 0x0349) ||
+	     chip->usb_id == USB_ID(0x0951, 0x16ad)) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		usleep_range(1000, 2000);
 }
-- 
2.25.1

