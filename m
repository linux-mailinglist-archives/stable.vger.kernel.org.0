Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF330CC35
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhBBTrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:47:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233204AbhBBNwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B634764FC0;
        Tue,  2 Feb 2021 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273416;
        bh=5BGQtXVUbXXaAD7nhktL8PbbZLzI4cPQ/RgcupTBFB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5XimHxH8qxI6ZtUIirKzXB04323tvmQmGD6WyhOqwm5M816+yFsLhZScN7GsQvlz
         xLCSlg4+CkmG7m3qWg5tk0eJXPCFMR5dslkiTGMJZJUY4yn0k1O74v0mMsnQu3qfhJ
         Cj9aPHwsSBCWFEOUOnQP+abUaLDvcT5S7xOlLdU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/142] ASoC: SOF: Intel: soundwire: fix select/depend unmet dependencies
Date:   Tue,  2 Feb 2021 14:37:41 +0100
Message-Id: <20210202133001.756498989@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit bd9038faa9d7f162b47e1577e35ec5eac39f9d90 ]

The LKP bot reports the following issue:

WARNING: unmet direct dependencies detected for SOUNDWIRE_INTEL
  Depends on [m]: SOUNDWIRE [=m] && ACPI [=y] && SND_SOC [=y]
  Selected by [y]:
  - SND_SOC_SOF_INTEL_SOUNDWIRE [=y] && SOUND [=y] && !UML &&
  SND [=y] && SND_SOC [=y] && SND_SOC_SOF_TOPLEVEL [=y] &&
  SND_SOC_SOF_INTEL_TOPLEVEL [=y] && SND_SOC_SOF_INTEL_PCI [=y]

This comes from having tristates being configured independently, when
in practice the CONFIG_SOUNDWIRE needs to be aligned with the SOF
choices: when the SOF code is compiled as built-in, the
CONFIG_SOUNDWIRE also needs to be 'y'.

The easiest fix is to replace the 'depends' with a 'select' and have a
single user selection to activate SoundWire on Intel platforms. This
still allows regmap to be compiled independently as a module.

This is just a temporary fix, the select/depend usage will be
revisited and the SOF Kconfig re-organized, as suggested by Arnd
Bergman.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: a115ab9b8b93e ('ASoC: SOF: Intel: add build support for SoundWire')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210122005725.94163-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index 5bfc2f8b13b90..de7ff2d097ab9 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -337,7 +337,7 @@ config SND_SOC_SOF_HDA
 
 config SND_SOC_SOF_INTEL_SOUNDWIRE_LINK
 	bool "SOF support for SoundWire"
-	depends on SOUNDWIRE && ACPI
+	depends on ACPI
 	help
 	  This adds support for SoundWire with Sound Open Firmware
 		  for Intel(R) platforms.
@@ -353,6 +353,7 @@ config SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE
 
 config SND_SOC_SOF_INTEL_SOUNDWIRE
 	tristate
+	select SOUNDWIRE
 	select SOUNDWIRE_INTEL
 	help
 	  This option is not user-selectable but automagically handled by
-- 
2.27.0



