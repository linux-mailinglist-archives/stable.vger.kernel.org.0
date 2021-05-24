Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991C238ED66
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhEXPg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232442AbhEXPe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6007C613D6;
        Mon, 24 May 2021 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870346;
        bh=joO3Ie+i6vmfuJPGjsekZplCcaCP4G08dYDWWb+cgMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwZGb3rnhPtIL39BPRBYHYDwgNEuQalCLt3QCeW1DDElgr8j2OBBrbY4l3ply7vIL
         Zu2IBT/TFHYi14IaBSumJds+fMVfcBx4UY1qZn/GBnq7hXVSvaZ37LtM4jy/m/sILl
         gtcEILBWFsu+YSRL11E0p4qwe6IHH7Tx/Z5QvwFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 06/36] ALSA: line6: Fix racy initialization of LINE6 MIDI
Date:   Mon, 24 May 2021 17:24:51 +0200
Message-Id: <20210524152324.370249772@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
References: <20210524152324.158146731@linuxfoundation.org>
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
@@ -687,6 +687,10 @@ static int line6_init_cap_control(struct
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
@@ -421,11 +421,6 @@ static int pod_init(struct usb_line6 *li
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
@@ -217,7 +217,6 @@ static int variax_init(struct usb_line6
 		       const struct usb_device_id *id)
 {
 	struct usb_line6_variax *variax = (struct usb_line6_variax *) line6;
-	int err;
 
 	line6->process_message = line6_variax_process_message;
 	line6->disconnect = line6_variax_disconnect;
@@ -233,11 +232,6 @@ static int variax_init(struct usb_line6
 	if (variax->buffer_activate == NULL)
 		return -ENOMEM;
 
-	/* initialize MIDI subsystem: */
-	err = line6_init_midi(&variax->line6);
-	if (err < 0)
-		return err;
-
 	/* initiate startup procedure: */
 	variax_startup1(variax);
 	return 0;


