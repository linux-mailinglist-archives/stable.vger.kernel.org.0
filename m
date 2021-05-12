Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4A437C1FD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhELPGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233222AbhELPEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FA096193B;
        Wed, 12 May 2021 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831581;
        bh=1XAI1jgPyx7DuHk3YMF2oFc+mjBHrFD2WfPX999FdwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZYT47Y2gaq6MHhbU2ZT9qvr3erI60oOPcSrlbaxB4hRdopMnwIy+uSDm1BUWjp+J
         XVf6Qr6HCAGSaBEBVjsvfCe23y9oBehCV9+vPaB5BQTxRXPBJsviAlxxPWKecnmQvf
         iPngPqkKOGV7T/0H/glCR1ysBKWYry29IAw4G6Rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Zhou <zhou.jia2@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/244] ALSA: core: remove redundant spin_lock pair in snd_card_disconnect
Date:   Wed, 12 May 2021 16:49:08 +0200
Message-Id: <20210512144748.661718503@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index db99b7fad6ad..45bbc4884ef0 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -384,10 +384,8 @@ int snd_card_disconnect(struct snd_card *card)
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



