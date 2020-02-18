Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661511631A4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgBRUBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbgBRUBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4292465D;
        Tue, 18 Feb 2020 20:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056107;
        bh=m5DX8gbNn2LYAQ6ON+TrHhlZmgkiUPrhN0fjPaqhjnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEbjcPTVE50za0/5+NAI9a8VjFbP7mf0saXGPTBpzdYi0JBsHUWHAvJ1kr2GwFVcq
         h9bxLDaYoqJUlvcjWd73aqEC3luXBHFJOL4FV8FZgBwITPPwWDCjKb2gnY67GDnYaR
         p4HevF/84bKyCNEW2qFZ50jYr12Tt2waabvu9cqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 08/80] ALSA: pcm: Fix double hw_free calls
Date:   Tue, 18 Feb 2020 20:54:29 +0100
Message-Id: <20200218190432.872521894@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0fbb027b44e79700da80e4b8bd1c1914d4796af6 upstream.

The commit 66f2d19f8116 ("ALSA: pcm: Fix memory leak at closing a
stream without hw_free") tried to fix the regression wrt the missing
hw_free call at closing without SNDRV_PCM_IOCTL_HW_FREE ioctl.
However, the code change dropped mistakenly the state check, resulting
in calling hw_free twice when SNDRV_PCM_IOCTL_HW_FRE got called
beforehand.  For most drivers, this is almost harmless, but the
drivers like SOF show another regression now.

This patch adds the state condition check before calling do_hw_free()
at releasing the stream for avoiding the double hw_free calls.

Fixes: 66f2d19f8116 ("ALSA: pcm: Fix memory leak at closing a stream without hw_free")
Reported-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/s5hd0ajyprg.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_native.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2474,7 +2474,8 @@ void snd_pcm_release_substream(struct sn
 
 	snd_pcm_drop(substream);
 	if (substream->hw_opened) {
-		do_hw_free(substream);
+		if (substream->runtime->status->state != SNDRV_PCM_STATE_OPEN)
+			do_hw_free(substream);
 		substream->ops->close(substream);
 		substream->hw_opened = 0;
 	}


