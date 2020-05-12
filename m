Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12B51CEADE
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 04:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgELCfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 22:35:50 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:59294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727892AbgELCft (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 22:35:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LM8fsNUdawdOqqHOxIRi8bU0opB5SbRtpeq2e4m0Q5CkUgxsTKBz6xcdK351D3wFSJa5hL7Eed92yc8BF0PcLYKMZMOKvkDBGs97AFZ75Yaae/8eOdsT7G5QSAasq8f3fTDndY/YykK1hMlmXZ2HGrWJXT/3jbQkwb+xPwqcawDSmZotftlpVqEyWWzQ/WTVtuF2I5FPt1IPZhbFJ9SdMb74lcXI00vT84CZZDmUVd/E1RsAgMnPwiInjFUxawIHI9KG0tmTiKYeGd793xNukJ8bwzdRD6uCeCGT3Zvifh8EHUIT8Dt+VjcT88Gam2c9IgTm9MDlmKtZ8lEYz7/J7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZv3hcABq5SrI5aeo/UvGg7MGc8ZdwkIXqZXWAanH5w=;
 b=Zl7l11ByS6ofut5oNJhYSuRwM+RqytHukHJVc3Xq1GboI0RVcU9ppmjcZmBE5LeVmkexAygCreqr440TOcSP9XWXsYiAeUZ9v/7hRhshU6gfQpKHlb+7R62hvjjcUHyqvzpVUnw9ufMnyfNkVYtIELGFkZZjfkY8B+b0lXKKeChealdVSP54dblYQSUTruorn/7yiu5Q6n8tjxDFWh4//k97EP4uaAv1q7juUT6vndUFO7/fgfhR83OuaIRVQ8xKTnHWN2lybRd1iOBL9LbSXgtDQerOHTdsNgxwtiWIRPTrRKLrNEaK0qUZRIXeL3XoO1yXBopM6spI5YqOoaERSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZv3hcABq5SrI5aeo/UvGg7MGc8ZdwkIXqZXWAanH5w=;
 b=qP+uF10LLiwBbiA2J0/XkXLGaV6S1UAC+Y9XzPOdWA7jHJj6rgQ77q+ygUjRPNQvPaTHiEmYApW71t8NwfnbUva3hvv11n6fuJTTPBTvxb6EYHVgFPvnLMPjeFNEY1OA94LSM2LStbe8nOrq4IE23zBTIn3hoTemS1pD0vSDGfo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB7048.eurprd04.prod.outlook.com (2603:10a6:20b:11a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 02:35:43 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792%9]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 02:35:43 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     mathias.nyman@intel.com
Cc:     linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-imx@nxp.com, Li Jun <jun.li@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when remove host
Date:   Tue, 12 May 2020 10:35:47 +0800
Message-Id: <20200512023547.31164-1-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0116.apcprd02.prod.outlook.com
 (2603:1096:4:92::32) To AM7PR04MB7157.eurprd04.prod.outlook.com
 (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.66) by SG2PR02CA0116.apcprd02.prod.outlook.com (2603:1096:4:92::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 12 May 2020 02:35:40 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 963cb923-1fd8-4cc4-47bc-08d7f61d2aea
X-MS-TrafficTypeDiagnostic: AM7PR04MB7048:|AM7PR04MB7048:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB704832C2F77F7096AD2D53508BBE0@AM7PR04MB7048.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVL/ErYsInjqEC0JeuBrUm6GsVotUAz13ykyrAKAEBG0KnGlRr7vH4DBdcjaNnUWoCkPch4u2II7K8JwoXSViLhAhbREiqTIbZdn7PAyKt+XbOebh0/0+4XxKJhbHwxkriGJgVdNX2+87HGj8L2RX/QRcx1/0msqxmumLTQqiLUwC4UYFpcIxUYaeDEyOs0ZvSML6cfoedR+V8LskwbFRxVnCtjphEUeQDe2ApSWgq3OtLKpn6OR+r8SYETHHtM4vYRtCWiP1c4P/2S4V4nsnWeHgI14lGSOat7umR67ksJCq4mSnc+1UQ7TTcOzviMeI1igoM25IERx8hcGZ0Vfb9wMbXD5R6/wI27OMxKFGsyAn6UWulQLDqwBKRD+KjdqFgLPFtMLowOpdU9VLNzmpTMf0RW6eTShiC9e1BQp4CxklqYlnJMQN1fVgQszDIvOoJPRBU8J9aBfVrIQ4suKembJgQ/wREYmp68munILv2R2JG/nLtZPjL+sWZfXDHJeGdG+jSNFjv2t1c7gQrHAnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(33430700001)(45080400002)(6486002)(6506007)(6916009)(8676002)(66476007)(316002)(54906003)(66556008)(86362001)(33440700001)(478600001)(5660300002)(66946007)(4326008)(1076003)(2906002)(956004)(186003)(8936002)(44832011)(2616005)(16526019)(36756003)(6512007)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yKmf7OAVgIhUC8Xis75UD2SGJ3mSAygRIRkdOjTYKibgKB7aJJAqmF6ZjahTOa7UAM3ApVxXbJFMhmQoZvEdzdCbdl5DGcG9GTHsIRHndwUsOQplWhyG/3XPR29Q68qg4N6OklwoCPgAeaZ4SU7KddBB+dCcCVAIQuE8N9TrxSo31o0Mx4AbBmb5LFNdSh42pmIZv74AlcWsQhLynv1hb5dAjsBUGRGx3kwfI+cC155V1dIpp/Xtutso5oeQgNM+kkMZV3B8B85MfutNYnVw2SbbJZFziU2SsQTwFDyyWLeIAo1ycpTJUj6eQid1Ikd06uGgQlt4fsVn2hUktJ2q/+/0Yb/r/SuNW23i4HZO/qo33XnmnQbUh9C8sTnFw7Z9sjzFJ1IPy4GqJZtZ+hZBvzhMh3i4BCLN+U3Fmhuj2GZiqiix1CaU/iMzOXBZ0jtJKzgvGcQfb9Phw8xsC1izB+7KnkSaaPp0n2hB1K33t/0=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 963cb923-1fd8-4cc4-47bc-08d7f61d2aea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 02:35:43.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1fH7iVJ5eJHl6U589Fels1XVpOYM5LzDHyenUiZiZmh6KYm4G9DfyW7j4vFsqbCMUfjnevtPXqyE4vdLNOOog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7048
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

While remove host(e.g. for USB role switch from host to device), if
runtime pm is enabled by user, below oops are occurs at dwc3
and cdns3 platform. Keep the xhci-plat device being active during
remove host fixes them.

oops1:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000240
Mem abort info:
  ESR = 0x96000004
xhci-hcd xhci-hcd.1.auto: // Halt the HC
xhci-hcd xhci-hcd.1.auto: // Reset the HC
xhci-hcd xhci-hcd.1.auto: Wait for controller to be ready for doorbell rings
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000004
xhci-hcd xhci-hcd.1.auto: // Disabling event ring interrupts
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=00000001b7b18000
xhci-hcd xhci-hcd.1.auto: cleaning up memory
xhci-hcd xhci-hcd.1.auto: Freed event ring
xhci-hcd xhci-hcd.1.auto: Freed command ring
[0000000000000240] pgd=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.4.3-00107-g64d454a-dirty #1219
Hardware name: FSL i.MX8MP EVK (DT)
Workqueue: pm pm_runtime_work
pstate: 60000005 (nZCv daif -PAN -UAO)
pc : xhci_suspend+0x34/0x698
lr : xhci_plat_runtime_suspend+0x2c/0x38
sp : ffff800011ddbbc0
x29: ffff800011ddbbc0 x28: 0000000000000000
x27: 0000000000000008 x26: ffff800011b28000
x25: ffff80001012b328 x24: ffff800011ddbd48
x23: 0000000000000000 x22: ffff80001076ed78
x21: ffff000177896000 x20: ffff0001714ebce4
x19: ffff000177896000 x18: ffffffffffffffff
x17: 0000000000000000 x16: 0000000000000000
x15: ffff800011b288c8 x14: 0000000000000261
x13: 0000000000000001 x12: 0000000000000001
x11: 0000000000000000 x10: 00000000000009c0
x9 : ffff800011ddbd40 x8 : fefefefefefefeff
x7 : 0000000000000000 x6 : 000000003ca92688
x5 : 00ffffffffffffff x4 : 001b6b0b00000000
x3 : ffff0001714ebc10 x2 : 0000000000000000
x1 : 0000000000000001 x0 : ffff000177896250
Call trace:
 xhci_suspend+0x34/0x698
 xhci_plat_runtime_suspend+0x2c/0x38
 pm_generic_runtime_suspend+0x28/0x40
 __rpm_callback+0xd8/0x138
 rpm_callback+0x24/0x98
 rpm_suspend+0xe0/0x448
 rpm_idle+0x124/0x140
 pm_runtime_work+0xa0/0xf8
 process_one_work+0x1dc/0x370
 worker_thread+0x48/0x468
 kthread+0xf0/0x120
 ret_from_fork+0x10/0x1c

oops2:
usb 2-1: USB disconnect, device number 2
xhci-hcd xhci-hcd.1.auto: remove, state 4
usb usb2: USB disconnect, device number 1
xhci-hcd xhci-hcd.1.auto: USB bus 2 deregistered
xhci-hcd xhci-hcd.1.auto: remove, state 4
usb usb1: USB disconnect, device number 1
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000138
Mem abort info:
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=00000008b05e8000
[0000000000000138] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 7 Comm: kworker/u8:0 Not tainted 5.6.0-rc4-next-20200304-03578-gd6235ff42e2b #101
Hardware name: Freescale i.MX8QXP MEK (DT)
Workqueue: 1-0050 tcpm_state_machine_work
pstate: 20000005 (nzCv daif -PAN -UAO)
pc : xhci_free_dev+0x214/0x270
lr : xhci_plat_runtime_resume+0x78/0x88
sp : ffff80001006b5b0
x29: ffff80001006b5b0 x28: 0000000000000002
x27: ffff00083b74fd48 x26: ffff00083a365580
x25: ffff800010141458 x24: 0000000000000000
x23: 0000000000000000 x22: ffff000837e58138
x21: 0000000000000004 x20: ffff000837e58000
x19: ffff000837e58250 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000001
x15: 0000000000000004 x14: ffffffffffffffff
x13: 0000000000004ed8 x12: ffff8000123d1000
x11: ffff800012158000 x10: ffff8000123d1360
x9 : ffff800010c74b00 x8 : 0000000000000007
x7 : 00000000000012c2 x6 : ffff8000123d1000
x5 : 0000000000000001 x4 : 0000000000000000
x3 : 0000000000000000 x2 : 0000000000000138
x1 : 0000000000000000 x0 : 0000000000000138
Call trace:
 xhci_free_dev+0x214/0x270
 xhci_plat_runtime_resume+0x78/0x88
 pm_generic_runtime_resume+0x30/0x48
 __rpm_callback+0x90/0x148
 rpm_callback+0x28/0x88
 rpm_resume+0x568/0x758
 rpm_resume+0x260/0x758
 rpm_resume+0x260/0x758
 __pm_runtime_resume+0x40/0x88
 device_release_driver_internal+0xa0/0x1c8
 device_release_driver+0x1c/0x28
 bus_remove_device+0xd4/0x158
 device_del+0x15c/0x3a0
 usb_disable_device+0xb0/0x268
 usb_disconnect+0xcc/0x300
 usb_remove_hcd+0xf4/0x1dc
 xhci_plat_remove+0x78/0xe0
 platform_drv_remove+0x30/0x50
 device_release_driver_internal+0xfc/0x1c8
 device_release_driver+0x1c/0x28
 bus_remove_device+0xd4/0x158
 device_del+0x15c/0x3a0
 platform_device_del.part.0+0x20/0x90
 platform_device_unregister+0x28/0x40
 cdns3_host_exit+0x20/0x40
 cdns3_role_stop+0x60/0x90
 cdns3_role_set+0x64/0xd8
 usb_role_switch_set_role.part.0+0x3c/0x68
 usb_role_switch_set_role+0x20/0x30
 tcpm_mux_set+0x60/0xf8
 tcpm_reset_port+0xa4/0xf0
 tcpm_detach.part.0+0x28/0x50
 tcpm_state_machine_work+0x12ac/0x2360
 process_one_work+0x1c8/0x470
 worker_thread+0x50/0x428
 kthread+0xfc/0x128
 ret_from_fork+0x10/0x18
Code: c8037c02 35ffffa3 17ffe7c3 f9800011 (c85f7c01)
---[ end trace 45b1a173d2679e44 ]---

Cc: Baolin Wang <baolin.wang@linaro.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: <stable@vger.kernel.org>
Fixes: b0c69b4bace3 ("usb: host: plat: Enable xHCI plat runtime PM")
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
---
 drivers/usb/host/xhci-plat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 1d4f6f85f0fe..f38d53528c96 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -362,6 +362,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 	struct clk *reg_clk = xhci->reg_clk;
 	struct usb_hcd *shared_hcd = xhci->shared_hcd;
 
+	pm_runtime_get_sync(&dev->dev);
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
 	usb_remove_hcd(shared_hcd);
-- 
2.17.1

