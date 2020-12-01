Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC862C9D5F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgLAJWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:22:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388638AbgLAJHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C47421D7A;
        Tue,  1 Dec 2020 09:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813622;
        bh=BbU6Hr7e+pRq9nrVXXo1dwEeD1dgrs25CEtb8rFAtv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X60VwPzBHglZVuWdOoPb6YFdRs21PHCRHPFHvH0J9iD8ORLXG2uslz7tuxLFui0DF
         apg+LjyegVVYo3aaJOEauXjrHwwhsNZCOCSdNEdAzsuGuRB+rWObU+DkSSQZebPze/
         S2QSwucKbcL+yx3sIIMt/ARvaVgGLrXlRuIc7TjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "alsa-devel@alsa-project.org, broonie@kernel.org, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, mateusz.gorski@linux.intel.com,
        Cezary Rojewski" <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Subject: [PATCH 5.4 95/98] ASoC: Intel: Allow for ROM init retry on CNL platforms
Date:   Tue,  1 Dec 2020 09:54:12 +0100
Message-Id: <20201201084659.719019674@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

commit 024aa45f55ccd40704cfdef61b2a8b6d0de9cdd1 upstream.

Due to unconditional initial timeouts, firmware may fail to load during
its initialization. This issue cannot be resolved on driver side as it
is caused by external sources such as CSME but has to be accounted for
nonetheless.

Fixes: cb6a55284629 ("ASoC: Intel: cnl: Add sst library functions for cnl platform")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200305145314.32579-7-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/skylake/bxt-sst.c     |    2 --
 sound/soc/intel/skylake/cnl-sst.c     |   15 ++++++++++-----
 sound/soc/intel/skylake/skl-sst-dsp.h |    1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/sound/soc/intel/skylake/bxt-sst.c
+++ b/sound/soc/intel/skylake/bxt-sst.c
@@ -38,8 +38,6 @@
 /* Delay before scheduling D0i3 entry */
 #define BXT_D0I3_DELAY 5000
 
-#define BXT_FW_ROM_INIT_RETRY 3
-
 static unsigned int bxt_get_errorcode(struct sst_dsp *ctx)
 {
 	 return sst_dsp_shim_read(ctx, BXT_ADSP_ERROR_CODE);
--- a/sound/soc/intel/skylake/cnl-sst.c
+++ b/sound/soc/intel/skylake/cnl-sst.c
@@ -109,7 +109,7 @@ static int cnl_load_base_firmware(struct
 {
 	struct firmware stripped_fw;
 	struct skl_dev *cnl = ctx->thread_context;
-	int ret;
+	int ret, i;
 
 	if (!ctx->fw) {
 		ret = request_firmware(&ctx->fw, ctx->fw_name, ctx->dev);
@@ -131,12 +131,16 @@ static int cnl_load_base_firmware(struct
 	stripped_fw.size = ctx->fw->size;
 	skl_dsp_strip_extended_manifest(&stripped_fw);
 
-	ret = cnl_prepare_fw(ctx, stripped_fw.data, stripped_fw.size);
-	if (ret < 0) {
-		dev_err(ctx->dev, "prepare firmware failed: %d\n", ret);
-		goto cnl_load_base_firmware_failed;
+	for (i = 0; i < BXT_FW_ROM_INIT_RETRY; i++) {
+		ret = cnl_prepare_fw(ctx, stripped_fw.data, stripped_fw.size);
+		if (!ret)
+			break;
+		dev_dbg(ctx->dev, "prepare firmware failed: %d\n", ret);
 	}
 
+	if (ret < 0)
+		goto cnl_load_base_firmware_failed;
+
 	ret = sst_transfer_fw_host_dma(ctx);
 	if (ret < 0) {
 		dev_err(ctx->dev, "transfer firmware failed: %d\n", ret);
@@ -158,6 +162,7 @@ static int cnl_load_base_firmware(struct
 	return 0;
 
 cnl_load_base_firmware_failed:
+	dev_err(ctx->dev, "firmware load failed: %d\n", ret);
 	release_firmware(ctx->fw);
 	ctx->fw = NULL;
 
--- a/sound/soc/intel/skylake/skl-sst-dsp.h
+++ b/sound/soc/intel/skylake/skl-sst-dsp.h
@@ -67,6 +67,7 @@ struct skl_dev;
 
 #define SKL_FW_INIT			0x1
 #define SKL_FW_RFW_START		0xf
+#define BXT_FW_ROM_INIT_RETRY		3
 
 #define SKL_ADSPIC_IPC			1
 #define SKL_ADSPIS_IPC			1


