Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA04B330E30
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhCHMfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232143AbhCHMfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E7B0651D3;
        Mon,  8 Mar 2021 12:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206936;
        bh=oFugl7Ru4MWdaA3uSOidDZTn0Uot986GGIC28ki2N8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S43jlJ+yiGMh2Tsl1pROclb+T+JC8jO3gG2GqrsFftYnqmmXv1OHxt8VZnm80nvDl
         60G5LABbi2pc3YUcrAPJdwvT7zVEsVIHscbHiFGgHoY9rowJlTfKiU4kW6+2tvzZBs
         HssTdlpMPByCk+FypqC6Cy/aqe62V+T7JkEa6t+4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 03/44] ALSA: usb-audio: Dont abort even if the clock rate differs
Date:   Mon,  8 Mar 2021 13:34:41 +0100
Message-Id: <20210308122718.759312498@linuxfoundation.org>
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

commit dcf269b3f703f5dbc2101824d9dbe95feed87b3d upstream.

The commit 93db51d06b32 ("ALSA: usb-audio: Check valid altsetting at
parsing rates for UAC2/3") changed the behavior of the function
set_sample_rate_v2v3() slightly to treat the inconsistent sample rate
as an error.  It was done by assumption that the sample rate
validation should have been done at the parser phase as implemented in
that patch.  But the validation is later selectively enabled only for
certain devices as it causes a regression (the commit fe773b8711e3
"ALSA: usb-audio: workaround for iface reset issue"), and now the
inconsistency surfaced as a fatal error while it worked in the past as
is, as reported for FiiO M3K DAC.

For recovering from the regression, change set_sample_rate_v2v3()
again to ignore the sample rate difference as non-error.

BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1182633
Fixes: 93db51d06b32 ("ALSA: usb-audio: Check valid altsetting at parsing rates for UAC2/3")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210227082002.21185-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/clock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -646,10 +646,10 @@ static int set_sample_rate_v2v3(struct s
 		cur_rate = prev_rate;
 
 	if (cur_rate != rate) {
-		usb_audio_warn(chip,
-			       "%d:%d: freq mismatch (RO clock): req %d, clock runs @%d\n",
-			       fmt->iface, fmt->altsetting, rate, cur_rate);
-		return -ENXIO;
+		usb_audio_dbg(chip,
+			      "%d:%d: freq mismatch: req %d, clock runs @%d\n",
+			      fmt->iface, fmt->altsetting, rate, cur_rate);
+		/* continue processing */
 	}
 
 validation:


