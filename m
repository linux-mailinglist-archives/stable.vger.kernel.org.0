Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5479D1D2BE7
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 11:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgENJxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 05:53:22 -0400
Received: from mail-eopbgr30053.outbound.protection.outlook.com ([40.107.3.53]:6195
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbgENJxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 05:53:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK7ycujFfBZHnLpSQz2VwHOeqBCGKP+SiDjKgSjtkPv2wE/o6A+oDl/FhO0ToQVM50VmuxOJusO0Mkv11mxOmWaJbUYm4icMCQwAHOHLVuNUF4/PnvoCcSxYqFJFDduVIpHi6jnPehJiIr/WJYlyTdiCKDyxxYB1cMod/NVW9sbehp9rM6s2h4HLsCjaLIliPoMaXOVSPvTwFRCoKsycJRVCH8aSJXzgcUPle69c1JiQAdgekMh91IFb6w9g1QmHxDnPcRFz06r11ATlR860HcS9DIRfHlpBvJsw/jJVeRH5gJ4LITz4EVScaw4+8f51hpD8n6CCz1B+1m22H32d9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsRTRtXV2DIyiEFEKdQre5EIcdGvgE4waxws/7kfMkw=;
 b=XIMbQpeCwiGqw3vnftbCTJTb4YX3Gq7IYVLdCeUFV6EYconUNZJUIJB/H7LblwkurhsAgWW22ymc6R3vStsyRep3VPJXIBV5j40iDt77WUFiXjbkrrf5YKnpFRP3u4T3iiT0m2MFUac7PWjUFA6l1txxkzDBtTTucL7f4wKD/55etSzB26Tj10GUz+pGS2sO7/zWUXqXm63Ue8/jGFD32joRobmMTSe5EuutD9oCYX2UK/06hn893UwGODp46bvDC7o0mQY4bfyWacCZqMGgjyvB0064Ug5AL2wxM8W+EBbAHZGvu364NBZd1a1RjkGxt5B4L//sfFs7u54CH3udcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsRTRtXV2DIyiEFEKdQre5EIcdGvgE4waxws/7kfMkw=;
 b=BXj+4reoA2IRlwnFZ6lK3CZ1nzfZ/tPzAm2x/OWXhLkuSPcJiyAYjLRZ2jStoMD6VCRThx3EweBcBbGzLjfkEcH2hK+8Kmwhrh+c60obO06CDduL2sIp0TbNBCwhd/HOdpOtQLQRhbrw0kvb5Bhh+zsDLn2QUbpyPrSeaaeYPeg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com (2603:10a6:803:127::18)
 by VE1PR04MB6431.eurprd04.prod.outlook.com (2603:10a6:803:12a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Thu, 14 May
 2020 09:53:13 +0000
Received: from VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::5086:ae9e:6397:6b03]) by VE1PR04MB6528.eurprd04.prod.outlook.com
 ([fe80::5086:ae9e:6397:6b03%7]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 09:53:13 +0000
From:   Li Jun <jun.li@nxp.com>
To:     mathias.nyman@intel.com
Cc:     gregkh@linuxfoundation.org, baolin.wang@linaro.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-imx@nxp.com, peter.chen@nxp.com, stern@rowland.harvard.edu,
        mgautam@codeaurora.org, mathias.nyman@linux.intel.com
Subject: [PATCH v2] usb: host: xhci-plat: keep runtime active when remove host
Date:   Thu, 14 May 2020 17:43:36 +0800
Message-Id: <1589449416-2245-1-git-send-email-jun.li@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0201.apcprd06.prod.outlook.com (2603:1096:4:1::33)
 To VE1PR04MB6528.eurprd04.prod.outlook.com (2603:10a6:803:127::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SG2PR06CA0201.apcprd06.prod.outlook.com (2603:1096:4:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3000.24 via Frontend Transport; Thu, 14 May 2020 09:53:09 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ddf55ec-74db-48e7-7121-08d7f7ec9daa
X-MS-TrafficTypeDiagnostic: VE1PR04MB6431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB64312C44CA833DA470911BF789BC0@VE1PR04MB6431.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgZBuw142udWZ5IiY9SLaXpUQAH2DzMuZ6KstuPr5XHUpTicafiE69FOEGi6hM/xg1vUq/09pFgbQWgZElRE3CBmV7vt0vgs6ZYqmCp2ZvtAgfaCNJrjMAc8r+lSVxGBB9uut/ihwBJ3XsIs+NqQMHuegyHsimwdKmaMu/iBblGpG4Dhk4/67Hz+VLJ4MasL/P4S/2eXi11BaLeWfjnOWJL65n/vWvIsc/Hwzv+1qQP3Be0PQ3lTMYC1HVEn/OcWiEf2jucvK46oY08add8vjbRazvGtOoFreVEQCgbf8L5D+3kl9/tkigzo0EnGYYhpIo+d+pBwr+2lkWQUndGMSDRb3BASOjlQnokK1avox9AGf6FguB+RIpW05gcTAcGWbdHeUROwyTlITAAi9ODjQpUkLZ9N32Ufcjfaz2pPBeq5xgHBRikCqVeofeMXZ6jHs7hrmTW9MIy2LsPk8O1R0LVPScci/uESOM8PD0w6tAfQpCMpqWwi367DX2R38xE8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6528.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(36756003)(86362001)(6666004)(5660300002)(66556008)(66476007)(66946007)(2906002)(4326008)(186003)(16526019)(8676002)(6486002)(8936002)(45080400002)(6506007)(478600001)(26005)(69590400007)(6916009)(6512007)(956004)(316002)(52116002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zBPYVq20Jfz+xlQDCKkOBs/MKmS17tmIhKykHeSWEz4iYrz5r/BpslIOjXXa6cxJ//DStD2xEkBeb7WrByEwEpYqtLJRf53hPG0qOAgguqCmxDLO/JgdTl6dEfPKLKTnUToWKE+hbUQDEcayQgs0yL41ixsnGjJYUA5vOlPh48m59JygyigPIoRUhgEmspYn5AFQ75piBN4XY9pxN7xmh4DJzBszXfytGuqgsb7b4fRZNgC7KcpkouwqzIOEgIMDzBPY3ulsDX0st5iPkpLPW8TfkS1ARLtAC2r2Xaao2I/2vwzTmgE0pI+khlmANrGe9Dnte/03GrIpzkwr1AD/uH3Unq+BjnYCZwXwcZdz0HzUbh2W3cIHV+lzWTKVmh7I1AA39MxfYqXe467a7Rz6db6usuJZU9/UrGhoUmg2qxg/qNMLSMNG4Qc0XGQNDiPjt2vJoJZdlO2CboqUvSy0u7hf+j2FiylCPCSz9f1DTaM=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddf55ec-74db-48e7-7121-08d7f7ec9daa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 09:53:13.0507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkWBde1KVU5a8erhyuq8n2x1eewEIE974YWdWaEQlLzsggv48l8W/VxmB2pq1fUT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6431
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Tested-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
---
changes for v2:
- Add pm_runtime_put_noidle() to balance pm_runtime_get_sync().
- Move pm_runtime_set_suspended() to be after pm_runtime_disable().

 drivers/usb/host/xhci-plat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 1d4f6f8..ea460b9 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -362,6 +362,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 	struct clk *reg_clk = xhci->reg_clk;
 	struct usb_hcd *shared_hcd = xhci->shared_hcd;
 
+	pm_runtime_get_sync(&dev->dev);
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
 	usb_remove_hcd(shared_hcd);
@@ -375,8 +376,9 @@ static int xhci_plat_remove(struct platform_device *dev)
 	clk_disable_unprepare(reg_clk);
 	usb_put_hcd(hcd);
 
-	pm_runtime_set_suspended(&dev->dev);
 	pm_runtime_disable(&dev->dev);
+	pm_runtime_put_noidle(&dev->dev);
+	pm_runtime_set_suspended(&dev->dev);
 
 	return 0;
 }
-- 
2.7.4

