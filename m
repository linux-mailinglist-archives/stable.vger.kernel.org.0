Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A89423C58
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbhJFLPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238509AbhJFLOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 07:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11172610FC;
        Wed,  6 Oct 2021 11:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633518778;
        bh=nP9Gz40YheGjmXGenK6aSQJa95wN7Jthsqmc5DCDn7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn4AQz2hgLL13u3uefGM3BA1JoVRCvY+/ROFa+3N0o/vdlwgex2YM/3JXFw/GUwPO
         PrGbrw3lwQMrFu2BgGVAPsVQsSOL7ZLyUagoo4sChrL8+GRNIYi+iddtXf98kqpyeB
         2wHyIgiqD9iJj0XiIklOvyPtb8LB3U3S3++ZRQfGWZWvAMWaAFH7SkwMZox37SyPk1
         b+t9UWL1iDq6KexVIWjseHb1tX0pXz8uP/DM90/E9n+U4t6QqrSeib4ERhxs8lzHN0
         tFuvZMumW5/72UfrwAM8m/ESJOGK1g1EN/2NWqexPXS1wIbBm9bIlnsQwsQ96ncaKv
         0jbypelvfsZKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH MANUALSEL 5.4 4/4] ALSA: pcsp: Make hrtimer forwarding more robust
Date:   Wed,  6 Oct 2021 07:12:50 -0400
Message-Id: <20211006111250.264294-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006111250.264294-1-sashal@kernel.org>
References: <20211006111250.264294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit f2ff7147c6834f244b8ce636b12e71a3bd044629 ]

The hrtimer callback pcsp_do_timer() prepares rearming of the timer with
hrtimer_forward(). hrtimer_forward() is intended to provide a mechanism to
forward the expiry time of the hrtimer by a multiple of the period argument
so that the expiry time greater than the time provided in the 'now'
argument.

pcsp_do_timer() invokes hrtimer_forward() with the current timer expiry
time as 'now' argument. That's providing a periodic timer expiry, but is
not really robust when the timer callback is delayed so that the resulting
new expiry time is already in the past which causes the callback to be
invoked immediately again. If the timer is delayed then the back to back
invocation is not really making it better than skipping the missed
periods. Sound is distorted in any case.

Use hrtimer_forward_now() which ensures that the next expiry is in the
future. This prevents hogging the CPU in the timer expiry code and allows
later on to remove hrtimer_forward() from the public interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: alsa-devel@alsa-project.org
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20210923153339.623208460@linutronix.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcsp/pcsp_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index 8f0f05bbc081..23a15d892e50 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -145,7 +145,7 @@ enum hrtimer_restart pcsp_do_timer(struct hrtimer *handle)
 	if (pointer_update)
 		pcsp_pointer_update(chip);
 
-	hrtimer_forward(handle, hrtimer_get_expires(handle), ns_to_ktime(ns));
+	hrtimer_forward_now(handle, ns_to_ktime(ns));
 
 	return HRTIMER_RESTART;
 }
-- 
2.33.0

