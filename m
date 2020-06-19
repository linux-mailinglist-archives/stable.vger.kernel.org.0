Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FE52016E1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgFSOpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388761AbgFSOpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC72420A8B;
        Fri, 19 Jun 2020 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577951;
        bh=yVlSZ/n9zmirRQUKA//+cMaYSvBlSctS/WZL1Q04WAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N81JUJ6/gDuUW9NSqCrTNKa4lGOrg9eH1V8uZPpuLg42XrlyARnyRAy2hzpTzkpdj
         nLeACaNlU7KipB//JnuRpnJz8cclNZKBGZoOwkMoh76zpuJYg3IZRVRFrR6R+mc1CL
         APKzCOD3igMLdl4mSZqd1HKZcfhk5s9ZsmjepqMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH 4.14 025/190] ALSA: usb-audio: Fix inconsistent card PM state after resume
Date:   Fri, 19 Jun 2020 16:31:10 +0200
Message-Id: <20200619141634.767771607@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 862b2509d157c629dd26d7ac6c6cdbf043d332eb upstream.

When a USB-audio interface gets runtime-suspended via auto-pm feature,
the driver suspends all functionality and increment
chip->num_suspended_intf.  Later on, when the system gets suspended to
S3, the driver increments chip->num_suspended_intf again, skips the
device changes, and sets the card power state to
SNDRV_CTL_POWER_D3hot.  In return, when the system gets resumed from
S3, the resume callback decrements chip->num_suspended_intf.  Since
this refcount is still not zero (it's been runtime-suspended), the
whole resume is skipped.  But there is a small pitfall here.

The problem is that the driver doesn't restore the card power state
after this resume call, leaving it as SNDRV_CTL_POWER_D3hot.  So,
even after the system resume finishes, the card instance still appears
as if it were system-suspended, and this confuses many ioctl accesses
that are blocked unexpectedly.

In details, we have two issues behind the scene: one is that the card
power state is changed only when the refcount becomes zero, and
another is that the prior auto-suspend check is kept in a boolean
flag.  Although the latter problem is almost negligible since the
auto-pm feature is imposed only on the primary interface, but this can
be a potential problem on the devices with multiple interfaces.

This patch addresses those issues by the following:

- Replace chip->autosuspended boolean flag with chip->system_suspend
  counter

- At the first system-suspend, chip->num_suspended_intf is recorded to
  chip->system_suspend

- At system-resume, the card power state is restored when the
  chip->num_suspended_intf refcount reaches to chip->system_suspend,
  i.e. the state returns to the auto-suspended

Also, the patch fixes yet another hidden problem by the code
refactoring along with the fixes above: namely, when some resume
procedure failed, the driver left chip->num_suspended_intf that was
already decreased, and it might lead to the refcount unbalance.
In the new code, the refcount decrement is done after the whole resume
procedure, and the problem is avoided as well.

Fixes: 0662292aec05 ("ALSA: usb-audio: Handle normal and auto-suspend equally")
Reported-and-tested-by: Macpaul Lin <macpaul.lin@mediatek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200603153709.6293-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.c     |   20 +++++++++++++-------
 sound/usb/usbaudio.h |    2 +-
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -768,9 +768,6 @@ static int usb_audio_suspend(struct usb_
 	if (chip == (void *)-1L)
 		return 0;
 
-	chip->autosuspended = !!PMSG_IS_AUTO(message);
-	if (!chip->autosuspended)
-		snd_power_change_state(chip->card, SNDRV_CTL_POWER_D3hot);
 	if (!chip->num_suspended_intf++) {
 		list_for_each_entry(as, &chip->pcm_list, list) {
 			snd_pcm_suspend_all(as->pcm);
@@ -783,6 +780,11 @@ static int usb_audio_suspend(struct usb_
 			snd_usb_mixer_suspend(mixer);
 	}
 
+	if (!PMSG_IS_AUTO(message) && !chip->system_suspend) {
+		snd_power_change_state(chip->card, SNDRV_CTL_POWER_D3hot);
+		chip->system_suspend = chip->num_suspended_intf;
+	}
+
 	return 0;
 }
 
@@ -795,10 +797,11 @@ static int __usb_audio_resume(struct usb
 
 	if (chip == (void *)-1L)
 		return 0;
-	if (--chip->num_suspended_intf)
-		return 0;
 
 	atomic_inc(&chip->active); /* avoid autopm */
+	if (chip->num_suspended_intf > 1)
+		goto out;
+
 	/*
 	 * ALSA leaves material resumption to user space
 	 * we just notify and restart the mixers
@@ -813,9 +816,12 @@ static int __usb_audio_resume(struct usb
 		snd_usbmidi_resume(p);
 	}
 
-	if (!chip->autosuspended)
+ out:
+	if (chip->num_suspended_intf == chip->system_suspend) {
 		snd_power_change_state(chip->card, SNDRV_CTL_POWER_D0);
-	chip->autosuspended = 0;
+		chip->system_suspend = 0;
+	}
+	chip->num_suspended_intf--;
 
 err_out:
 	atomic_dec(&chip->active); /* allow autopm after this point */
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -37,7 +37,7 @@ struct snd_usb_audio {
 	struct usb_interface *pm_intf;
 	u32 usb_id;
 	struct mutex mutex;
-	unsigned int autosuspended:1;	
+	unsigned int system_suspend;
 	atomic_t active;
 	atomic_t shutdown;
 	atomic_t usage_count;


