Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C7F6D494D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjDCOgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbjDCOgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:36:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0B317658
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:36:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BF0361E74
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71541C433D2;
        Mon,  3 Apr 2023 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532591;
        bh=dLsDh4xH4aiYf9EooKnyH/jGCc4mPbktyPp1EHowaeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7OEXXhzBA3D8JzmYxILsJTF+6wFuYgs7M0k4YnwqAfKwPTm3K1aZEWCtw5Vk5LZn
         g+XNef/D9ksCIjttvif0gyI9LrAyhIbaI4i+V5/eF1Lr24q4FXoesErnpbzjm6GNdQ
         vlSHnc5kJvHTsUnakLkjxYQKsx5mTaD9H9KCUzzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ferry Toth <fntoth@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/181] ASoC: SOF: Intel: pci-tng: revert invalid bar size setting
Date:   Mon,  3 Apr 2023 16:07:56 +0200
Message-Id: <20230403140416.500136406@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit ca09e2a351fbc7836ba9418304ff0c3e72addfe0 ]

The logic for the ioremap is to find the resource index 3 (IRAM) and
infer the BAR address by subtracting the IRAM offset. The BAR size
defined in hardware specifications is 2MB.

The commit 5947b2726beb6 ("ASoC: SOF: Intel: Check the bar size before
remapping") tried to find the BAR size by querying the resource length
instead of a pre-canned value, but by requesting the size for index 3
it only gets the size of the IRAM. That's obviously wrong and prevents
the probe from proceeding.

This commit attempted to fix an issue in a fuzzing/simulated
environment but created another on actual devices, so the best course
of action is to revert that change.

Reported-by: Ferry Toth <fntoth@gmail.com>
Tested-by: Ferry Toth <fntoth@gmail.com> (Intel Edison-Arduino)
Link: https://github.com/thesofproject/linux/issues/3901
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307095341.3222-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tng.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/pci-tng.c b/sound/soc/sof/intel/pci-tng.c
index f0f6d9ba88037..0b17d1bb225e2 100644
--- a/sound/soc/sof/intel/pci-tng.c
+++ b/sound/soc/sof/intel/pci-tng.c
@@ -75,11 +75,7 @@ static int tangier_pci_probe(struct snd_sof_dev *sdev)
 
 	/* LPE base */
 	base = pci_resource_start(pci, desc->resindex_lpe_base) - IRAM_OFFSET;
-	size = pci_resource_len(pci, desc->resindex_lpe_base);
-	if (size < PCI_BAR_SIZE) {
-		dev_err(sdev->dev, "error: I/O region is too small.\n");
-		return -ENODEV;
-	}
+	size = PCI_BAR_SIZE;
 
 	dev_dbg(sdev->dev, "LPE PHY base at 0x%x size 0x%x", base, size);
 	sdev->bar[DSP_BAR] = devm_ioremap(sdev->dev, base, size);
-- 
2.39.2



