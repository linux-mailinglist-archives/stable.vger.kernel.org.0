Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9B3289D6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhCASG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239227AbhCAR7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:59:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF4976524D;
        Mon,  1 Mar 2021 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619675;
        bh=8OHyZyUzFVh/ELW1UiG+7dTWtN9HwcthoW9RT05Iy2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3/i4h9uRUWGzG6wJRlFr1LZAFPoLmKfbDJCgJxb/GAYjdjibyy86A4O6WLB/myOI
         EbrNv90hZu1xz6wyTZStHxcfNgucaidKFhiR/ptSLskHolmMfD78xkzHsuX6H7F0Sj
         i3u1wFrz21yY+swSBzoMLJwXj16LuwieEWjgdc4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 523/663] ASoC: siu: Fix build error by a wrong const prefix
Date:   Mon,  1 Mar 2021 17:12:51 +0100
Message-Id: <20210301161207.717952087@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ae07f5c7c5e9ebca5b9d6471bb4b99a9da5c6d88 upstream.

A const prefix was put wrongly in the middle at the code refactoring
commit 932eaf7c7904 ("ASoC: sh: siu_pcm: remove snd_pcm_ops"), which
leads to a build error as:
  sound/soc/sh/siu_pcm.c:546:8: error: expected '{' before 'const'

Also, another inconsistency is that the declaration of siu_component
misses the const prefix.

This patch corrects both failures.

Fixes: 932eaf7c7904 ("ASoC: sh: siu_pcm: remove snd_pcm_ops")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210126154702.3974-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sh/siu.h     |    2 +-
 sound/soc/sh/siu_pcm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/sh/siu.h
+++ b/sound/soc/sh/siu.h
@@ -169,7 +169,7 @@ static inline u32 siu_read32(u32 __iomem
 #define SIU_BRGBSEL	(0x108 / sizeof(u32))
 #define SIU_BRRB	(0x10c / sizeof(u32))
 
-extern struct snd_soc_component_driver siu_component;
+extern const struct snd_soc_component_driver siu_component;
 extern struct siu_info *siu_i2s_data;
 
 int siu_init_port(int port, struct siu_port **port_info, struct snd_card *card);
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -543,7 +543,7 @@ static void siu_pcm_free(struct snd_soc_
 	dev_dbg(pcm->card->dev, "%s\n", __func__);
 }
 
-struct const snd_soc_component_driver siu_component = {
+const struct snd_soc_component_driver siu_component = {
 	.name		= DRV_NAME,
 	.open		= siu_pcm_open,
 	.close		= siu_pcm_close,


