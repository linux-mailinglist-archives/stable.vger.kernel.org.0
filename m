Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05E1330E33
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhCHMfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhCHMfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 177B8651D3;
        Mon,  8 Mar 2021 12:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206939;
        bh=yl3uYpl4eWGqwx0bnPQoz3bT/GGz1VJD3FwHdyGja2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCSoO2mNZR+a/3/HE0/4RBHJVuwMuuAqjBQf0u+kNcZyB6RQN5kNPplVEtywo5rjN
         CSM4pTLhXW0whIEBLMs+N3CNMwpl++hHBGgeFyjB8yrPc4uCgrBdodtpL8/cXG+O5O
         CnQEQkzHFBnFjpGvf1xZRxIp3zGSY3ZYLX/X/j7U=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 05/44] ALSA: usb-audio: Allow modifying parameters with succeeding hw_params calls
Date:   Mon,  8 Mar 2021 13:34:43 +0100
Message-Id: <20210308122718.855464297@linuxfoundation.org>
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

commit 5f5e6a3e8b1df52f79122e447855cffbf1710540 upstream.

The recent fix for the hw constraints for implicit feedback streams
via commit e4ea77f8e53f ("ALSA: usb-audio: Always apply the hw
constraints for implicit fb sync") added the check of the matching
endpoints and whether those EPs are already opened.  This is needed
and correct, per se, even for the normal streams without the implicit
feedback, as the endpoint setup is exclusive.

However, it's reported that there seem applications that behave in
unexpected ways to update the hw_params without clearing the previous
setup via hw_free, and those hit a problem now: then hw_params is
called with still the previous EP setup kept, hence it's restricted
with the previous own setup.  Although the obvious fix is to call
snd_pcm_hw_free() API in the application side, it's a kind of
unwelcome change.

This patch tries to ease the situation: in the endpoint check, we add
a couple of more conditions and now skip the endpoint that is being
used only by the stream in question itself.  That is, in addition to
the presence check of ep (ep->cur_audiofmt is non-NULL), when the
following conditions are met, we skip such an ep:
- ep->opened == 1, and
- ep->cur_audiofmt == subs->cur_audiofmt.

subs->cur_audiofmt is non-NULL only if it's a re-setup of hw_params,
and ep->cur_audiofmt points to the currently set up parameters.  So if
those match, it must be this stream itself.

Fixes: e4ea77f8e53f ("ALSA: usb-audio: Always apply the hw constraints for implicit fb sync")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211941
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210228080138.9936-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -845,13 +845,19 @@ get_sync_ep_from_substream(struct snd_us
 
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		ep = snd_usb_get_endpoint(chip, fp->endpoint);
-		if (ep && ep->cur_rate)
-			return ep;
+		if (ep && ep->cur_audiofmt) {
+			/* if EP is already opened solely for this substream,
+			 * we still allow us to change the parameter; otherwise
+			 * this substream has to follow the existing parameter
+			 */
+			if (ep->cur_audiofmt != subs->cur_audiofmt || ep->opened > 1)
+				return ep;
+		}
 		if (!fp->implicit_fb)
 			continue;
 		/* for the implicit fb, check the sync ep as well */
 		ep = snd_usb_get_endpoint(chip, fp->sync_ep);
-		if (ep && ep->cur_rate)
+		if (ep && ep->cur_audiofmt)
 			return ep;
 	}
 	return NULL;


