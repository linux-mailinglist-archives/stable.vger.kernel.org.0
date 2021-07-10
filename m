Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63F43C302C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhGJCdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232875AbhGJCbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F0261435;
        Sat, 10 Jul 2021 02:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884073;
        bh=z3dqv1bXqAxWDrPeE7lAIHInmHI+g7TBQ9B3R3Dk2P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJtgLKBKTUmMjhMlEwYacNbMKox/47dwb1mpjRLEKpRpdrq0Nq8UkTIlfQ5gdPkXl
         Lu55t+0VTA1/80iwufhPM2r4V0Rqm1zYBgcy0Qo53S7e8oke3lxTNS3xSafMsLoHa7
         eSpeBtyFsKj6kYd22h3rVlFt1JOkoUwSAiClrmh7q4R1jl2nbxzRW3eCj0to5BCTYr
         w6JlaN5HZHuOZYJk9SIMF9FuJs94ISgyrBEQpKt5yMkhpajMh8xLqlk4xABffB4UZ1
         R51Iooe/mg54hz85sf8w6aq+PUFRxL7uSu1bb2XPT1h1NY85pWmN/E25UbeXOWY0Ix
         CBAEKXVQt1Cyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 34/63] ALSA: sb: Fix potential double-free of CSP mixer elements
Date:   Fri,  9 Jul 2021 22:26:40 -0400
Message-Id: <20210710022709.3170675-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
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
index 69960cf1bb51..ef1289cc78a4 100644
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

