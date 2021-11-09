Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4F544B8D3
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346264AbhKIWqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346260AbhKIWoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:44:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF8F61B46;
        Tue,  9 Nov 2021 22:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496685;
        bh=nj1FTzjwkeR7B4FSSl63i4tJKlVTSuNv7GNf3Bc4GDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGMWS8wSeVgthJx9F4VRgVXWmn2a4MfcKdOFCU9zN6iKcE05zhdfSQfIe8cR7Tt5r
         JYlC/6T2fT/nV+yyCk8tuMAPFiP3vOM7Va95APnqwO52/eqgO3qT5sg3YOIjKSXYnh
         yJEV+ypbvutGWMGbs0BaIPKUdE36Hcmkci4EzbcOwYoU2i8or5ajvuKWXbEqwOe3FR
         YaKNsnkb4JX4zWFTqtMsXbE7UqHUDLPAPW31Q8yCvqGXDj/HT9XxFiSsvTNQ1FIMVr
         CCd6hAr+Up8KirgnAwlx14gXCyhxon9SE0xHhEpzHKs/X42yiJCt/+JlXbSclU1Yn0
         wKEwphIJy6jZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 11/12] ALSA: gus: fix null pointer dereference on pointer block
Date:   Tue,  9 Nov 2021 17:24:25 -0500
Message-Id: <20211109222426.1236575-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222426.1236575-1-sashal@kernel.org>
References: <20211109222426.1236575-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit a0d21bb3279476c777434c40d969ea88ca64f9aa ]

The pointer block return from snd_gf1_dma_next_block could be
null, so there is a potential null pointer dereference issue.
Fix this by adding a null check before dereference.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Link: https://lore.kernel.org/r/20211024104611.9919-1-cyeaa@connect.ust.hk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/gus/gus_dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/isa/gus/gus_dma.c b/sound/isa/gus/gus_dma.c
index 36c27c8323601..2e27cd3427c87 100644
--- a/sound/isa/gus/gus_dma.c
+++ b/sound/isa/gus/gus_dma.c
@@ -141,6 +141,8 @@ static void snd_gf1_dma_interrupt(struct snd_gus_card * gus)
 	}
 	block = snd_gf1_dma_next_block(gus);
 	spin_unlock(&gus->dma_lock);
+	if (!block)
+		return;
 	snd_gf1_dma_program(gus, block->addr, block->buf_addr, block->count, (unsigned short) block->cmd);
 	kfree(block);
 #if 0
-- 
2.33.0

