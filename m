Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F49A5AE9BA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240300AbiIFNdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240542AbiIFNdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B1A7823C;
        Tue,  6 Sep 2022 06:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 203266154A;
        Tue,  6 Sep 2022 13:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212B3C433C1;
        Tue,  6 Sep 2022 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471173;
        bh=s0zx0goknXA6fbAcjuEMEq/YelsOfuPhdzbB3HsBVnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuME/0UZFG9282qPV+Me8e1HvE0Cp2IBIpcVoafIPkJuik1AY0lcBOhq++5xi7i8b
         SLKV+S/yj2M7VEqCe8a54MzvmEo5KXlLMSscm8nSMfArxNh23Nm5wpySH+m8lwJtFy
         u8UnQ8PNfAgGhjDkWPUBYA2FPHUbqFmfFYepW+X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/80] ALSA: hda: intel-nhlt: remove use of __func__ in dev_dbg
Date:   Tue,  6 Sep 2022 15:30:06 +0200
Message-Id: <20220906132817.310080258@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 6376ab02374822e1e8758a848ee736a182786a2e ]

The module and function information can be added with
'modprobe foo dyndbg=+pmf'

Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220616220559.136160-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-nhlt.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/sound/hda/intel-nhlt.c b/sound/hda/intel-nhlt.c
index e2237239d922a..5e04fedaec49e 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -55,8 +55,8 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 
 		/* find max number of channels based on format_configuration */
 		if (fmt_configs->fmt_count) {
-			dev_dbg(dev, "%s: found %d format definitions\n",
-				__func__, fmt_configs->fmt_count);
+			dev_dbg(dev, "found %d format definitions\n",
+				fmt_configs->fmt_count);
 
 			for (i = 0; i < fmt_configs->fmt_count; i++) {
 				struct wav_fmt_ext *fmt_ext;
@@ -66,9 +66,9 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 				if (fmt_ext->fmt.channels > max_ch)
 					max_ch = fmt_ext->fmt.channels;
 			}
-			dev_dbg(dev, "%s: max channels found %d\n", __func__, max_ch);
+			dev_dbg(dev, "max channels found %d\n", max_ch);
 		} else {
-			dev_dbg(dev, "%s: No format information found\n", __func__);
+			dev_dbg(dev, "No format information found\n");
 		}
 
 		if (cfg->device_config.config_type != NHLT_CONFIG_TYPE_MIC_ARRAY) {
@@ -95,17 +95,16 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 			}
 
 			if (dmic_geo > 0) {
-				dev_dbg(dev, "%s: Array with %d dmics\n", __func__, dmic_geo);
+				dev_dbg(dev, "Array with %d dmics\n", dmic_geo);
 			}
 			if (max_ch > dmic_geo) {
-				dev_dbg(dev, "%s: max channels %d exceed dmic number %d\n",
-					__func__, max_ch, dmic_geo);
+				dev_dbg(dev, "max channels %d exceed dmic number %d\n",
+					max_ch, dmic_geo);
 			}
 		}
 	}
 
-	dev_dbg(dev, "%s: dmic number %d max_ch %d\n",
-		__func__, dmic_geo, max_ch);
+	dev_dbg(dev, "dmic number %d max_ch %d\n", dmic_geo, max_ch);
 
 	return dmic_geo;
 }
-- 
2.35.1



