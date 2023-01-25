Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9998467B372
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 14:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbjAYNfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 08:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbjAYNfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 08:35:05 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CCA5898A;
        Wed, 25 Jan 2023 05:35:03 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PD0YBq012677;
        Wed, 25 Jan 2023 13:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=PPS06212021;
 bh=LfjvalWby16qgVY2AxSseKaNlKAryq1N+BoZwpl2yUg=;
 b=nuhNVjJh1dl7W9Ognpgr8Mvm8VpMvUTdoC2om81tgfSwHxsJmdao3WueSG+MgPCxdkel
 IRfzYrH8Q/rkZyupSkXd1WpES5rLhE+9zDg6Apeyel6GxE9dgy6r/Gt4zSCQfZ8d1GbC
 VfDqGx1THWLccTbvEOK+2H8AhtQnDwap4GJ2CprcaOp4GrJekbes/Pwlvtq8eRO0FbK7
 d8vN6nBtoN2k3E2oObprpSLJJLT1Ba4lloVlgIKkdD4K5ra4OVte1PlDaIcxcJSWTOMK
 306Z+9zXSCA+9g4lg5Xj0g1G3ezX64L5qP/PaZMXSdPG8HUjM6cWrRUBhkU5zzNpByiv AQ== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3n85934k7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Jan 2023 13:35:00 +0000
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 25 Jan 2023 05:34:59 -0800
Received: from otp-azaharia-d1.corp.ad.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.17 via Frontend Transport; Wed, 25 Jan 2023 05:34:57 -0800
From:   Adrian Zaharia <adrian.zaharia@windriver.com>
To:     <stable@vger.kernel.org>
CC:     <mathias.nyman@intel.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5.10 1/1] xhci: Set HCD flag to defer primary roothub registration
Date:   Wed, 25 Jan 2023 15:33:59 +0200
Message-ID: <20230125133359.3538078-2-adrian.zaharia@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230125133359.3538078-1-adrian.zaharia@windriver.com>
References: <20230125133359.3538078-1-adrian.zaharia@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NL6R-LJuFKEkEYdEzGIxeXFTfRuGGdxi
X-Proofpoint-GUID: NL6R-LJuFKEkEYdEzGIxeXFTfRuGGdxi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_08,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 suspectscore=0
 bulkscore=0 phishscore=0 malwarescore=0 impostorscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit b7a4f9b5d0e4b6dd937678c546c0b322dd1a4054 ]

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
Link: https://lore.kernel.org/r/20220510091630.16564-3-kishon@ti.com
Signed-off-by: Adrian Zaharia <Adrian.Zaharia@windriver.com>
---
 drivers/usb/host/xhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2967372a9988..473b0b64dd57 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -696,6 +696,8 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
+
 	xhci_dbc_init(xhci);
 
 	xhci_debugfs_init(xhci);
-- 
2.39.1

