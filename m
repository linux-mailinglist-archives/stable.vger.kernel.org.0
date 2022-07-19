Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B5B579F11
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243186AbiGSNKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243403AbiGSNJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:09:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023E264E01;
        Tue, 19 Jul 2022 05:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDC660DF8;
        Tue, 19 Jul 2022 12:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5549EC341DD;
        Tue, 19 Jul 2022 12:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233712;
        bh=DX8GnNXoZmg5Xm54obL/bmHPMlMYP2TaYkBJHhzBO74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQGtSENbSCteUHjwzcR7DvulCrjg2NtMLv1YIaHi433rouqNqn+KBJrG3evTZE2uT
         A+Jq7QoJqatuf27bZvyfsqzkUwYtHJYypzHhMgQR3PO2bNiEgzYtUNhhXyvHBs5JiJ
         Iwhz89BMVnXFf6TBidm6inMHLfvR5LUMvSNPcnis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 186/231] ASoC: rt711-sdca-sdw: fix calibrate mutex initialization
Date:   Tue, 19 Jul 2022 13:54:31 +0200
Message-Id: <20220719114729.840207773@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit ed0a7fb29c9fd4f53eeb37d1fe2354df7a038047 ]

In codec driver bind/unbind test, the following warning is thrown:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
...
[  699.182495]  rt711_sdca_jack_init+0x1b/0x1d0 [snd_soc_rt711_sdca]
[  699.182498]  rt711_sdca_set_jack_detect+0x3b/0x90 [snd_soc_rt711_sdca]
[  699.182500]  snd_soc_component_set_jack+0x24/0x50 [snd_soc_core]

A quick check in the code shows that the 'calibrate_mutex' used by
this driver are not initialized at probe time. Moving the
initialization to the probe removes the issue.

BugLink: https://github.com/thesofproject/linux/issues/3644
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c |    3 +++
 sound/soc/codecs/rt711-sdca.c     |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -373,6 +373,9 @@ static int rt711_sdca_sdw_remove(struct
 	if (rt711->first_hw_init)
 		pm_runtime_disable(&slave->dev);
 
+	mutex_destroy(&rt711->calibrate_mutex);
+	mutex_destroy(&rt711->disable_irq_lock);
+
 	return 0;
 }
 
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -1414,6 +1414,7 @@ int rt711_sdca_init(struct device *dev,
 	rt711->regmap = regmap;
 	rt711->mbq_regmap = mbq_regmap;
 
+	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
 	/*
@@ -1552,7 +1553,6 @@ int rt711_sdca_io_init(struct device *de
 			rt711_sdca_jack_detect_handler);
 		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
 			rt711_sdca_btn_check_handler);
-		mutex_init(&rt711->calibrate_mutex);
 	}
 
 	/* calibration */


