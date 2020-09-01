Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89182585AF
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 04:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgIACgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 22:36:21 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:19266
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbgIACgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 22:36:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A55D6rtAbEmjnXZoODe5mhIsCxszIi1Uv1FN0k9Ar0O4KlwqY2/FBFj6U1B1JXUvD1vgxm4ck2n6G6g8Plu0wWLFyQbqPLXBkv3QyhN84iOZa/iiODlAN62TCuymkXQ1zN5yEeJAy9ri5ZRCKYGzSRFxWJ0M2r6m0L7DidCesp2zG6CT4lSeHpOSE3hkZPKlwa/QgGwAUBXCnw6sQR0D73wM31KEKZFEwQGuExXkUdHDoNIpOo6WcaJ/mAh9+7TpmZdajaPfHeLBqntLuWO+2zP31+W7LRnPmLzPMV2quaasgFuHMVTmSTSzkOs4wLhqCaaGoSve5hZoPPgxi1n9FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfVP43N+y95YfzTo+kpZ5ayQwbTfDUGjLhhFAboI3uQ=;
 b=clpevNfLWsoePJ45NuQ5pHqJ4NjbYBe8b/q3L9+yySLy5Jegz/KI6mG6ReUjEb8ONTHfnwr3edvwdn8dB62Zkjdml7p0koezy8THNxtS2iw0Gr/gvizCij7oTMpHG5sUHZjXY8iz6ax5/MZF0BiLaDTaCBsuMk4AG/V/SLtqv0iYR3EmvU+drfUwFmYutcsQU64A2LsFWnt8TX9b7C8eXBdLNFG0MQhwivxNR3Gl04WnojqLDfj9qZV5Ujh/cNKQwVdiaz4kdaZmDvfPSJB+jNpRNrO34sjLQEQqWLXv0SQme899A1EkLVZA30qVho+kL63ntsRcKSsHEjmAAhe6sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfVP43N+y95YfzTo+kpZ5ayQwbTfDUGjLhhFAboI3uQ=;
 b=d+wre45ljVSimYbUfxdocPk0qXOm5yBngV/2oQZbskomSPbfGr8JvCcZM7i+lD2l8t2qCoFI18k8lKz59YeqIzJrp6x+93SWOMtVeTpvUqFHBK+WCQXEIDr6jgVlLshYS3qQaZ3VsUpbIbRYSpPxv98r4QyJknl6MIqK5N64zZo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB6998.eurprd04.prod.outlook.com (2603:10a6:20b:10a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Tue, 1 Sep
 2020 02:36:17 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1023:be8d:40c:efe1]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1023:be8d:40c:efe1%3]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 02:36:17 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, gregkh@linuxfoundation.org, jun.li@nxp.com,
        Peter Chen <peter.chen@nxp.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] usb: cdns3: gadget: free interrupt after gadget has deleted
Date:   Tue,  1 Sep 2020 10:35:49 +0800
Message-Id: <20200901023549.25688-1-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0088.apcprd06.prod.outlook.com
 (2603:1096:3:14::14) To AM7PR04MB7157.eurprd04.prod.outlook.com
 (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.66) by SG2PR06CA0088.apcprd06.prod.outlook.com (2603:1096:3:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 1 Sep 2020 02:36:14 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 212c8d59-3436-422a-5681-08d84e1fcd8f
X-MS-TrafficTypeDiagnostic: AM7PR04MB6998:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB699807A968E74FF3ED7061108B2E0@AM7PR04MB6998.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:288;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZJqIud1j/v2nHEDt//I2QDqJQboc8DsmV2Hy5uuODrZhVImq+QZF/aLTE9QAPmUkmCpqdzN+X2fzD1oDhfd0PCnApebQEPOgpcS/TAWMFJ5Z51S22wNALiZxSQ3Qmx9XMwSIIOGmeKSHcZWV5xhYTlEcHM+xghW3Q3b3EMgwQf9VO3VVt9om+IrMv1KYznCOm1LpvwTot/BnTpNZEZ9cxdG7ZH0l3Ys1Mk2NaD3LGx4kQC9vjD7FUhKBlxqKbjognBILDwxvqDrrbcuRjeMGkuo3YjbMYfeVeSC+Tub5wuYXc3WYkwgFHX25ey4htuLvDJaY7skLNK5I+MqqEmSfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(8936002)(6916009)(2906002)(6486002)(52116002)(2616005)(66556008)(66946007)(956004)(66476007)(316002)(44832011)(86362001)(8676002)(5660300002)(36756003)(4326008)(186003)(83380400001)(16526019)(6506007)(6512007)(478600001)(6666004)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: h7zk00PFsXEtvoHoBtvJF74lhFPX2RwLVUo47XrNWKH6MJSjfoQl1R9X163gJvDh9xsBXYfOsZHcCPdpfn63zMOEgLI9Fg2tVg8dI6qhgVG15QGpD3Tv/AhDerRlYR/XLDmBmWskhWZvTWoQxavqOCECPKHr1lGQgVnJeH0Exq5aVwXrD8mZ6HquFGu/X8DEyL1zzh8zdy9IRjMmr4lA7QXDocJDjmTfEPbW67HMny5Yf7am/aZtUTBa1LQm1biZaOqJbW2HN0WEj0QdrnUippTbnZVnZmYxbC7uxfcB0c7YzjxORWqhUo2UCCF6zqjwRLXQrruXAgQ87ouJuI7awHhE7nrwQYip7wse81TLCYqt/OGSI7uFrBhn7u+RDbLNZI4mYRCeJk4HCZI0V6Ubjmir5PXDpqbWF9C4m0mbE1442pVv4qG/+27WGUjhno3IzYxRb4wlGY9xxXv49kZ0I/r1429T50R2MOz/xvR5WwMfCrYrycVKangbp42IByzf+fS9OmyI38o+w9mZBVGbcVcnZ4mVE5UiJlni8qB9tV+UgAIlFrRvIZ1XK34V2N0ApiCgjLCjRc0Iikn3c3XkpYgdMpq+pdDbORgIqnMpcpSPHtFga+/ey9HpQpVsOArGu5B8wKgWj4qWn4v3gSY+3A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212c8d59-3436-422a-5681-08d84e1fcd8f
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7157.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2020 02:36:17.4512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdKe6jvWXHcxSBpfF/+Fh5xcqT+nHSDDyPgZ7mZEF2tboBx9YoQT5RexNUT4xDmU8qypQp0PmT8lJIy936glmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6998
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The interrupt may occur during the gadget deletion, it fixes the
below oops.

[ 2394.974604] configfs-gadget gadget: suspend
[ 2395.042578] configfs-gadget 5b130000.usb: unregistering UDC driver [g1]
[ 2395.382562] irq 229: nobody cared (try booting with the "irqpoll" option)
[ 2395.389362] CPU: 0 PID: 301 Comm: kworker/u12:6 Not tainted 5.8.0-rc3-next-20200703-00060-g2f13b83cbf30-dirty #456
[ 2395.399712] Hardware name: Freescale i.MX8QM MEK (DT)
[ 2395.404782] Workqueue: 2-0051 tcpm_state_machine_work
[ 2395.409832] Call trace:
[ 2395.412289]  dump_backtrace+0x0/0x1d0
[ 2395.415950]  show_stack+0x1c/0x28
[ 2395.419271]  dump_stack+0xbc/0x118
[ 2395.422678]  __report_bad_irq+0x50/0xe0
[ 2395.426513]  note_interrupt+0x2cc/0x38c
[ 2395.430355]  handle_irq_event_percpu+0x88/0x90
[ 2395.434800]  handle_irq_event+0x4c/0xe8
[ 2395.438640]  handle_fasteoi_irq+0xbc/0x168
[ 2395.442740]  generic_handle_irq+0x34/0x48
[ 2395.446752]  __handle_domain_irq+0x68/0xc0
[ 2395.450846]  gic_handle_irq+0x64/0x150
[ 2395.454596]  el1_irq+0xb8/0x180
[ 2395.457733]  __do_softirq+0xac/0x3b8
[ 2395.461310]  irq_exit+0xc0/0xe0
[ 2395.464448]  __handle_domain_irq+0x6c/0xc0
[ 2395.468540]  gic_handle_irq+0x64/0x150
[ 2395.472295]  el1_irq+0xb8/0x180
[ 2395.475436]  _raw_spin_unlock_irqrestore+0x14/0x48
[ 2395.480232]  usb_gadget_disconnect+0x120/0x140
[ 2395.484678]  usb_gadget_remove_driver+0xb4/0xd0
[ 2395.489208]  usb_del_gadget+0x6c/0xc8
[ 2395.492872]  cdns3_gadget_exit+0x5c/0x120
[ 2395.496882]  cdns3_role_stop+0x60/0x90
[ 2395.500634]  cdns3_role_set+0x64/0xd8
[ 2395.504301]  usb_role_switch_set_role.part.0+0x3c/0x90
[ 2395.509444]  usb_role_switch_set_role+0x20/0x30
[ 2395.513978]  tcpm_mux_set+0x60/0xf8
[ 2395.517470]  tcpm_reset_port+0xa4/0xf0
[ 2395.521222]  tcpm_detach.part.0+0x44/0x50
[ 2395.525227]  tcpm_state_machine_work+0x8b0/0x2360
[ 2395.529932]  process_one_work+0x1c8/0x470
[ 2395.533939]  worker_thread+0x50/0x420
[ 2395.537603]  kthread+0x148/0x168
[ 2395.540830]  ret_from_fork+0x10/0x18
[ 2395.544399] handlers:
[ 2395.546671] [<000000008dea28da>] cdns3_wakeup_irq
[ 2395.551375] [<000000009fee5c61>] cdns3_drd_irq threaded [<000000005148eaec>] cdns3_drd_thread_irq
[ 2395.560255] Disabling IRQ #229
[ 2395.563454] configfs-gadget gadget: unbind function 'Mass Storage Function'/000000000132f835
[ 2395.563657] configfs-gadget gadget: unbind
[ 2395.563917] udc 5b130000.usb: releasing '5b130000.usb'

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index fe6738ac0498..1b2027ec68a5 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -3074,12 +3074,12 @@ void cdns3_gadget_exit(struct cdns3 *cdns)
 
 	priv_dev = cdns->gadget_dev;
 
-	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
 	pm_runtime_mark_last_busy(cdns->dev);
 	pm_runtime_put_autosuspend(cdns->dev);
 
 	usb_del_gadget_udc(&priv_dev->gadget);
+	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
 	cdns3_free_all_eps(priv_dev);
 
-- 
2.17.1

