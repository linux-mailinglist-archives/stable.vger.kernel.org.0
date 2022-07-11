Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E506F5707C3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiGKP5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiGKP5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:57:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BAA33426
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 08:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657555055; x=1689091055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tr/JZvgZzKAx63LhgFdSA+iXxcmS0P+9mB3tg/Q/LcE=;
  b=DFeH7k2Ox3NjTluZvlB/6HoHoKVTRxc8iG9esOubJio9YTJ0WWJkNWpe
   onhbeWJe9c0MUKNVGg0jIrQqJE16x8CcJPDOXvqQxU/5YJJQKDh/EjAyb
   7IFZvnwZJu9QTA22UFL9QEOCEp2z2AZ+fsBas8vRjFMcj+1/Jv780BKXn
   0OJNgrtHZeefKDbZB7sKaPKKFQi8A5ZdMU4wrqEuHD9pvBJNcEj+2u9Xn
   ePjVxFHwe6HJVfEMlvxEPXnWSkBzKN9m0Q9JA8re6BdjLPv60DGn5Pepk
   BZDs5ym4wc4Zmr0vV/8ISBcG4lUWeuvBWWqtbjK8Q5Nrj7WI9ZPnskQgT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="264479648"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="264479648"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:34 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="771553857"
Received: from jbeecha-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.209.161.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:34 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: [PATCH 2/3] ASoC: SOF: pm: add definitions for S4 and S5 states
Date:   Mon, 11 Jul 2022 10:57:18 -0500
Message-Id: <20220711155719.104952-3-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
References: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7a5974e035a6d496797547e4b469bc88938343c2 upstream.

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

