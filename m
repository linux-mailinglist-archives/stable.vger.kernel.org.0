Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA81FB964
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732971AbgFPQDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732599AbgFPPuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:50:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0150208B8;
        Tue, 16 Jun 2020 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322619;
        bh=XntC1FNYkP+J2zrvMQnq4mbbNnvaGrMS1ILo3IOE6Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOkcW3BKP7VzUvcUos+s1PzDR2ReSWaTnS08FYoF7zWWg4QppG9RsSWGPxlTxsKAU
         8PgbfMeAn5Y0G7t2RWiM+xvMeSoYeAATmBovW+nBFabIOzMHhGrig7SrZOerZ4+Him
         BnajNSHExiEu6SGyzT5GfjS381JiQf5XBexsskUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 031/161] ASoC: SOF: imx: fix undefined reference issue
Date:   Tue, 16 Jun 2020 17:33:41 +0200
Message-Id: <20200616153107.871999768@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit cb0312f61c3e95c71ec8955a94d42bf7eb5ba617 ]

make.cross ARCH=mips allyesconfig fails with the following error:

sound/soc/sof/sof-of-dev.o:(.data.sof_of_imx8qxp_desc+0x40): undefined
reference to `sof_imx8x_ops'.

This seems to be a Makefile order issue, solve by using the same
structure as for Intel platforms.

Fixes: f9ad75468453 ("ASoC: SOF: imx: fix reverse CONFIG_SND_SOC_SOF_OF
dependency")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20200409071832.2039-3-daniel.baluta@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/imx/Kconfig | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/imx/Kconfig b/sound/soc/sof/imx/Kconfig
index 812749064ca8..9586635cf8ab 100644
--- a/sound/soc/sof/imx/Kconfig
+++ b/sound/soc/sof/imx/Kconfig
@@ -11,17 +11,26 @@ config SND_SOC_SOF_IMX_TOPLEVEL
 
 if SND_SOC_SOF_IMX_TOPLEVEL
 
+config SND_SOC_SOF_IMX_OF
+	def_tristate SND_SOC_SOF_OF
+	select SND_SOC_SOF_IMX8 if SND_SOC_SOF_IMX8_SUPPORT
+	help
+	  This option is not user-selectable but automagically handled by
+	  'select' statements at a higher level
+
 config SND_SOC_SOF_IMX8_SUPPORT
 	bool "SOF support for i.MX8"
-	depends on IMX_SCU
-	select IMX_DSP
 	help
 	  This adds support for Sound Open Firmware for NXP i.MX8 platforms
 	  Say Y if you have such a device.
 	  If unsure select "N".
 
 config SND_SOC_SOF_IMX8
-	def_tristate SND_SOC_SOF_OF
-	depends on SND_SOC_SOF_IMX8_SUPPORT
+	tristate
+	depends on IMX_SCU
+	select IMX_DSP
+	help
+	  This option is not user-selectable but automagically handled by
+	  'select' statements at a higher level
 
 endif ## SND_SOC_SOF_IMX_IMX_TOPLEVEL
-- 
2.25.1



