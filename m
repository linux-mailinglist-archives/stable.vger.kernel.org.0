Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66B6527FAA
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiEPI2g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 May 2022 04:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiEPI2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:28:35 -0400
Received: from de-smtp-delivery-63.mimecast.com (de-smtp-delivery-63.mimecast.com [194.104.111.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DAADE013
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:28:31 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2044.outbound.protection.outlook.com [104.47.22.44]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-Y0jZdOmiM6GUk2Mp2Ib-2Q-2; Mon, 16 May 2022 10:28:28 +0200
X-MC-Unique: Y0jZdOmiM6GUk2Mp2Ib-2Q-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZR0P278MB0041.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:17::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Mon, 16 May 2022 08:28:26 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 08:28:26 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     gregkh@linuxfoundation.org, andrew@lunn.ch, stable@vger.kernel.org
CC:     Francesco Dolcini <francesco.dolcini@toradex.com>, kuba@kernel.org
Subject: [PATCH 5.10] net: phy: Fix race condition on link status change
Date:   Mon, 16 May 2022 10:28:15 +0200
Message-ID: <20220516082815.17917-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
X-ClientProxiedBy: MR2P264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::25) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c6d6165-ed1e-4c3b-2958-08da37160c49
X-MS-TrafficTypeDiagnostic: ZR0P278MB0041:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0041A35B66D72D5FB57D77AAE2CF9@ZR0P278MB0041.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: qKcXVWMYA5+jLJM8mOBJDqxbsvYdhgJyZRUsOpaEJ31ZA5SWXfvQ8hR+WcAA6J8JUDw+wZKHnHsMKcIB+VyZhmLmVZK0RW9ebxlvprpvBk22HSBdlaaM1NbB5fNsmHOB4Ry4DtsC7saP8hwZ5FnwpeAxX3clQV/KpvFsa2jLA4+iy4HAskqGk+ZZU9X2Uwq4c65E+0XmVB4IC5qbSMblq/y/plsDqniq1K9jUZFHKd+Glu/WrHC7TOikmzQxwWNrbvYo07mgmHvYZpCcK5DzPWHU2goppXnBcAlUMUWjUfUa1DAJHHcjaFx2nKovt6MR4Zpxpezgq8mQ4LsWW9XCXhhI9RTJmdwLFPg8H93hH9L4439O76Vtgr4Q/l7E6L3jNCfFLh/KVCGKR8RnfMyjcBBQNA9A5/SlOaJqzrvFmxVI/nln9yw3Z8VZkYl7i/fykws/wjj331fKIAmrLfIGo5MkXWoYUwjD4H3PSH2nY5kLaui/kC4A2wphaX/pcij4gsbgrwDldG4jCQ3Svos5qTrixXQ2JOqrUN3cm5jhq8AY1bMikpn6FFMOvEpyAOPjknrvE//3lGz3x1gDaq+fraUxdgXmAh+1kkO56eH9hYh4Tf41dce4dha/yaQmExP0ZI+QhsB9WnnV6Gh/MQ00vKq1gKAeikSzU5yk6Kyn+XCxOkldhuqfDmXfLkDUet9zZ8nZFQUzFxEzEBIDHLQfqg5PZo39zOzxIYakKIzj7MXjefjGcrMu6uDHifq/cC0FzvNlZ9ztYhi2h9/qtl0o8yrsx4sQhmn95FKiohvdyhjquou412ue4N2/NIIZDnFlqDmuyZZUtC1OPq9ammCabg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(366004)(39840400004)(376002)(396003)(346002)(6666004)(2906002)(38350700002)(38100700002)(83380400001)(316002)(41300700001)(52116002)(6512007)(66946007)(1076003)(186003)(6486002)(966005)(66556008)(66476007)(4326008)(8676002)(45080400002)(44832011)(5660300002)(508600001)(8936002)(26005)(6506007)(86362001)(36756003)(2616005);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QNGKRyScdE69PMiivK96jtwU1L+FXX5eUZDqr3pjzfagpQQ1JiVjrY6flt1M?=
 =?us-ascii?Q?BqWHZxl+FVy4i9AbgEFXs8p1tHdE+JdS5z5A0NdANz6DXzFrpI2yk1U/txHc?=
 =?us-ascii?Q?/lNKfV1jz3qmVNQPvfsC3hHIjY2uDJbCxGrkqlC6uS4366Q6SdE9Od9ritLm?=
 =?us-ascii?Q?VvXBr9ZcqDIgtDYKvvPB7pKiwBf5HgXnNYn4PaFNhy4l7HOlz56WiWbYzycK?=
 =?us-ascii?Q?McRLYoXcVL3Lid89Jiwq2nXvlPi4tdAZLvtOuKDYijIJhn2+Zbispkb65nEs?=
 =?us-ascii?Q?qxzjfuHqejlHFlXsGql2adGQdw4x0ilYPmET3Je3gK5uEW6/NSYjN/GMJ0HL?=
 =?us-ascii?Q?eMHeNpA14ZSlnUy9JjCTU+RKQMZACxXggefDCVhbAA5mdB2H0xQ90ygZJ/ML?=
 =?us-ascii?Q?bQruUE9cnI7prrSfwg7MgtYr9CU5eQ18+6kIHjxBuRl3gaJAPDmkk9UjHxyH?=
 =?us-ascii?Q?8h7PHgwKPhfmqebFSEG77XZK1JL8Zvy8SPVI9+LYsqhPfCgBIv8Ln+OVxEc6?=
 =?us-ascii?Q?J6uRHnGs5+SVpn+8ZBzezOh2GJJxenx9XsECG8HiOtogiUZubJ4jFanwTvTA?=
 =?us-ascii?Q?ngdkB/T9l9+oJHi4HAmlbL0IhfmtrVDxMC/TuycU0jE5JJa4+9ESqQC/pGGi?=
 =?us-ascii?Q?Uu2flIX7qTYKjMm5txS3fhUxJTB5Jonzq3Au5cknOFmuHBBRmcSCgR4rnNTo?=
 =?us-ascii?Q?MAixbhYnnxvn3B08Eiep21q9wEYoqH9PqU93xPQ55zJfZij6XxfseJirgBxh?=
 =?us-ascii?Q?6+bAyhS/Nys5+yjBjt1ZVCJvURydGaBjDaq/9o1Pd5OOFeMsHtQ8f6iYb0gj?=
 =?us-ascii?Q?eENrkPR5A4VpbuUrByLBBVBssqUWEyf7+HugPfFSYqMx18LiqixJOZud61VR?=
 =?us-ascii?Q?/PJPm5H4O2QKXyCyNLlXxB3jPbUmVfNBCHg9Gr0x7yp4ssFwao/P3H1Ajswm?=
 =?us-ascii?Q?unFSl7FFAhJyQHi54ExhSTsIuV1RIMgbTkydQijPCMfc6l888tOcuXW0c3/J?=
 =?us-ascii?Q?JXoq/4UTn0VTaFqOczxq+RfzGjMAg6ErVoUhSTfEOdbYKFdZfpIFkvwyuuDf?=
 =?us-ascii?Q?EwTE7iZF2M/GPqDdxL8PWslPfTRXVwDzlH2df/z6RcIctb6cwWjGBzcaG8qg?=
 =?us-ascii?Q?z58itkkD478xLFgsle6lCZaqJiAtMEZXB3MYFszPXOoikxkcOpIxw+HXy2k7?=
 =?us-ascii?Q?XknVZM3zUlfbkbTiYNj0AlrusL5Nys5Zf0C1DdJOGaVnLMulK32Y5a+SaFxy?=
 =?us-ascii?Q?IzfaWh/q4vmBiBErVoqZyWEPx25AHOugZ6/THnV6ouqzcn6FgtaT6vPRdxgn?=
 =?us-ascii?Q?gRgmrWzkCsp2/k4NBQtuudwbd3Ex5oKUILHseUsryCs5SIGgDOO6MoadetPw?=
 =?us-ascii?Q?mTXU0nrvHv//rKWWK3TykhaKl4XsINti5/rwHGW4toCLFTCXvpWeS+3Pw0xb?=
 =?us-ascii?Q?kKBIDZjHj6s+ZT7UiTVAkKVbv9DWr+9ghHMT4uyzp/miXaNumRYyk7FxKIc7?=
 =?us-ascii?Q?vd75tFNdzfXV7f/WqAtQV4xS6XxN6ZeszAgU5891oKHUonIJUyY+2P+isi8G?=
 =?us-ascii?Q?58sEKlRqUV9ZzXT918U8ADBay2QF3+t0EUrIAH6f+sTpUztp0EPdWVrgiYm1?=
 =?us-ascii?Q?H8AQIL4z2DaVeDKWJnJrL7wCSaj3iIsK091D9KkFLF2jQ8+dEEg0d2aAQrX6?=
 =?us-ascii?Q?CK4K9Y/QLaRITbPprPhdjFwp6OFV5jp3nUeZyY0aL03+U+Yy+d56J7hS1cdp?=
 =?us-ascii?Q?VWIOJi4zbP/aj2hPEFpcYAPnTnqoyWE=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6d6165-ed1e-4c3b-2958-08da37160c49
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 08:28:26.2213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shjtVO/hBlH585Ot4cp1IOq7XoAbJfhEQn/n9ddsBKSeUJLHN9s3OGNpTbLr4VFVoaW4tbsJ6TfCGY5jnf27PLe2au8/WXvwOLWWzrib784=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0041
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

backport of commit 91a7cda1f4b8bdf770000a3b60640576dafe0cec upstream.

This fixes the following error caused by a race condition between
phydev->adjust_link() and a MDIO transaction in the phy interrupt
handler. The issue was reproduced with the ethernet FEC driver and a
micrel KSZ9031 phy.

[  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
[  146.201779] ------------[ cut here ]------------
[  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
[  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
[  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
[  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  146.236257]  unwind_backtrace from show_stack+0x10/0x14
[  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
[  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
[  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
[  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
[  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
[  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
[  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
[  146.279605]  irq_thread from kthread+0xe4/0x104
[  146.284267]  kthread from ret_from_fork+0x14/0x28
[  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
[  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
[  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  146.318262] irq event stamp: 12325
[  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
[  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
[  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
[  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
[  146.354447] ---[ end trace 0000000000000000 ]---

With the FEC driver phydev->adjust_link() calls fec_enet_adjust_link()
calls fec_stop()/fec_restart() and both these function reset and
temporary disable the FEC disrupting any MII transaction that
could be happening at the same time.

fec_enet_adjust_link() and phy_read() can be running at the same time
when we have one additional interrupt before the phy_state_machine() is
able to terminate.

Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
                           |
                           | phy_interrupt()            <-- PHY IRQ
                           |  handle_interrupt()
                           |   phy_read()
                           |   phy_trigger_machine()
                           |    --> schedule phylib WQ
                           |
                           |
phy_state_machine()        |
 phy_check_link_status()   |
  phy_link_change()        |
   phydev->adjust_link()   |
    fec_enet_adjust_link() |
     --> FEC reset         | phy_interrupt()            <-- PHY IRQ
                           |  phy_read()
                           |

Fix this by acquiring the phydev lock in phy_interrupt().

Link: https://lore.kernel.org/all/20220422152612.GA510015@francesco-nb.int.toradex.com/
Fixes: c974bdbc3e77 ("net: phy: Use threaded IRQ, to allow IRQ from sleeping devices")
cc: <stable@vger.kernel.org>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220506060815.327382-1-francesco.dolcini@toradex.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[fd: backport: adapt locking before did_interrupt()/ack_interrupt()
 callbacks removal ]
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 drivers/net/phy/phy.c | 45 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index db7866b6f752..18e67eb6d8b4 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -124,10 +124,15 @@ EXPORT_SYMBOL(phy_print_status);
  */
 static int phy_clear_interrupt(struct phy_device *phydev)
 {
-	if (phydev->drv->ack_interrupt)
-		return phydev->drv->ack_interrupt(phydev);
+	int ret = 0;
 
-	return 0;
+	if (phydev->drv->ack_interrupt) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->ack_interrupt(phydev);
+		mutex_unlock(&phydev->lock);
+	}
+
+	return ret;
 }
 
 /**
@@ -981,6 +986,36 @@ int phy_disable_interrupts(struct phy_device *phydev)
 	return phy_clear_interrupt(phydev);
 }
 
+/**
+ * phy_did_interrupt - Checks if the PHY generated an interrupt
+ * @phydev: target phy_device struct
+ */
+static int phy_did_interrupt(struct phy_device *phydev)
+{
+	int ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->did_interrupt(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
+/**
+ * phy_handle_interrupt - Handle PHY interrupt
+ * @phydev: target phy_device struct
+ */
+static irqreturn_t phy_handle_interrupt(struct phy_device *phydev)
+{
+	irqreturn_t ret;
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->handle_interrupt(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
+}
+
 /**
  * phy_interrupt - PHY interrupt handler
  * @irq: interrupt line
@@ -994,9 +1029,9 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	struct phy_driver *drv = phydev->drv;
 
 	if (drv->handle_interrupt)
-		return drv->handle_interrupt(phydev);
+		return phy_handle_interrupt(phydev);
 
-	if (drv->did_interrupt && !drv->did_interrupt(phydev))
+	if (drv->did_interrupt && !phy_did_interrupt(phydev))
 		return IRQ_NONE;
 
 	/* reschedule state queue work to run as soon as possible */
-- 
2.25.1

