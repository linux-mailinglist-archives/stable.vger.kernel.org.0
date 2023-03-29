Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8E36CD897
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 13:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjC2LiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 07:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjC2LiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 07:38:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C9A3596
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 04:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680089878; x=1711625878;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E+ffUpHrVx1RXmyEoo1Pw68WP8xips1tEnQiz6jLQMI=;
  b=j1P/UQUvgQCoYtka56JTZvA9tXNomujfKGmkQeMcopRv/fuJvGVd4TXH
   IH/iZrMf5cCUqW2rkmimCe1KpH71sGAJ/wODlvSKdhnwGeZEq9yGTCOEF
   sqfn1sfZVvVoae5rOK1kE4BlqMkw2h12RQOtmbIuz2ybbtQIicOUM3A3k
   iEbfCpaZKHlJw8EJHE4kZ8lIeCUHSBqZvy47OzyjvNpclk/JfC51gTeoT
   pMkb9nhdpX/mbuF177+xELuETXiFnIl83vGUlUyZRlegULvKWH95AxWM0
   UmYwrWvhYgcZ8AW7S+cSIaNyB3M/ZUvevsiWC5JOsTa0pl6gXoUfoRm1A
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403476136"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="403476136"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 04:37:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="795205168"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="795205168"
Received: from dfchaves-mobl.amr.corp.intel.com (HELO pujfalus-desk.ger.corp.intel.com) ([10.252.41.108])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 04:37:55 -0700
From:   Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
To:     lgirdwood@gmail.com, broonie@kernel.org
Cc:     alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com, stable@vger.kernel.org
Subject: [PATCH for v6.3-rc] ASoC: SOF: avoid a NULL dereference with unsupported widgets
Date:   Wed, 29 Mar 2023 14:38:28 +0300
Message-Id: <20230329113828.28562-1-peter.ujfalusi@linux.intel.com>
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

From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

If an IPC4 topology contains an unsupported widget, its .module_info
field won't be set, then sof_ipc4_route_setup() will cause a kernel
Oops trying to dereference it. Add a check for such cases.

Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
---
Hi Mark,

This patch is generated on top of 6.3-rc4, it will have conflict with asoc-next
because we have ChainDMA scheduled for 6.4 in there.
I should have taken this patch a faster track, but missed it when arranging the
patches, features.
We noticed this when trying to use our development IPC4 topologies with mainline
which does not yet able to handle the process module types (slated fro 6.4).
IPC4 is still evolving so it is not rare that fw/tplg/kernel needs to be
lock-stepped, but NULL pointer dereference should not happen.

This is how the merge conflict resolution should end up between 6.3 and 6.4:

int ret;

/* no route set up if chain DMA is used */
if (src_pipeline->use_chain_dma || sink_pipeline->use_chain_dma) {
	if (!src_pipeline->use_chain_dma || !sink_pipeline->use_chain_dma) {
		dev_err(sdev->dev,
			"use_chain_dma must be set for both src %s and sink %s pipelines\n",
			src_widget->widget->name, sink_widget->widget->name);
		return -EINVAL;
	}
	return 0;
}

if (!src_fw_module || !sink_fw_module) {
	/* The NULL module will print as "(efault)" */
	dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
		src_fw_module->man4_module_entry.name,
		sink_fw_module->man4_module_entry.name);
	return -ENODEV;
}

sroute->src_queue_id = sof_ipc4_get_queue_id(src_widget, sink_widget,
					     SOF_PIN_TYPE_SOURCE);


Can you send this patch for 6.3 cycle?

Thank you,
Peter

 sound/soc/sof/ipc4-topology.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index a623707c8ffc..669b99a4f76e 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1805,6 +1805,14 @@ static int sof_ipc4_route_setup(struct snd_sof_dev *sdev, struct snd_sof_route *
 	u32 header, extension;
 	int ret;
 
+	if (!src_fw_module || !sink_fw_module) {
+		/* The NULL module will print as "(efault)" */
+		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
+			src_fw_module->man4_module_entry.name,
+			sink_fw_module->man4_module_entry.name);
+		return -ENODEV;
+	}
+
 	sroute->src_queue_id = sof_ipc4_get_queue_id(src_widget, sink_widget,
 						     SOF_PIN_TYPE_SOURCE);
 	if (sroute->src_queue_id < 0) {
-- 
2.40.0

