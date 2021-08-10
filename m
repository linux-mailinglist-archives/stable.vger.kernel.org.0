Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D333E8188
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhHJSAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236166AbhHJRzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:55:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4CF6113C;
        Tue, 10 Aug 2021 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617494;
        bh=hDWi11sJfcOlWySAbTNanelCHGUfGD085xvsx3AB2H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFnvraB2YCRS6gplX+OA22oDdFUZ9PgcsXuAY9qQsxq21drJn+tW5FfIwNGR34ZtP
         Ql4b/m4iKeuTU12vxiKOpocXilD67rLw0pHLDnUPfq3S0+DrFxRfQo/mK6eKZ8NnfR
         zNRg1eIL1DQT8dwMrTTkY/PspgjupasmUSqxDpPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 083/175] ALSA: pcm - fix mmap capability check for the snd-dummy driver
Date:   Tue, 10 Aug 2021 19:29:51 +0200
Message-Id: <20210810173003.676139587@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 852a8a97776a153be2e6c803218eced45f37a19c upstream.

The snd-dummy driver (fake_buffer configuration) uses the ops->page
callback for the mmap operations. Allow mmap for this case, too.

Cc: <stable@vger.kernel.org>
Fixes: c4824ae7db41 ("ALSA: pcm: Fix mmap capability check")
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20210730090254.612478-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -246,7 +246,7 @@ static bool hw_support_mmap(struct snd_p
 	if (!(substream->runtime->hw.info & SNDRV_PCM_INFO_MMAP))
 		return false;
 
-	if (substream->ops->mmap)
+	if (substream->ops->mmap || substream->ops->page)
 		return true;
 
 	switch (substream->dma_buffer.dev.type) {


