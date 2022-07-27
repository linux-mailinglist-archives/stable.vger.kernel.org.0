Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FB158311D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243192AbiG0Rqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243137AbiG0Rp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:45:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB648C591;
        Wed, 27 Jul 2022 09:53:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B82961748;
        Wed, 27 Jul 2022 16:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426F8C433C1;
        Wed, 27 Jul 2022 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940812;
        bh=bOoIJVJe4A9m72RfC667rC++3yP4biKNPinGYjYRcU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdomxCRrc12C56RU19NePhPIKE+iO0PjDUMJ6mZAxkHwvHn9sZuHR5/J7lt1ICjJR
         Wd+vhYeQGL3A7fMVeW1kByKhV2jdzYyJrYXBDz1Pw3sUD9sHJe0oXHSScPXcmABFxw
         VOBytlPLWoGDBLN6n5zvVs65817Mlkz9Y0m5DzrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.18 157/158] ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5 states
Date:   Wed, 27 Jul 2022 18:13:41 +0200
Message-Id: <20220727161027.624641879@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 391153522d186f19a008d824bb3a05950351ce6c upstream.

The IMR was assumed to be preserved when suspending to S4 and S5
states, but community reports invalidate that assumption, the hardware
seems to be powered off and the IMR memory content cleared.

Make sure regular boot with firmware download is used for S4 and S5.

BugLink: https://github.com/thesofproject/sof/issues/5892
Fixes: 5fb5f51185126 ("ASoC: SOF: Intel: hda-loader: add IMR restore support")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220616201818.130802-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-loader.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -397,7 +397,8 @@ int hda_dsp_cl_boot_firmware(struct snd_
 	struct firmware stripped_firmware;
 	int ret, ret1, i;
 
-	if ((sdev->fw_ready.flags & SOF_IPC_INFO_D3_PERSISTENT) &&
+	if ((sdev->system_suspend_target < SOF_SUSPEND_S4) &&
+	    (sdev->fw_ready.flags & SOF_IPC_INFO_D3_PERSISTENT) &&
 	    !(sof_debug_check_flag(SOF_DBG_IGNORE_D3_PERSISTENT)) &&
 	    !sdev->first_boot) {
 		dev_dbg(sdev->dev, "IMR restore supported, booting from IMR directly\n");


