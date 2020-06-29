Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE0020E2B9
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390016AbgF2VIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730327AbgF2TAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5768B2554C;
        Mon, 29 Jun 2020 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446113;
        bh=giUKFoUw8erXn1s1XujgwlrbbRAXpbQ4mI3lyyA1zdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FB+KcMKgStk9MdKKDapw8h7A4IjQbXC535ShRd0vYm/CUSv0jSzcndU++hQoVtjLS
         I+oxt6622sByTGz4N8GwOiGuEgREVo3Hxfq5ln344Be3fortmyS4XAmFJ16dXpCke+
         flZqnEAytr40VeEn+WkKb/1f30AA6Wdwu6ugQRlE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Scheel <julian@jusst.de>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 104/135] ALSA: usb-audio: uac1: Invalidate ctl on interrupt
Date:   Mon, 29 Jun 2020 11:52:38 -0400
Message-Id: <20200629155309.2495516-105-sashal@kernel.org>
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
index 9bbe84ce7d07f..a2a9712bd6fa7 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2330,9 +2330,14 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
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

