Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA9A6E94
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfICQ1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730280AbfICQ1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 723D623789;
        Tue,  3 Sep 2019 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528021;
        bh=heB/LCCjWV2KkeXrOrpEpB/FTZIC9PTxznEi7XRNfgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/P7OeEaq1ydsE7iNVhjDrLJJng9pNn3oKbGDETbRsW8wbrFlihWBg6gxPhS9x6uf
         QKC38TUUiUWsA1NIPDXfyZDMvcvjW5oN0DPO42UXF6O9YFexFgfXyP3EKu/oBmxoto
         RW3g7V23VFo54I/zGI8h6pDw7qWE/uRaCCNaCv58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 057/167] ALSA: pcm: Revert capture stream behavior change in blocking mode
Date:   Tue,  3 Sep 2019 12:23:29 -0400
Message-Id: <20190903162519.7136-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 00a399cad1a063e7665f06b6497a807db20441fd ]

In the commit 62ba568f7aef ("ALSA: pcm: Return 0 when size <
start_threshold in capture"), we changed the behavior of
__snd_pcm_lib_xfer() to return immediately with 0 when a capture
stream has a high start_threshold.  This was intended to be a
correction of the behavior consistency and looked harmless, but this
was the culprit of the recent breakage reported by syzkaller, which
was fixed by the commit e190161f96b8 ("ALSA: pcm: Fix tight loop of
OSS capture stream").

At the time for the OSS fix, I didn't touch the behavior for ALSA
native API, as assuming that this behavior actually is good.  But this
turned out to be also broken actually for a similar deployment,
e.g. one thread goes to a write loop in blocking mode while another
thread controls the start/stop of the stream manually.

Overall, the original commit is harmful, and it brings less merit to
keep that behavior.  Let's revert it.

Fixes: 62ba568f7aef ("ALSA: pcm: Return 0 when size < start_threshold in capture")
Fixes: e190161f96b8 ("ALSA: pcm: Fix tight loop of OSS capture stream")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 6c99fa8ac5fa1..6c0b30391ba99 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2112,13 +2112,6 @@ int pcm_lib_apply_appl_ptr(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-/* allow waiting for a capture stream that hasn't been started */
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-#define wait_capture_start(substream)	((substream)->oss.oss)
-#else
-#define wait_capture_start(substream)	false
-#endif
-
 /* the common loop for read/write data */
 snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 				     void *data, bool interleaved,
@@ -2184,16 +2177,11 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 		snd_pcm_update_hw_ptr(substream);
 
 	if (!is_playback &&
-	    runtime->status->state == SNDRV_PCM_STATE_PREPARED) {
-		if (size >= runtime->start_threshold) {
-			err = snd_pcm_start(substream);
-			if (err < 0)
-				goto _end_unlock;
-		} else if (!wait_capture_start(substream)) {
-			/* nothing to do */
-			err = 0;
+	    runtime->status->state == SNDRV_PCM_STATE_PREPARED &&
+	    size >= runtime->start_threshold) {
+		err = snd_pcm_start(substream);
+		if (err < 0)
 			goto _end_unlock;
-		}
 	}
 
 	avail = snd_pcm_avail(substream);
-- 
2.20.1

