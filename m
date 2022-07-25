Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF395803C0
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiGYSGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiGYSFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:05:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C08513F10
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 11:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658772302; x=1690308302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eD0dcs06KnoTQdD+8PIVklPM597Is+KJvGRXIixy6oI=;
  b=i+NzYc53cuPXjrOuZ87H+1sV6D74zlesfYJSuwt9NBP2S/439/G7oAP7
   EFjd+966sEx5x8WJlIhVcT0MuR2Y1fVUrZl9acKZQMeyye5bWfJ5uJ8eW
   bLFiQwh/HVrQtkJSrlD4GmsSfwVOJrxOH6fkXXSwFM7Uu+qYQTUQ10sgn
   AYkA+A1kOCiBXtyiGnTSPqp875xYHvFKzrZAA6TG7B9M/FO4fMoHu2yCJ
   18ol951haRt6lDVT613+AfFdVqyKZkz8p5vcQ+u7DmeDjVfvnFjtMztwd
   1nwWyu1BM7OPVT6Es1w/bpe0P/lPebNB7kjzHVkIxWeXq6tIVnRrvXA6I
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="274627572"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="274627572"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:05:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="632449961"
Received: from jxzhao-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.212.0.178])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:05:01 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>
Subject: [PATCH v2 2/3] ASoC: SOF: pm: add definitions for S4 and S5 states
Date:   Mon, 25 Jul 2022 13:04:48 -0500
Message-Id: <20220725180449.12742-3-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220725180449.12742-1-pierre-louis.bossart@linux.intel.com>
References: <20220725180449.12742-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9d2d462713384538477703e68577b05131c7d97d upstream.

We currently don't have a means to differentiate between S3, S4 and
S5. Add definitions so that we have select different code paths
depending on the target state in follow-up patches.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
---
 sound/soc/sof/pm.c       | 9 +++++++++
 sound/soc/sof/sof-priv.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 937354c25856..76351f7f3243 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -23,6 +23,9 @@ static u32 snd_sof_dsp_power_target(struct snd_sof_dev *sdev)
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
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 0d9b640ae24c..c856f0d84e49 100644
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
-- 
2.34.1

