Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627C65958E7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiHPKtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiHPKst (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:48:49 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A5CFC30F;
        Tue, 16 Aug 2022 03:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660644984; x=1692180984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hkWcQNjVhGcUtHECBaMGjDVMJWJKeF34QritOqABUew=;
  b=ZrxRQfBCt5F+BNabZdkOjlN2hzvo5bqBcGoDzyZOfk0oG290X21MCRg0
   SGpdd34hFVLX7ai4w7JH7RVonQnPCyea5jYmeBvGTa66INYPtFXDlMhWr
   L0k7OIh04E71OVijvoqB+uqrFbCpRdjoMYT3zaosQDP84xMD12fZPWvdT
   hzeBUrf0sh+EumLZwP9Ltq4+82xGfqLQMuBJN42EFvU9vHkGJ6X/Urmol
   0WBcI5x0fj3MC/NIqfsGxSv+uP1Zsna6ytKbMhQD9cMFiE45qhTxQmL22
   dQcvcEl4352ji8MlwTtwexEpn1Z90KVbk2p3UWko9tpePDgoHHaIJceE/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="279141259"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="279141259"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 03:16:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="749260748"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 16 Aug 2022 03:16:19 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Utkarsh Patel <utkarsh.h.patel@intel.com>, rajmohan.mani@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/6] usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device
Date:   Tue, 16 Aug 2022 13:16:24 +0300
Message-Id: <20220816101629.69054-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220816101629.69054-1-heikki.krogerus@linux.intel.com>
References: <20220816101629.69054-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

This adds the necessary ACPI ID for Intel Meteor Lake
IOM devices.

The callback function is_memory() is modified so that it
also checks if the resource descriptor passed to it is a
memory type "Address Space Resource Descriptor".

On Intel Meteor Lake the ACPI memory resource is not
described using the "32-bit Memory Range Descriptor" because
the memory is outside of the 32-bit address space. The
memory resource is described using the "Address Space
Resource Descriptor" instead.

Intel Meteor Lake is the first platform to describe the
memory resource for this device with Address Space Resource
Descriptor, but it most likely will not be the last.
Therefore the change to the is_memory() callback function
is made generic.

Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Cc: stable@vger.kernel.org
[ heikki: Rewrote the commit message. ]
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 47b733f78fb0d..a8e273fe204ab 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -571,9 +571,11 @@ static int pmc_usb_register_port(struct pmc_usb *pmc, int index,
 
 static int is_memory(struct acpi_resource *res, void *data)
 {
-	struct resource r;
+	struct resource_win win = {};
+	struct resource *r = &win.res;
 
-	return !acpi_dev_resource_memory(res, &r);
+	return !(acpi_dev_resource_memory(res, r) ||
+		 acpi_dev_resource_address_space(res, &win));
 }
 
 /* IOM ACPI IDs and IOM_PORT_STATUS_OFFSET */
@@ -583,6 +585,9 @@ static const struct acpi_device_id iom_acpi_ids[] = {
 
 	/* AlderLake */
 	{ "INTC1079", 0x160, },
+
+	/* Meteor Lake */
+	{ "INTC107A", 0x160, },
 	{}
 };
 
-- 
2.35.1

