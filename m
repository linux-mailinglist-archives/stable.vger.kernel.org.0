Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D7A171FC4
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732110AbgB0N4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:56:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732105AbgB0N4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:56:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66A462084E;
        Thu, 27 Feb 2020 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811780;
        bh=09CLZHhNHNyqqmnT9B63fYO3RiBBKa0IUbToH8AhA4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlS8Wu4G8fT+BXwM+clS12KJrSlYiD7se70si0c/8bUdhE2q5JzF2Su5oFnFF6e8m
         DqycQjlrjukv5Pv1DbD08nG/rDD7znIZF1Qbt2mQy2kaQ8jnK4InbKSNuV13rhYIxR
         kAQoy+/aUWP9CIrbfXgGsLicXBKMG9jzHR99b2Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/237] ALSA: sh: Fix unused variable warnings
Date:   Thu, 27 Feb 2020 14:35:12 +0100
Message-Id: <20200227132304.183181494@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5da116f164ce265e397b8f59af5c39e4a61d61a5 ]

Remove unused variables that are left over after the conversion of new
PCM ops:
  sound/sh/sh_dac_audio.c:166:26: warning: unused variable 'runtime'
  sound/sh/sh_dac_audio.c:186:26: warning: unused variable 'runtime'
  sound/sh/sh_dac_audio.c:205:26: warning: unused variable 'runtime'

Fixes: 1cc2f8ba0b3e ("ALSA: sh: Convert to the new PCM ops")
Link: https://lore.kernel.org/r/20200104110057.13875-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/sh/sh_dac_audio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/sh/sh_dac_audio.c b/sound/sh/sh_dac_audio.c
index 834b2574786f5..6251b5e1b64a2 100644
--- a/sound/sh/sh_dac_audio.c
+++ b/sound/sh/sh_dac_audio.c
@@ -190,7 +190,6 @@ static int snd_sh_dac_pcm_copy(struct snd_pcm_substream *substream,
 {
 	/* channel is not used (interleaved data) */
 	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-	struct snd_pcm_runtime *runtime = substream->runtime;
 
 	if (copy_from_user_toio(chip->data_buffer + pos, src, count))
 		return -EFAULT;
@@ -210,7 +209,6 @@ static int snd_sh_dac_pcm_copy_kernel(struct snd_pcm_substream *substream,
 {
 	/* channel is not used (interleaved data) */
 	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-	struct snd_pcm_runtime *runtime = substream->runtime;
 
 	memcpy_toio(chip->data_buffer + pos, src, count);
 	chip->buffer_end = chip->data_buffer + pos + count;
@@ -229,7 +227,6 @@ static int snd_sh_dac_pcm_silence(struct snd_pcm_substream *substream,
 {
 	/* channel is not used (interleaved data) */
 	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-	struct snd_pcm_runtime *runtime = substream->runtime;
 
 	memset_io(chip->data_buffer + pos, 0, count);
 	chip->buffer_end = chip->data_buffer + pos + count;
-- 
2.20.1



