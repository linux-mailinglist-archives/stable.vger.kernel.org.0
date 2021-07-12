Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C312F3C555C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355609AbhGLIJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353555AbhGLICe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E37B761CCA;
        Mon, 12 Jul 2021 07:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076538;
        bh=FnvRDjWdHqXKilpbFTReWHP+mb+zE0shfipgN28g0/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6nnP3QE8r5mYYspC3HtL7Y/VJiVP3z9wExFziE6iPZx39xRLM7UlFxyRq7giPwYo
         z9c8U32giiXgbWzsxrcGq78GOeOqoS8NAnlReeb6NFFIE+6VGakySzp3B7yMuxLqY5
         UoZ3hjbMe1EMf3Ta+WYjkNIVbBBXnZyP7HJ+X92E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 685/800] ASoC: rt1308-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:48 +0200
Message-Id: <20210712061039.707356807@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 30e102dab5fad1db71684f8ac5e1ac74e49da06d ]

The intent of the status check on resume was to verify if a SoundWire
peripheral reported ATTACHED before waiting for the initialization to
complete. This is required to avoid timeouts that will happen with
'ghost' devices that are exposed in the platform firmware but are not
populated in hardware.

Unfortunately we used 'hw_init' instead of 'first_hw_init'. Due to
another error, the resume operation never timed out, but the volume
settings were not properly restored.

BugLink: https://github.com/thesofproject/linux/issues/2908
BugLink: https://github.com/thesofproject/linux/issues/2637
Fixes: a87a6653a28c0 ('ASoC: rt1308-sdw: add rt1308 SdW amplifier driver')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1308-sdw.c b/sound/soc/codecs/rt1308-sdw.c
index 1c226994aebd..f716668de640 100644
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -709,7 +709,7 @@ static int __maybe_unused rt1308_dev_resume(struct device *dev)
 	struct rt1308_sdw_priv *rt1308 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt1308->hw_init)
+	if (!rt1308->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
-- 
2.30.2



