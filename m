Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B3E6D3FB3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDCJIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjDCJIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 05:08:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD1B7687
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 02:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680512917; x=1712048917;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VQ2N7IpKAZjfzIJrRPnJDXllKTJjvePBYNPePA2Tx/A=;
  b=V87QZl9uhPOvnX9eB+osVitOgh0AaxSpmI0M+RyZpV3pJ1Ed9r8ungyx
   CYDTaCTerCIAi7YPS3K+qw1hlVTnfma0bWTS/UmsAhWo5x6uZa5bS8131
   fXXfLciZMPz9//oaDzGnsK9RHR5c40mUWLxWyd6W1y9JjJH6okt54EY0/
   uXatqYGJErLM0r2hXrQjOpEFnnGLHyvGvfK4XEPtdnsWeocoUSDehS+Ec
   bPksGIMh+VrpbiG6dHBfsvm0352nCZfZMpNxKhYqQFaCeyf+tZ8faRhal
   8goTX+npimyZ3weKWtItlKY+0apYcxXa2FzB6AvvBjud+/TbbP4aLkSc4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="344400034"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="344400034"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 02:08:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="755157940"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="755157940"
Received: from xinpan-mobl1.ger.corp.intel.com (HELO pujfalus-desk.ger.corp.intel.com) ([10.251.210.95])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 02:08:34 -0700
From:   Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
To:     lgirdwood@gmail.com, broonie@kernel.org
Cc:     alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com, stable@vger.kernel.org,
        error27@gmail.com
Subject: [PATCH for v6.3-rc] ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module
Date:   Mon,  3 Apr 2023 12:09:09 +0300
Message-Id: <20230403090909.18233-1-peter.ujfalusi@linux.intel.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The original patch uses a feature in lib/vsprintf.c to handle the invalid
address when tring to print *_fw_module->man4_module_entry.name when the
*rc_fw_module is NULL.
This case is handled by check_pointer_msg() internally and turns the
invalid pointer to '(efault)' for printing but it is hiding useful
information about the circumstances. Change the print to emmit the name
of the widget and a note on which side's fw_module is missing.

Fixes: e3720f92e023 ("ASoC: SOF: avoid a NULL dereference with unsupported widgets")
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/alsa-devel/4826f662-42f0-4a82-ba32-8bf5f8a03256@kili.mountain/
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
---
Hi Mark, Dan,

This patch clarifies the print and will not rely on vsprintf internal protection
on printing the error.

Regards,
Peter

 sound/soc/sof/ipc4-topology.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 669b99a4f76e..3a5394c3dd83 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1806,10 +1806,12 @@ static int sof_ipc4_route_setup(struct snd_sof_dev *sdev, struct snd_sof_route *
 	int ret;
 
 	if (!src_fw_module || !sink_fw_module) {
-		/* The NULL module will print as "(efault)" */
-		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
-			src_fw_module->man4_module_entry.name,
-			sink_fw_module->man4_module_entry.name);
+		dev_err(sdev->dev,
+			"cannot bind %s -> %s, no firmware module for: %s%s\n",
+			src_widget->widget->name, sink_widget->widget->name,
+			src_fw_module ? "" : " source",
+			sink_fw_module ? "" : " sink");
+
 		return -ENODEV;
 	}
 
-- 
2.40.0

