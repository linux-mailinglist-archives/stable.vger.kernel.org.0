Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A93CE0DD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347288AbhGSPSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346615AbhGSPO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B31D600EF;
        Mon, 19 Jul 2021 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710132;
        bh=6dhkOTtgfdcdhxD2ZprguMLZIVnF8Y6WHZsOVdLQsy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NM4UT9P0lRhMlY3THV67Zo0ys9aaJzAVGhmf+Jy8l3MlMGkJSBEkL+UjQyOD2BLfL
         2dLp0ZuVKUQMPQYMVXDBgYKkdJhMI273fekmLmBoNWC8MpY2lqobe1JN11Ok0NthnB
         MNK/Q6gurpyNE0iCsi4q1hV6zaCvQ8HGLYHi9ANA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/243] ALSA: sb: Fix potential double-free of CSP mixer elements
Date:   Mon, 19 Jul 2021 16:51:41 +0200
Message-Id: <20210719144943.233578405@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1528e04a4d28..dbcd9ab2c2b7 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -1072,10 +1072,14 @@ static void snd_sb_qsound_destroy(struct snd_sb_csp * p)
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



