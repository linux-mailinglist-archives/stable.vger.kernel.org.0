Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AD73C6ABE
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 08:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhGMGvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 02:51:43 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:26882 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232908AbhGMGvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 02:51:43 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D6hDKB025924;
        Mon, 12 Jul 2021 23:48:38 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 39rx79g7fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 23:48:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlTRRrASge69HC5nAa+XzAWPD7tPzkqQ9Pt/oQWWeTZcgNSlEkJFFzdIPiLPSqB/jfcFpBCJsgye7Hgr7LqV6xcZWp1OmBFAjPVV9uMSC6LrHxCDc68V/Imt5t9ut4SFeX9J00W9S8JpxdMsWs0u4t/GNSXytea7K43gLlqH8DcZUd8vIOQ+xdcHvYYOZUE1k4NK4IPQWGzH8+AGSyY6RDiT5d9g2WWiEN3Hph9ILeQPDJivi0YsniF38LlzXOJK/7OwA90ZCQAVY9HJiq+zFT5elR3sZOP0A41G6D1u/n8P2yNAWwJ9vo6Swkud2N/h/8sIUUhQXcM3RaDXYdyNOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRHVHrb603nV6Pvw2ZqL1KUutUQX1S8NeVPEIO2M0Tg=;
 b=aRzA1l5LdnbOgYW42hvj9RRZfOxk6Whgv9OCcsSmdSaYDhTJnwWNxCACFSWOW1Bo+XCp/785c6ImKx0mU/uG9A7Lqupl1BqM33kffKWju0V3BhBxRJsEjixu6e20QOVL4LSbwq4bqpf8xpjwAHmec5ElJsu5Q7KsKI+EDmEzCCCKwxBK7uG31OWW+YXZVUYQ/iu+dAoVQHyk1fN7ygsIfrU+wux3mq8JgtgRM/clSTlmID4EklO8S5Co7UStw/NV5szX2VlsLS9POSKJQ6D6mZW8eR9Qg2j5OUm4jXtaeDJBukGkGqLr+q3LtD2HvQ06C2NQqdSHKgWdSsdbMfDxRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRHVHrb603nV6Pvw2ZqL1KUutUQX1S8NeVPEIO2M0Tg=;
 b=nAZ8fi4fc7/c6nporBBolYIjF7e6B0GOnGizCAjojpcLcUJGBQSkP2LIaDLZ7jQ/1J4MvG8m1mfM68Zf6CHDoSV0pqO856ze4ASg5aDetfdTFUjB8IY86F9S/k0tDasXd1rnY41Zj3Qo4PbMGO16m9VF8iUKbfgfe8PntgHzIP8=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none
 header.from=windriver.com;
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB4775.namprd11.prod.outlook.com (2603:10b6:510:34::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 06:48:35 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::d074:8957:ab05:b451]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::d074:8957:ab05:b451%4]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 06:48:34 +0000
From:   Yongxin Liu <yongxin.liu@windriver.com>
To:     tglx@linutronix.de
Cc:     evgreen@chromium.org, rajatja@google.com, bhelgaas@google.com,
        stable@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org,
        maz@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/apic/msi: check interupt context before reporting warning
Date:   Tue, 13 Jul 2021 14:46:09 +0800
Message-Id: <20210713064609.25429-1-yongxin.liu@windriver.com>
X-Mailer: git-send-email 2.14.5
Content-Type: text/plain
X-ClientProxiedBy: HK2P15301CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::21) To PH0PR11MB5175.namprd11.prod.outlook.com
 (2603:10b6:510:3d::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp6.wrs.com (60.247.85.82) by HK2P15301CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.4 via Frontend Transport; Tue, 13 Jul 2021 06:48:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cec1fb7-89d9-4c42-3a9e-08d945ca3c52
X-MS-TrafficTypeDiagnostic: PH0PR11MB4775:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4775B4FB168E667E6621B1E6E5149@PH0PR11MB4775.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TdwsTbA+7RBid3a69oci/6nlbJ8TRr9b9bFSfvm9WVlnRvz5dNRmlzhnkodKlxd3RuJ3wrXCgU1SaHsz83o52znZIBwSnfPoFaUjJQS6QFeNNT9h/u4VXgPSQgWrxGbnX9uNzy4mh+ArPGSjcv7D0BtQup42NMmKuIOiTh0hXEeULjPZWTfAIJxz4yZNk7r0eYpOXZVZi8xwnydoM+6WX2G3U2RwOGl2SkJhpLkInGK7LKqbWHhNkXL/gF2lDavYip0/ytD4Euzf5MrLItQBXoHupY7O1RJy9ngHGm1pgB0xEeV47lj6GtjbPy1YyFuWEL2HFfKkyHboLhwsuyIuOKQkXnuRp/XJHFn15qqfOQXgqtYGJyJ90mZ/PIAXM9xAcZo78ATI4QusGZJHH2bjLlS4Z2poL+lZcNrmR/9SGmWk4CdOuXF9Turd7exzAzuH5QYeVErZPrubquM1maLp1Xj1dbv04Mw9JEPZ1D7/LWeUQYEmMy+A8Sy8cpWROjdwEm+WlgBe6Va2lUKJSFXTggVaaoaPMtLgHCruq44NhNCZ2txqt/s5b/8+y43fbQsVBbVTXHHSjQivZcYyKzi4/ZFSdKA0uWmHnscQsCH4iDSJbzsVv9c3fq2i25/de5RXSYRdzoY8SHJpx4Yzz+Cnhr3t1+b6SKyeM31LQV+NdG/psBg3IyDYTf7v0aw5qWI0M/BLSIv5Rebanwrz0w2WKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39840400004)(396003)(366004)(136003)(346002)(4326008)(5660300002)(66476007)(44832011)(2616005)(8676002)(66556008)(86362001)(83380400001)(66946007)(6916009)(956004)(52116002)(186003)(478600001)(6486002)(316002)(6666004)(6506007)(36756003)(26005)(2906002)(6512007)(1076003)(38100700002)(38350700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YRBZMr5XES0kFVLqgpW+XI1Yigfz4Jd1DDdHOGYL67wlAEqaUZ8rBEc31TWr?=
 =?us-ascii?Q?jQYV/WZf9bVKddmmHFEPzWKU5AS+RS2JB4cPC9KVTIokd78k8VKKleRagNMG?=
 =?us-ascii?Q?eJldaQUHXVLoDAJjziPQb1HKRcE7YpbTPMfvgsl+QtxK4mJrZ+ARq+Wfi4SI?=
 =?us-ascii?Q?p3xzKYZhB97WFUFtaRQqImOzZRKUfnTPUlnTcud2HQfmVaH/t170d/dJgebn?=
 =?us-ascii?Q?4Pu+bPZKfAWGAtPkiLPyT9jT+PVa6RvQp3Y/LdYLie9gMMhx+gZ2yATQvVGa?=
 =?us-ascii?Q?6R63meUpd7hqJflDa++IuzsDn0b0PQhMfoPVqinEXP064vq9jFVaKdSzeTyp?=
 =?us-ascii?Q?f6dlH1MDMnY3FeABIctkOgiZ39y5jqgtGWV37Boa0BJJ2nN10HfCeKDzEpJo?=
 =?us-ascii?Q?VbTBU5+In6LbrbeP/06XO3izqU9E6b9po7UknmytNIfb6UVBSBqxPpuKmDkF?=
 =?us-ascii?Q?HTsGhhV9EJaC1AAq/RD4nkf4bNqTlmkeXIdWxLEhDntfAYbvE9Vdy4jOPBF8?=
 =?us-ascii?Q?19AZgHmnjhFIplZr4qXrVs5Wy2Bk3oDdSkHXXpbIYpuks1poSg3N3ZH9k5Yu?=
 =?us-ascii?Q?kGQ1RjBLLenX4q37/UgOJu3QdqA5iZjTiT2zccdS54Gm46pfAYAWgd8ij0K+?=
 =?us-ascii?Q?S86jQr267cSp+mIa9BkZ5jFsGUZqoTYmB3WcZ35vfWYD3iulW2xnz8GTiSfT?=
 =?us-ascii?Q?USChhQOTbWQSQfNQubVIjGasUMz/Ij/NeYnMEDIkJa2E61aHKaIU0Tk6eBKn?=
 =?us-ascii?Q?ZxrJiVGl8wAVfb0opbDFBxpdVJBqCdaNw4lyHKLQyIWwr555C8q9tyRe9VD2?=
 =?us-ascii?Q?ELaA4qGMH3GayP8wp9URNS0eOoYBD7omlUH+/YjzLkmuikjQLC2v6qfWLWz4?=
 =?us-ascii?Q?9PLAthG5HFvBpleclNRoO/hglv8LOMWEDTIR2gxDW40u2HlsBEueQOqVFer1?=
 =?us-ascii?Q?LU8DZumdIqN9YB4NTln/SP2Nylb86OZtdhEVb9BCt65m1u0lpImB3AigIZMQ?=
 =?us-ascii?Q?pDO5an36fFn2if2bgmYEv5IGqX/NmBay2IWq2cK5278QdlXsntFeC092cWeV?=
 =?us-ascii?Q?bJsMz+pXuwlOrjtgEV7lwopoEOwE57rBVNuN1FkX/a3mn91exOncCERet7QW?=
 =?us-ascii?Q?AFVbgfiJVeQAWCO/6gUDRSujTP3y/SgjsaMeQWGKDNNk8GZXjAGq7Dcggshy?=
 =?us-ascii?Q?EpZeP1QvCTOiaVcFTISBvciyHUyiHsLSlT6nQm+kNGOcX1VLnNUwid7RH9Gt?=
 =?us-ascii?Q?NqfhmLip3o5OZ1RtoN4ma8qYwIRUB8O+vlbnb0hjxFXA1f8DJl9orU4UL8Zo?=
 =?us-ascii?Q?tZgIomwLMSjGjIlTA1bwOaAp?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cec1fb7-89d9-4c42-3a9e-08d945ca3c52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 06:48:34.8831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nW8MJas0pOpwG1b/q+y8xFFlYGEkq3VPASFDKxS1m7ciYce3FuACtau3Ehi2IglmmJVcbU86e51r3HFzFlnTAESIXWI5w4sxlTpRhnkNVyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4775
X-Proofpoint-ORIG-GUID: JaN7cC-8ZayD7HNYxZlQh2T0A05EEd92
X-Proofpoint-GUID: JaN7cC-8ZayD7HNYxZlQh2T0A05EEd92
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_03:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130040
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Affinity change can happen in both interrupt context and non-interrupt
context. The paranoia check for interrupt target cpu is not always true
in non-interrupt context.

For example:
  Set affinity for irq to CPU#7
  $ echo 80 > /proc/irq/default_smp_affinity

  Open serial port on different CPU.
  $taskset -c 4 agetty -L 115200 ttyS1

Will triger the following warning.

  WARNING: CPU: 4 PID: 765 at arch/x86/kernel/apic/msi.c:75 msi_set_affinity+0x16f/0x190
  Call Trace:
   irq_do_set_affinity+0x57/0x1b0
   irq_setup_affinity+0x136/0x190
   irq_startup+0xaf/0xf0
   __setup_irq+0x745/0x7e0
   ? kmem_cache_alloc_trace+0x2b5/0x450
   request_threaded_irq+0x110/0x180
   univ8250_setup_irq+0x1e2/0x220
   serial8250_do_startup+0x481/0x760
   serial8250_startup+0x1e/0x20
   uart_startup.part.22+0xf8/0x260
   uart_port_activate+0x41/0x60
   tty_port_open+0x82/0xd0
   ? _raw_spin_unlock+0x16/0x30
   uart_open+0x1e/0x30
   tty_open+0x100/0x4d0
   ? cdev_purge+0x60/0x60
   chrdev_open+0xa3/0x1c0
   ? cdev_put.part.3+0x20/0x20
   do_dentry_open+0x21f/0x380
   vfs_open+0x2f/0x40
   path_openat+0xd67/0xf60
   ? page_add_file_rmap+0xad/0x140
   ? do_set_pte+0xd7/0x210
   do_filp_open+0xc5/0x140
   do_sys_openat2+0x239/0x300
   ? do_sys_openat2+0x239/0x300
   do_sys_open+0x59/0x80
   __x64_sys_openat+0x20/0x30
   do_syscall_64+0x3f/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

With this patch, the warning is only reported in interrupt context and when
the target CPU is not local CPU.

Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
---
 arch/x86/kernel/apic/msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 44ebe25e7703..c4c73f227eeb 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -72,7 +72,7 @@ msi_set_affinity(struct irq_data *irqd, const struct cpumask *mask, bool force)
 	 * Paranoia: Validate that the interrupt target is the local
 	 * CPU.
 	 */
-	if (WARN_ON_ONCE(cpu != smp_processor_id())) {
+	if (in_interrupt() && WARN_ON_ONCE(cpu != smp_processor_id())) {
 		irq_msi_update_msg(irqd, cfg);
 		return ret;
 	}
-- 
2.14.5

