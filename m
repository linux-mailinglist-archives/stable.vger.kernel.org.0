Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FB93DB59D
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 11:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhG3JDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 05:03:12 -0400
Received: from mail1.perex.cz ([77.48.224.245]:49828 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230402AbhG3JDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 05:03:11 -0400
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id 1088CA003F;
        Fri, 30 Jul 2021 11:03:05 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz 1088CA003F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1627635785; bh=esDYRbz6AalQmhVyKPdaKQ9dA13PxErSDR/m1A34si4=;
        h=From:To:Cc:Subject:Date:From;
        b=mz/iHq08wy95u48V76l+wfaHKNNSArXTzG7wJLw5dBUY8qeHOhp+NbN2IdufWHeR8
         I0AsKi+DC4IiZJfDxshMX+00y38/jWwaSsfVVKCFOr9v/9sOI76VkbiJEiv1TsGS75
         Ll2xSAjqJOOmM2bHb/zBavL6scknnh33BDKRDdcM=
Received: from p1gen2.perex-int.cz (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Fri, 30 Jul 2021 11:03:00 +0200 (CEST)
From:   Jaroslav Kysela <perex@perex.cz>
To:     ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: pcm - fix mmap capability check for the snd-dummy driver
Date:   Fri, 30 Jul 2021 11:02:54 +0200
Message-Id: <20210730090254.612478-1-perex@perex.cz>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The snd-dummy driver (fake_buffer configuration) uses the ops->page
callback for the mmap operations. Allow mmap for this case, too.

Cc: <stable@vger.kernel.org>
Fixes: c4824ae7db41 ("ALSA: pcm: Fix mmap capability check")
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
---
 sound/core/pcm_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 6a2971a7e6a1..09c0e2a6489c 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -246,7 +246,7 @@ static bool hw_support_mmap(struct snd_pcm_substream *substream)
 	if (!(substream->runtime->hw.info & SNDRV_PCM_INFO_MMAP))
 		return false;
 
-	if (substream->ops->mmap)
+	if (substream->ops->mmap || substream->ops->page)
 		return true;
 
 	switch (substream->dma_buffer.dev.type) {
-- 
2.31.1
