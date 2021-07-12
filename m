Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D133C5565
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355647AbhGLIKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353577AbhGLICg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3514461CC1;
        Mon, 12 Jul 2021 07:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076554;
        bh=esk09oZcbN0idloauH1h0UliJR4S1QsTKJ7Deu4x8D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxApPjuaZ+2mNQwvkJLZEE9TVgKtp3LpsBtA9F/Jn2YWvffdq7WF21mueNRlKP1m/
         hwtOfdSuaLPrDaTSyjNcrRIi/BvmoBhE9g7mQNi5y4KVvZoL2bAhiNsZJeJRRthBn9
         qFw4GUSPlMNfRmNzzy2jhoWSXIW7CFdx+9v5IgVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 692/800] ASoC: rt715-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:55 +0200
Message-Id: <20210712061040.455349421@linuxfoundation.org>
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

[ Upstream commit dbc07517ab173688ef11234d1099bc1e24e4f14b ]

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
Fixes: d1ede0641b05e ('ASoC: rt715: add RT715 codec driver')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-11-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt715-sdw.c b/sound/soc/codecs/rt715-sdw.c
index 81a1dd77b6f6..a7b21b03c08b 100644
--- a/sound/soc/codecs/rt715-sdw.c
+++ b/sound/soc/codecs/rt715-sdw.c
@@ -541,7 +541,7 @@ static int __maybe_unused rt715_dev_resume(struct device *dev)
 	struct rt715_priv *rt715 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt715->hw_init)
+	if (!rt715->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
-- 
2.30.2



