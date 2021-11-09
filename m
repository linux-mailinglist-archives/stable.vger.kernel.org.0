Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B18A44B6B9
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344361AbhKIW31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344160AbhKIW1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:27:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D723361A50;
        Tue,  9 Nov 2021 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496405;
        bh=OXp0f50fIwKe5A8ng8EYY+C7aGVgb0MmMfZBWxF7nFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8jVYlU6jlxguOj9ePJ1imn0OquIT/VLLEEb2uxiHshEFUXXT1HvqUd4xE/fRG9BN
         069QUvr8Zc8zY62U50mGfZgGKqJQILcwZGiNz+JnLdItJNV6YrtcSGKMo812pGzQ+D
         8/2zJJ7BxSBxpjfE2kRsb17ZUI5HvFO+dN8oKxx6QPCyMBCIfn2TkTHPntKUvHTtHO
         rmJNspmhpNVOOXAQhyaAUABrN9yLrlH9Jdst4lFndmYmh2x55MkKoT08RuXzvQzK1V
         e+2E1k/YDTaCgx1VU7K9KOZZP7IeRKhzMPq9XFNWF6oeYIkhqgGdJgxAIkTuevP/S7
         nVn0FWEhzapzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geraldo Nascimento <geraldogabriel@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 35/75] ALSA: usb-audio: disable implicit feedback sync for Behringer UFX1204 and UFX1604
Date:   Tue,  9 Nov 2021 17:18:25 -0500
Message-Id: <20211109221905.1234094-35-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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
index 590a0dbba7a21..34461947260b2 100644
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

