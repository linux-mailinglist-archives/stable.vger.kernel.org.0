Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4032344B7CE
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345209AbhKIWhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344824AbhKIWfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62CE2611AD;
        Tue,  9 Nov 2021 22:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496540;
        bh=KFya8t7XucbD4ytnXfZ1+zfqS0YsfWJVp8FuMTEXMeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/IFeZ0Pqqtr1yNjLpEjd2dMhRk+PWAn7T5WSA/EArXoWCKEJvsxAq4Z092V2xLmd
         Z/493OPDAQR78Q2JopnFQlvoMYLxGPIJTe85uJNxouBd9zK+PVEO+SfXeHLMFBZ9Of
         UHPgqG22KV014k4EWFTCEGZkXPcejt9EFFv5SsPB0E0vlccIJbZWG7qcCCkwDCC6Lj
         GFCegLSpvitgzwcSbVnprZ7KV46S6dlp7B9HUk8ItpFb4CN/eox/H5/tnw4iLbR/QD
         0ryFBCsgcZHIaGcM7MQjzjjhK8AZgxUm+hmyeO2R4KTCBmS2ZkBynNclW9vN0ir0Oo
         +r2FRakNrvPYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 48/50] ALSA: gus: fix null pointer dereference on pointer block
Date:   Tue,  9 Nov 2021 17:21:01 -0500
Message-Id: <20211109222103.1234885-48-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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
index a1c770d826dda..6d664dd8dde0b 100644
--- a/sound/isa/gus/gus_dma.c
+++ b/sound/isa/gus/gus_dma.c
@@ -126,6 +126,8 @@ static void snd_gf1_dma_interrupt(struct snd_gus_card * gus)
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

