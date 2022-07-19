Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFE2579CCC
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241506AbiGSMnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbiGSMnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:43:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EFF80501;
        Tue, 19 Jul 2022 05:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3469D6182F;
        Tue, 19 Jul 2022 12:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B5EC341C6;
        Tue, 19 Jul 2022 12:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232993;
        bh=1mtxs395ZlU+Q1Yog4IOyC9wgbTJnqJ3X7rz6XpMosY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWIoM2RjeHV4y2y7kT8wpEOzxdG30ug2o4pkxkbmiTALsQ01nZ73hzbBg3Y39OKUL
         hGNrCwLy8iEwXBWZ9xR/1NMGKLxpQNUoVskGhYex15B+FOOzyVkpODFfIsiLCBrJuO
         E8JySEGi6pND9b9bJKl0rvCshiBhVQ1WTx/mYdOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/167] ASoC: rt711: fix calibrate mutex initialization
Date:   Tue, 19 Jul 2022 13:54:28 +0200
Message-Id: <20220719114709.689028379@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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

[ Upstream commit 08bb5dc6ce02374169213cea772b1c297eaf32d5 ]

Follow the same flow as rt711-sdca and initialize all mutexes at probe
time.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdw.c |    3 +++
 sound/soc/codecs/rt711.c     |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -474,6 +474,9 @@ static int rt711_sdw_remove(struct sdw_s
 	if (rt711->first_hw_init)
 		pm_runtime_disable(&slave->dev);
 
+	mutex_destroy(&rt711->calibrate_mutex);
+	mutex_destroy(&rt711->disable_irq_lock);
+
 	return 0;
 }
 
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -1199,6 +1199,7 @@ int rt711_init(struct device *dev, struc
 	rt711->sdw_regmap = sdw_regmap;
 	rt711->regmap = regmap;
 
+	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
 	/*
@@ -1313,7 +1314,6 @@ int rt711_io_init(struct device *dev, st
 			rt711_jack_detect_handler);
 		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
 			rt711_btn_check_handler);
-		mutex_init(&rt711->calibrate_mutex);
 		INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
 		schedule_work(&rt711->calibration_work);
 	}


