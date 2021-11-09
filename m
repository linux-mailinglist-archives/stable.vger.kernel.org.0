Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB17544B5B0
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245697AbhKIWWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245743AbhKIWUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC7E761361;
        Tue,  9 Nov 2021 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496275;
        bh=rZ9QWQfRU/US9o4SdMAl+V6Df536/kZ9QhPCdC8ndLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7p8y3gz8noLjjJbwDmrm/Jb/C42UFPQT4V0oHJPP+wfymq+hkwQ/30EjPSh0OqVE
         XWnoMvc26tN2J8Kk+llgaq2dRWGGcrIPtr2OGJ2iVU2NRwuENlzi1aAqVgm+HpIwif
         SXNt9zqDefaDd/ZNI0C+MR1pMxrbLRe6D5S0UQI8OhXH70LofkNOFXE1Vhd2LQDAxP
         Er03p2R6cnfuPaoTDmYJ4pEUvZB0zJpq+vKME97HJM3eyX+eOhTecjl22vg3ecXukZ
         1aUDHPzz9xbxZFviGlIKNk37IBWyhlSQOXRtT07x0pr4Tc71esTFAj2gE6UUyo0z2Q
         YJ1IQopQIqHgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geraldo Nascimento <geraldogabriel@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 38/82] ALSA: usb-audio: disable implicit feedback sync for Behringer UFX1204 and UFX1604
Date:   Tue,  9 Nov 2021 17:15:56 -0500
Message-Id: <20211109221641.1233217-38-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 28c369e60827f706cef4604a3e2848198f25bd26 ]

Behringer UFX1204 and UFX1604 have Synchronous endpoints to which
current ALSA code applies implicit feedback sync as if they were
Asynchronous endpoints. This breaks UAC compliance and is unneeded.

The commit 5e35dc0338d85ccebacf3f77eca1e5dea73155e8 and subsequent
1a15718b41df026cffd0e42cfdc38a1384ce19f9 were meant to clear up noise.

Unfortunately, noise persisted for those using higher sample rates and
this was only solved by commit d2e8f641257d0d3af6e45d6ac2d6f9d56b8ea964

Since there are no more reports of noise, let's get rid of the
implicit-fb quirks breaking UAC compliance.

Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Link: https://lore.kernel.org/r/YVYSnoQ7nxLXT0Dq@geday
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/implicit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index 23767a14d1266..70319c822c10b 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -54,8 +54,6 @@ static const struct snd_usb_implicit_fb_match playback_implicit_fb_quirks[] = {
 
 	/* Fixed EP */
 	/* FIXME: check the availability of generic matching */
-	IMPLICIT_FB_FIXED_DEV(0x1397, 0x0001, 0x81, 1), /* Behringer UFX1604 */
-	IMPLICIT_FB_FIXED_DEV(0x1397, 0x0002, 0x81, 1), /* Behringer UFX1204 */
 	IMPLICIT_FB_FIXED_DEV(0x2466, 0x8010, 0x81, 2), /* Fractal Audio Axe-Fx III */
 	IMPLICIT_FB_FIXED_DEV(0x31e9, 0x0001, 0x81, 2), /* Solid State Logic SSL2 */
 	IMPLICIT_FB_FIXED_DEV(0x31e9, 0x0002, 0x81, 2), /* Solid State Logic SSL2+ */
-- 
2.33.0

