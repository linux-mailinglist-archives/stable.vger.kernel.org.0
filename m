Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB11A56DC
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgDKXSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730657AbgDKXOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9991821973;
        Sat, 11 Apr 2020 23:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646844;
        bh=kz4aik7AaZKvs4fI9Ltirklw5+Y51jzFfOY+3UvPsGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No0Cvf9WCy0EAw/+8fNtYJDIISZ/hnlLuV3IEGzbiLCCPCjE7eCdfdpfGhh7/SCCv
         yOlEHX2x8LuNd4BJuguh7m0s65QNQHxwHBoGFt19MBzCiVcWbruflg4KX8JCXvkSJI
         fzIWCoiC1sBg/uboh0Ok15N83wZK1A+7DTQXYFeg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 31/37] ASoC: Intel: Skylake: Enable codec wakeup during chip init
Date:   Sat, 11 Apr 2020 19:13:20 -0400
Message-Id: <20200411231327.26550-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit e603f11d5df8997d104ab405ff27640b90baffaa ]

Follow the recommendation set by hda_intel.c and enable HDMI/DP codec
wakeup during bus initialization procedure. Disable wakeup once init
completes.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200305145314.32579-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index a0bef63b8fb11..7fb4df78ecb35 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -103,9 +103,11 @@ static int skl_init_chip(struct hdac_bus *bus, bool full_reset)
 {
 	int ret;
 
+	snd_hdac_set_codec_wakeup(bus, true);
 	skl_enable_miscbdcge(bus->dev, false);
 	ret = snd_hdac_bus_init_chip(bus, full_reset);
 	skl_enable_miscbdcge(bus->dev, true);
+	snd_hdac_set_codec_wakeup(bus, false);
 
 	return ret;
 }
-- 
2.20.1

