Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52332469D3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgHQP0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729406AbgHQP03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C78523159;
        Mon, 17 Aug 2020 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677988;
        bh=AWzTDOSp9902vFeSTzQeewOWoyM76XLWejNu5KwIUE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6voz3uAAGvd6IDmiu1a4shB+xStVkHvwQIP9+s7a+jR6tdjZWBEUsIuzanAgKcX/
         gyVBsLiSQ51lBHUMoR5d00WgenKT3FiQncTB0qectR7AtxDao9ZjRP0nJ+07fhCQ9c
         hNCXZeKkKz2pF/3Xs0UItYUiwk07rMkOLxRWo0VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 180/464] ASoC: Intel: bxt_rt298: add missing .owner field
Date:   Mon, 17 Aug 2020 17:12:13 +0200
Message-Id: <20200817143842.438461313@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 88cee34b776f80d2da04afb990c2a28c36799c43 ]

This field is required for ASoC cards. Not setting it will result in a
module->name pointer being NULL and generate problems such as

cat /proc/asound/modules
 0 (efault)

Fixes: 76016322ec56 ('ASoC: Intel: Add Broxton-P machine driver')
Reported-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200625191308.3322-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bxt_rt298.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/bxt_rt298.c b/sound/soc/intel/boards/bxt_rt298.c
index 7a4decf341918..c84c60df17dbc 100644
--- a/sound/soc/intel/boards/bxt_rt298.c
+++ b/sound/soc/intel/boards/bxt_rt298.c
@@ -565,6 +565,7 @@ static int bxt_card_late_probe(struct snd_soc_card *card)
 /* broxton audio machine driver for SPT + RT298S */
 static struct snd_soc_card broxton_rt298 = {
 	.name = "broxton-rt298",
+	.owner = THIS_MODULE,
 	.dai_link = broxton_rt298_dais,
 	.num_links = ARRAY_SIZE(broxton_rt298_dais),
 	.controls = broxton_controls,
@@ -580,6 +581,7 @@ static struct snd_soc_card broxton_rt298 = {
 
 static struct snd_soc_card geminilake_rt298 = {
 	.name = "geminilake-rt298",
+	.owner = THIS_MODULE,
 	.dai_link = broxton_rt298_dais,
 	.num_links = ARRAY_SIZE(broxton_rt298_dais),
 	.controls = broxton_controls,
-- 
2.25.1



