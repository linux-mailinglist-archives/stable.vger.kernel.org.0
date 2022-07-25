Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B615803C2
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiGYSGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiGYSFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:05:02 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02141C938
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 11:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658772301; x=1690308301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qiqhk1Qf7fv2aJwIZ00nCRW3W43wffhKyHqojZorF6E=;
  b=c5FJaHfZWyiW5B3C63ni4FXGQWdoXV+2DTSSLyOHcYbJwQY8b2ixoPGD
   yego00K8EwrPM9f4Wwv7FX0zeOt2UJWWLzQSJeg62MyBvzTYJ48i+DoA/
   KDMhWM3f8FnzluJhyNP74OwzxvAkq4lP0Ks3BCpKtmNgYpnHZWLPeJHOs
   4Me1yzRS0+N1WjKOeil7HtSy+bg9P+cYSCI/+xshH5TYDGQG0asfcggft
   eJHaxUWXjapzvuo/N/7QePVm+z2WjgxLBiSyw52b7cE23HMc6MhKDfhD6
   1WtdnEONwVqZMqMtOwrl0VVO0Bew81HhXUgSkgZ9gJr2qQTlSh1FKVmiB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="274627570"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="274627570"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:05:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="632449952"
Received: from jxzhao-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.212.0.178])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:05:00 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>
Subject: [PATCH v2 1/3] ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
Date:   Mon, 25 Jul 2022 13:04:47 -0500
Message-Id: <20220725180449.12742-2-pierre-louis.bossart@linux.intel.com>
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

commit a933084558c61cac8c902d2474b39444d87fba46 upstream.

The existing code only deals with S0 and S3, let's start adding S1 and S2.

No functional change.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
---
 sound/soc/sof/pm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 1c319582ca6f..937354c25856 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -327,8 +327,18 @@ int snd_sof_prepare(struct device *dev)
 		return 0;
 
 #if defined(CONFIG_ACPI)
-	if (acpi_target_system_state() == ACPI_STATE_S0)
+	switch (acpi_target_system_state()) {
+	case ACPI_STATE_S0:
 		sdev->system_suspend_target = SOF_SUSPEND_S0IX;
+		break;
+	case ACPI_STATE_S1:
+	case ACPI_STATE_S2:
+	case ACPI_STATE_S3:
+		sdev->system_suspend_target = SOF_SUSPEND_S3;
+		break;
+	default:
+		break;
+	}
 #endif
 
 	return 0;
-- 
2.34.1

