Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B371644B630
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344213AbhKIWZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344370AbhKIWX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8FBA61211;
        Tue,  9 Nov 2021 22:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496335;
        bh=d1FIuv/dVVxW19ZgxtqFuPC8CVQXUTdfjD91zC5VN2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLBGruY4GntLaDxwkqGidoZGNE6VAeL+3qfzgTdZGx19pEaXrxYJDASe8FuBR/Tkr
         mjzC3KzFUNMLzgmc0AoKQwkTV6GDk4LhC9ORl9RCPU1+aBVVt9XPCsGfZNzpnbkc1k
         SOVeEFAn0N04qfGH5RE+dmAbhuTyuv9JQHC1roJ003xbIYp7YTguicpwgj1VwdNKQa
         FcrbjJMwB6bmeWPTphc7686Tu+bXJZ/rhGltV4ERPPIvVYZURXpXFCNNrzdM2RcABB
         X80uvdsE2ksieUrqixRzl1L/AC73kKtF9jaVqCG9QuvG+GdaWWY19hxRHq07rX9Ru9
         ySuPsdQy0qQyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 77/82] ALSA: usb-audio: fix null pointer dereference on pointer cs_desc
Date:   Tue,  9 Nov 2021 17:16:35 -0500
Message-Id: <20211109221641.1233217-77-sashal@kernel.org>
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

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit b97053df0f04747c3c1e021ecbe99db675342954 ]

The pointer cs_desc return from snd_usb_find_clock_source could
be null, so there is a potential null pointer dereference issue.
Fix this by adding a null check before dereference.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Link: https://lore.kernel.org/r/20211024111736.11342-1-cyeaa@connect.ust.hk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 81d5ce07d548b..98345a695dccb 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -496,6 +496,10 @@ int snd_usb_set_sample_rate_v2v3(struct snd_usb_audio *chip,
 	union uac23_clock_source_desc *cs_desc;
 
 	cs_desc = snd_usb_find_clock_source(chip, clock, fmt->protocol);
+
+	if (!cs_desc)
+		return 0;
+
 	if (fmt->protocol == UAC_VERSION_3)
 		bmControls = le32_to_cpu(cs_desc->v3.bmControls);
 	else
-- 
2.33.0

