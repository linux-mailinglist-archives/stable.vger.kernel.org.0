Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C77E38A42C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhETKBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235288AbhETJ7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7B8061876;
        Thu, 20 May 2021 09:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503524;
        bh=JqtoyHvuHtPfaXbCoVRi4NDPKrtDhVqz3kqV4VGUEAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qThDZpvEp2vsM58xgHc+iq5vk5WgwdWXcQJmLqzWiCJoywlqOhcgg2Uxq5gDPvfHd
         Dd+VXnSTxnvQVkilXIXwH+MvdpHCHBQ9PRd+nbMgs5OhCpZs+r5Zy4Zrtb7z1ae/NS
         Mo7mGVnfYg7fFo9I3vtlyfxL6X7kg9u+UGlYewa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Zhou <zhou.jia2@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 253/425] ALSA: core: remove redundant spin_lock pair in snd_card_disconnect
Date:   Thu, 20 May 2021 11:20:22 +0200
Message-Id: <20210520092139.726296983@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 16b7cc7aa66b..3eafa15006f8 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -405,10 +405,8 @@ int snd_card_disconnect(struct snd_card *card)
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



