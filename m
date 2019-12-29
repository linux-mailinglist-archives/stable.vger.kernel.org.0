Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2699612C95C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbfL2SGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731840AbfL2RuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E16E206A4;
        Sun, 29 Dec 2019 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641818;
        bh=VjdN9avP/gm0g+8+wpi7ScxeO9Ik9wXOONwHsKgHv/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U443CYGAX6cISsri3drkHrZRcQvM8XhV9RTHuU4D6xuCUM1cYTF6qe3SJmAlPGNwE
         J2kWaNrkHawk33u6gm2R6WtynGNgykZDsnXCJqAxBlVS/iMpPbN88sCIbUYkxTc8fI
         mwyoVd4Qm6AOYpceJm5ls/QR5nxcK6gfZa3EIAVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/434] ASoC: SOF: imx: fix reverse CONFIG_SND_SOC_SOF_OF dependency
Date:   Sun, 29 Dec 2019 18:24:36 +0100
Message-Id: <20191229172716.662287191@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f9ad75468453b019b92c5296e6a04bf7c37f49e4 ]

updated solution to the problem reported with randconfig:

CONFIG_SND_SOC_SOF_IMX depends on CONFIG_SND_SOC_SOF, but is in
turn referenced by the sof-of-dev driver. This creates a reverse
dependency that manifests in a link error when CONFIG_SND_SOC_SOF_OF
is built-in but CONFIG_SND_SOC_SOF_IMX=m:

sound/soc/sof/sof-of-dev.o:(.data+0x118): undefined reference to `sof_imx8_ops'

use def_trisate to propagate the right settings without select.

Fixes: f4df4e4042b0 ("ASoC: SOF: imx8: Fix COMPILE_TEST error")
Fixes: 202acc565a1f ("ASoC: SOF: imx: Add i.MX8 HW support")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191101173045.27099-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/imx/Kconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/imx/Kconfig b/sound/soc/sof/imx/Kconfig
index 5acae75f5750..71f318bc2c74 100644
--- a/sound/soc/sof/imx/Kconfig
+++ b/sound/soc/sof/imx/Kconfig
@@ -11,8 +11,8 @@ config SND_SOC_SOF_IMX_TOPLEVEL
 
 if SND_SOC_SOF_IMX_TOPLEVEL
 
-config SND_SOC_SOF_IMX8
-	tristate "SOF support for i.MX8"
+config SND_SOC_SOF_IMX8_SUPPORT
+	bool "SOF support for i.MX8"
 	depends on IMX_SCU
 	depends on IMX_DSP
 	help
@@ -20,4 +20,8 @@ config SND_SOC_SOF_IMX8
           Say Y if you have such a device.
           If unsure select "N".
 
+config SND_SOC_SOF_IMX8
+	def_tristate SND_SOC_SOF_OF
+	depends on SND_SOC_SOF_IMX8_SUPPORT
+
 endif ## SND_SOC_SOF_IMX_IMX_TOPLEVEL
-- 
2.20.1



