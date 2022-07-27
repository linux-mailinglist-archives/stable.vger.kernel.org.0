Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FCB583124
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbiG0RrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243188AbiG0Rqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:46:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCEC8C775;
        Wed, 27 Jul 2022 09:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27E20B821D7;
        Wed, 27 Jul 2022 16:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507D5C433C1;
        Wed, 27 Jul 2022 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940809;
        bh=WsH6qdCjwRPejsJXtp/9b+oVzgQaxs/0Nr45MAGQSlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7J0uVZ6/NQ1QdDkoyXUEvZwU2mbG+02ku+T0gv2NNf1VDv998CxY9unywUFuA7la
         PCCE4IHg6Q1oumZ9QoGzrQNBoLxoTISNvWqRG+kavUjUN4X5hywsPIIGIDZzJcsF21
         OGEbcrsuhZxS4m6mYKyQlHDwN+EvANVOu7SvAPjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.18 156/158] ASoC: SOF: pm: add definitions for S4 and S5 states
Date:   Wed, 27 Jul 2022 18:13:40 +0200
Message-Id: <20220727161027.581987180@linuxfoundation.org>
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

commit 9d2d462713384538477703e68577b05131c7d97d upstream.

We currently don't have a means to differentiate between S3, S4 and
S5. Add definitions so that we have select different code paths
depending on the target state in follow-up patches.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220616201818.130802-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pm.c       |    9 +++++++++
 sound/soc/sof/sof-priv.h |    2 ++
 2 files changed, 11 insertions(+)

--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -23,6 +23,9 @@ static u32 snd_sof_dsp_power_target(stru
 	u32 target_dsp_state;
 
 	switch (sdev->system_suspend_target) {
+	case SOF_SUSPEND_S5:
+	case SOF_SUSPEND_S4:
+		/* DSP should be in D3 if the system is suspending to S3+ */
 	case SOF_SUSPEND_S3:
 		/* DSP should be in D3 if the system is suspending to S3 */
 		target_dsp_state = SOF_DSP_PM_D3;
@@ -336,6 +339,12 @@ int snd_sof_prepare(struct device *dev)
 	case ACPI_STATE_S3:
 		sdev->system_suspend_target = SOF_SUSPEND_S3;
 		break;
+	case ACPI_STATE_S4:
+		sdev->system_suspend_target = SOF_SUSPEND_S4;
+		break;
+	case ACPI_STATE_S5:
+		sdev->system_suspend_target = SOF_SUSPEND_S5;
+		break;
 	default:
 		break;
 	}
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -85,6 +85,8 @@ enum sof_system_suspend_state {
 	SOF_SUSPEND_NONE = 0,
 	SOF_SUSPEND_S0IX,
 	SOF_SUSPEND_S3,
+	SOF_SUSPEND_S4,
+	SOF_SUSPEND_S5,
 };
 
 enum sof_dfsentry_type {


