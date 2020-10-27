Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC74B29BA55
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1804888AbgJ0P7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803513AbgJ0PxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:53:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A5E20657;
        Tue, 27 Oct 2020 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813980;
        bh=dYPfU2nzxaMcnrWOWuW9A74av4A+cXEPOv4fMsWHBNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwElJz3vZviR3JjL7LzUAj42zKy4BGWOHyZMhcJ1xv3YuEqgoBpbVpB1J5iQty38E
         vOWFuupe2SJB4fz3wfnODuRo94yPxZ0TQCgoOIlL6ZNBUH/lPNgiX/ORIGl44tgvds
         sgVGTkIVbcy7dqUxYbiA285QRO7NtuwrN0nMLezQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Mac Chiang <mac.chiang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 735/757] ASoC: Intel: sof_rt5682: override quirk data for tgl_max98373_rt5682
Date:   Tue, 27 Oct 2020 14:56:25 +0100
Message-Id: <20201027135524.981041892@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>

[ Upstream commit 3e1734b64ce786c54dc98adcfe67941e6011d735 ]

A Chrome System based on tgl_max98373_rt5682 has different SSP interface
configurations. Using DMI data of this variant DUT, override quirk
data.

Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Signed-off-by: Mac Chiang <mac.chiang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200821195603.215535-13-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 0129d23694ed5..9a6f10ede427e 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -119,6 +119,19 @@ static const struct dmi_system_id sof_rt5682_quirk_table[] = {
 		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
 					SOF_RT5682_SSP_CODEC(0)),
 	},
+	{
+		.callback = sof_rt5682_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Volteer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Terrador"),
+		},
+		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
+					SOF_RT5682_SSP_CODEC(0) |
+					SOF_SPEAKER_AMP_PRESENT |
+					SOF_MAX98373_SPEAKER_AMP_PRESENT |
+					SOF_RT5682_SSP_AMP(2) |
+					SOF_RT5682_NUM_HDMIDEV(4)),
+	},
 	{}
 };
 
-- 
2.25.1



