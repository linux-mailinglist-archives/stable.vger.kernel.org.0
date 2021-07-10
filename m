Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59F3C2D5F
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhGJCWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhGJCWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E930B61402;
        Sat, 10 Jul 2021 02:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883560;
        bh=CTqiA0nCJ1PAXq3EDSd5kAAfEFa48FGUGn2VsY6ulMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNfgpv2NhGPIUaexNoRRK8tw7nGQDuU+PlT6tT8ESU3NW9F9uJmWsyJ9SksnYepek
         asbNwfqDTsT1KkIwf5ki1Xjh5L8bSqneP9Mq0HfymL0tSiR5IJTaTra8WF32kJ5Lue
         UjZLjK4tBX/5XcalUiuGRRVRtWLc2IP4tT5alkQWwgVgT8Ir6RqDbxY1Uq/NUuWMcM
         7iliGbz+dVgjxq5nKXbOwaJytW3/tXS0cpiyrSKd6O2xrzVYQ7XvjrfaqGmliHTojC
         SK95/6KOO1wDd2ee1S7xkxHYaUsw6mRMFYmJBzBUXfcoNGymF/qbs261X0yLB51w46
         kZHt/V9PcKJlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 068/114] ALSA: control_led - fix initialization in the mode show callback
Date:   Fri,  9 Jul 2021 22:17:02 -0400
Message-Id: <20210710021748.3167666-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit e381a14c3e3a4e90e293d4eaa5a3ab8ae98b9973 ]

The str variable should be always initialized before use even if
the switch covers all cases. This is a minimalistic fix: Assign NULL,
the sprintf() may print '(null)' if something is corrupted.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20210614071710.1786866-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index a90e31dbde61..ff7fd5e29551 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -397,7 +397,7 @@ static ssize_t show_mode(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct snd_ctl_led *led = container_of(dev, struct snd_ctl_led, dev);
-	const char *str;
+	const char *str = NULL;
 
 	switch (led->mode) {
 	case MODE_FOLLOW_MUTE:	str = "follow-mute"; break;
-- 
2.30.2

