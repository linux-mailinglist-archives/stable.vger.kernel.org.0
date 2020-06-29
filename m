Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A682D20E2CB
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390425AbgF2VIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbgF2TAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B90425551;
        Mon, 29 Jun 2020 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446114;
        bh=sAiNEf54H7tUH6Ot3FT8uPvmxim8eAexcw0I/inkF2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Djuw6pBW1zA3AHwqHCqHSRzYL5HL7EBkoM1NyJi/M+gJ14ktCBjMOZq+mJnQ/HQJx
         Nj3Rq50k1ngmChq6mj42r3O00pEUqIzIT0I6ooJUfLc8Y9sqMnLmJFmvO/NT1/nGCF
         SHjV+b5Mdte4aZLpQYMKyIWMIuUWMmPQ655K//qg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Mack <daniel@zonque.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 105/135] ALSA: usb-audio: allow clock source validity interrupts
Date:   Mon, 29 Jun 2020 11:52:39 -0400
Message-Id: <20200629155309.2495516-106-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

[ Upstream commit 191227d99a281333b50aaf82ab4152fbfa249c19 ]

miniDSP USBStreamer UAC2 devices send clock validity changes with the
control field set to zero. The current interrupt handler ignores all
packets if the control field does not match the mixer element's, but
it really should only do that in case that field is needed to
distinguish multiple elements with the same ID.

This patch implements a logic that lets notifications packets pass
if the element ID is unique for a given device.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index a2a9712bd6fa7..eb98e60e57335 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2391,6 +2391,7 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 	__u8 unitid = (index >> 8) & 0xff;
 	__u8 control = (value >> 8) & 0xff;
 	__u8 channel = value & 0xff;
+	unsigned int count = 0;
 
 	if (channel >= MAX_CHANNELS) {
 		usb_audio_dbg(mixer->chip,
@@ -2399,6 +2400,12 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 		return;
 	}
 
+	for (list = mixer->id_elems[unitid]; list; list = list->next_id_elem)
+		count++;
+
+	if (count == 0)
+		return;
+
 	for (list = mixer->id_elems[unitid]; list; list = list->next_id_elem) {
 		struct usb_mixer_elem_info *info;
 
@@ -2406,7 +2413,7 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 			continue;
 
 		info = (struct usb_mixer_elem_info *)list;
-		if (info->control != control)
+		if (count > 1 && info->control != control)
 			continue;
 
 		switch (attribute) {
-- 
2.25.1

