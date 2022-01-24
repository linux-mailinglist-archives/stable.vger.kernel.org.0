Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FED49A8E3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381480AbiAYDRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349532AbiAXTUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:20:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DA3C061787;
        Mon, 24 Jan 2022 11:07:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02BCEB811F9;
        Mon, 24 Jan 2022 19:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1793BC340E5;
        Mon, 24 Jan 2022 19:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051267;
        bh=1WH8nMsyTmBCT0CINOhWGaYMGMaXc0HjjN3TTcQlxqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w64wgXtc6Ur//qozsHpjAV5SjFdGI9XoHGCCsXRHRTkXSj3rJIW4jsoZJit9qypVF
         Gxwf7o8QDOuF9wwSgxCOHk5e8KiBH4aQGXsYk/y43ozBy8vuded8aHp4JuuU0LaGQl
         /HTMk/75mL1f6KN3vEx2IB4KWcIQM4WZsrvctc4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bixuan Cui <cuibixuan@linux.alibaba.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/186] ALSA: oss: fix compile error when OSS_DEBUG is enabled
Date:   Mon, 24 Jan 2022 19:42:29 +0100
Message-Id: <20220124183939.504425996@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@linux.alibaba.com>

[ Upstream commit 8e7daf318d97f25e18b2fc7eb5909e34cd903575 ]

Fix compile error when OSS_DEBUG is enabled:
    sound/core/oss/pcm_oss.c: In function 'snd_pcm_oss_set_trigger':
    sound/core/oss/pcm_oss.c:2055:10: error: 'substream' undeclared (first
    use in this function); did you mean 'csubstream'?
      pcm_dbg(substream->pcm, "pcm_oss: trigger = 0x%x\n", trigger);
              ^

Fixes: 61efcee8608c ("ALSA: oss: Use standard printk helpers")
Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
Link: https://lore.kernel.org/r/1638349134-110369-1-git-send-email-cuibixuan@linux.alibaba.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/pcm_oss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index b092f257c1c69..87806dab321a3 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2070,7 +2070,7 @@ static int snd_pcm_oss_set_trigger(struct snd_pcm_oss_file *pcm_oss_file, int tr
 	int err, cmd;
 
 #ifdef OSS_DEBUG
-	pcm_dbg(substream->pcm, "pcm_oss: trigger = 0x%x\n", trigger);
+	pr_debug("pcm_oss: trigger = 0x%x\n", trigger);
 #endif
 	
 	psubstream = pcm_oss_file->streams[SNDRV_PCM_STREAM_PLAYBACK];
-- 
2.34.1



