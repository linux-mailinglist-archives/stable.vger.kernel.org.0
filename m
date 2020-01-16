Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9D113FFFE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390798AbgAPXrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389656AbgAPXVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C1B52077C;
        Thu, 16 Jan 2020 23:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216882;
        bh=SVLO7tEHdnLI7m6T+W/vO/glj99aOKwiy6fqanCwsqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8H4+grn5j/kiF6lhpERMq14UR6qhpp1iaQ+8iYvMoacoLtmziH3meQ+dU0AEeE09
         TRLCyYZOXK0mDVLoH3zNAeE94DXz8Ac3/KoNNprxF2r8aSnZBalUzKdDWEEfrYbkkD
         zSFQ6AXu15KS5tLKkNcMlPcbyXVFFtbs83+d5jS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 058/203] ASoC: SOF: Intel: Broadwell: clarify mutual exclusion with legacy driver
Date:   Fri, 17 Jan 2020 00:16:15 +0100
Message-Id: <20200116231749.071108262@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit a6955fe0e2309feeab5ec71e4b0dcbe498f4f497 upstream.

Some distros select all options blindly, which leads to confusion and
bug reports. SOF does not fully support Broadwell due to firmware
dependencies, the machine drivers can only support one option, and
UCM/topology files are still being propagated to downstream distros,
so make SOF on Broadwell an opt-in option that first require distros
to opt-out of existing defaults.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204237
Fixes: f35bf70f61d3 ('ASoC: Intel: Make sure BDW based machine drivers build for SOF')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191101173045.27099-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/Kconfig     |    3 +++
 sound/soc/sof/intel/Kconfig |   10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/Kconfig
+++ b/sound/soc/intel/Kconfig
@@ -59,6 +59,9 @@ config SND_SOC_INTEL_HASWELL
 	  If you have a Intel Haswell or Broadwell platform connected to
 	  an I2S codec, then enable this option by saying Y or m. This is
 	  typically used for Chromebooks. This is a recommended option.
+	  This option is mutually exclusive with the SOF support on
+	  Broadwell. If you want to enable SOF on Broadwell, you need to
+	  deselect this option first.
 
 config SND_SOC_INTEL_BAYTRAIL
 	tristate "Baytrail (legacy) Platforms"
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -76,10 +76,18 @@ config SND_SOC_SOF_BAYTRAIL
 
 config SND_SOC_SOF_BROADWELL_SUPPORT
 	bool "SOF support for Broadwell"
+	depends on SND_SOC_INTEL_HASWELL=n
 	help
 	  This adds support for Sound Open Firmware for Intel(R) platforms
 	  using the Broadwell processors.
-	  Say Y if you have such a device.
+	  This option is mutually exclusive with the Haswell/Broadwell legacy
+	  driver. If you want to enable SOF on Broadwell you need to deselect
+	  the legacy driver first.
+	  SOF does fully support Broadwell yet, so this option is not
+	  recommended for distros. At some point all legacy drivers will be
+	  deprecated but not before all userspace firmware/topology/UCM files
+	  are made available to downstream distros.
+	  Say Y if you want to enable SOF on Broadwell
 	  If unsure select "N".
 
 config SND_SOC_SOF_BROADWELL


