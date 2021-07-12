Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B1E3C4F9B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243826AbhGLH0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344872AbhGLHYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:24:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D969A611AF;
        Mon, 12 Jul 2021 07:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074498;
        bh=ZRvzb0/Kb99A3CPDuHTrJxsgCC0PldrH005685a9QjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJTkpEhw6MSGjYrSL2MFJOXx6qsqYtHgYxIp4BaB26frgwXAx3eB5wU++LiGh8G1Z
         NNAFzcHGrVL3wkPri8Qw3CCesJvedGle2TqJcQbaEsTHN14JlB9u31C7d+fQ903CAO
         8hR8pahrmbKKg6PfjZs0bU3Jz2lYdORiIu3bkSe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 600/700] ASoC: rt700-sdw: use first_hw_init flag on resume
Date:   Mon, 12 Jul 2021 08:11:23 +0200
Message-Id: <20210712061039.759023193@linuxfoundation.org>
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

[ Upstream commit a9e54e5fbe396b546771cf77b43ce7c75e212278 ]

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
Fixes: 7d2a5f9ae41e3 ('ASoC: rt700: add rt700 codec driver')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt700-sdw.c b/sound/soc/codecs/rt700-sdw.c
index 4001612dfd73..fc6299a6022d 100644
--- a/sound/soc/codecs/rt700-sdw.c
+++ b/sound/soc/codecs/rt700-sdw.c
@@ -498,7 +498,7 @@ static int __maybe_unused rt700_dev_resume(struct device *dev)
 	struct rt700_priv *rt700 = dev_get_drvdata(dev);
 	unsigned long time;
 
-	if (!rt700->hw_init)
+	if (!rt700->first_hw_init)
 		return 0;
 
 	if (!slave->unattach_request)
-- 
2.30.2



