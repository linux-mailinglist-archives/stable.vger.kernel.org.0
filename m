Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3865707C2
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiGKP5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiGKP5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:57:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F4F33413
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 08:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657555055; x=1689091055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=43JgnO0rG83Q29jX/qSGHBLhVdIzVgOAvIMuEQdJUy4=;
  b=ZtPQH+twmHDWFfuUoAd9UkM6xMwa9HCJwBzRaCDbUWN5B+FnJiquIeOr
   nQUqd+X81YckqvD2l8K9SeS7dtMs69SqtRniqnrYiPx2zJJ+EVV5pl7YN
   GI5GM0zCBThHvCj0OVzKVMEOr7G2s6jrL85uHj3AxN7m901D4oMN9zjcp
   oXEm1zOQhxz+M37FUUj/1olOsEXHQrbiZSfIBAxbTx3RO7KYbEsrGqsQE
   OnZwOnGE1s2gl1B7CRvJQxGr4QLC1E/Ul0c+ZyVG5soHB1N8sUtg8cubT
   NmNk/7Ilj153FCqo7HpPRk4YEOg+PqRSSrCdgqBHJj/5lFhYME2jV3K0w
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="264479644"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="264479644"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:34 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="771553856"
Received: from jbeecha-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.209.161.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:57:33 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: [PATCH 1/3] ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
Date:   Mon, 11 Jul 2022 10:57:17 -0500
Message-Id: <20220711155719.104952-2-pierre-louis.bossart@linux.intel.com>
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

commit 6639990dbb25257eeb3df4d03e38e7d26c2484ab upstream.

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

