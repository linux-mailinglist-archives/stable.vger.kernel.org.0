Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23962C09A3
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387734AbgKWNJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732268AbgKWMrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E147208FE;
        Mon, 23 Nov 2020 12:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135666;
        bh=jFH0vNW4SvmfFqsGlzsYIiRi4DO2mfVHZFyRorzZ5JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BReaNL0sauMWy/vFNCvK4Heac+n4A5Sqbe/fUN9tGCcJaQb3mlrPE8Wclp4wzERwH
         mE6mw2x1ocv7HzgYeBz8SysRNJqvkinzYqxWvjjen0RRVESp0kvM/yknoS1j0/y8mY
         YfS40hBr+laMcNEA+KjzUtuwJwzHBgY6/n2YDvSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 144/252] ASoC: Intel: KMB: Fix S24_LE configuration
Date:   Mon, 23 Nov 2020 13:21:34 +0100
Message-Id: <20201123121842.545811832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

[ Upstream commit 1bd7b0fc0165694897b7d2fb39751a07b98f6bf1 ]

S24_LE is 24 bit audio in 32 bit container configuration
Fixing the configuration to match the data arrangement of
this audio format.

Fixes: c5477e966728 ("ASoC: Intel: Add KeemBay platform driver")

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20201116061905.32431-2-michael.wei.hong.sit@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/keembay/kmb_platform.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/keembay/kmb_platform.c b/sound/soc/intel/keembay/kmb_platform.c
index 16f9fc4c663d1..49079da5c4065 100644
--- a/sound/soc/intel/keembay/kmb_platform.c
+++ b/sound/soc/intel/keembay/kmb_platform.c
@@ -455,9 +455,9 @@ static int kmb_dai_hw_params(struct snd_pcm_substream *substream,
 		kmb_i2s->xfer_resolution = 0x02;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
-		config->data_width = 24;
-		kmb_i2s->ccr = 0x08;
-		kmb_i2s->xfer_resolution = 0x04;
+		config->data_width = 32;
+		kmb_i2s->ccr = 0x14;
+		kmb_i2s->xfer_resolution = 0x05;
 		break;
 	case SNDRV_PCM_FORMAT_S32_LE:
 		config->data_width = 32;
-- 
2.27.0



