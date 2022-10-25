Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6359F60C732
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiJYJD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiJYJDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:03:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA69159D56;
        Tue, 25 Oct 2022 02:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666688604; x=1698224604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n7m5a560kz8pazJBqnW28hj2rqVi6MtTE1dS+y8uJO4=;
  b=YAsSgPexE4DqixVrhZyXSXC1WUjwzJnMKhvenI1eSVaS72VFjNOUfvPh
   rD14uXjTpltpWlaHT/n+qvVshXWcOmRzESGI4O9gVMFwPqNsD+6o6Fg/J
   kmx2i9YzSF2jWFycQToqOhnfCJUZ6VkKrhsvyPdbS6tMWgET9OeGWfdPw
   jSV2Gu5SiTTTF/182w4dOuIvjP2Pknc1RoifiIf4gIL7DqiLnNSxmd0hY
   /syUteC3aWxowNLeg3QvOVA0FV0jHxA6ts0m5GKpuKEb0kjxBm7+cv6q1
   qNein/P2up14GhZdmDvomVhBhNu2I6rl2X4echRuJhVHVUTny2g5oA9qQ
   w==;
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="183777316"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 02:03:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 02:03:21 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 02:03:18 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <vkoul@kernel.org>, <peda@axentia.se>, <du@axentia.se>
CC:     <maciej.sosnowski@intel.com>, <nicolas.ferre@microchip.com>,
        <mripard@kernel.org>, <torfl6749@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 03/32] dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pending
Date:   Tue, 25 Oct 2022 12:02:37 +0300
Message-ID: <20221025090306.297886-4-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025090306.297886-1-tudor.ambarus@microchip.com>
References: <20221025090306.297886-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cyclic channels must too call issue_pending in order to start a transfer.
Start the transfer in issue_pending regardless of the type of channel.
This wrongly worked before, because in the past the transfer was started
at tx_submit level when only a desc in the transfer list.

Fixes: 53830cc75974 ("dmaengine: at_hdmac: add cyclic DMA operation support")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
---
 drivers/dma/at_hdmac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 3f71f4d2f467..e9d0c3632868 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1536,10 +1536,6 @@ static void atc_issue_pending(struct dma_chan *chan)
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
-	/* Not needed for cyclic transfers */
-	if (atc_chan_is_cyclic(atchan))
-		return;
-
 	atc_advance_work(atchan);
 }
 
-- 
2.25.1

