Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9241C1BF0D1
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 09:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgD3HHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 03:07:11 -0400
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:60640
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726337AbgD3HHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 03:07:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTlpn+xEhQyWV2/8QmmDClxY3YPwQfo3H9oKLiY2fKU0qxl0NYYqaWj7jXefFkNbbQZYh6V3ngAl5pYkghI9LJ6G7gAWlWlDYFozwScbpl9TS6SW2vGz6POGdwgIIo+4n+H9i/ROSlr6kDjGsmm+lwwkp7ZTFF8tH8UD4X6KdnTY7mTL5NKtau5RUR/ifMyuNDOfkwI35aim1CETV74udYl1oLxFkJx8xzF9khbbGobM3JY+4Xp2ihY/PnskG8CvK1bV/BWgZ79eEg3G8zBj+5Q58l3yDdaPLl3jDkY0BfRHcmwL8nWIHHfzzVaXlWDcICky3k/jRmx01b0PMQL/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=az32wHi6xA7uWEJ7QaNKqS1I/Lh36wDpcZCuqwZxmj4=;
 b=EFEw1wPbR04GGFdhvJm2ieMXH8NybD4ypItfS5HKgKSbpdVYaxSRLZe+FbyWWLvtI05VDYvu0uLXoeVf+fiSs4ODvjHzTzlp6Daow/tvuiIbq/D4MMVp5Dtob8p8OgvlKB3LliXSjlleU9BQ+n/SPkiTL96e+xpEYQeq/NPMoBu+hkqVEtzXdcWRo/KM1JX2CfCj8jJ3ZI08471WHLRTAXmFw1Dnu4M6wN0bSYmz4JJKvPHihd1otzb3QvoZPyRqqcm0BtxK5Izq10R32ypuILVDrKVy+x+exumvfSYFTg4vg0o+dxgqqAZFJkNKojyuoIDIIXEAm6fjQBuQl1PtTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=az32wHi6xA7uWEJ7QaNKqS1I/Lh36wDpcZCuqwZxmj4=;
 b=AF8fAK3giBJ5rSSv/PUSwtFyMDA8X3+/w7wsBUTB49iLvkbG12BUAmJ8TOI2JpAU2bG4wphJxvRuMHy6m1q5tt6bQLtYk2pCuOXqdoWJsXoCnM0xd2aA7iZcqGBSUeEvnQZu+LH1bJNjQplpvABT4Xl2ePc5AS2ZNjW7rimPjMw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB6967.eurprd04.prod.outlook.com (2603:10a6:20b:108::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 07:07:07 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792%9]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 07:07:07 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, gregkh@linuxfoundation.org, jun.li@nxp.com,
        Peter Chen <peter.chen@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: cdns3: gadget: prev_req->trb is NULL for ep0
Date:   Thu, 30 Apr 2020 15:07:13 +0800
Message-Id: <20200430070713.8198-1-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0118.apcprd06.prod.outlook.com
 (2603:1096:1:1d::20) To AM7PR04MB7157.eurprd04.prod.outlook.com
 (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.66) by SG2PR06CA0118.apcprd06.prod.outlook.com (2603:1096:1:1d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 07:07:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14ed2ec0-b349-4290-c358-08d7ecd517c8
X-MS-TrafficTypeDiagnostic: AM7PR04MB6967:|AM7PR04MB6967:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB69673583A44EA5D499A23B8A8BAA0@AM7PR04MB6967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZECc6gZhSx51vT8Pd/BnGp545cwxS7WmdxvAJzOGIbXuY5URpRmqFbC1Xo5vNz1/nIWrSIOcqvA97fv7mdqA398FvEeWL5s3kCXtClHKPiPvntd4s38egfRoQLD3Afpf83ZmesRNUfZlPz5c5+DUyL7RBrNnaSENpuAXr8qHNjB35DioGcMNHJ5ZVqm12uWjN55Vq+babUaTn4Y9uJOb7uo0M5gprQDcu1cO7wjWpYaZmvOC/FgpYTEX/0CMRUmx+Ur7rpumFtv44EvWVVzAR63LavljPODYAfmMU8hrJNmijujIrWPph8yUmMEpWXisynq4Jc0ExoU/0CBSmwpRweZJzBPo/INlmkFY8ma6xVXyspQPmZyE+D3sDsbOihcnVNSbhVS+JCy/BZORFhZo9rQDHcFMhDxskxbk9PBvPlApiHaPsyzlmmLa3Hs313z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(66946007)(8676002)(2906002)(4326008)(8936002)(6666004)(66476007)(6512007)(66556008)(45080400002)(2616005)(44832011)(86362001)(478600001)(6486002)(956004)(1076003)(26005)(186003)(5660300002)(36756003)(54906003)(52116002)(6916009)(6506007)(316002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8v83L597e3E4LyjeWQqQQ18/waCImNlgFQWlUmHaiiuAD1WzhGHRjWIZBz3DemEiYWkOInj7qVnPFHqjAz5Sv2DGty+SeMIdpIDj/lMoH7QTyjk1DaLHJx6HD4u2QfwJM4NpyWxiJjYWwlKKS9GjVsy/wHPeQ0jL5nbMDlo8AZptcIVqAMHBvhSsCfPDwV6hvHSTYA5saILBROq2Eft07rN4tjFcGK74CX+36g3k+5R4I/2ski1RWTiOU+PkK6il+UUVec/39AHLY5atI+49VwkAvgzekUmmMGZ/jxoIUQ9UTXRAm0g21kdUIy7WFvHGtCXPSWrz1MvI2tEQQV0V9aV1t71iB8P0LAJHFimpKk4agdRe1nc4DGo56OoSBDPaNy92z8H1rtMV6VRsq+1v4Atk/uk9jYfiNTZQBJRaDX56wLJwbhmmhCg/5uI4TXw0qbYd48e23L4jVN2Lrt4IeBhfC8O9YRXWcUi132H8sRF0w5Czd0kaipemk+wyPfoiMbZhJZJi9kKmeTeAgzul9XFOwo2YPJuPGfaVgy3edTEBVnoyr66+kHA/AEBdphFLWi4bKwMz10HyukrKmFsf/5a6znJ5Eih1u0wCKPJ+xcYZIcr9LAD12EAfE9PhlzRkdw+x4Sr3wBE0anDFnTpcK76U1hIEd5oXtQy5n+ANA0bDI5p6UR14hHA3dxrR+zn5XHgyyllFefvbCiyWv2OQDdkr3wJ5jBUaELdVGcOcfYbM8laLaNfBd429eiPBfZurdhGp/dxg+xpaiFZY+336gUOLNNnRGAJVg4If6Xv8kJk=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ed2ec0-b349-4290-c358-08d7ecd517c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 07:07:06.9497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bO953fKGD8KqjL3IUV2oDA7+IZd65LHFAW8pt0w6SrHmwgi8DBA/dQSw0Zh8eEAu3AwWY9RWkURqqZAOe3Rtfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6967
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

And there are no multiple TRBs on EP0 and WA1 workaround,
so it doesn't need to change TRB for EP0. It fixes below oops.

configfs-gadget gadget: high-speed config #1: b
android_work: sent uevent USB_STATE=CONFIGURED
Unable to handle kernel read from unreadable memory at virtual address 0000000000000008
Mem abort info:
android_work: sent uevent USB_STATE=DISCONNECTED
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits

  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=00000008b5bb7000
[0000000000000008] pgd=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 430 Comm: HwBinder:401_1 Not tainted 5.4.24-06071-g6fa8921409c1-dirty #77
Hardware name: Freescale i.MX8QXP MEK (DT)
pstate: 60400085 (nZCv daIf +PAN -UAO)
pc : cdns3_gadget_ep_dequeue+0x1d4/0x270
lr : cdns3_gadget_ep_dequeue+0x48/0x270
sp : ffff800012763ba0
x29: ffff800012763ba0 x28: ffff00082c653c00
x27: 0000000000000000 x26: ffff000068fa7b00
x25: ffff0000699b2000 x24: ffff00082c6ac000
x23: ffff000834f0a480 x22: ffff000834e87b9c
x21: 0000000000000000 x20: ffff000834e87800
x19: ffff000069eddc00 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 0000000000000000
x13: 0000000000000000 x12: 0000000000000001
x11: ffff80001180fbe8 x10: 0000000000000001
x9 : ffff800012101558 x8 : 0000000000000001
x7 : 0000000000000006 x6 : ffff000835d9c668
x5 : ffff000834f0a4c8 x4 : 0000000096000000
x3 : 0000000000001810 x2 : 0000000000000000
x1 : ffff800024bd001c x0 : 0000000000000001
Call trace:
 cdns3_gadget_ep_dequeue+0x1d4/0x270
 usb_ep_dequeue+0x34/0xf8
 composite_dev_cleanup+0x154/0x170
 configfs_composite_unbind+0x6c/0xa8
 usb_gadget_remove_driver+0x44/0x70
 usb_gadget_unregister_driver+0x74/0xe0
 unregister_gadget+0x28/0x58
 gadget_dev_desc_UDC_store+0x80/0x110
 configfs_write_file+0x1e0/0x2a0
 __vfs_write+0x48/0x90
 vfs_write+0xe4/0x1c8
 ksys_write+0x78/0x100
 __arm64_sys_write+0x24/0x30
 el0_svc_common.constprop.0+0x74/0x168
 el0_svc_handler+0x34/0xa0
 el0_svc+0x8/0xc
Code: 52830203 b9407660 f94042e4 11000400 (b9400841)
---[ end trace 1574516e4c1772ca ]---
Kernel panic - not syncing: Fatal exception
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x0002,20002008
Memory Limit: none
Rebooting in 5 seconds..

Fixes: f616c3bda47e ("usb: cdns3: Fix dequeue implementation")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 996699bd312f..c6908374232a 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2552,7 +2552,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	link_trb = priv_req->trb;
 
 	/* Update ring only if removed request is on pending_req_list list */
-	if (req_on_hw_ring) {
+	if (req_on_hw_ring && link_trb) {
 		link_trb->buffer = TRB_BUFFER(priv_ep->trb_pool_dma +
 			((priv_req->end_trb + 1) * TRB_SIZE));
 		link_trb->control = (link_trb->control & TRB_CYCLE) |
-- 
2.17.1

