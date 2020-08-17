Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE6B2469D0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbgHQP0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgHQP00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BB523718;
        Mon, 17 Aug 2020 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677986;
        bh=VJbg8hMm8UosYBUqGXvPNUZUBrnWT/iWfgBsybH5Ap8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAGjVxeB2Ol8ESeSpSvxpHMnKFMu7R93orW0CYV7QV1YaA2ZW85RqO7FgTNgW/3Ub
         H2eCt/DOKp8PTYBfjIkoHDDsroBFnazE5EsnfvPYTICo9TkPhxHeM95zARA1YSoO/M
         Kx9Y2+UEXTVniDfnZoFIXASq8HHgfRkDjKvVAmw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 179/464] ASoC: Intel: sof_sdw: add missing .owner field
Date:   Mon, 17 Aug 2020 17:12:12 +0200
Message-Id: <20200817143842.394445387@linuxfoundation.org>
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

[ Upstream commit fb4b42f68972d6bc905c8b6e21a43a490dedfca7 ]

This field is required for ASoC cards. Not setting it will result in a
module->name pointer being NULL and generate problems such as

cat /proc/asound/modules
 0 (efault)

Fixes: 52db12d193d4 ('ASoC: Intel: boards: add sof_sdw machine driver')
Reported-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200625191308.3322-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index e1c1a8ba78e62..1bfd9613449e9 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -893,6 +893,7 @@ static const char sdw_card_long_name[] = "Intel Soundwire SOF";
 
 static struct snd_soc_card card_sof_sdw = {
 	.name = "soundwire",
+	.owner = THIS_MODULE,
 	.late_probe = sof_sdw_hdmi_card_late_probe,
 	.codec_conf = codec_conf,
 	.num_configs = ARRAY_SIZE(codec_conf),
-- 
2.25.1



