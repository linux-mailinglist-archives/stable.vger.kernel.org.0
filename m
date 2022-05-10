Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DE3521078
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 11:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbiEJJUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 05:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238514AbiEJJUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 05:20:47 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CA3209B4E;
        Tue, 10 May 2022 02:16:50 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24A9GgVC090455;
        Tue, 10 May 2022 04:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1652174202;
        bh=HCLvsLcceoS32V+c9Kah6D+bZwM7/UEjPIu3cYvdX5c=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Lj+WmdLKnScDKuCm4RVky7ExCzikaUphlFlJQuaDNpbML30X9huH2uRIuLbskuuvx
         w8rzfNnprgHK9htLJaXkNjeZzAThimhlAAeU/ABNgQty+soS1gucuNGsb3fxtk5OES
         AEHCUqbzK61/7UzDQf8/uqC4MUpAmPqtKbJQIRVo=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24A9GgdQ105134
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 May 2022 04:16:42 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 10
 May 2022 04:16:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 10 May 2022 04:16:42 -0500
Received: from a0393678ub.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24A9GYeK127131;
        Tue, 10 May 2022 04:16:39 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [RESEND PATCH v2 2/2] xhci: Set HCD flag to defer primary roothub registration
Date:   Tue, 10 May 2022 14:46:30 +0530
Message-ID: <20220510091630.16564-3-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220510091630.16564-1-kishon@ti.com>
References: <20220510091630.16564-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set "HCD_FLAG_DEFER_RH_REGISTER" to hcd->flags in xhci_run() to defer
registering primary roothub in usb_add_hcd() if xhci has two roothubs.
This will make sure both primary roothub and secondary roothub will be
registered along with the second HCD.
This is required for cold plugged USB devices to be detected in certain
PCIe USB cards (like Inateck USB card connected to AM64 EVM or J7200 EVM).

This patch has been added and reverted earier as it triggered a race
in usb device enumeration.
That race is now fixed in 5.16-rc3, and in stable back to 5.4
commit 6cca13de26ee ("usb: hub: Fix locking issues with address0_mutex")
commit 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0
race")

[minor rebase change, and commit message update -Mathias]
CC: stable@vger.kernel.org # 5.4+
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/host/xhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 25b87e99b4dd..2be38d9de8df 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -696,6 +696,8 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
+
 	xhci_create_dbc_dev(xhci);
 
 	xhci_debugfs_init(xhci);
-- 
2.17.1

