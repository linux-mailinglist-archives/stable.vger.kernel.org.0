Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C756A7014
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbfICQhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730251AbfICQ0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67DE23878;
        Tue,  3 Sep 2019 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528013;
        bh=HZP2POAxEn65fG59z9X9HA/tlFO9WFGZJxvz8mPkXN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GS6krZzBCp+8nc0q1x2fqvmwRPJT2K/A2HN2WGXKyODTL5rW19/v+v/E0iXTuPzip
         gpp1NgrYg+5aANCjk2ZiLa3sPDaCQgqpJLtv/B4gvZinn1uTiKwRo/LPbRhhX7qDtU
         pxYlItYEVU56pT5ecqG5YlhEcqwfLgypFOz12aio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+fbe0496f92a0ce7b786c@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 053/167] ALSA: pcm: Fix tight loop of OSS capture stream
Date:   Tue,  3 Sep 2019 12:23:25 -0400
Message-Id: <20190903162519.7136-53-sashal@kernel.org>
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

[ Upstream commit e190161f96b88ffae870405fd6c3fdd1d2e7f98d ]

When the trigger=off is passed for a PCM OSS stream, it sets the
start_threshold of the given substream to the boundary size, so that
it won't be automatically started.  This can be problematic for a
capture stream, unfortunately, as detected by syzkaller.  The scenario
is like the following:

- In __snd_pcm_lib_xfer() that is invoked from snd_pcm_oss_read()
  loop, we have a check whether the stream was already started or the
  stream can be auto-started.
- The function at this check returns 0 with trigger=off since we
  explicitly disable the auto-start.
- The loop continues and repeats calling __snd_pcm_lib_xfer() tightly,
  which may lead to an RCU stall.

This patch fixes the bug by simply allowing the wait for non-started
stream in the case of OSS capture.  For native usages, it's supposed
to be done by the caller side (which is user-space), hence it returns
zero like before.

(In theory, __snd_pcm_lib_xfer() could wait even for the native API
 usage cases, too; but I'd like to stay in a safer side for not
 breaking the existing stuff for now.)

Reported-by: syzbot+fbe0496f92a0ce7b786c@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 40013b26f6719..6c99fa8ac5fa1 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2112,6 +2112,13 @@ int pcm_lib_apply_appl_ptr(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+/* allow waiting for a capture stream that hasn't been started */
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define wait_capture_start(substream)	((substream)->oss.oss)
+#else
+#define wait_capture_start(substream)	false
+#endif
+
 /* the common loop for read/write data */
 snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 				     void *data, bool interleaved,
@@ -2182,7 +2189,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 			err = snd_pcm_start(substream);
 			if (err < 0)
 				goto _end_unlock;
-		} else {
+		} else if (!wait_capture_start(substream)) {
 			/* nothing to do */
 			err = 0;
 			goto _end_unlock;
-- 
2.20.1

