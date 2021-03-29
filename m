Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0E734D1CE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhC2Nux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:50:53 -0400
Received: from mail-mw2nam12on2112.outbound.protection.outlook.com ([40.107.244.112]:47776
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231591AbhC2NuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 09:50:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZDsVpvhAT6aFE/cV862ZepsqQtTOjh9DG/lcGSet0iVTqIPX7WJTTDnl9TsjUdJOgrKZeetJdd/D8hIBzzihPgu+d+tTfa4Oo18/EVtuEukp9w/EHVMyf3wa1uO3wSV+DrXTcezh75hcKE7BFsFfKk7wJEuwUx6j/phfTUVInmiiN1f6pznKiw9XE7Mkmf7NNl+U+j9SxUMn6JbEWeruCQ3y03pHzuulZYua5gGmi8FhCehtyzTbQ41jphUivSxeVGRA0PDxObUaTNOILn+tQHBQeJ73l9lbfDfqNm9n+RyJ/DhyJRbBmTB65L4KtX5JACsxcTYXSiuRfirZBVxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVMtBqDoNaTbFI64m93aSW64xy30M56vXzompTSR3rg=;
 b=XeaeM8vc15ok48wUca7IMdk+x/HoNe76uSpx4PLobVp34ho//VSUNdmb+24GQAFm3PK2eAT+SuQ9gJttjLonuPewRkEDNuU4DZmb6G6E8VpLO5zKvnKT/CyHT5dp7Wghn+AZBbPWp0tP5NtF/9FiM9rqs6LWsy8iniF3M7EYlU3ej130DmHDFORw24NgmOrelksFAP88wEQpMaiHUFHrwGziydGl4m6UHUla5B3ocCy+tUl3KHGik9ZdGLCVjxgHyvsOEQxbKK6JRtff97tssth/Tvst7ekSVc22IfQd8vbfvp//PUaUaX1T5LQyakiZjhQ8uR8FJqRNiFahOaUbnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVMtBqDoNaTbFI64m93aSW64xy30M56vXzompTSR3rg=;
 b=iBVZiQCH/WHjkjf80qpsxaCfo65giCfl9lsshvE9KtH6xVcttcNG2EnM6zmOcAMzjWXz0iI8tNDzIpSAmfixsaq68RuGHDJYEfypNdH6g26RhQsaz9Y+RQhHXxS2CITKzTDfFiOLUI2K54waFlwYEjXEwiRgeX+s0srdvIhTh50OkhJUIXstR/XTowVcyykpD/tnIwCYwV/EzxG8QwM0a7/d9Kfo4H3FtJRaa3zG7FpI0/9z602qrmha33Lu3I6uWpXxgY/HsxGSIpcA7EigYwXZ1n2Kg7Fg1WtqTF66IBFZxBXwa66Pl008kyw7wbNLA7QuhKvSI/lip16Dyxvfiw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6294.prod.exchangelabs.com (2603:10b6:510:18::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.30; Mon, 29 Mar 2021 13:50:24 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 13:50:24 +0000
From:   dennis.dalessandro@cornelisnetworks.com
To:     dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Subject: [PATCH for-rc 3/4] IB/hfi1: Fix probe time panic when AIP is enabled with a buggy BIOS
Date:   Mon, 29 Mar 2021 09:48:19 -0400
Message-Id: <1617025700-31865-4-git-send-email-dennis.dalessandro@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
Content-Type: text/plain
X-Originating-IP: [198.175.72.68]
X-ClientProxiedBy: SJ0PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::27) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from awfm-01.cornelisnetworks.com (198.175.72.68) by SJ0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:a03:33e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Mon, 29 Mar 2021 13:50:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 722cc19f-fc1a-4f2d-01e4-08d8f2b999f1
X-MS-TrafficTypeDiagnostic: PH0PR01MB6294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR01MB629417AB93B6841F7A24EDF0F47E9@PH0PR01MB6294.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PYyRPad22fnymH9Ux33mneUQ7cSbT/2amOAYBfG33uggKiU6p49M3/1xHSQwBNJgV/O4nvpWJjSQkFCpq/WIsahfkZlA2vt7gJEsW2j+/xc9TPhli+NYn4EyRt4ghoRf+WDEOEXqLuMXhkHvb5/+FP9EH8JVIADmzPgTD3mx/Wmfx96PfH7CFMlxwD5uLiMETNiyX4c+qd3J2+cIZd1Uo0Da+NSQD7AiuoIibNMntAY33sBboFiSokkCtJ1ZfY2PnulHSTjRBoVo+dJpR1zAE+WSM/j0VMSB4xl+MSB6wdUHNaZBrqTpWpzt9rFnTYGZDFAoxWLaZSeKYAwt7Dgb3DtxX4fjOjWgKb8EfgSExiOeCYUpHkwVL2arMY0c4WxpcHNQHne+7aJo5MZSFGChsYSvsmzrXFiDvAk14NdCOnCTAJ+caiO94LskWmVzQwPqpg78SeADb7GOeMJslfQx0l1WpvtrcoSPtej4ohHkWbhTW2rz/o4URkYHqqsrsjQobAvvXWR0mJDb75n4jFM4+Gr5PenmXEqFkdmI37eWNCslV8uJ8H5g3w4aiLkUFM1IWJj6LzTHzziY9ZfG8ovFeNil439TCCSvwulLdyc26wnkQh88vIdz/DpzD0PxvIYZpaDYulkDCHca7VQ8Ek9nevd1KZHcdKlbzSjUINGlyUc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(376002)(136003)(396003)(366004)(346002)(83380400001)(66556008)(66476007)(66946007)(186003)(6666004)(6486002)(8936002)(5660300002)(16526019)(9686003)(7696005)(52116002)(107886003)(8676002)(36756003)(478600001)(86362001)(2616005)(2906002)(956004)(316002)(26005)(4326008)(54906003)(38100700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?If57u1nEZthL1KdS0vgrAa1WPtDXW2fggZdxp08Sbm3q59oJtEXRNzYkRzcD?=
 =?us-ascii?Q?cNvXLHVqbgchqT1tq4iR7oyXWnAij1INB3ykZJ3mopAt3SeISUrCZzQpPzy4?=
 =?us-ascii?Q?kTQNnASOB9WIxKQ4Fg+h1DMy+pEluyn7iEEaNf6nbgetROuu6M0dNZyjkNFe?=
 =?us-ascii?Q?Vjw5pDmUhUxWfCPSMvUsq0qcAT7vPrHVeZurOMAUpKbCkbGNC+q6Wv3lXPwk?=
 =?us-ascii?Q?UqFedOpGPskJXCbXAEWeE3/maEgSWNQ97AMWFV6Hn+kJp44bfD2HYzc8lRhx?=
 =?us-ascii?Q?VL2N5Yi9j4iMYE+KjW/0rBRkutFlOfM4cam+CBZsmnbq0xRUHUdPtNoOdjoN?=
 =?us-ascii?Q?Ifd7wgf7tMxmG9FWukuXuLJtrus2g55JJIouHy5hQmt3R3BvkeKU2nTSB7ai?=
 =?us-ascii?Q?6jQ85TNH+QYoimyA1Sv6xIUaGjjns/eZRk6RGKnP/8SBuT+0N27nq2UiUl/C?=
 =?us-ascii?Q?PFFtWycTGajBjfkPORkjHiS9KVR/dWMkrzaKklesXNPtURcL9OnF+A18PNRa?=
 =?us-ascii?Q?hRgxsZBYpOnl0VSAjG3WBzhYthqYQyDItzF735vgZMeRY5QnUOp8za95dxZa?=
 =?us-ascii?Q?q9OHiOZBoB/Xt0RwC69tp3EvxEXWYI4d2QUeTJ6ZQRLYm329VIl+rF5hnCGC?=
 =?us-ascii?Q?7Xqqp1VMARRwelIL7Mx9bGCE3MHX1jOdQjJvJxj5KXqep/ZJ40f3R6BqexVn?=
 =?us-ascii?Q?zY/lDrFkVdZWXFICZoX/nvFG/WdeJfV4MlmA9tfpKFxOK8v/1deWxougRNZA?=
 =?us-ascii?Q?hPOX8D2njnPGJUjc9IR2ykbPfXUKK2IUTcBc+atxJjDWr1vY8Mvg72lbwSxq?=
 =?us-ascii?Q?C8uWQ+3iOANZudRPduLZrTIBTUZomDo/8NV5eJWO0QmGcl+3pQWOXgTLXdRx?=
 =?us-ascii?Q?t3/2LpXJ0CMSV+YLS2pYYQYo/ykpZcP89J8n4VKBcYr3N/yM4r17arJg1RVB?=
 =?us-ascii?Q?O+0svF8CskroglWXEt1B1QSDJ4pHNnVeQFl1JZHt6Y8EDBUJ3G6TYzJBs/t7?=
 =?us-ascii?Q?q95X/lTB9PLRUJ6bFOmaN5y5Gt4Z/G5CsU8ZxrMp1vtyAvBXEJSqZUkP1QxL?=
 =?us-ascii?Q?PefUZwPiKnM5tBs7IsXjsggpDuGK32tTZTE4JnCLxiFZVcPACCVkEFgvC4oN?=
 =?us-ascii?Q?xtDEaA/CatJ2cClxsQLvsYouP4MwNI5z2wOrPp9SejSKcrL4EbWIefAVuObw?=
 =?us-ascii?Q?dmzRt1/gXz3hGEjUwhS4+Y6T3ijs/lp4rJFIb9RwScCNWRSB58WSQoQj3KhZ?=
 =?us-ascii?Q?nfQI5x0oF5Fyl6ufLCnGr7b6sfjPXEkXhvdDHoyiOQvQahAc1xS0BORG6+2V?=
 =?us-ascii?Q?U2ET7jXJZsKL22UL3Z4E1OH1?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722cc19f-fc1a-4f2d-01e4-08d8f2b999f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 13:50:23.9779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtMMdxvQ2AVyMJUAknPWZhTRND5hJJizuXMYR3SWExfFiR57tUltRfFacltYYQbXJ/GQSYh8nb8Ypho3+RygOTqsscT6ic73oUmWNqOg9PssMkZ7kAfXrcWEtXr1U81L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6294
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

A panic can result when AIP is enabled:

[ 8.644728] BUG: unable to handle kernel NULL pointer dereference at 000000000000000
[ 8.657708] PGD 0 P4D 0
[ 8.664488] Oops: 0000 1 SMP PTI
[ 8.672190] CPU: 70 PID: 981 Comm: systemd-udevd Tainted: G OE --------- - - 4.18.0-240.el8.x86_64 #1
[ 8.687916] Hardware name: Intel Corporation S2600KP/S2600KP, BIOS SE5C610.86B.01.01.0005.101720141054 10/17/2014
[ 8.703340] RIP: 0010:__bitmap_and+0x1b/0x70
[ 8.741702] RSP: 0018:ffff99aa0845f9f0 EFLAGS: 00010246
[ 8.751757] RAX: 0000000000000000 RBX: ffff8d5a6fc18000 RCX: 0000000000000048
[ 8.764203] RDX: 0000000000000000 RSI: ffffffffc06336f0 RDI: ffff8d5a8fa67750
[ 8.776990] RBP: 0000000000000079 R08: 0000000fffffffff R09: 0000000000000000
[ 8.789768] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffc06336f0
[ 8.802007] R13: 00000000000000a0 R14: ffff8d5a6fc18000 R15: 0000000000000003
[ 8.814317] FS: 00007fec137a5980(0000) GS:ffff8d5a9fa80000(0000) knlGS:0000000000000000
[ 8.827629] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8.838309] CR2: 0000000000000000 CR3: 0000000a04b48002 CR4: 00000000001606e0
[ 8.850502] Call Trace:
[ 8.857950] hfi1_num_netdev_contexts+0x7c/0x110 [hfi1]
[ 8.868295] hfi1_init_dd+0xd7f/0x1a90 [hfi1]
[ 8.877681] ? pci_bus_read_config_dword+0x49/0x70
[ 8.887567] ? pci_mmcfg_read+0x3e/0xe0
[ 8.896797] do_init_one.isra.18+0x336/0x640 [hfi1]
[ 8.906958] local_pci_probe+0x41/0x90
[ 8.915784] pci_device_probe+0x105/0x1c0
[ 8.925002] really_probe+0x212/0x440
[ 8.933687] driver_probe_device+0x49/0xc0
[ 8.942918] device_driver_attach+0x50/0x60
[ 8.952553] __driver_attach+0x61/0x130
[ 8.961553] ? device_driver_attach+0x60/0x60
[ 8.971122] bus_for_each_dev+0x77/0xc0
[ 8.979912] ? klist_add_tail+0x3b/0x70
[ 8.988886] bus_add_driver+0x14d/0x1e0
[ 8.998175] ? dev_init+0x10b/0x10b [hfi1]
[ 9.007531] driver_register+0x6b/0xb0
[ 9.016757] ? dev_init+0x10b/0x10b [hfi1]
[ 9.026220] hfi1_mod_init+0x1e6/0x20a [hfi1]
[ 9.035601] do_one_initcall+0x46/0x1c3
[ 9.043958] ? free_unref_page_commit+0x91/0x100
[ 9.053460] ? _cond_resched+0x15/0x30
[ 9.062426] ? kmem_cache_alloc_trace+0x140/0x1c0
[ 9.071982] do_init_module+0x5a/0x220
[ 9.080574] load_module+0x14b4/0x17e0
[ 9.088911] ? __do_sys_finit_module+0xa8/0x110
[ 9.098231] __do_sys_finit_module+0xa8/0x110
[ 9.107307] do_syscall_64+0x5b/0x1a0

The issue happens when pcibus_to_node() returns NO_NUMA_NODE.

Fix this issue by moving the initialization of dd->node to hfi1_devdata
allocation and remove the other pcibus_to_node() calls in the probe
path and use dd->node instead.

Affinity logic is adjusted to use a new field dd->affinity_entry
as a guard instead of dd->node.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/affinity.c  | 21 +++++----------------
 drivers/infiniband/hw/hfi1/hfi.h       |  1 +
 drivers/infiniband/hw/hfi1/init.c      | 10 +++++++++-
 drivers/infiniband/hw/hfi1/netdev_rx.c |  3 +--
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 2a91b8d..04b1e8f 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -632,22 +632,11 @@ static void _dev_comp_vect_cpu_mask_clean_up(struct hfi1_devdata *dd,
  */
 int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 {
-	int node = pcibus_to_node(dd->pcidev->bus);
 	struct hfi1_affinity_node *entry;
 	const struct cpumask *local_mask;
 	int curr_cpu, possible, i, ret;
 	bool new_entry = false;
 
-	/*
-	 * If the BIOS does not have the NUMA node information set, select
-	 * NUMA 0 so we get consistent performance.
-	 */
-	if (node < 0) {
-		dd_dev_err(dd, "Invalid PCI NUMA node. Performance may be affected\n");
-		node = 0;
-	}
-	dd->node = node;
-
 	local_mask = cpumask_of_node(dd->node);
 	if (cpumask_first(local_mask) >= nr_cpu_ids)
 		local_mask = topology_core_cpumask(0);
@@ -660,7 +649,7 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 	 * create an entry in the global affinity structure and initialize it.
 	 */
 	if (!entry) {
-		entry = node_affinity_allocate(node);
+		entry = node_affinity_allocate(dd->node);
 		if (!entry) {
 			dd_dev_err(dd,
 				   "Unable to allocate global affinity node\n");
@@ -751,6 +740,7 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 	if (new_entry)
 		node_affinity_add_tail(entry);
 
+	dd->affinity_entry = entry;
 	mutex_unlock(&node_affinity.lock);
 
 	return 0;
@@ -766,10 +756,9 @@ void hfi1_dev_affinity_clean_up(struct hfi1_devdata *dd)
 {
 	struct hfi1_affinity_node *entry;
 
-	if (dd->node < 0)
-		return;
-
 	mutex_lock(&node_affinity.lock);
+	if (!dd->affinity_entry)
+		goto unlock;
 	entry = node_affinity_lookup(dd->node);
 	if (!entry)
 		goto unlock;
@@ -780,8 +769,8 @@ void hfi1_dev_affinity_clean_up(struct hfi1_devdata *dd)
 	 */
 	_dev_comp_vect_cpu_mask_clean_up(dd, entry);
 unlock:
+	dd->affinity_entry = NULL;
 	mutex_unlock(&node_affinity.lock);
-	dd->node = NUMA_NO_NODE;
 }
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 024ef6e..d341b8a 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1403,6 +1403,7 @@ struct hfi1_devdata {
 	spinlock_t irq_src_lock;
 	int vnic_num_vports;
 	struct net_device *dummy_netdev;
+	struct hfi1_affinity_node *affinity_entry;
 
 	/* Keeps track of IPoIB RSM rule users */
 	atomic_t ipoib_rsm_usr_num;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index e4f8db4..6d03aa0 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1277,7 +1277,6 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 	dd->pport = (struct hfi1_pportdata *)(dd + 1);
 	dd->pcidev = pdev;
 	pci_set_drvdata(pdev, dd);
-	dd->node = NUMA_NO_NODE;
 
 	ret = xa_alloc_irq(&hfi1_dev_table, &dd->unit, dd, xa_limit_32b,
 			GFP_KERNEL);
@@ -1287,6 +1286,15 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 		goto bail;
 	}
 	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s_%d", class_name(), dd->unit);
+	/*
+	 * If the BIOS does not have the NUMA node information set, select
+	 * NUMA 0 so we get consistent performance.
+	 */
+	dd->node = pcibus_to_node(pdev->bus);
+	if (dd->node == NUMA_NO_NODE) {
+		dd_dev_err(dd, "Invalid PCI NUMA node. Performance may be affected\n");
+		dd->node = 0;
+	}
 
 	/*
 	 * Initialize all locks for the device. This needs to be as early as
diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
index cec02e8..c1fa53d 100644
--- a/drivers/infiniband/hw/hfi1/netdev_rx.c
+++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
@@ -173,8 +173,7 @@ u32 hfi1_num_netdev_contexts(struct hfi1_devdata *dd, u32 available_contexts,
 		return 0;
 	}
 
-	cpumask_and(node_cpu_mask, cpu_mask,
-		    cpumask_of_node(pcibus_to_node(dd->pcidev->bus)));
+	cpumask_and(node_cpu_mask, cpu_mask, cpumask_of_node(dd->node));
 
 	available_cpus = cpumask_weight(node_cpu_mask);
 
-- 
1.8.3.1

