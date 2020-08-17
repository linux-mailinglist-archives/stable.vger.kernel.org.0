Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4262469D1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbgHQP0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729810AbgHQP0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 370DF22DBF;
        Mon, 17 Aug 2020 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677982;
        bh=IGN/m2EtxKNoYYRaJtEqHcO+yM2lpVJRF/occyqOmt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTKw7V4piBWiIAVtyv99ZYJ+3LZNs7DnsGvHbftg0pJPKwbNm8JEVRIMGGi0MaUBj
         HRPHdkedwhZeMsOcTIKw4Fe6nLE7DAxqbrKcO2blRXMntmqjpkngFUukva0JWcL2V8
         5e82+0LrAu3SupVf9Is4Skxi74/NHQbQ8MWhYDc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 178/464] ASoC: Intel: cml_rt1011_rt5682: add missing .owner field
Date:   Mon, 17 Aug 2020 17:12:11 +0200
Message-Id: <20200817143842.347180590@linuxfoundation.org>
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

[ Upstream commit 299120928897d6cb893c7165df7cd232d835e259 ]

This field is required for ASoC cards. Not setting it will result in a
module->name pointer being NULL and generate problems such as

cat /proc/asound/modules
 0 (efault)

Fixes: 17fe95d6df93 ('ASoC: Intel: boards: Add CML m/c using RT1011 and RT5682')
Reported-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200625191308.3322-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/cml_rt1011_rt5682.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/cml_rt1011_rt5682.c b/sound/soc/intel/boards/cml_rt1011_rt5682.c
index 68eff29daf8f8..6f89b50a8c8ff 100644
--- a/sound/soc/intel/boards/cml_rt1011_rt5682.c
+++ b/sound/soc/intel/boards/cml_rt1011_rt5682.c
@@ -493,6 +493,7 @@ static struct snd_soc_codec_conf rt1011_conf[] = {
 /* Cometlake audio machine driver for RT1011 and RT5682 */
 static struct snd_soc_card snd_soc_card_cml = {
 	.name = "cml_rt1011_rt5682",
+	.owner = THIS_MODULE,
 	.dai_link = cml_rt1011_rt5682_dailink,
 	.num_links = ARRAY_SIZE(cml_rt1011_rt5682_dailink),
 	.codec_conf = rt1011_conf,
-- 
2.25.1



