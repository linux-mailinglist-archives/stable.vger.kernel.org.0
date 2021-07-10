Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E93D3C30BF
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhGJCgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234065AbhGJCfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66D6561421;
        Sat, 10 Jul 2021 02:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884350;
        bh=e56wCNtzipbCruyvGQJOp9CBwWPfNJuoSaIZ7Nckhbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZs4rpumhbBvM/b+vJamc5MAVt9nmGKq605h+9zVakS03U0PgfOlTXkxpFXirjBn5
         LLBdjsqJ3zB+QeW03GEmBahOO/7nQ/4PBvFu52h9HtMERnQfJfun1/9sIOEvitgGq/
         H8bSYvjyG/QvPuptfeYyzZTXPxLQ+t8jxY6JKRSTYJXsoVywSt2EXnvh+bM3ybwpLs
         dMrDrlqEQfaX1p8c2NZ0oem+FDrqau1SMk963f+wbviDL26ocPOK/plMGNtosQWxq2
         wPJSl8m9OPHDkdTLtoHDM4GPYQk0HQyBSm9UPvzISSUHVYj/FUM3XnqjumefcNmu8x
         +jtxMdKuCfy5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 21/39] ALSA: sb: Fix potential double-free of CSP mixer elements
Date:   Fri,  9 Jul 2021 22:31:46 -0400
Message-Id: <20210710023204.3171428-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
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
index 2e00b64ef13b..b3eecde0b612 100644
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

