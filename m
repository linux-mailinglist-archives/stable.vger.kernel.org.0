Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC4D6D4925
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbjDCOfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbjDCOfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B106D16F09
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63036B81C88
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F3FC433EF;
        Mon,  3 Apr 2023 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532505;
        bh=5hDqYyvqlV8Bo90sllU5fpXSgThq0RxaW1rl9qBcAeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcD1UN3G97+eBFw+WQb5KIN4tuqFffYSr+fHbCLZnaXsKMSVbbrSNgJWG97Du1Ljp
         agQTo89+Uql1dDDGMQdzVnFamyak47rLd/VnJmcrQB4wlBaMtU5Xvt0UqDT1fVKkIr
         8yGyBdD+4iWtuXSo6vbtrXiYBOVG9RSQyXIa6ZC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gil Fine <gil.fine@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/181] thunderbolt: Limit USB3 bandwidth of certain Intel USB4 host routers
Date:   Mon,  3 Apr 2023 16:07:16 +0200
Message-Id: <20230403140415.140110769@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit f0a57dd33b3eadf540912cd130db727ea824d174 ]

Current Intel USB4 host routers have hardware limitation that the USB3
bandwidth cannot go higher than 16376 Mb/s. Work this around by adding a
new quirk that limits the bandwidth for the affected host routers.

Cc: stable@vger.kernel.org
Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/quirks.c | 31 +++++++++++++++++++++++++++++++
 drivers/thunderbolt/tb.h     |  3 +++
 drivers/thunderbolt/usb4.c   | 17 +++++++++++++++--
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index ae28a03fa890b..1157b8869bcca 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -26,6 +26,19 @@ static void quirk_clx_disable(struct tb_switch *sw)
 	tb_sw_dbg(sw, "disabling CL states\n");
 }
 
+static void quirk_usb3_maximum_bandwidth(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	tb_switch_for_each_port(sw, port) {
+		if (!tb_port_is_usb3_down(port))
+			continue;
+		port->max_bw = 16376;
+		tb_port_dbg(port, "USB3 maximum bandwidth limited to %u Mb/s\n",
+			    port->max_bw);
+	}
+}
+
 struct tb_quirk {
 	u16 hw_vendor_id;
 	u16 hw_device_id;
@@ -43,6 +56,24 @@ static const struct tb_quirk tb_quirks[] = {
 	 * DP buffers.
 	 */
 	{ 0x8087, 0x0b26, 0x0000, 0x0000, quirk_dp_credit_allocation },
+	/*
+	 * Limit the maximum USB3 bandwidth for the following Intel USB4
+	 * host routers due to a hardware issue.
+	 */
+	{ 0x8087, PCI_DEVICE_ID_INTEL_ADL_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_ADL_NHI1, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_RPL_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_RPL_NHI1, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_MTL_M_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_MTL_P_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_MTL_P_NHI1, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
 	/*
 	 * CLx is not supported on AMD USB4 Yellow Carp and Pink Sardine platforms.
 	 */
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index e11d973a8f9b6..f034723b1b40e 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -252,6 +252,8 @@ struct tb_switch {
  * @ctl_credits: Buffers reserved for control path
  * @dma_credits: Number of credits allocated for DMA tunneling for all
  *		 DMA paths through this port.
+ * @max_bw: Maximum possible bandwidth through this adapter if set to
+ *	    non-zero.
  *
  * In USB4 terminology this structure represents an adapter (protocol or
  * lane adapter).
@@ -277,6 +279,7 @@ struct tb_port {
 	unsigned int total_credits;
 	unsigned int ctl_credits;
 	unsigned int dma_credits;
+	unsigned int max_bw;
 };
 
 /**
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index cf8d4f769579e..3c821f5e44814 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1865,6 +1865,15 @@ int usb4_port_retimer_nvm_read(struct tb_port *port, u8 index,
 				usb4_port_retimer_nvm_read_block, &info);
 }
 
+static inline unsigned int
+usb4_usb3_port_max_bandwidth(const struct tb_port *port, unsigned int bw)
+{
+	/* Take the possible bandwidth limitation into account */
+	if (port->max_bw)
+		return min(bw, port->max_bw);
+	return bw;
+}
+
 /**
  * usb4_usb3_port_max_link_rate() - Maximum support USB3 link rate
  * @port: USB3 adapter port
@@ -1886,7 +1895,9 @@ int usb4_usb3_port_max_link_rate(struct tb_port *port)
 		return ret;
 
 	lr = (val & ADP_USB3_CS_4_MSLR_MASK) >> ADP_USB3_CS_4_MSLR_SHIFT;
-	return lr == ADP_USB3_CS_4_MSLR_20G ? 20000 : 10000;
+	ret = lr == ADP_USB3_CS_4_MSLR_20G ? 20000 : 10000;
+
+	return usb4_usb3_port_max_bandwidth(port, ret);
 }
 
 /**
@@ -1913,7 +1924,9 @@ int usb4_usb3_port_actual_link_rate(struct tb_port *port)
 		return 0;
 
 	lr = val & ADP_USB3_CS_4_ALR_MASK;
-	return lr == ADP_USB3_CS_4_ALR_20G ? 20000 : 10000;
+	ret = lr == ADP_USB3_CS_4_ALR_20G ? 20000 : 10000;
+
+	return usb4_usb3_port_max_bandwidth(port, ret);
 }
 
 static int usb4_usb3_port_cm_request(struct tb_port *port, bool request)
-- 
2.39.2



