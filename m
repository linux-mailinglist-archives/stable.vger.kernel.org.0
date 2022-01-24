Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3849A066
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351422AbiAXXGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841161AbiAXW5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:57:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2187BC03463E;
        Mon, 24 Jan 2022 13:12:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D75612E9;
        Mon, 24 Jan 2022 21:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAE1C340E5;
        Mon, 24 Jan 2022 21:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058757;
        bh=k1eXA3Vc/yXVD7aYepW49WbAwf5hJ+QkyGEAYVbM4mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niv0wF7ayJbkawU7oDMzjB23gJP9dJWfky0sLUavYJ13/EvzmNJEJSG27m0z+IRnk
         TYEHBbL3F0rkkCUWgXuskPV/qmEp77RKQVxR2dwHlhA8XDrQd9yzbLZNz5kfGzsjpt
         I17iPoYXJxP9WTTWlr+lCb4p5QZ34Won8irB7OuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Hofman <pavel.hofman@ivitera.com>,
        John Keeping <john@metanate.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0392/1039] usb: gadget: u_audio: fix calculations for small bInterval
Date:   Mon, 24 Jan 2022 19:36:21 +0100
Message-Id: <20220124184138.497253682@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit f2f69bf65df12176843ca11eab99949ba69e128b ]

If bInterval is 1, then p_interval is 8000 and p_interval_mil is 8E9,
which is too big for a 32-bit value.  While the storage is indeed
64-bit, this value is used as the divisor in do_div() which will
truncate it into a uint32_t leading to incorrect calculated values.

Switch back to keeping the base value in struct snd_uac_chip which fits
easily into an int, meaning that the division can be done in two steps
with the divisor fitting safely into a uint32_t on both steps.

Fixes: 6fec018a7e70 ("usb: gadget: u_audio.c: Adding Playback Pitch ctl for sync playback")
Tested-by: Pavel Hofman <pavel.hofman@ivitera.com>
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20220104183243.718258-1-john@metanate.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index c46400be54641..4fb05f9576a67 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -76,8 +76,8 @@ struct snd_uac_chip {
 	struct snd_pcm *pcm;
 
 	/* pre-calculated values for playback iso completion */
-	unsigned long long p_interval_mil;
 	unsigned long long p_residue_mil;
+	unsigned int p_interval;
 	unsigned int p_framesize;
 };
 
@@ -194,21 +194,24 @@ static void u_audio_iso_complete(struct usb_ep *ep, struct usb_request *req)
 		 * If there is a residue from this division, add it to the
 		 * residue accumulator.
 		 */
+		unsigned long long p_interval_mil = uac->p_interval * 1000000ULL;
+
 		pitched_rate_mil = (unsigned long long)
 				params->p_srate * prm->pitch;
 		div_result = pitched_rate_mil;
-		do_div(div_result, uac->p_interval_mil);
+		do_div(div_result, uac->p_interval);
+		do_div(div_result, 1000000);
 		frames = (unsigned int) div_result;
 
 		pr_debug("p_srate %d, pitch %d, interval_mil %llu, frames %d\n",
-				params->p_srate, prm->pitch, uac->p_interval_mil, frames);
+				params->p_srate, prm->pitch, p_interval_mil, frames);
 
 		p_pktsize = min_t(unsigned int,
 					uac->p_framesize * frames,
 					ep->maxpacket);
 
 		if (p_pktsize < ep->maxpacket) {
-			residue_frames_mil = pitched_rate_mil - frames * uac->p_interval_mil;
+			residue_frames_mil = pitched_rate_mil - frames * p_interval_mil;
 			p_pktsize_residue_mil = uac->p_framesize * residue_frames_mil;
 		} else
 			p_pktsize_residue_mil = 0;
@@ -222,11 +225,11 @@ static void u_audio_iso_complete(struct usb_ep *ep, struct usb_request *req)
 		 * size and decrease the accumulator.
 		 */
 		div_result = uac->p_residue_mil;
-		do_div(div_result, uac->p_interval_mil);
+		do_div(div_result, uac->p_interval);
+		do_div(div_result, 1000000);
 		if ((unsigned int) div_result >= uac->p_framesize) {
 			req->length += uac->p_framesize;
-			uac->p_residue_mil -= uac->p_framesize *
-					   uac->p_interval_mil;
+			uac->p_residue_mil -= uac->p_framesize * p_interval_mil;
 			pr_debug("increased req length to %d\n", req->length);
 		}
 		pr_debug("remains uac->p_residue_mil %llu\n", uac->p_residue_mil);
@@ -591,7 +594,7 @@ int u_audio_start_playback(struct g_audio *audio_dev)
 	unsigned int factor;
 	const struct usb_endpoint_descriptor *ep_desc;
 	int req_len, i;
-	unsigned int p_interval, p_pktsize;
+	unsigned int p_pktsize;
 
 	ep = audio_dev->in_ep;
 	prm = &uac->p_prm;
@@ -612,11 +615,10 @@ int u_audio_start_playback(struct g_audio *audio_dev)
 	/* pre-compute some values for iso_complete() */
 	uac->p_framesize = params->p_ssize *
 			    num_channels(params->p_chmask);
-	p_interval = factor / (1 << (ep_desc->bInterval - 1));
-	uac->p_interval_mil = (unsigned long long) p_interval * 1000000;
+	uac->p_interval = factor / (1 << (ep_desc->bInterval - 1));
 	p_pktsize = min_t(unsigned int,
 				uac->p_framesize *
-					(params->p_srate / p_interval),
+					(params->p_srate / uac->p_interval),
 				ep->maxpacket);
 
 	req_len = p_pktsize;
-- 
2.34.1



