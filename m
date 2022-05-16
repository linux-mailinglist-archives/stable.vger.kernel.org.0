Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37745527FAC
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbiEPI33 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 May 2022 04:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbiEPI31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:29:27 -0400
Received: from de-smtp-delivery-63.mimecast.com (de-smtp-delivery-63.mimecast.com [194.104.111.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13808E034
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:29:25 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2049.outbound.protection.outlook.com [104.47.22.49]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-18-Ucy0Z7djOuya28ho3A2WSA-2; Mon, 16 May 2022 10:29:23 +0200
X-MC-Unique: Ucy0Z7djOuya28ho3A2WSA-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZR0P278MB0041.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:17::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Mon, 16 May 2022 08:29:21 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 08:29:21 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     gregkh@linuxfoundation.org, andrew@lunn.ch, stable@vger.kernel.org
CC:     Francesco Dolcini <francesco.dolcini@toradex.com>, kuba@kernel.org
Subject: [PATCH 5.4] net: phy: Fix race condition on link status change
Date:   Mon, 16 May 2022 10:29:19 +0200
Message-ID: <20220516082919.18137-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
X-ClientProxiedBy: MRXP264CA0020.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::32) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35efac86-753d-4d10-9fea-08da37162d3d
X-MS-TrafficTypeDiagnostic: ZR0P278MB0041:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0041ABD1979C3979AAA8B033E2CF9@ZR0P278MB0041.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: kxEdet7vnipbZb/KgDNixZEjmZB5DX/czKF64d/Q2gKfviy8AdxNxSCDQ4dHwlBzp0YpdxeFeccgMO5pq/wUtydh5bnrbdz1bcHFySk+KMgQw7Ab3zlfPpAdE8ZQIp3jnAuTTaRoyIDZNtJgsBD2DH0kEzOd+uSTPM1PGe6LL6AO/CbqwQ5+ByqbwcHLHrx+tpOlsbhTbh56bv+wjHcZfq17Ubl1oA8CHYPpnr7CRLwbq6ObtBGZPM16wflMx93EvBBSwr43ewLuvraQfcCAolKUEpLUJOqzoC1VjMY8M06jAIpyViEyDOUoBmJu+zI5TP8s6F+7MQjDMhJdvZhG7ov0aPMCecsTfyc245BbUucdo05WvZXjVOsuowgsdJrQNe2/7Fz5HjMIspRje8+deaa7PHaTtueI1Iu0aMb3w31Xis5++J20pETb3tdvrpfWgBZPPa4fqa84TRLz+wpmHGzyB7ENUi+BzcwmP496yZ7pS8nV71441EeSECNAMRNfQJxt4esIu7OWO3gnM9hU+U6F0uLEwBjO2yt3gs2Yh/kSUFCmJOgJBgQFo86cyraJ28s7r0EpmMQrwcnWaYR8X2mqeY6t36vojMS429d0xrqZh47plX2v6W0kWZubMY08960pnKn4903U2JKrFioWrtDdz62cpjUf2RwjhbgXqkf5/28lroG/bNFPdzkBS9Th8EdTpPmYkodkyZxbDS+4pBa+VcJw8WYtrRMmXbpUlI9UebBeYn/Ej/OolzIiMrQonfrM91q+oOiXjekBoIIMTclFOp3hqUPXCl5Im9OiIMK9iA6Qh3jxpCHtmhcpKCZF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(366004)(39840400004)(376002)(396003)(346002)(2906002)(38350700002)(38100700002)(83380400001)(316002)(41300700001)(52116002)(6512007)(66946007)(1076003)(186003)(6486002)(966005)(66556008)(66476007)(4326008)(8676002)(45080400002)(44832011)(5660300002)(508600001)(8936002)(26005)(6506007)(86362001)(36756003)(2616005);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C8Adj143cr2PFWLqvuyLwYRAXcXKJ1a2QlTRMd6VHkEidIe1n7y1JWAvLP5W?=
 =?us-ascii?Q?U05Qor+gceFD/8OjRk2hcKN7gympF1nEMkk2hs4qPt940NUO1xG+NEmJ4eAW?=
 =?us-ascii?Q?ukhNFxn2csaCEAAJdBcicBUxbi1/p8NeyMb0yWGpubujBKA+p8Tdyf31MhHm?=
 =?us-ascii?Q?gEMWxObExxsK8aoL4uwYfX0I8GItpYQ78at8DzVI/q//bPv1e5sTvcIO4v28?=
 =?us-ascii?Q?Pi9TqdSxxzbzpXnrlq8EoI/01DSVVwW3T1QjH8m6a9ad38fU0TVGvkeYKiKV?=
 =?us-ascii?Q?uAzGAIqkQmZngb4Iy/u3HgknMfnw6OQYA/MgvM8+Xbn3ndQ0ys6WRZXsCCed?=
 =?us-ascii?Q?q0AZeNyZSHsrGJGFA79sRE4u9+8/ND0e8Tb1tIz55CE+JBck/cy7ZZBFDckh?=
 =?us-ascii?Q?wRPIONymXsJ/YSsXrvcMygJfJueo8PbVwfevBmKcqn/yY8/uad00q0r8/qyz?=
 =?us-ascii?Q?1+N7W0YEVKNB3t1Udxe88trTV7AW1eTMkd9aiBzINOjPoDz9DrLci5xDhdWl?=
 =?us-ascii?Q?KiY2eH6/P8Z2T18uuhyqPW/qbS0lMY1FXcBW1J2d9l8J58s/654XSaflGrAS?=
 =?us-ascii?Q?31cJ7vsCkJmphCMNfRX/cSHF4aNiH59+F0mUSQ5JUC+SMk4zuQG+a0RRffJL?=
 =?us-ascii?Q?FhgdonDG6McrRUb42s5flKyBZS67YiaX0qPNsqopIaV8k0sbe5aOCzs6c+Ma?=
 =?us-ascii?Q?KH407m9epm5pJ/4cm+Oilo6OvxUMDvQOuE9j2M8ebnuMJew69MDRrCtZtSSc?=
 =?us-ascii?Q?afxgjn7Dg60o5+oM2RcqHv0CVWsTIbP0u/rTr85BNkT+IprY1F4hHPtkY2yr?=
 =?us-ascii?Q?ywa+CuwlJYLsYtvIwEFPsKaSs1ey0IvbDXL6JrbFmN6UIxd6OJ3pwtca7458?=
 =?us-ascii?Q?u+VR7z26p4Mgos7hAvqbUshWWEEpfbZBwEalCDN1PTHyyVPc3XKipERCp1J4?=
 =?us-ascii?Q?BP4YwFZF8AalP1GaweE3Y6JplxuRyNCDxirYfOc6pQ1AXvT3oMb/4nnhPDz2?=
 =?us-ascii?Q?k7nBYPqtZx1C0hclXjDaljtY+TjtOY3GwZNBMfxcXfGzuV1MGRI0uObQua7r?=
 =?us-ascii?Q?9ATfJXo5D22zs5RudqjGQWUnwPuEij9OqzOdknDcnb0kQHt1WXNffYM5zjhE?=
 =?us-ascii?Q?4czOSBCJM39SHogL/5V+b7mfdMfC7xz5uFGGOANEHofQi5fQXqKLZtJUYo3V?=
 =?us-ascii?Q?yr/OxIHgedjK5fuypDzoxSAfeds6EuobuzFAF21JF4KroKgqvLMecJqvroAO?=
 =?us-ascii?Q?UFUE7ISxso9us16kz9YTalxpKRO2xHd+tpWJr4/BNHtBddaZKt+l2mmuteeX?=
 =?us-ascii?Q?2eZTiwQhqXHwNNn3JjcxEU+DAtMZl6niTRmfty2bjk1sW6GEQVPeCaxiSRZt?=
 =?us-ascii?Q?zJNJXF4oem00CrYmhWjWLTQqukDhogX4dueG4NTCTZRLDwWRERXidxxl8hlo?=
 =?us-ascii?Q?kOAfrDFBELjCd53bnTnedZI/CL7iocDV4jTRGrBHXM/MHU1qTztYMRXLUeqF?=
 =?us-ascii?Q?YLAiJg3UUldTu4ueUkr77olLrzrY4s1nECvFknt5MMLqYorNdaOSERCicN3q?=
 =?us-ascii?Q?74VQh13UQEcvA+hKzGzO+ajJKJqTI2vwg2wZitzeKWMvxifc131RIhE2zuPE?=
 =?us-ascii?Q?A9Qv0h+yHFpeOCVTXLZlHcZNOkNwE6LYPxmKNeRmnEYOp2qhKK/MEaZLojSR?=
 =?us-ascii?Q?MIwdufI/3ozRZLa57OIFOtXeG1noiSkuUGAPXjrCns24ZsRrjEvuiOKfl4WC?=
 =?us-ascii?Q?HiAV9dy6Cg+PjhZYiT4ffLlqislxSe8=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35efac86-753d-4d10-9fea-08da37162d3d
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 08:29:21.4949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMxQmWGAGa+FgYmeWT8v7Jrlvw3l+9VW9UfCbE7npTXVO1hG1qT1xi0cpWiD21Y132atRwWkbEduSXzf5BvfqCinPOiU0Oa4jGdvOFhjD8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0041
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
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
index 6c52ff8c0d2e..9e8cf64f0442 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -116,10 +116,15 @@ EXPORT_SYMBOL(phy_print_status);
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
@@ -760,6 +765,36 @@ static int phy_disable_interrupts(struct phy_device *phydev)
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
+ * phy_handle_interrupt - PHY specific interrupt handler
+ * @phydev: target phy_device struct
+ */
+static int phy_handle_interrupt(struct phy_device *phydev)
+{
+	int ret;
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
@@ -771,11 +806,11 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 {
 	struct phy_device *phydev = phy_dat;
 
-	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
+	if (phydev->drv->did_interrupt && !phy_did_interrupt(phydev))
 		return IRQ_NONE;
 
 	if (phydev->drv->handle_interrupt) {
-		if (phydev->drv->handle_interrupt(phydev))
+		if (phy_handle_interrupt(phydev))
 			goto phy_err;
 	} else {
 		/* reschedule state queue work to run as soon as possible */
-- 
2.25.1

