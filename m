Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763E42C9D61
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgLAJWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389130AbgLAJHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9C622249;
        Tue,  1 Dec 2020 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813625;
        bh=3X7nDeaHGV8ca1bsDthpExKd61Y42M88KLXSYxDFZUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6jSkLP2TnJ26daDMQI/4iYYCFW0BbJo3n3p10NEws2c6dmgg4DIl3VZtbqRyhXDN
         zo10xkjwgMEYr+HkOnvGFxWxvryxG8K6EVifhMGRxz/oWroW8sT5Ib1MD5v+wQTtBf
         8P8TIie8dl3T1FQ37pGSbyAJ8IPEmxuj2MvEFLZY=
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
Subject: [PATCH 5.4 96/98] ASoC: Intel: Skylake: Await purge request ack on CNL
Date:   Tue,  1 Dec 2020 09:54:13 +0100
Message-Id: <20201201084659.771053432@linuxfoundation.org>
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

commit 7693cadac86548b30389a6e11d78c38db654f393 upstream.

Each purge request is sent by driver after master core is powered up and
unresetted but before it is unstalled. On unstall, ROM begins processing
the request and initializing environment for FW load. Host should await
ROM's ack before moving forward. Without doing so, ROM init poll may
start too early and false timeouts can occur.

Fixes: cb6a55284629 ("ASoC: Intel: cnl: Add sst library functions for cnl platform")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200305145314.32579-8-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/skylake/bxt-sst.c     |    1 -
 sound/soc/intel/skylake/cnl-sst.c     |   20 ++++++++++++++++++--
 sound/soc/intel/skylake/skl-sst-dsp.h |    1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

--- a/sound/soc/intel/skylake/bxt-sst.c
+++ b/sound/soc/intel/skylake/bxt-sst.c
@@ -17,7 +17,6 @@
 #include "skl.h"
 
 #define BXT_BASEFW_TIMEOUT	3000
-#define BXT_INIT_TIMEOUT	300
 #define BXT_ROM_INIT_TIMEOUT	70
 #define BXT_IPC_PURGE_FW	0x01004000
 
--- a/sound/soc/intel/skylake/cnl-sst.c
+++ b/sound/soc/intel/skylake/cnl-sst.c
@@ -57,18 +57,34 @@ static int cnl_prepare_fw(struct sst_dsp
 	ctx->dsp_ops.stream_tag = stream_tag;
 	memcpy(ctx->dmab.area, fwdata, fwsize);
 
+	ret = skl_dsp_core_power_up(ctx, SKL_DSP_CORE0_MASK);
+	if (ret < 0) {
+		dev_err(ctx->dev, "dsp core0 power up failed\n");
+		ret = -EIO;
+		goto base_fw_load_failed;
+	}
+
 	/* purge FW request */
 	sst_dsp_shim_write(ctx, CNL_ADSP_REG_HIPCIDR,
 			   CNL_ADSP_REG_HIPCIDR_BUSY | (CNL_IPC_PURGE |
 			   ((stream_tag - 1) << CNL_ROM_CTRL_DMA_ID)));
 
-	ret = cnl_dsp_enable_core(ctx, SKL_DSP_CORE0_MASK);
+	ret = skl_dsp_start_core(ctx, SKL_DSP_CORE0_MASK);
 	if (ret < 0) {
-		dev_err(ctx->dev, "dsp boot core failed ret: %d\n", ret);
+		dev_err(ctx->dev, "Start dsp core failed ret: %d\n", ret);
 		ret = -EIO;
 		goto base_fw_load_failed;
 	}
 
+	ret = sst_dsp_register_poll(ctx, CNL_ADSP_REG_HIPCIDA,
+				    CNL_ADSP_REG_HIPCIDA_DONE,
+				    CNL_ADSP_REG_HIPCIDA_DONE,
+				    BXT_INIT_TIMEOUT, "HIPCIDA Done");
+	if (ret < 0) {
+		dev_err(ctx->dev, "timeout for purge request: %d\n", ret);
+		goto base_fw_load_failed;
+	}
+
 	/* enable interrupt */
 	cnl_ipc_int_enable(ctx);
 	cnl_ipc_op_int_enable(ctx);
--- a/sound/soc/intel/skylake/skl-sst-dsp.h
+++ b/sound/soc/intel/skylake/skl-sst-dsp.h
@@ -68,6 +68,7 @@ struct skl_dev;
 #define SKL_FW_INIT			0x1
 #define SKL_FW_RFW_START		0xf
 #define BXT_FW_ROM_INIT_RETRY		3
+#define BXT_INIT_TIMEOUT		300
 
 #define SKL_ADSPIC_IPC			1
 #define SKL_ADSPIS_IPC			1


