Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0760D38AB44
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhETLWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240131AbhETLU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E23561D85;
        Thu, 20 May 2021 10:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505467;
        bh=eK1sJ7ATL0rlTrWlJly6d1wzclRUc1ZGHPpZi8qgbYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHTR4hFnwRGRfcbXclvCNUkUnDmsExu9i5puYY8K5huYjNqtWkQ+jS9GD9/OcdkRj
         +ZbWUyVOrazvfO7t6HmcyAWw3uJr3V51v11SpNxJgHfgihGreHKGY+Vuq1vQVcSvmR
         8qCqh8umzN3bCu1BuXlyvRZQIc/Qm9Pb/zaoAeHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Zhou <zhou.jia2@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 114/190] ALSA: core: remove redundant spin_lock pair in snd_card_disconnect
Date:   Thu, 20 May 2021 11:22:58 +0200
Message-Id: <20210520092105.963865143@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 67765c61e5d5..d0f8405fdfd8 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -403,10 +403,8 @@ int snd_card_disconnect(struct snd_card *card)
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



