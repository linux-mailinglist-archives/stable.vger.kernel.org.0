Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6B74E7727
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376563AbiCYP1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376951AbiCYPXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:23:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC1B9D06D;
        Fri, 25 Mar 2022 08:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 575A060C86;
        Fri, 25 Mar 2022 15:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8AEC340E9;
        Fri, 25 Mar 2022 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221418;
        bh=bOkJy+mMiLrQcWXHlmJVF/rdsYha53wcln9168+rGTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFchtC3onO8nblxevVfGwueYpyWgIFsK3ePQxmEKrLJ/xanavqtEK70d/zBnjsKuy
         ZkKDMQLq/Q75A99cWyPRaDj2h7gO02EA8x6cQ1oI5U4KJ4ofrB2764RJPLiLaOGM0z
         Es+mpoFasJivkdtTJ6sZDCauS1CkVNZmD7m9Cm1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Palmer <daniel@0x0f.com>,
        Arnaud POULIQUEN <arnaud.pouliquen@st.com>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 03/37] ASoC: sti: Fix deadlock via snd_pcm_stop_xrun() call
Date:   Fri, 25 Mar 2022 16:14:13 +0100
Message-Id: <20220325150420.147141772@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 455c5653f50e10b4f460ef24e99f0044fbe3401c upstream.

This is essentially a revert of the commit dc865fb9e7c2 ("ASoC: sti:
Use snd_pcm_stop_xrun() helper"), which converted the manual
snd_pcm_stop() calls with snd_pcm_stop_xrun().

The commit above introduced a deadlock as snd_pcm_stop_xrun() itself
takes the PCM stream lock while the caller already holds it.  Since
the conversion was done only for consistency reason and the open-call
with snd_pcm_stop() to the XRUN state is a correct usage, let's revert
the commit back as the fix.

Fixes: dc865fb9e7c2 ("ASoC: sti: Use snd_pcm_stop_xrun() helper")
Reported-by: Daniel Palmer <daniel@0x0f.com>
Cc: Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220315091319.3351522-1-daniel@0x0f.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20220315164158.19804-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sti/uniperif_player.c |    6 +++---
 sound/soc/sti/uniperif_reader.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/sti/uniperif_player.c
+++ b/sound/soc/sti/uniperif_player.c
@@ -91,7 +91,7 @@ static irqreturn_t uni_player_irq_handle
 			SET_UNIPERIF_ITM_BCLR_FIFO_ERROR(player);
 
 			/* Stop the player */
-			snd_pcm_stop_xrun(player->substream);
+			snd_pcm_stop(player->substream, SNDRV_PCM_STATE_XRUN);
 		}
 
 		ret = IRQ_HANDLED;
@@ -105,7 +105,7 @@ static irqreturn_t uni_player_irq_handle
 		SET_UNIPERIF_ITM_BCLR_DMA_ERROR(player);
 
 		/* Stop the player */
-		snd_pcm_stop_xrun(player->substream);
+		snd_pcm_stop(player->substream, SNDRV_PCM_STATE_XRUN);
 
 		ret = IRQ_HANDLED;
 	}
@@ -138,7 +138,7 @@ static irqreturn_t uni_player_irq_handle
 		dev_err(player->dev, "Underflow recovery failed\n");
 
 		/* Stop the player */
-		snd_pcm_stop_xrun(player->substream);
+		snd_pcm_stop(player->substream, SNDRV_PCM_STATE_XRUN);
 
 		ret = IRQ_HANDLED;
 	}
--- a/sound/soc/sti/uniperif_reader.c
+++ b/sound/soc/sti/uniperif_reader.c
@@ -65,7 +65,7 @@ static irqreturn_t uni_reader_irq_handle
 	if (unlikely(status & UNIPERIF_ITS_FIFO_ERROR_MASK(reader))) {
 		dev_err(reader->dev, "FIFO error detected\n");
 
-		snd_pcm_stop_xrun(reader->substream);
+		snd_pcm_stop(reader->substream, SNDRV_PCM_STATE_XRUN);
 
 		ret = IRQ_HANDLED;
 	}


