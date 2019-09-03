Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C441A701B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbfICQhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730717AbfICQ0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8111C23789;
        Tue,  3 Sep 2019 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528009;
        bh=hZ88OPcW/uIsLOuymIz8Dzs7/P+IEy5pFES3O5z/m9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6kivvQWi/ogWyC37hh++fgdoHhbOhoYii2TvwnFTkfH4f6Zn7Y/1UMlp1a8Dx4bB
         Q1qu4tf0HSxVr5/H4uMiX5AAPFk86INWlG6o/iqsO5EL+byFlP73Z5fF3CZtR7AGnv
         xtAdIDA/cOa6NCDIyjUe8LTrV0s6wNSMAuppfHb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Biehl Pasquali <pasqualirb@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 051/167] ALSA: pcm: Return 0 when size < start_threshold in capture
Date:   Tue,  3 Sep 2019 12:23:23 -0400
Message-Id: <20190903162519.7136-51-sashal@kernel.org>
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

From: Ricardo Biehl Pasquali <pasqualirb@gmail.com>

[ Upstream commit 62ba568f7aef4beb0eda945a2b2a91b7a2b8f215 ]

In __snd_pcm_lib_xfer(), when capture, if state is PREPARED
and size is less than start_threshold nothing can be done.
As there is no error, 0 is returned.

Signed-off-by: Ricardo Biehl Pasquali <pasqualirb@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 4e6110d778bd2..7f71c2449af5e 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2173,11 +2173,16 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 		goto _end_unlock;
 
 	if (!is_playback &&
-	    runtime->status->state == SNDRV_PCM_STATE_PREPARED &&
-	    size >= runtime->start_threshold) {
-		err = snd_pcm_start(substream);
-		if (err < 0)
+	    runtime->status->state == SNDRV_PCM_STATE_PREPARED) {
+		if (size >= runtime->start_threshold) {
+			err = snd_pcm_start(substream);
+			if (err < 0)
+				goto _end_unlock;
+		} else {
+			/* nothing to do */
+			err = 0;
 			goto _end_unlock;
+		}
 	}
 
 	runtime->twake = runtime->control->avail_min ? : 1;
-- 
2.20.1

