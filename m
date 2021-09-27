Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4171A419B74
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbhI0RTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236747AbhI0RRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 440EE611C2;
        Mon, 27 Sep 2021 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762706;
        bh=OBKzlLp2AMiJkC09jKb5ImBnds8wvxcoJV1WgITTGsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQNy8QiozOdc71qBI4rnkMByZuZDqrNQDXXP7PSifh6A+FBMOAsDmWgTBQaJjvz/5
         wtqlCp+QElZths8vcKqnqvayleJmUaz9sujlnMgBRpYJom/XYYc3rQJk/Wef9Sdx2U
         fIgMs8a1XLqebe+Hc+VrEXDBkgQy0QaTf1bTLbbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henrik Enquist <henrik.enquist@gmail.com>,
        Pavel Hofman <pavel.hofman@ivitera.com>
Subject: [PATCH 5.14 006/162] usb: gadget: u_audio: EP-OUT bInterval in fback frequency
Date:   Mon, 27 Sep 2021 19:00:52 +0200
Message-Id: <20210927170233.679153722@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit f5dfd98a80ff8d50cf4ae2820857d7f5a46cbab9 upstream.

The patch increases the bitshift in feedback frequency
calculation with EP-OUT bInterval value.

Tests have revealed that Win10 and OSX UAC2 drivers require
the feedback frequency to be based on the actual packet
interval instead of on the USB2 microframe. Otherwise they
ignore the feedback value. Linux snd-usb-audio driver
detects the applied bitshift automatically.

Tested-by: Henrik Enquist <henrik.enquist@gmail.com>
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210906130822.12256-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_audio.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -76,11 +76,13 @@ static const struct snd_pcm_hardware uac
 };
 
 static void u_audio_set_fback_frequency(enum usb_device_speed speed,
+					struct usb_ep *out_ep,
 					unsigned long long freq,
 					unsigned int pitch,
 					void *buf)
 {
 	u32 ff = 0;
+	const struct usb_endpoint_descriptor *ep_desc;
 
 	/*
 	 * Because the pitch base is 1000000, the final divider here
@@ -108,8 +110,13 @@ static void u_audio_set_fback_frequency(
 		 * byte fromat (that is Q16.16)
 		 *
 		 * ff = (freq << 16) / 8000
+		 *
+		 * Win10 and OSX UAC2 drivers require number of samples per packet
+		 * in order to honor the feedback value.
+		 * Linux snd-usb-audio detects the applied bit-shift automatically.
 		 */
-		freq <<= 4;
+		ep_desc = out_ep->desc;
+		freq <<= 4 + (ep_desc->bInterval - 1);
 	}
 
 	ff = DIV_ROUND_CLOSEST_ULL((freq * pitch), 1953125);
@@ -247,7 +254,7 @@ static void u_audio_iso_fback_complete(s
 		pr_debug("%s: iso_complete status(%d) %d/%d\n",
 			__func__, status, req->actual, req->length);
 
-	u_audio_set_fback_frequency(audio_dev->gadget->speed,
+	u_audio_set_fback_frequency(audio_dev->gadget->speed, audio_dev->out_ep,
 				    params->c_srate, prm->pitch,
 				    req->buf);
 
@@ -506,7 +513,7 @@ int u_audio_start_capture(struct g_audio
 	 * be meauserd at start of playback
 	 */
 	prm->pitch = 1000000;
-	u_audio_set_fback_frequency(audio_dev->gadget->speed,
+	u_audio_set_fback_frequency(audio_dev->gadget->speed, ep,
 				    params->c_srate, prm->pitch,
 				    req_fback->buf);
 


