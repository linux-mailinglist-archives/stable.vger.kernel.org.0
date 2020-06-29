Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9951020D710
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgF2T0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732668AbgF2TZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E30602544F;
        Mon, 29 Jun 2020 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445403;
        bh=0o1eBr6mNFv6neboNJd0U7cVg8BlS8w2mFXzgB4Dr+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHgZYgeEmduUNG1rfrS/nPM9vO9v1aGWxxCoH7vlbh8WSx4ObKXOd/pY2SgJ/oCY5
         QaoeAxZaFfuBsLTtOrgK5Xy0chOyYllC4X5lKkgwSIMQfr7T4z7/1JfmNwIwh7mC9G
         Kd2PYxfN59+Xz9kZ4whJWNJgQIR7jXYh4PvQ9Oj4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Scheel <julian@jusst.de>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 155/191] ALSA: usb-audio: uac1: Invalidate ctl on interrupt
Date:   Mon, 29 Jun 2020 11:39:31 -0400
Message-Id: <20200629154007.2495120-156-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Scheel <julian@jusst.de>

[ Upstream commit b2500b584cfd228d67e1e43daf27c8af865b499e ]

When an interrupt occurs, the value of at least one of the belonging
controls should have changed. To make sure they get re-read from device
on the next read, invalidate the cache. This was correctly implemented
for uac2 already, but missing for uac1.

Signed-off-by: Julian Scheel <julian@jusst.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 024864ce3f761..60423d2572c7d 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2397,9 +2397,14 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
 {
 	struct usb_mixer_elem_list *list;
 
-	for (list = mixer->id_elems[unitid]; list; list = list->next_id_elem)
+	for (list = mixer->id_elems[unitid]; list; list = list->next_id_elem) {
+		struct usb_mixer_elem_info *info =
+			(struct usb_mixer_elem_info *)list;
+		/* invalidate cache, so the value is read from the device */
+		info->cached = 0;
 		snd_ctl_notify(mixer->chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
 			       &list->kctl->id);
+	}
 }
 
 static void snd_usb_mixer_dump_cval(struct snd_info_buffer *buffer,
-- 
2.25.1

