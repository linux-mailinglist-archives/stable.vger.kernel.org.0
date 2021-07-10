Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2703C2D5B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhGJCWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232761AbhGJCWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF84D613FE;
        Sat, 10 Jul 2021 02:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883554;
        bh=WTR3HR2O77FCPjnMuu4vUPAkOF6KxIhKe3sBHTkkkNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQSXgYo3mPFvsfNIYuNDm/IKSA+aCHi/rILlM2m/RqrtW41Tkpu2EVeeJy9CMrcqZ
         QIfin3BDVCXWdoqZLeijNNbfwznbLQPC5TL/gRIzwD1UwLdtYrZYBoerGNzv0u+3LS
         1aOy3iiRiSwobz3vmVvaV/I2MaCv1ZAIUMyfuR9ZZEX4uIGirsPDnM45sTLFIOLiNs
         gV6GdzR1d5CIA8qH0zieNViiTAeIaFeb/dJ1rbd1V+mtKnGWy6gAFBpt84tU1JDgzs
         cz1JcRt1jA87XgeYxsv2pw+vmvkpgWAWxpkK50YT87F98LRlGlhc0jnuWjQCIIZdfW
         off+Z4uXMgL1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 063/114] ALSA: sb: Fix potential double-free of CSP mixer elements
Date:   Fri,  9 Jul 2021 22:16:57 -0400
Message-Id: <20210710021748.3167666-63-sashal@kernel.org>
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
index 4789345a8fdd..c98ccd421a2e 100644
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

