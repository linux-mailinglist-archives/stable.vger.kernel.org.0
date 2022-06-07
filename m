Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4C65419FB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378617AbiFGV13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378941AbiFGVZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DF0227CEE;
        Tue,  7 Jun 2022 12:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E978E61787;
        Tue,  7 Jun 2022 19:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4091C385A2;
        Tue,  7 Jun 2022 19:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628484;
        bh=+hczqrVV9QRUroM1CK7I7IRBPGHFmeEUds3FThURv7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBT/phw+i57k7PnKxod6J7JDPPHmpM2LkhZ0hGwt3sV7snAfWuNrEFmOQKjqdkCAV
         d35Qc4X5LawFk4ALHnvVqMz17FkT3h54th7FuW6ovSYJx4BJYd2wnBG8ciDq+AAqD3
         lN2ofmbQAI3iwJfVXTy7qC2QJoazLlUMfP1ihdoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 346/879] ALSA: pcm: Check for null pointer of pointer substream before dereferencing it
Date:   Tue,  7 Jun 2022 18:57:44 +0200
Message-Id: <20220607165012.904143979@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 8848d2f3160d..b8296b6eb2c1 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -453,7 +453,6 @@ EXPORT_SYMBOL(snd_pcm_lib_malloc_pages);
  */
 int snd_pcm_lib_free_pages(struct snd_pcm_substream *substream)
 {
-	struct snd_card *card = substream->pcm->card;
 	struct snd_pcm_runtime *runtime;
 
 	if (PCM_RUNTIME_CHECK(substream))
@@ -462,6 +461,8 @@ int snd_pcm_lib_free_pages(struct snd_pcm_substream *substream)
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



