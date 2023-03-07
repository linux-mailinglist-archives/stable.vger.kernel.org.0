Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820036AF4D0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbjCGTUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjCGTTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:19:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7A1BD4C7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:03:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03FB8B819DB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534C5C4339B;
        Tue,  7 Mar 2023 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215818;
        bh=1JuYttSn3ht/CJWRtuEQTErsofXMlpxaYWbopeHMiLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpy8vvbHy6SK71TpWLuAQRqBg+3bzoAe1Gb0IPodaCMKvD3FbJkj9MWM27snhfWMr
         cGUU3T2vZMoQRBB7jKN07FFrWQr+/0TzbU5NW1zgJEe8i4y+GfHiNH0A7X2Wa90Hg1
         i8jPdyqOFyOyRT6/soPLl2HTNZ+q6II3ZC/rcmLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Zimmermann <tim@linux4.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/567] thermal: intel: intel_pch: Add support for Wellsburg PCH
Date:   Tue,  7 Mar 2023 18:02:00 +0100
Message-Id: <20230307165922.489441031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Tim Zimmermann <tim@linux4.de>

[ Upstream commit 40dc1929089fc844ea06d9f8bdb6211ed4517c2e ]

Add the PCI ID for the Wellsburg C610 series chipset PCH.

The driver can read the temperature from the Wellsburg PCH with only
the PCI ID added and no other modifications.

Signed-off-by: Tim Zimmermann <tim@linux4.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_pch_thermal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
index 527c91f5960be..768c66046a599 100644
--- a/drivers/thermal/intel/intel_pch_thermal.c
+++ b/drivers/thermal/intel/intel_pch_thermal.c
@@ -29,6 +29,7 @@
 #define PCH_THERMAL_DID_CNL_LP	0x02F9 /* CNL-LP PCH */
 #define PCH_THERMAL_DID_CML_H	0X06F9 /* CML-H PCH */
 #define PCH_THERMAL_DID_LWB	0xA1B1 /* Lewisburg PCH */
+#define PCH_THERMAL_DID_WBG	0x8D24 /* Wellsburg PCH */
 
 /* Wildcat Point-LP  PCH Thermal registers */
 #define WPT_TEMP	0x0000	/* Temperature */
@@ -345,6 +346,7 @@ enum board_ids {
 	board_cnl,
 	board_cml,
 	board_lwb,
+	board_wbg,
 };
 
 static const struct board_info {
@@ -375,6 +377,10 @@ static const struct board_info {
 		.name = "pch_lewisburg",
 		.ops = &pch_dev_ops_wpt,
 	},
+	[board_wbg] = {
+		.name = "pch_wellsburg",
+		.ops = &pch_dev_ops_wpt,
+	},
 };
 
 static int intel_pch_thermal_probe(struct pci_dev *pdev,
@@ -490,6 +496,8 @@ static const struct pci_device_id intel_pch_thermal_id[] = {
 		.driver_data = board_cml, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_LWB),
 		.driver_data = board_lwb, },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_WBG),
+		.driver_data = board_wbg, },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, intel_pch_thermal_id);
-- 
2.39.2



