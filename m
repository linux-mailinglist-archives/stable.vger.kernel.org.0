Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC91431B12
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhJRNag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232191AbhJRN3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC52E6135E;
        Mon, 18 Oct 2021 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563647;
        bh=XUV2F7QPq6I0CrJayOW5sCUAAwA4qldj1kvMCO92C68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsBiPbHuEI/BT3cDsJAzWDGkA9CcVs7y+vopf0FHgkVW9Jsc3jRmK0aTF4nhWPrzd
         V1rqnI3NNmXQ/o1sgdwRRkpkvlm8UG2N1Wgnvw7D0mVz9/fdauiXSdM+QBZClUhMMe
         grj+uSGmyGEU6IkfZaDiN4VoV0jDfzph9E2m5KRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        John Keeping <john@metanate.com>
Subject: [PATCH 4.19 01/50] ALSA: seq: Fix a potential UAF by wrong private_free call order
Date:   Mon, 18 Oct 2021 15:24:08 +0200
Message-Id: <20211018132326.576347595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 1f8763c59c4ec6254d629fe77c0a52220bd907aa upstream.

John Keeping reported and posted a patch for a potential UAF in
rawmidi sequencer destruction: the snd_rawmidi_dev_seq_free() may be
called after the associated rawmidi object got already freed.
After a deeper look, it turned out that the bug is rather the
incorrect private_free call order for a snd_seq_device.  The
snd_seq_device private_free gets called at the release callback of the
sequencer device object, while this was rather expected to be executed
at the snd_device call chains that runs at the beginning of the whole
card-free procedure.  It's been broken since the rewrite of
sequencer-device binding (although it hasn't surfaced because the
sequencer device release happens usually right along with the card
device release).

This patch corrects the private_free call to be done in the right
place, at snd_seq_device_dev_free().

Fixes: 7c37ae5c625a ("ALSA: seq: Rewrite sequencer device binding with standard bus")
Reported-and-tested-by: John Keeping <john@metanate.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210930114114.8645-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq_device.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/sound/core/seq_device.c
+++ b/sound/core/seq_device.c
@@ -162,6 +162,8 @@ static int snd_seq_device_dev_free(struc
 	struct snd_seq_device *dev = device->device_data;
 
 	cancel_autoload_drivers();
+	if (dev->private_free)
+		dev->private_free(dev);
 	put_device(&dev->dev);
 	return 0;
 }
@@ -189,11 +191,7 @@ static int snd_seq_device_dev_disconnect
 
 static void snd_seq_dev_release(struct device *dev)
 {
-	struct snd_seq_device *sdev = to_seq_dev(dev);
-
-	if (sdev->private_free)
-		sdev->private_free(sdev);
-	kfree(sdev);
+	kfree(to_seq_dev(dev));
 }
 
 /*


