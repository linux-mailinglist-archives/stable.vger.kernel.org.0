Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9CE6ECDF2
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjDXN2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjDXN2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:28:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D20465B9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F18F861F10
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8DFC433D2;
        Mon, 24 Apr 2023 13:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342885;
        bh=E5MLtgRyfqBoZdloFp77SgptROvj0OSsfz/NoVgW8Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7ZAtDI7wgj1SVjrRefF0lbDknCfMShvihMYx3aJUTkGDOoTrb2HKhH0cuxpfzB0w
         Zp4Xv20sZ1KUD/gU64lNgNq2elwxGpSzKj3tTJJph0Y/iQf3vnji8qbaxMW8sZkhuD
         aE6+ahoE9qT+j9WorEY/vAvR0ovac8SMSotYQiJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 95/98] ASoC: SOF: pm: Tear down pipelines only if DSP was active
Date:   Mon, 24 Apr 2023 15:17:58 +0200
Message-Id: <20230424131137.577717904@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Baluta <daniel.baluta@nxp.com>

commit 0b186bb06198653d74a141902a7739e0bde20cf4 upstream.

With PCI if the device was suspended it is brought back to full
power and then suspended again.

This doesn't happen when device is described via DT.

We need to make sure that we tear down pipelines only if the device
was previously active (thus the pipelines were setup).

Otherwise, we can break the use_count:

[  219.009743] sof-audio-of-imx8m 3b6e8000.dsp:
sof_ipc3_tear_down_all_pipelines: widget PIPELINE.2.SAI3.IN is still in use: count -1

and after this everything stops working.

Fixes: d185e0689abc ("ASoC: SOF: pm: Always tear down pipelines before DSP suspend")
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20230405092655.19587-1-daniel.baluta@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -183,6 +183,7 @@ static int sof_suspend(struct device *de
 	const struct sof_ipc_tplg_ops *tplg_ops = sdev->ipc->ops->tplg;
 	pm_message_t pm_state;
 	u32 target_state = snd_sof_dsp_power_target(sdev);
+	u32 old_state = sdev->dsp_power_state.state;
 	int ret;
 
 	/* do nothing if dsp suspend callback is not set */
@@ -192,7 +193,12 @@ static int sof_suspend(struct device *de
 	if (runtime_suspend && !sof_ops(sdev)->runtime_suspend)
 		return 0;
 
-	if (tplg_ops && tplg_ops->tear_down_all_pipelines)
+	/* we need to tear down pipelines only if the DSP hardware is
+	 * active, which happens for PCI devices. if the device is
+	 * suspended, it is brought back to full power and then
+	 * suspended again
+	 */
+	if (tplg_ops && tplg_ops->tear_down_all_pipelines && (old_state == SOF_DSP_PM_D0))
 		tplg_ops->tear_down_all_pipelines(sdev, false);
 
 	if (sdev->fw_state != SOF_FW_BOOT_COMPLETE)


