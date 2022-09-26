Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D905EA189
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbiIZKwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbiIZKub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAB258B5C;
        Mon, 26 Sep 2022 03:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59385601D2;
        Mon, 26 Sep 2022 10:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475CCC433B5;
        Mon, 26 Sep 2022 10:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188044;
        bh=zXKLPQxflgXEDWXJGg2+JBGZsUTGlj6t+iWUZEX6spc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwtMMncsyzjVT/vfVmGi6EKgATvEzxlMPR9ZinxTJhZRzA4FpzdCPHH9ChkyMzo6s
         jB3bn0UsdgsMNXntWHPkQkRqVASuuA0+w4ut8SBj0fJ6H9xscqixVLE09QR7eWL5G1
         AU0E/FfMucddyvYkzqSXLN7EmRrRl49rtwiF+MGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Azhar Shaikh <azhar.shaikh@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/141] usb: typec: intel_pmc_mux: Update IOM port status offset for AlderLake
Date:   Mon, 26 Sep 2022 12:10:31 +0200
Message-Id: <20220926100754.821644020@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Azhar Shaikh <azhar.shaikh@intel.com>

[ Upstream commit ca5ce82529104e96ccc5e1888979258e233e1644 ]

Intel AlderLake(ADL) IOM has a different IOM port status offset than
Intel TigerLake.
Add a new ACPI ID for ADL and use the IOM port status offset as per
the platform.

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
Link: https://lore.kernel.org/r/20210601035843.71150-1-azhar.shaikh@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1b1b672cc1d4 ("usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 28 ++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index acdef6fbb85e..ea1333ad4b2b 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -83,8 +83,6 @@ enum {
 /*
  * Input Output Manager (IOM) PORT STATUS
  */
-#define IOM_PORT_STATUS_OFFSET				0x560
-
 #define IOM_PORT_STATUS_ACTIVITY_TYPE_MASK		GENMASK(9, 6)
 #define IOM_PORT_STATUS_ACTIVITY_TYPE_SHIFT		6
 #define IOM_PORT_STATUS_ACTIVITY_TYPE_USB		0x03
@@ -144,6 +142,7 @@ struct pmc_usb {
 	struct pmc_usb_port *port;
 	struct acpi_device *iom_adev;
 	void __iomem *iom_base;
+	u32 iom_port_status_offset;
 };
 
 static void update_port_status(struct pmc_usb_port *port)
@@ -153,7 +152,8 @@ static void update_port_status(struct pmc_usb_port *port)
 	/* SoC expects the USB Type-C port numbers to start with 0 */
 	port_num = port->usb3_port - 1;
 
-	port->iom_status = readl(port->pmc->iom_base + IOM_PORT_STATUS_OFFSET +
+	port->iom_status = readl(port->pmc->iom_base +
+				 port->pmc->iom_port_status_offset +
 				 port_num * sizeof(u32));
 }
 
@@ -546,14 +546,32 @@ static int is_memory(struct acpi_resource *res, void *data)
 	return !acpi_dev_resource_memory(res, &r);
 }
 
+/* IOM ACPI IDs and IOM_PORT_STATUS_OFFSET */
+static const struct acpi_device_id iom_acpi_ids[] = {
+	/* TigerLake */
+	{ "INTC1072", 0x560, },
+
+	/* AlderLake */
+	{ "INTC1079", 0x160, },
+	{}
+};
+
 static int pmc_usb_probe_iom(struct pmc_usb *pmc)
 {
 	struct list_head resource_list;
 	struct resource_entry *rentry;
-	struct acpi_device *adev;
+	static const struct acpi_device_id *dev_id;
+	struct acpi_device *adev = NULL;
 	int ret;
 
-	adev = acpi_dev_get_first_match_dev("INTC1072", NULL, -1);
+	for (dev_id = &iom_acpi_ids[0]; dev_id->id[0]; dev_id++) {
+		if (acpi_dev_present(dev_id->id, NULL, -1)) {
+			pmc->iom_port_status_offset = (u32)dev_id->driver_data;
+			adev = acpi_dev_get_first_match_dev(dev_id->id, NULL, -1);
+			break;
+		}
+	}
+
 	if (!adev)
 		return -ENODEV;
 
-- 
2.35.1



