Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141F438EA47
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhEXOxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233991AbhEXOvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:51:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ECDF6128D;
        Mon, 24 May 2021 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867683;
        bh=T73aE6qjderFT5AXqvF+eWkmvZ0i4FnAsV5zIEkKxBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1D55jXw0dAbJHUscZmUrO6jn3kvYLuG5OT8O1HwKwuhyx7wVEg0X42aOvR8wBp7S
         81BnvhEvngvOq1glgeJJwUApx6a+TLpycntk3upU2QlC6UcbJHZfk9334xd+pj3rJi
         kmKPXzoj1OoADYfrALDfPvA+kR5j1tAvwVa4/3PkHUbuUgM+tke3I2sJPEVTsRkd7Q
         v7uLjzDHTVio1gGuEL7CEMnUymH9rhUMZr5oIavW4Xo7nYJ8KdOKF8jfmebKURnkFd
         e72Ti0dr3OJ4tYKl4jXvZc+0tifcMmugeOwGsLcrY3OlpXdgJkBL1mJhlBXOgPLMnI
         yx07Me2Xj2A6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 16/62] Revert "ALSA: gus: add a check of the status of snd_ctl_add"
Date:   Mon, 24 May 2021 10:46:57 -0400
Message-Id: <20210524144744.2497894-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 1dacca7fa1ebea47d38d20cd2df37094805d2649 ]

This reverts commit 0f25e000cb4398081748e54f62a902098aa79ec1.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit did nothing if there was an error, except to print
out a message, which is pointless.  So remove the commit as it gives a
"false sense of doing something".

Cc: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210503115736.2104747-33-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/gus/gus_main.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/sound/isa/gus/gus_main.c b/sound/isa/gus/gus_main.c
index afc088f0377c..b7518122a10d 100644
--- a/sound/isa/gus/gus_main.c
+++ b/sound/isa/gus/gus_main.c
@@ -77,17 +77,8 @@ static const struct snd_kcontrol_new snd_gus_joystick_control = {
 
 static void snd_gus_init_control(struct snd_gus_card *gus)
 {
-	int ret;
-
-	if (!gus->ace_flag) {
-		ret =
-			snd_ctl_add(gus->card,
-					snd_ctl_new1(&snd_gus_joystick_control,
-						gus));
-		if (ret)
-			snd_printk(KERN_ERR "gus: snd_ctl_add failed: %d\n",
-					ret);
-	}
+	if (!gus->ace_flag)
+		snd_ctl_add(gus->card, snd_ctl_new1(&snd_gus_joystick_control, gus));
 }
 
 /*
-- 
2.30.2

