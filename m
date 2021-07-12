Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1343C4AA6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbhGLGxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240098AbhGLGuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7496161006;
        Mon, 12 Jul 2021 06:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072465;
        bh=nx+CTs1gCp4wWb9O/EGCs3lNrHrVYeQ5m2jv+ueYaoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsFr8jun2TMtw/WQc68cGuX5RpaAZMhKJzWn24Ql48CaClo/gXZYiLEQsH5H83iJM
         kKMF5+DhBZr2L2yhxflQRhWIeR9zIEfdZqtghvGqmPat7tKxM4j1GVzese+n85a7Lb
         V4DtQ+w7kG7CNFEGPUJDoIGlh8bVBkjlrq6tUfQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/593] ASoC: rt711-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:05 +0200
Message-Id: <20210712060947.267438157@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a0897ebca669f09a2e02206a9c48a738af655329 ]

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
Fixes: 320b8b0d13b81 ('ASoC: rt711: add rt711 codec driver')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-9-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt711-sdw.c b/sound/soc/codecs/rt711-sdw.c
index f0a0691bd31c..eb54e90c1c60 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -500,7 +500,7 @@ static int __maybe_unused rt711_dev_resume(struct device *dev)
 	struct rt711_priv *rt711 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt711->hw_init)
+	if (!rt711->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
-- 
2.30.2



