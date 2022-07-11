Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF6656D525
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 09:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiGKHGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 03:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGKHGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 03:06:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B211A38D
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 00:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 424D16124D
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 07:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478FAC34115;
        Mon, 11 Jul 2022 07:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657523161;
        bh=65j2S4u64bryEo82RcCIcaE2vTvDEWLbbONBchqWFq4=;
        h=Subject:To:Cc:From:Date:From;
        b=mUfNuMIQQV8789NmS4oYC9W3jCTSSZrJRt5J9xb8mPu4HAf78TXthOCT5jUdG58Kx
         EVFHxiHRCsODVG0onmJFZHzar5fE6MXCkAhBNGK8U32cp26L5391rX2H5i0p8Oem0F
         Zk7NCDTezRRbzFCJ7FL4tZljyTOjyHxDAP3k4pKk=
Subject: FAILED: patch "[PATCH] ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4" failed to apply to 5.18-stable tree
To:     pierre-louis.bossart@linux.intel.com, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jul 2022 09:05:59 +0200
Message-ID: <16575231593075@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 391153522d186f19a008d824bb3a05950351ce6c Mon Sep 17 00:00:00 2001
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Date: Thu, 16 Jun 2022 15:18:18 -0500
Subject: [PATCH] ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4
 and S5 states
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index d3ec5996a9a3..145d483bd129 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -389,7 +389,8 @@ int hda_dsp_cl_boot_firmware(struct snd_sof_dev *sdev)
 	struct snd_dma_buffer dmab;
 	int ret, ret1, i;
 
-	if (hda->imrboot_supported && !sdev->first_boot) {
+	if (sdev->system_suspend_target < SOF_SUSPEND_S4 &&
+	    hda->imrboot_supported && !sdev->first_boot) {
 		dev_dbg(sdev->dev, "IMR restore supported, booting from IMR directly\n");
 		hda->boot_iteration = 0;
 		ret = hda_dsp_boot_imr(sdev);

