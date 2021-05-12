Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B357337C57C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhELPlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235543AbhELPfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54B1261C40;
        Wed, 12 May 2021 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832675;
        bh=0tZ7O0vNpbKTAR9y891TW5HsK9QWmS05pBoP9DLh498=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irhBLoL5cOfdHWqJHexm0o6C4dQESdxhCRrL+g8DgIsSg80Fw6MoAG3Ys+BQj+KV3
         O5sH7On+tdfb6UPIZBLYcMBr4ow0uvukJqyBrWZNNzXbjJn4iMV5/fUZsLiRWHFByt
         9f1trQfsZtAol59PBICduvdxS7QOuMQPE2djiTfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Zhou <zhou.jia2@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/530] ALSA: core: remove redundant spin_lock pair in snd_card_disconnect
Date:   Wed, 12 May 2021 16:48:08 +0200
Message-Id: <20210512144832.200074074@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia Zhou <zhou.jia2@zte.com.cn>

[ Upstream commit abc21649b3e5c34b143bf86f0c78e33d5815e250 ]

modification in commit 2a3f7221acdd ("ALSA: core: Fix card races between
register and disconnect") resulting in this problem.

Fixes: 2a3f7221acdd ("ALSA: core: Fix card races between register and disconnect")
Signed-off-by: Jia Zhou <zhou.jia2@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Link: https://lore.kernel.org/r/1616989007-34429-1-git-send-email-wang.yi59@zte.com.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 018ce4ef12ec..9f5270c90a10 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -390,10 +390,8 @@ int snd_card_disconnect(struct snd_card *card)
 		return 0;
 	}
 	card->shutdown = 1;
-	spin_unlock(&card->files_lock);
 
 	/* replace file->f_op with special dummy operations */
-	spin_lock(&card->files_lock);
 	list_for_each_entry(mfile, &card->files_list, list) {
 		/* it's critical part, use endless loop */
 		/* we have no room to fail */
-- 
2.30.2



