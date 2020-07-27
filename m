Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7901022F0BE
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbgG0O1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730001AbgG0O0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9030220663;
        Mon, 27 Jul 2020 14:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859973;
        bh=+ugu/tNF/pHt3udlHuscPoyBo9goacPReY2N/k7oBBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOv4vbJ11pKZJurAZErnHuFeSAARQOPkld4piEe+QJpqrqY8cPEJWb/yO5eGNwshU
         sS2BEbCjnV9BIV2iPz9JT78cW43tt1KkzJVIdhChwU4MIZlrSVtLKl5HHOAMgXhhUd
         5BviJcEnwN56dyJTgCkhbDF76+iEbYxpyV48zFhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Curtis Malainey <curtis@malainey.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.7 176/179] ASoC: Intel: bdw-rt5677: fix non BE conversion
Date:   Mon, 27 Jul 2020 16:05:51 +0200
Message-Id: <20200727134941.229904990@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit fffebe8a8339c7e56db4126653a3bc0c0c5592cf upstream.

When SOF is used, the normal links are converted into DPCM ones. This
generates an error

[ 58.276668] bdw-rt5677 bdw-rt5677: CPU DAI spi-RT5677AA:00 for rtd
Wake on Voice does not support playback
[ 58.276676] bdw-rt5677 bdw-rt5677: ASoC: can't create pcm Wake on
Voice :-22

Fix by forcing the capture direction.

Fixes: b73287f0b0745 ('ASoC: soc-pcm: dpcm: fix playback/capture checks')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Curtis Malainey <curtis@malainey.com>
Link: https://lore.kernel.org/r/20200707210439.115300-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/boards/bdw-rt5677.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/intel/boards/bdw-rt5677.c
+++ b/sound/soc/intel/boards/bdw-rt5677.c
@@ -328,6 +328,7 @@ static struct snd_soc_dai_link bdw_rt567
 	{
 		.name = "Codec DSP",
 		.stream_name = "Wake on Voice",
+		.capture_only = 1,
 		.ops = &bdw_rt5677_dsp_ops,
 		SND_SOC_DAILINK_REG(dsp),
 	},


