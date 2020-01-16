Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797C513F94C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgAPTYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgAPQwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668D524653;
        Thu, 16 Jan 2020 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193574;
        bh=KA6r6uhzWScbjS1G8ybuqW922xv9nzdxSFBb9Cr0Z7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qegqH12dvY1XY/Gw98fWlc6udRJq0biK27t9rsvyKzQ04J8OfpeRT6H+bFZ7Q39+b
         9I4HvgkGp7KEfnVjnEdiQyxM9FXmeKm0nOt1hqP9HCy3CMWYMSbZESO08SoS6sYcHC
         RVm7x4VpKY0r5bCDyFAkbYmBYIX02UMFftLciIAI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 117/205] ASoC: core: Fix compile warning with CONFIG_DEBUG_FS=n
Date:   Thu, 16 Jan 2020 11:41:32 -0500
Message-Id: <20200116164300.6705-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit bd0b609e0c3362cb167c51d4bd4330d79fc00987 ]

Paper over a compile warning:
  sound/soc/soc-pcm.c:1185:8: warning: unused variable ‘name’

Fixes: 0632fa042541 ("ASoC: core: Fix pcm code debugfs error")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20191107134833.1502-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index a6e96cf1d8ff..d07026a846b9 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1148,7 +1148,9 @@ static int dpcm_be_connect(struct snd_soc_pcm_runtime *fe,
 {
 	struct snd_soc_dpcm *dpcm;
 	unsigned long flags;
+#ifdef CONFIG_DEBUG_FS
 	char *name;
+#endif
 
 	/* only add new dpcms */
 	for_each_dpcm_be(fe, stream, dpcm) {
-- 
2.20.1

