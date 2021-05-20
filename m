Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9C38A956
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbhETLBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238971AbhETK5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:57:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26CC861CF3;
        Thu, 20 May 2021 10:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504923;
        bh=YbVIz8Ibv02Yvf0tb5GKbY4pMdqT6P027w+wWsILNAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc0zNIjbyByh2k8UdfbkLFMNf7OFEan7HsyR8yMMkamdXCQPInZIzZ14TlQg/jSVv
         G9B+eIzzJEvdqNuSU8oetT2fbMwnyaC2fcSqVdYnoYxxOBycFHLC/MFWc/sHP9CtgU
         MGC1/UOcpgPo7bqImXG4yesU9AWiT3eFGIq6/r8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Zhou <zhou.jia2@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 141/240] ALSA: core: remove redundant spin_lock pair in snd_card_disconnect
Date:   Thu, 20 May 2021 11:22:13 +0200
Message-Id: <20210520092113.380345776@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 02e96c580cb7..59377e579adb 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -406,10 +406,8 @@ int snd_card_disconnect(struct snd_card *card)
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



