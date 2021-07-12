Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C4E3C4F9A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbhGLH0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344344AbhGLHY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:24:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAEAB611BF;
        Mon, 12 Jul 2021 07:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074495;
        bh=6LNJOtjPeyIpFsciVlh6aA0rkX1BxdhSzZCEzcCCRDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cd7nb0z5sFF+u7k92LNqX9jfLfGlXgwHWSKtPr3vqjOPgX7wJIvMkIcv5WefRR6vG
         t10dQZ1NlpQsb51rkmowf5LHRsJchytQm/vxppf/afgNRuTARR7dbbrxaFWzYNDddG
         Ykjfl5UqoZm/VKw6OOzFBBaVgTSHAKE3norWUDKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 599/700] ASoC: rt5682-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:22 +0200
Message-Id: <20210712061039.661025860@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 5361a42114689f875a9748299cadb4b1adbee6f4 ]

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
Fixes: 03f6fc6de9192 ('ASoC: rt5682: Add the soundwire support')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index d1dd7f720ba4..6bf1b4c31296 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -743,7 +743,7 @@ static int __maybe_unused rt5682_dev_resume(struct device *dev)
 	struct rt5682_priv *rt5682 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt5682->hw_init)
+	if (!rt5682->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
-- 
2.30.2



