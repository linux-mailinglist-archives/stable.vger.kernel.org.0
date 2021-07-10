Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E110B3C311E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhGJCkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235892AbhGJCju (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B80FA6144A;
        Sat, 10 Jul 2021 02:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884580;
        bh=0maWroivBJOvh18abpe9bTk7gxcjye2N3W9KBM9/MHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQQTYIuVCXmBUQ9Z/SIOH4/2woxeBgt3xOIc3gu7U99sWeU83DLWuZsDS3lEwgzsS
         Dta4tmnNSxv1lWBpFmYBbcBmm6+sCD1Gkauy+JQ4F8Y4y1ptMdKaJzTBSP6dCUAng2
         2rlTlFkmS9eKCHTuZYnVReSp3uE1RdosRO4+G3GDyZNVrdgGR3LZS7pPbFpnpwh4hz
         5yR9+v+OxwCBoGuQvUB9/KCBem6UOZF/jMrixXFy+bu0KNg4gaWSJeaD6TbEHOKjHP
         c2n/SWnUkfmsN04QFkHUmatI1i0yi9pxEoYswQJLBDr8c6gumJa/++g10iOIIQ+bA6
         mHwckIQs2guMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 12/26] ALSA: sb: Fix potential double-free of CSP mixer elements
Date:   Fri,  9 Jul 2021 22:35:50 -0400
Message-Id: <20210710023604.3172486-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c305366a37441c2ac90b08711cb6f032b43672f2 ]

snd_sb_qsound_destroy() contains the calls of removing the previously
created mixer controls, but it doesn't clear the pointers.  As
snd_sb_qsound_destroy() itself may be repeatedly called via ioctl,
this could lead to double-free potentially.

Fix it by clearing the struct fields properly afterwards.

Link: https://lore.kernel.org/r/20210608140540.17885-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb16_csp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 2cc068be7d3b..90fa57ad14c0 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -1086,10 +1086,14 @@ static void snd_sb_qsound_destroy(struct snd_sb_csp * p)
 	card = p->chip->card;	
 	
 	down_write(&card->controls_rwsem);
-	if (p->qsound_switch)
+	if (p->qsound_switch) {
 		snd_ctl_remove(card, p->qsound_switch);
-	if (p->qsound_space)
+		p->qsound_switch = NULL;
+	}
+	if (p->qsound_space) {
 		snd_ctl_remove(card, p->qsound_space);
+		p->qsound_space = NULL;
+	}
 	up_write(&card->controls_rwsem);
 
 	/* cancel pending transfer of QSound parameters */
-- 
2.30.2

