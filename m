Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AD53ED603
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbhHPNQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239777AbhHPNOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E409B632C2;
        Mon, 16 Aug 2021 13:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119495;
        bh=vzf6VxPSQuSCdFHx85d/bzenVI6YU+/X7QK7TR/+tfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKhUrv/wo88xDHRMynQu02CC6+GhppLhHyvXeEhCw9YeLSt5qY2NFb7HCdZ8K6njJ
         80RR2S2O1eHoJMFcDkSP9xFszrXRRC6DvuyOtuekF9NXRwycIh0NVt//0wx4lDeAI0
         3NUCiD8VeryDKBRodfaoBd7oC+g5l0qEwU/t5enA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/151] ASoC: SOF: Intel: Kconfig: fix SoundWire dependencies
Date:   Mon, 16 Aug 2021 15:01:18 +0200
Message-Id: <20210816125445.655236121@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 6b994c554ebc4c065427f510db333081cbd7228d ]

The previous Kconfig cleanup added simplifications but also introduced
a new one by moving a boolean to a tristate. This leads to randconfig
problems.

This patch moves the select operations in the SOUNDWIRE_LINK_BASELINE
option. The INTEL_SOUNDWIRE config remains a tristate for backwards
compatibility with older configurations but is essentially an on/off
switch.

Fixes: cf5807f5f814f ('ASoC: SOF: Intel: SoundWire: simplify Kconfig')
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210802151628.15291-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index 4bce89b5ea40..4447f515e8b1 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -278,6 +278,8 @@ config SND_SOC_SOF_HDA
 
 config SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE
 	tristate
+	select SOUNDWIRE_INTEL if SND_SOC_SOF_INTEL_SOUNDWIRE
+	select SND_INTEL_SOUNDWIRE_ACPI if SND_SOC_SOF_INTEL_SOUNDWIRE
 
 config SND_SOC_SOF_INTEL_SOUNDWIRE
 	tristate "SOF support for SoundWire"
@@ -285,8 +287,6 @@ config SND_SOC_SOF_INTEL_SOUNDWIRE
 	depends on SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE
 	depends on ACPI && SOUNDWIRE
 	depends on !(SOUNDWIRE=m && SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE=y)
-	select SOUNDWIRE_INTEL
-	select SND_INTEL_SOUNDWIRE_ACPI
 	help
 	  This adds support for SoundWire with Sound Open Firmware
 	  for Intel(R) platforms.
-- 
2.30.2



