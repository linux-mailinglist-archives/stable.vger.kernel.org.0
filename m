Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA535405D7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346859AbiFGRcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347404AbiFGRan (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317BC1109BA;
        Tue,  7 Jun 2022 10:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71310CE21CD;
        Tue,  7 Jun 2022 17:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FDDC385A5;
        Tue,  7 Jun 2022 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622793;
        bh=uD3kUOkQq+jybqex1hsntI82/ulhgLwlE89synK6EKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPhpahdBratiuYK3akUEUGixozf9Zcb0sTGcYXloVu/hgPbyzY0C6cD9p7paYL/BP
         oS8m78/gFSC9kJ4TRj8/OFt6Yf1wHH8QyzI08BnqZnRoKLi6ZgmsHANrobeLG9xxB/
         2AfQSAU7kneuKlckHKAepfm+Z3BvYbdK9a/dLZkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/452] ALSA: pcm: Check for null pointer of pointer substream before dereferencing it
Date:   Tue,  7 Jun 2022 19:00:15 +0200
Message-Id: <20220607164913.268195102@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 011b559be832194f992f73d6c0d5485f5925a10b ]

Pointer substream is being dereferenced on the assignment of pointer card
before substream is being null checked with the macro PCM_RUNTIME_CHECK.
Although PCM_RUNTIME_CHECK calls BUG_ON, it still is useful to perform the
the pointer check before card is assigned.

Fixes: d4cfb30fce03 ("ALSA: pcm: Set per-card upper limit of PCM buffer allocations")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://lore.kernel.org/r/20220424205945.1372247-1-colin.i.king@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index a9a0d74f3165..191883842a35 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -434,7 +434,6 @@ EXPORT_SYMBOL(snd_pcm_lib_malloc_pages);
  */
 int snd_pcm_lib_free_pages(struct snd_pcm_substream *substream)
 {
-	struct snd_card *card = substream->pcm->card;
 	struct snd_pcm_runtime *runtime;
 
 	if (PCM_RUNTIME_CHECK(substream))
@@ -443,6 +442,8 @@ int snd_pcm_lib_free_pages(struct snd_pcm_substream *substream)
 	if (runtime->dma_area == NULL)
 		return 0;
 	if (runtime->dma_buffer_p != &substream->dma_buffer) {
+		struct snd_card *card = substream->pcm->card;
+
 		/* it's a newly allocated buffer.  release it now. */
 		do_free_pages(card, runtime->dma_buffer_p);
 		kfree(runtime->dma_buffer_p);
-- 
2.35.1



