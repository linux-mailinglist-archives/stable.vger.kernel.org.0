Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DEC38A712
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhETKdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237321AbhETKbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 659B261C30;
        Thu, 20 May 2021 09:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504340;
        bh=sEP+78M9DwHYbFIR814WP8GqfRmfhoaYsCHzC4LKNmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFzOrKZijW7N8XzPlIyLApQfGOQjjvhwqbUmYebLR8+jZ48nIp4g9AJUNznJ2BVMH
         TJCWSgDxBsa8Cfd6ej4r5k7uIuHQnyC1kvkJRci4YeQq5KhYhw7mdxqSIPQgy2b8eI
         RWc4cFKHVm5nU9tZYT55tEeBRuNE3mzMzhfIuLjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Zhou <zhou.jia2@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 200/323] ALSA: core: remove redundant spin_lock pair in snd_card_disconnect
Date:   Thu, 20 May 2021 11:21:32 +0200
Message-Id: <20210520092126.984356107@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index dcb9199f5e4f..7fdeae4dc820 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -404,10 +404,8 @@ int snd_card_disconnect(struct snd_card *card)
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



