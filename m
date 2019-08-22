Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEC899A8F
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390487AbfHVRIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390481AbfHVRIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:44 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C8F523400;
        Thu, 22 Aug 2019 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493723;
        bh=YWZMTuicYL37W61tyGEDFMuUQiDu4m6h46X35x3t5h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrSouZeYjrlALJn/lWm7u9YJz7Gv31wBgqp5KnQWFogyrg00hoN4hHEDXkivBUF9q
         ZXyEhBKclMovlQuttrev8iB0jUEmOAPPfw2FaNDtVJhLYVl4RqaEUqCmcZ/iuJoOqE
         XtuUtmx0mkeDeIh6ep+NhoyUZDwcbze7rZ5/gisk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuki Tsunashima <ytsunashima@jp.adit-jv.com>,
        Suresh Udipi <sudipi@jp.adit-jv.com>,
        Adam Miartus <amiartus@de.adit-jv.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 054/135] ALSA: pcm: fix lost wakeup event scenarios in snd_pcm_drain
Date:   Thu, 22 Aug 2019 13:06:50 -0400
Message-Id: <20190822170811.13303-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuki Tsunashima <ytsunashima@jp.adit-jv.com>

[ Upstream commit 37151a41df800493cfcbbef4f7208ffe04feb959 ]

lost wakeup can occur after enabling irq, therefore put task
into interruptible before enabling interrupts,

without this change, task can be put to sleep and snd_pcm_drain
will delay

Fixes: f2b3614cefb6 ("ALSA: PCM - Don't check DMA time-out too shortly")
Signed-off-by: Yuki Tsunashima <ytsunashima@jp.adit-jv.com>
Signed-off-by: Suresh Udipi <sudipi@jp.adit-jv.com>
[ported from 4.9]
Signed-off-by: Adam Miartus <amiartus@de.adit-jv.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 12dd9b318db18..703857aab00fc 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1873,6 +1873,7 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 		if (!to_check)
 			break; /* all drained */
 		init_waitqueue_entry(&wait, current);
+		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&to_check->sleep, &wait);
 		snd_pcm_stream_unlock_irq(substream);
 		if (runtime->no_period_wakeup)
@@ -1885,7 +1886,7 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 			}
 			tout = msecs_to_jiffies(tout * 1000);
 		}
-		tout = schedule_timeout_interruptible(tout);
+		tout = schedule_timeout(tout);
 
 		snd_pcm_stream_lock_irq(substream);
 		group = snd_pcm_stream_group_ref(substream);
-- 
2.20.1

