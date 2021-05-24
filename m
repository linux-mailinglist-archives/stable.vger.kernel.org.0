Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25C038EFD1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhEXP7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235644AbhEXP7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B2066196A;
        Mon, 24 May 2021 15:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871087;
        bh=MTf65CjRn4pimJ0YQqAOZWp680x6htRBMF1uX8Kmrns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpmdIvtR/zYTcj5R/8YmFLAt1lT3ln9z0QpotLsz/RbwQjRB9KjXjd9BNR+2t/TO3
         WzwhDINnCEJ7f7aejXLnSUbB82yOC0mPgY5fDXzKybUtXa9PIKwdV+ZORLrSfH6LD5
         2H9jND5oEtpTLA3ZPik2qHHK0b9k+URAXCc6cWHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 045/127] ALSA: line6: Fix racy initialization of LINE6 MIDI
Date:   Mon, 24 May 2021 17:26:02 +0200
Message-Id: <20210524152336.367951866@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 05ca447630334c323c9e2b788b61133ab75d60d3 upstream.

The initialization of MIDI devices that are found on some LINE6
drivers are currently done in a racy way; namely, the MIDI buffer
instance is allocated and initialized in each private_init callback
while the communication with the interface is already started via
line6_init_cap_control() call before that point.  This may lead to
Oops in line6_data_received() when a spurious event is received, as
reported by syzkaller.

This patch moves the MIDI initialization to line6_init_cap_control()
as well instead of the too-lately-called private_init for avoiding the
race.  Also this reduces slightly more lines, so it's a win-win
change.

Reported-by: syzbot+0d2b3feb0a2887862e06@syzkallerlkml..appspotmail.com
Link: https://lore.kernel.org/r/000000000000a4be9405c28520de@google.com
Link: https://lore.kernel.org/r/20210517132725.GA50495@hyeyoo
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210518083939.1927-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/driver.c |    4 ++++
 sound/usb/line6/pod.c    |    5 -----
 sound/usb/line6/variax.c |    6 ------
 3 files changed, 4 insertions(+), 11 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -699,6 +699,10 @@ static int line6_init_cap_control(struct
 		line6->buffer_message = kmalloc(LINE6_MIDI_MESSAGE_MAXLEN, GFP_KERNEL);
 		if (!line6->buffer_message)
 			return -ENOMEM;
+
+		ret = line6_init_midi(line6);
+		if (ret < 0)
+			return ret;
 	} else {
 		ret = line6_hwdep_init(line6);
 		if (ret < 0)
--- a/sound/usb/line6/pod.c
+++ b/sound/usb/line6/pod.c
@@ -376,11 +376,6 @@ static int pod_init(struct usb_line6 *li
 	if (err < 0)
 		return err;
 
-	/* initialize MIDI subsystem: */
-	err = line6_init_midi(line6);
-	if (err < 0)
-		return err;
-
 	/* initialize PCM subsystem: */
 	err = line6_init_pcm(line6, &pod_pcm_properties);
 	if (err < 0)
--- a/sound/usb/line6/variax.c
+++ b/sound/usb/line6/variax.c
@@ -159,7 +159,6 @@ static int variax_init(struct usb_line6
 		       const struct usb_device_id *id)
 {
 	struct usb_line6_variax *variax = line6_to_variax(line6);
-	int err;
 
 	line6->process_message = line6_variax_process_message;
 	line6->disconnect = line6_variax_disconnect;
@@ -172,11 +171,6 @@ static int variax_init(struct usb_line6
 	if (variax->buffer_activate == NULL)
 		return -ENOMEM;
 
-	/* initialize MIDI subsystem: */
-	err = line6_init_midi(&variax->line6);
-	if (err < 0)
-		return err;
-
 	/* initiate startup procedure: */
 	schedule_delayed_work(&line6->startup_work,
 			      msecs_to_jiffies(VARIAX_STARTUP_DELAY1));


