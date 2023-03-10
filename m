Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C846B4AFD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbjCJP3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbjCJP2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:28:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EFA22CA8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 759EA6196E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D06C433D2;
        Fri, 10 Mar 2023 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461394;
        bh=NL6HpkWJnBfdZo9mrTKscaDtinx4Q/cg/fhoc7Vbw+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QC6CAuJqGHKT+gmw68mo7x3IuGpu81cdYmikkdeV2vbP64+qGJkHvkwKvwnlrkh28
         kEX1csiWHtq5dfbKuIkusM2ytc2jtOeGjQy7mldey9ipCTlODyKCGGy2m7odCjHLjW
         MkFgy3sueJMB1VaeecHf5AIaPzoi6urRaW7x1eNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/136] soundwire: cadence: Remove wasted space in response_buf
Date:   Fri, 10 Mar 2023 14:44:04 +0100
Message-Id: <20230310133710.899871682@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 827c32d0df4bbe0d1c47d79f6a5eabfe9ac75216 ]

The response_buf was declared much larger (128 entries) than the number
of responses that could ever be written into it. The Cadence IP is
configurable up to a maximum of 32 entries, and the datasheet says
that RX_FIFO_AVAIL can be 2 larger than this. So allow up to 34
responses.

Also add checking in cdns_read_response() to prevent overflowing
reponse_buf if RX_FIFO_AVAIL contains an unexpectedly large number.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221202161812.4186897-3-rf@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c |  7 +++++++
 drivers/soundwire/cadence_master.h | 13 ++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 0339e6df6eb78..74af111f39127 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -770,8 +770,15 @@ static void cdns_read_response(struct sdw_cdns *cdns)
 	u32 num_resp, cmd_base;
 	int i;
 
+	/* RX_FIFO_AVAIL can be 2 entries more than the FIFO size */
+	BUILD_BUG_ON(ARRAY_SIZE(cdns->response_buf) < CDNS_MCP_CMD_LEN + 2);
+
 	num_resp = cdns_readl(cdns, CDNS_MCP_FIFOSTAT);
 	num_resp &= CDNS_MCP_RX_FIFO_AVAIL;
+	if (num_resp > ARRAY_SIZE(cdns->response_buf)) {
+		dev_warn(cdns->dev, "RX AVAIL %d too long\n", num_resp);
+		num_resp = ARRAY_SIZE(cdns->response_buf);
+	}
 
 	cmd_base = CDNS_MCP_CMD_BASE;
 
diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index e587aede63bf0..e437a604429fa 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -8,6 +8,12 @@
 #define SDW_CADENCE_GSYNC_KHZ		4 /* 4 kHz */
 #define SDW_CADENCE_GSYNC_HZ		(SDW_CADENCE_GSYNC_KHZ * 1000)
 
+/*
+ * The Cadence IP supports up to 32 entries in the FIFO, though implementations
+ * can configure the IP to have a smaller FIFO.
+ */
+#define CDNS_MCP_IP_MAX_CMD_LEN		32
+
 /**
  * struct sdw_cdns_pdi: PDI (Physical Data Interface) instance
  *
@@ -119,7 +125,12 @@ struct sdw_cdns {
 	struct sdw_bus bus;
 	unsigned int instance;
 
-	u32 response_buf[0x80];
+	/*
+	 * The datasheet says the RX FIFO AVAIL can be 2 entries more
+	 * than the FIFO capacity, so allow for this.
+	 */
+	u32 response_buf[CDNS_MCP_IP_MAX_CMD_LEN + 2];
+
 	struct completion tx_complete;
 	struct sdw_defer *defer;
 
-- 
2.39.2



