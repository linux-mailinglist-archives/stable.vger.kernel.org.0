Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BDC330E32
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhCHMfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhCHMfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 921C6651DC;
        Mon,  8 Mar 2021 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206937;
        bh=rAMjjK9s+a59lqPXO59oO/s8fAJOPiviYCrBl1784o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlifchyX1/6+raEOlohjGgDvHoDGbzmp08FY6LsOVrJEVtbZqqhJdraQgSBV9HnEr
         p33O/m+hV0wiL/DaQKmMsrxgtvQTs455xgtY0wg1y292MH30evZ5D6C6j3Mz6/XdLl
         gdkyvVY9N2O0+F5jeclcIQK7PsTcdGBI4ZZTs3XQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 04/44] ALSA: usb-audio: Drop bogus dB range in too low level
Date:   Mon,  8 Mar 2021 13:34:42 +0100
Message-Id: <20210308122718.807791412@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit 21cba9c5359dd9d1bffe355336cfec0b66d1ee52 upstream.

Some USB audio firmware seem to report broken dB values for the volume
controls, and this screws up applications like PulseAudio who blindly
trusts the given data.  For example, Edifier G2000 reports a PCM
volume from -128dB to -127dB, and this results in barely inaudible
sound.

This patch adds a sort of sanity check at parsing the dB values in
USB-audio driver and disables the dB reporting if the range looks
bogus.  Here, we assume -96dB as the bottom line of the max dB.

Note that, if one can figure out that proper dB range later, it can be
patched in the mixer maps.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211929
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210227105737.3656-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1301,6 +1301,17 @@ no_res_check:
 			/* totally crap, return an error */
 			return -EINVAL;
 		}
+	} else {
+		/* if the max volume is too low, it's likely a bogus range;
+		 * here we use -96dB as the threshold
+		 */
+		if (cval->dBmax <= -9600) {
+			usb_audio_info(cval->head.mixer->chip,
+				       "%d:%d: bogus dB values (%d/%d), disabling dB reporting\n",
+				       cval->head.id, mixer_ctrl_intf(cval->head.mixer),
+				       cval->dBmin, cval->dBmax);
+			cval->dBmin = cval->dBmax = 0;
+		}
 	}
 
 	return 0;


