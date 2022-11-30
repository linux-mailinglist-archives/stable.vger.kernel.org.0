Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E40963CF8D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 08:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiK3HGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 02:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiK3HG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 02:06:29 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11012004.outbound.protection.outlook.com [40.93.200.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B029554D1;
        Tue, 29 Nov 2022 23:06:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avLq9j0Ie7lX8ZJUsUGl9GPMG6msSNvgJmtKjp6FrpXcEpp6Gmfm9ZZkzWs8mR5u3/i0DqgNobFi/Q6NoTdpHHn0QFC8srKTLBil6J2j+RV1XFihjSF752rkbgbTt//YR3QnOfpEnQWzYtwO+vr3ut0KAv1qcyiOVRsA82449Fd3hFkeQidU8XVLtRt5HrlMv/sHeymwwDoc5FL2+xy4dKiYuCnnSSUds39E6nDlh8YK9uoRcAywiuIgnsyOLy+p59a4bvKgifROEw141Y2yk1xury5DT8a7yWR8bb7ICUM6GOaAys2LcJXYCwY2toHSvh+c1efc7BiHfgLmeujl0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdqMmzsn9mjW4qHIuOcoq1kP4jyTU1hxlaF3HLlDSew=;
 b=ZoJbVQE2e2AFzCvOsu/fNPiyh+Q65kF3r4jCzT2Cku//ipdaGt8oNNhs1ynPag3CqrRzTtHANgrZuxe+nfKGZ4I7GSvRmYMYH4ROU7h7NCJnWYAqXiK274owNDBUbBn9/5a0hQAPt2ohw4ekzMt6hkVeHJVuKP50NxMLnnPO6yS3btm14PZHNbfvPyXWDBuJW+GvnRRM0awBjGQ6K6xFetW5xqqm4TjwCofsUvNQ/rKJ6xyKGisR+RVA8T7eS/PAAhmZO+nWHXCJwBMzcU+OxQWmC9dw1nAUJTdlh4gMpTTZm59iH0KZxO0ledtWIE0JURcOaJ8kNQIhdh+yhphwZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdqMmzsn9mjW4qHIuOcoq1kP4jyTU1hxlaF3HLlDSew=;
 b=JkTCQIjYttyX+lakU/MWxyeZmXqNTvPlP/dZ13FOgD3fsMK/D7h2qUetBsgqHhuHTG5oo0jigyHHigm36cuv7xiughgmplizIlZd38O3uZ6WUIqOlIpa5xRyRM2jAyqP6a8EmagAAP0/twpTNCMtO9QjXNuQR9ZaRc9bfD9tDyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by BN6PR05MB3009.namprd05.prod.outlook.com (2603:10b6:404:29::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Wed, 30 Nov
 2022 07:06:25 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::6764:941b:e0cc:c4e1]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::6764:941b:e0cc:c4e1%7]) with mapi id 15.20.5857.022; Wed, 30 Nov 2022
 07:06:25 +0000
From:   vdasa@vmware.com
To:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Vishnu Dasa <vdasa@vmware.com>, Zack Rusin <zackr@vmware.com>,
        Nadav Amit <namit@vmware.com>,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bryan Tan <bryantan@vmware.com>
Subject: [PATCH] VMCI: Use threaded irqs instead of tasklets
Date:   Tue, 29 Nov 2022 23:05:11 -0800
Message-Id: <20221130070511.46558-1-vdasa@vmware.com>
X-Mailer: git-send-email 2.35.1
Reply-To: vdasa@vmware.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:a03:60::34) To BYAPR05MB3960.namprd05.prod.outlook.com
 (2603:10b6:a02:88::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR05MB3960:EE_|BN6PR05MB3009:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fda90b2-c707-4f48-c7a9-08dad2a16491
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9xMNJzprILTciMLWFH9GVkC9bniPDerz/4D7xaNUxkhiYinb2n51DO+VUMBoozhtZdgSyvja/Wd7LAOZpH92myElAc3Tx99sHGHXpqdmt/u0sVoTgVB3x3iElucf6xHd4b/o0wq1Qvm2ltn1jYFJTLhxdhGW3gknEknnTc1lKNEdwOzcf1O3g8v9D8EGjFNH+6cIaGrlH/DiufLeaJO+mT7OnGZokRFHnYWzR+FmTbILp3cjdj3U9zT/CLzZtkvJil59KTwICX9iKeG/Papq4F8yFU7g/OUNnyxgvSynvs0CwViVvvp9CbbwsKHZEzLFwAczi5B1sAocYFb4EEXaQka26wbm8oyxUpc54lBWrev2FhLHOCimGgw1X/hWWDO/y+ATArlG28RnnhRT2CUe3jZy70Xdm2iK+sxX9TtCx1vIO48sakOZjMDbPt2Npa2ggHWtJ6mhCS4gp2OXi3sS2B8SOP53Oyvv3QY87hl0gjKYyUryTskLHkmVP3K85FP+GmB/fJo+ztD66U2/PREOZQKnZh53kw4xnxFwYWtz439uFUvB7itDGXWUaaer7uXRx96iFE/8+HdJ7NBNmeghGfBoZSkMz6BiuloafUV4K3kQr+JfVL2mik6euKGEO+uiGGY1thV3abOPWt4QxdPug1Civi3Be6DSG6Fen6FAj3vXqQZRB3XD2ZVvjZc3Zd1PL5CREV/EBA1lNihHJHpfispWMAaK4pY4LkuaFzpTM3cqRP3n3vBcmk7mztfUIMpc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(2616005)(2906002)(83380400001)(107886003)(26005)(38100700002)(38350700002)(41300700001)(8676002)(66476007)(9686003)(66946007)(66556008)(6512007)(52116002)(6666004)(6506007)(478600001)(6486002)(36756003)(186003)(1076003)(8936002)(5660300002)(4326008)(86362001)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1650S0hjBphMXbGbHtOdFQ3hcSOk1j8dNuQXkw1EgbpYpEG8EUy4KNV15cCQ?=
 =?us-ascii?Q?HWNAwFPuqo5nEJ1NMuigNqipwaVwhvM4JWVGmzHs1yuphwZxhzMB1qCkXcaJ?=
 =?us-ascii?Q?fNCrRbeb0+5KYucp929NutWqJpoQxrwHX3quY91PFLPxZu0/FExC20tT62eb?=
 =?us-ascii?Q?XRE9tMl6SL6QCmKjSIijl15BQIgldwJBdZ/9uyfvDhJz/HidUy4YJ1L1Vr+/?=
 =?us-ascii?Q?sC0Y49tiem9qj4eG//eS3Kbr1ftjPpZsaCxPV7+aMqzHyQdMfOnDgMAqKcag?=
 =?us-ascii?Q?oDk6rtS6Xu+3WkxsbAyw8V72WkXoeUFhVcU9LI5UFAJoXPIFjm1+Y46da8qB?=
 =?us-ascii?Q?PQr2U5U7okZlvhz+nZzrM3ps9+HUqAlOJCioZ6/3FpJc1SOhO7mG1s4ZI4RG?=
 =?us-ascii?Q?LzARo/lojxHwYCvZht968wrB04WAhACvkxX2JClkWtCI4JLnhUgotsmlst21?=
 =?us-ascii?Q?GN5uhFJTI7NGtOmpAsVFQwcXD1A9n5/LzVsu6lHNuI4TUvKXwdgcLpNEO5AL?=
 =?us-ascii?Q?WicHu6nxZrmFFxSek5hUPNPPoJ6ktjtvrp0z+14djcXuKH17wGFCcaqBBy7B?=
 =?us-ascii?Q?Wn8mcLRgaFhodUt4WbPgHTG7thSSi/jcKKUVUBmHphY6qKDZOzM5ryTpvUUt?=
 =?us-ascii?Q?gp3ys+SHZS6sZAowCm1CN3jbAgIWsf+tTaHvmLaWBN8cbQWyIm1tRmWcexnM?=
 =?us-ascii?Q?IfjsMf5FRCv7D/l515DtGRDmwQCwVn5pLaErarq7oZ5E4DdFt+JRK31IFiW8?=
 =?us-ascii?Q?I5WZRxif8PHDjXs0dfbWA2ZoWU0mYAHKQf8kVbLSdbB66H+ShWmg29O0vjCe?=
 =?us-ascii?Q?MCBnaA7t+olwAc05vdnVvn3lSulLyIZQ4aoNkqZCfx3ucElEl4Z+PCIRyiT/?=
 =?us-ascii?Q?/PckE+IcdHcm9a7eJ8Rqh9RxBmXTHSnmiFAM3QGYjIj5zynlJVJz6Wbm7mPU?=
 =?us-ascii?Q?84rb0k6Q+93uh4BBPnzdy2MUhKgBHv/yDluNLcPL3f/JmYzR3E/H1xAM40/X?=
 =?us-ascii?Q?OhpG0xE3DXKwE8fQl0pPoDM/VPu1nKR54s4moIwEtAHblP0kfD5EeFPB3VPc?=
 =?us-ascii?Q?V4eClWLuViFGGXv2CsiE2YCnh2tf3aVrUqZT5ZZKt16DtWBHKE7Y3fXHx1NZ?=
 =?us-ascii?Q?S+kqDdY5e06AI8Og9+8j6+yP5wNQxpnKa4O888N2+zRZddN830dMPxGlsW8Z?=
 =?us-ascii?Q?4aL8a7FU5xZbQghD8UNcvqroaDt6/qpvMYG3Ym8S33IHNJikC3UjvqBUSMho?=
 =?us-ascii?Q?vjB9h4N1zEt20Ae/2epcjp7u3d1n8ZMjY0/Z7oXxfynC4q5HaLfpzmDOKBmj?=
 =?us-ascii?Q?CXqqwjAeuSfMGOjI9550anQUNnw3TXtJwEEDeFYOFN2cSg7coQAqHVEo5BqA?=
 =?us-ascii?Q?dPKDpLvqYGdNhtplyUDrAE4UTI82tbH1axkBhYhQZEiq65nqHNuedBa/8VBN?=
 =?us-ascii?Q?CS80IIq5OOzMsuvG9BeTAOdKJQsn4lKNtkLREMqqd81mFHQYor3BUq7Kr/Ub?=
 =?us-ascii?Q?pwGg1zIjOvOFkFD/WuRXCMyFMD1+Tg3JY6w8vZoKd2C1dP4T4SiUr4m/4nWy?=
 =?us-ascii?Q?Y7KFaITT9capNEpmcqk=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fda90b2-c707-4f48-c7a9-08dad2a16491
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB3960.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 07:06:25.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VRnpcRWJ8a0scGtsHxicx0ZBr3mNGsT7NA9mgKuEjjujGgtwkfmwl79lv4kBjlHLL1FSJ/dosDNCsfubdddcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB3009
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishnu Dasa <vdasa@vmware.com>

The vmci_dispatch_dgs() tasklet function calls vmci_read_data()
which uses wait_event() resulting in invalid sleep in an atomic
context (and therefore potentially in a deadlock).

Use threaded irqs to fix this issue and completely remove usage
of tasklets.

[   20.264639] BUG: sleeping function called from invalid context at drivers/misc/vmw_vmci/vmci_guest.c:145
[   20.264643] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 762, name: vmtoolsd
[   20.264645] preempt_count: 101, expected: 0
[   20.264646] RCU nest depth: 0, expected: 0
[   20.264647] 1 lock held by vmtoolsd/762:
[   20.264648]  #0: ffff0000874ae440 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: vsock_connect+0x60/0x330 [vsock]
[   20.264658] Preemption disabled at:
[   20.264659] [<ffff80000151d7d8>] vmci_send_datagram+0x44/0xa0 [vmw_vmci]
[   20.264665] CPU: 0 PID: 762 Comm: vmtoolsd Not tainted 5.19.0-0.rc8.20220727git39c3c396f813.60.fc37.aarch64 #1
[   20.264667] Hardware name: VMware, Inc. VBSA/VBSA, BIOS VEFI 12/31/2020
[   20.264668] Call trace:
[   20.264669]  dump_backtrace+0xc4/0x130
[   20.264672]  show_stack+0x24/0x80
[   20.264673]  dump_stack_lvl+0x88/0xb4
[   20.264676]  dump_stack+0x18/0x34
[   20.264677]  __might_resched+0x1a0/0x280
[   20.264679]  __might_sleep+0x58/0x90
[   20.264681]  vmci_read_data+0x74/0x120 [vmw_vmci]
[   20.264683]  vmci_dispatch_dgs+0x64/0x204 [vmw_vmci]
[   20.264686]  tasklet_action_common.constprop.0+0x13c/0x150
[   20.264688]  tasklet_action+0x40/0x50
[   20.264689]  __do_softirq+0x23c/0x6b4
[   20.264690]  __irq_exit_rcu+0x104/0x214
[   20.264691]  irq_exit_rcu+0x1c/0x50
[   20.264693]  el1_interrupt+0x38/0x6c
[   20.264695]  el1h_64_irq_handler+0x18/0x24
[   20.264696]  el1h_64_irq+0x68/0x6c
[   20.264697]  preempt_count_sub+0xa4/0xe0
[   20.264698]  _raw_spin_unlock_irqrestore+0x64/0xb0
[   20.264701]  vmci_send_datagram+0x7c/0xa0 [vmw_vmci]
[   20.264703]  vmci_datagram_dispatch+0x84/0x100 [vmw_vmci]
[   20.264706]  vmci_datagram_send+0x2c/0x40 [vmw_vmci]
[   20.264709]  vmci_transport_send_control_pkt+0xb8/0x120 [vmw_vsock_vmci_transport]
[   20.264711]  vmci_transport_connect+0x40/0x7c [vmw_vsock_vmci_transport]
[   20.264713]  vsock_connect+0x278/0x330 [vsock]
[   20.264715]  __sys_connect_file+0x8c/0xc0
[   20.264718]  __sys_connect+0x84/0xb4
[   20.264720]  __arm64_sys_connect+0x2c/0x3c
[   20.264721]  invoke_syscall+0x78/0x100
[   20.264723]  el0_svc_common.constprop.0+0x68/0x124
[   20.264724]  do_el0_svc+0x38/0x4c
[   20.264725]  el0_svc+0x60/0x180
[   20.264726]  el0t_64_sync_handler+0x11c/0x150
[   20.264728]  el0t_64_sync+0x190/0x194

Signed-off-by: Vishnu Dasa <vdasa@vmware.com>
Suggested-by: Zack Rusin <zackr@vmware.com>
Reported-by: Nadav Amit <namit@vmware.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 463713eb6164 ("VMCI: dma dg: add support for DMA datagrams receive")
Cc: <stable@vger.kernel.org> # v5.18+
Cc: VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bryan Tan <bryantan@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_guest.c | 49 ++++++++++++------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index aa7b05de97dd..6ab717b4a5db 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -56,8 +56,6 @@ struct vmci_guest_device {
 
 	bool exclusive_vectors;
 
-	struct tasklet_struct datagram_tasklet;
-	struct tasklet_struct bm_tasklet;
 	struct wait_queue_head inout_wq;
 
 	void *data_buffer;
@@ -304,9 +302,8 @@ static int vmci_check_host_caps(struct pci_dev *pdev)
  * This function assumes that it has exclusive access to the data
  * in register(s) for the duration of the call.
  */
-static void vmci_dispatch_dgs(unsigned long data)
+static void vmci_dispatch_dgs(struct vmci_guest_device *vmci_dev)
 {
-	struct vmci_guest_device *vmci_dev = (struct vmci_guest_device *)data;
 	u8 *dg_in_buffer = vmci_dev->data_buffer;
 	struct vmci_datagram *dg;
 	size_t dg_in_buffer_size = VMCI_MAX_DG_SIZE;
@@ -465,10 +462,8 @@ static void vmci_dispatch_dgs(unsigned long data)
  * Scans the notification bitmap for raised flags, clears them
  * and handles the notifications.
  */
-static void vmci_process_bitmap(unsigned long data)
+static void vmci_process_bitmap(struct vmci_guest_device *dev)
 {
-	struct vmci_guest_device *dev = (struct vmci_guest_device *)data;
-
 	if (!dev->notification_bitmap) {
 		dev_dbg(dev->dev, "No bitmap present in %s\n", __func__);
 		return;
@@ -486,13 +481,13 @@ static irqreturn_t vmci_interrupt(int irq, void *_dev)
 	struct vmci_guest_device *dev = _dev;
 
 	/*
-	 * If we are using MSI-X with exclusive vectors then we simply schedule
-	 * the datagram tasklet, since we know the interrupt was meant for us.
+	 * If we are using MSI-X with exclusive vectors then we simply call
+	 * vmci_dispatch_dgs(), since we know the interrupt was meant for us.
 	 * Otherwise we must read the ICR to determine what to do.
 	 */
 
 	if (dev->exclusive_vectors) {
-		tasklet_schedule(&dev->datagram_tasklet);
+		vmci_dispatch_dgs(dev);
 	} else {
 		unsigned int icr;
 
@@ -502,12 +497,12 @@ static irqreturn_t vmci_interrupt(int irq, void *_dev)
 			return IRQ_NONE;
 
 		if (icr & VMCI_ICR_DATAGRAM) {
-			tasklet_schedule(&dev->datagram_tasklet);
+			vmci_dispatch_dgs(dev);
 			icr &= ~VMCI_ICR_DATAGRAM;
 		}
 
 		if (icr & VMCI_ICR_NOTIFICATION) {
-			tasklet_schedule(&dev->bm_tasklet);
+			vmci_process_bitmap(dev);
 			icr &= ~VMCI_ICR_NOTIFICATION;
 		}
 
@@ -536,7 +531,7 @@ static irqreturn_t vmci_interrupt_bm(int irq, void *_dev)
 	struct vmci_guest_device *dev = _dev;
 
 	/* For MSI-X we can just assume it was meant for us. */
-	tasklet_schedule(&dev->bm_tasklet);
+	vmci_process_bitmap(dev);
 
 	return IRQ_HANDLED;
 }
@@ -638,10 +633,6 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	vmci_dev->iobase = iobase;
 	vmci_dev->mmio_base = mmio_base;
 
-	tasklet_init(&vmci_dev->datagram_tasklet,
-		     vmci_dispatch_dgs, (unsigned long)vmci_dev);
-	tasklet_init(&vmci_dev->bm_tasklet,
-		     vmci_process_bitmap, (unsigned long)vmci_dev);
 	init_waitqueue_head(&vmci_dev->inout_wq);
 
 	if (mmio_base != NULL) {
@@ -808,8 +799,9 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	 * Request IRQ for legacy or MSI interrupts, or for first
 	 * MSI-X vector.
 	 */
-	error = request_irq(pci_irq_vector(pdev, 0), vmci_interrupt,
-			    IRQF_SHARED, KBUILD_MODNAME, vmci_dev);
+	error = request_threaded_irq(pci_irq_vector(pdev, 0), NULL,
+				     vmci_interrupt, IRQF_SHARED,
+				     KBUILD_MODNAME, vmci_dev);
 	if (error) {
 		dev_err(&pdev->dev, "Irq %u in use: %d\n",
 			pci_irq_vector(pdev, 0), error);
@@ -823,9 +815,9 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	 * between the vectors.
 	 */
 	if (vmci_dev->exclusive_vectors) {
-		error = request_irq(pci_irq_vector(pdev, 1),
-				    vmci_interrupt_bm, 0, KBUILD_MODNAME,
-				    vmci_dev);
+		error = request_threaded_irq(pci_irq_vector(pdev, 1), NULL,
+					     vmci_interrupt_bm, 0,
+					     KBUILD_MODNAME, vmci_dev);
 		if (error) {
 			dev_err(&pdev->dev,
 				"Failed to allocate irq %u: %d\n",
@@ -833,9 +825,11 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 			goto err_free_irq;
 		}
 		if (caps_in_use & VMCI_CAPS_DMA_DATAGRAM) {
-			error = request_irq(pci_irq_vector(pdev, 2),
-					    vmci_interrupt_dma_datagram,
-					    0, KBUILD_MODNAME, vmci_dev);
+			error = request_threaded_irq(pci_irq_vector(pdev, 2),
+						     NULL,
+						    vmci_interrupt_dma_datagram,
+						     0, KBUILD_MODNAME,
+						     vmci_dev);
 			if (error) {
 				dev_err(&pdev->dev,
 					"Failed to allocate irq %u: %d\n",
@@ -871,8 +865,6 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 
 err_free_irq:
 	free_irq(pci_irq_vector(pdev, 0), vmci_dev);
-	tasklet_kill(&vmci_dev->datagram_tasklet);
-	tasklet_kill(&vmci_dev->bm_tasklet);
 
 err_disable_msi:
 	pci_free_irq_vectors(pdev);
@@ -943,9 +935,6 @@ static void vmci_guest_remove_device(struct pci_dev *pdev)
 	free_irq(pci_irq_vector(pdev, 0), vmci_dev);
 	pci_free_irq_vectors(pdev);
 
-	tasklet_kill(&vmci_dev->datagram_tasklet);
-	tasklet_kill(&vmci_dev->bm_tasklet);
-
 	if (vmci_dev->notification_bitmap) {
 		/*
 		 * The device reset above cleared the bitmap state of the
-- 
2.34.1

