Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1AE20EADB
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 03:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgF3B0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 21:26:23 -0400
Received: from mail-eopbgr70081.outbound.protection.outlook.com ([40.107.7.81]:64598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbgF3B0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 21:26:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqYr5mFFOy2mBRFH/opx1lbGlVbwCsqWEBgd0tkZKMQg/X+K56Jclkb7nhrdYoTrWELhcaRzo9ImS6oCl7cdqfAZqHISfv7rr8DfZmhOG7lqoY2tdxkG8DDlVvx89SDhy9hUON9Lbk2bSghk+Kl+nohNhfrSEp8mCwuHz0nzW0tnFT0UfVe+ZYdhKELP0Nxxrl+Fchiv4TLe4b6Zru8sYZzXUX33O4l3cNQ443LrpH60EIhdu7iIDCS/Pkp+qKwhtB/aIRQPlJT7TzYT6uG5CVZdoT0r2MdwJAeOf4UQO9p6ND1qkyXq3uWWGLlLmepzx7lIyq2kkOgXoJJgHBf8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChkQw4zdBBqb0KChY87aNNt4d5AK4QqSERRxLOnOqII=;
 b=bgujtFQwC8cYIsC/asEoMPI1GLOAM4/srqPdpQbMT4shCTMvHnjWZKadxI9bBU87FmgvmmkHsl91tId9mMBgN+VaHrq90j1xqBWuiK+ewsZsn3sdqi6iBI1XH6St9e+SmanMmVzn7NmDpCFWQPOL2h5R5pH/bBlqrfutzbNpT38FoxNta1JpvSU9KbFYqErZBFdKR2ykY0VIBOBS1T6Y5WpkZqdouEGT229/T0o2a6k+c2Q8Fvlyq/cbPME+4dG9cG0Jm5aP6bpKUo4Elx1cHoTg+vHcG+vMqbP59De9hcUD4l9o3QGDM6tFQoEbuopUPivsGUMEfylBsBaF44rHZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChkQw4zdBBqb0KChY87aNNt4d5AK4QqSERRxLOnOqII=;
 b=mO81fqystvImWuW8VXxpF0HRMFaYbx+ld7hYK8uofWbF3Tu0VXKetRs5bKONdksrhmT+AjOOcmeKGG88dDrMKZeWFAjMdgDZ1xx6ZPEM27T4qAN12jNFW01TObhDHICYrv26otxLgj8a/BiVeE434UjfOi02iq6J4jwi0g1dXT8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM6PR04MB5093.eurprd04.prod.outlook.com (2603:10a6:20b:4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Tue, 30 Jun
 2020 01:26:19 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 01:26:19 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     linux-usb@vger.kernel.org
Cc:     linux-imx@nxp.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] usb: chipidea: core: add wakeup support for extcon
Date:   Tue, 30 Jun 2020 09:26:30 +0800
Message-Id: <20200630012630.13396-1-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:3:18::13) To AM7PR04MB7157.eurprd04.prod.outlook.com
 (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.67) by SG2PR02CA0025.apcprd02.prod.outlook.com (2603:1096:3:18::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 01:26:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f166e5f3-a9be-4afa-e79d-08d81c94973e
X-MS-TrafficTypeDiagnostic: AM6PR04MB5093:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB5093D3F4F6049606FFB3E10B8B6F0@AM6PR04MB5093.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yFkJ+DISb88J/7rOyJxJHSUDpN4JfknxdWP7LN5WPQJGsfy/kPF5Ey8ki1y8ztCG+/bwPFdIMlO6r8vnBy8dAB29jlFIX9jtn5JsC0JfmfemUJ6uUAm3oNeQuF0165YDIYXGA4NUVTFxo5Eh1c+AEYT2ERkMELNwUsnQNxLYSw1d8JCoIY41dlKyWCnJUsuadOCtgHTNZas6sPTCC7Sv/kQ5mYZt9SXmei2Nhy7FATgKDfKoPKIdWre2Jl40li8sjcBWWUD+UyfGNRbOx+kDscCb1xFQlDpYVyFsIa6VaJQe3zCuP5idfEtr7M8tw5S+y+Ual29gEIdRL49bHdwkmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(186003)(16526019)(86362001)(956004)(2616005)(66946007)(6506007)(66556008)(26005)(36756003)(6486002)(1076003)(66476007)(44832011)(316002)(83380400001)(6512007)(5660300002)(450100002)(4326008)(8936002)(6916009)(478600001)(2906002)(52116002)(8676002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G4ZJ4pE2Gx/Tc9hKAGN8ViNvdkk23uksjeCfSorsqTS0s0NM+/zmJS+pL+AysbXteC1oz2K6if3RP5QuPfb/guqAuv91/XjK4n85gTTco7rEbIo+pNJPxLsADGllCbd8QPByDGTiBmm3jo7ts1UIl3Sy6By/DRbud6fLImac3HA7d2SxdjiuEgiEmD2w/Qr5eO/tzXOH7WaD7kzSs1hJtgZ5DEJTjAokkHoyBtQr7A/WbxS8XTlo3htcjSAoyRHUjh4SzXIkZK3Efxr+mjnRhhUx5pWFiL74yUP+/HiBP8tKfRCe+zOshDAwN1vEq+n407f+ohfiD/TZJjJ+fQAsXRhraqxGzGdLRhq2OcrUDYKcCW69fk/pujCc8TdrdZrfxCWEnvNShQf1bUzG/zpebPx+fxBj7i/Ayt35ixtRGilDSRq1Nbk53EEHOx1gHYM+zImC9zgxdc1bh7OBI8i6WzIY8xKRDxtycons6sSU4+k=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f166e5f3-a9be-4afa-e79d-08d81c94973e
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7157.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 01:26:19.3335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FBlSi15F5l8vJzAq9IVpZXQVyErjswa8Zlwz6bPKut0UEC7WhaoS/OttrltjeAxeEccWihc0qN50SkHXHYCdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5093
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If wakeup event occurred by extcon event, it needs to call
ci_irq again since the first ci_irq calling at extcon notifier
only wakes up controller, but do noop for event handling,
it causes the extcon use case can't work well from low power mode.

Cc: <stable@vger.kernel.org>
Fixes: 3ecb3e09b042 ("usb: chipidea: Use extcon framework for VBUS and ID detect")
Reported-by: Philippe Schenker <philippe.schenker@toradex.com>
Tested-by: Philippe Schenker <philippe.schenker@toradex.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/chipidea/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index e8ce300ad490..9e10dcfeb98f 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1313,6 +1313,29 @@ static void ci_controller_suspend(struct ci_hdrc *ci)
 	enable_irq(ci->irq);
 }
 
+/*
+ * Handle the wakeup interrupt triggered by extcon connector
+ * We need to call ci_irq again for extcon since the first
+ * interrupt (wakeup int) only let the controller be out of
+ * low power mode, but not handle any interrupts.
+ */
+static void ci_extcon_wakeup_int(struct ci_hdrc *ci)
+{
+	struct ci_hdrc_cable *cable_id, *cable_vbus;
+	u32 otgsc = hw_read_otgsc(ci, ~0);
+
+	cable_id = &ci->platdata->id_extcon;
+	cable_vbus = &ci->platdata->vbus_extcon;
+
+	if (!IS_ERR(cable_id->edev) && ci->is_otg &&
+		(otgsc & OTGSC_IDIE) && (otgsc & OTGSC_IDIS))
+		ci_irq(ci->irq, ci);
+
+	if (!IS_ERR(cable_vbus->edev) && ci->is_otg &&
+		(otgsc & OTGSC_BSVIE) && (otgsc & OTGSC_BSVIS))
+		ci_irq(ci->irq, ci);
+}
+
 static int ci_controller_resume(struct device *dev)
 {
 	struct ci_hdrc *ci = dev_get_drvdata(dev);
@@ -1343,6 +1366,7 @@ static int ci_controller_resume(struct device *dev)
 		enable_irq(ci->irq);
 		if (ci_otg_is_fsm_mode(ci))
 			ci_otg_fsm_wakeup_by_srp(ci);
+		ci_extcon_wakeup_int(ci);
 	}
 
 	return 0;
-- 
2.17.1

