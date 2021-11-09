Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B99444B860
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345793AbhKIWmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345367AbhKIWkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:40:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E035761B1C;
        Tue,  9 Nov 2021 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496621;
        bh=tYjtW025gHLRr8426PhlfQYECjhcjlWc5ctzxhuJJ2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ponmLuvQfoM/ZCSHDR5SWTq++XUmF8J2JLlLuTT/UDH+qzqYYy73USl3pvMp4NcUG
         eVyOQdCohmLYfiVoR/VDFdEXfO9kVVJNyvhxBZJD395io4bs/orF3G9znIsnV8XsbX
         BplBcDSh9Y5ICiaB7QZX5mr+QbSfC6xeHaGqPWrxPW7bySzn7/acXrew+ZYNLS+piv
         tq2mf709gD6uLaC5XfccGq1+UGRBY4dnEuxXg8jzrApO81rM79Tu0rYLMSad24+6SW
         WRIcozFY2v/pylh7s7iZ9tnOR9F8uKD9+bftsXALOXiUj0CBo3NrdEKRtzl4aJwC7i
         uVKA5jVssC6fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 20/21] ALSA: gus: fix null pointer dereference on pointer block
Date:   Tue,  9 Nov 2021 17:23:09 -0500
Message-Id: <20211109222311.1235686-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
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
index 7f95f452f1064..48e76b8fede41 100644
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

