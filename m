Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AA1236BE
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfLQULV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:11:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbfLQULU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:11:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2E6206D7;
        Tue, 17 Dec 2019 20:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613479;
        bh=f7ieGE8/if+8bFte30hLjnpe1/ihpHbySerNRFQz5E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEynHgde9BCqyPm/W8rwgrPXPJs+iSNNmHyORM8Jxv//yS1ZI5ylsrNPdpQQcpvWX
         Z0vOTgOtFDsd+sxUb9bQdxkrJmjiC7e15qFpDfB3OsDj3JjeQ4jm1kDvmW8I7RsE0k
         ZmCRL+lfnoSnbmoocSuX8j+TZW8QeDFeM5b/HmJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 36/37] net: mscc: ocelot: unregister the PTP clock on deinit
Date:   Tue, 17 Dec 2019 21:09:57 +0100
Message-Id: <20191217200735.865521155@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 9385973fe8db9743fa93bf17245635be4eb8c4a6 ]

Currently a switch driver deinit frees the regmaps, but the PTP clock is
still out there, available to user space via /dev/ptpN. Any PTP
operation is a ticking time bomb, since it will attempt to use the freed
regmaps and thus trigger kernel panics:

[    4.291746] fsl_enetc 0000:00:00.2 eth1: error -22 setting up slave phy
[    4.291871] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
[    4.308666] mscc_felix: probe of 0000:00:00.5 failed with error -22
[    6.358270] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000088
[    6.367090] Mem abort info:
[    6.369888]   ESR = 0x96000046
[    6.369891]   EC = 0x25: DABT (current EL), IL = 32 bits
[    6.369892]   SET = 0, FnV = 0
[    6.369894]   EA = 0, S1PTW = 0
[    6.369895] Data abort info:
[    6.369897]   ISV = 0, ISS = 0x00000046
[    6.369899]   CM = 0, WnR = 1
[    6.369902] user pgtable: 4k pages, 48-bit VAs, pgdp=00000020d58c7000
[    6.369904] [0000000000000088] pgd=00000020d5912003, pud=00000020d5915003, pmd=0000000000000000
[    6.369914] Internal error: Oops: 96000046 [#1] PREEMPT SMP
[    6.420443] Modules linked in:
[    6.423506] CPU: 1 PID: 262 Comm: phc_ctl Not tainted 5.4.0-03625-gb7b2a5dadd7f #204
[    6.431273] Hardware name: LS1028A RDB Board (DT)
[    6.435989] pstate: 40000085 (nZcv daIf -PAN -UAO)
[    6.440802] pc : css_release+0x24/0x58
[    6.444561] lr : regmap_read+0x40/0x78
[    6.448316] sp : ffff800010513cc0
[    6.451636] x29: ffff800010513cc0 x28: ffff002055873040
[    6.456963] x27: 0000000000000000 x26: 0000000000000000
[    6.462289] x25: 0000000000000000 x24: 0000000000000000
[    6.467617] x23: 0000000000000000 x22: 0000000000000080
[    6.472944] x21: ffff800010513d44 x20: 0000000000000080
[    6.478270] x19: 0000000000000000 x18: 0000000000000000
[    6.483596] x17: 0000000000000000 x16: 0000000000000000
[    6.488921] x15: 0000000000000000 x14: 0000000000000000
[    6.494247] x13: 0000000000000000 x12: 0000000000000000
[    6.499573] x11: 0000000000000000 x10: 0000000000000000
[    6.504899] x9 : 0000000000000000 x8 : 0000000000000000
[    6.510225] x7 : 0000000000000000 x6 : ffff800010513cf0
[    6.515550] x5 : 0000000000000000 x4 : 0000000fffffffe0
[    6.520876] x3 : 0000000000000088 x2 : ffff800010513d44
[    6.526202] x1 : ffffcada668ea000 x0 : ffffcada64d8b0c0
[    6.531528] Call trace:
[    6.533977]  css_release+0x24/0x58
[    6.537385]  regmap_read+0x40/0x78
[    6.540795]  __ocelot_read_ix+0x6c/0xa0
[    6.544641]  ocelot_ptp_gettime64+0x4c/0x110
[    6.548921]  ptp_clock_gettime+0x4c/0x58
[    6.552853]  pc_clock_gettime+0x5c/0xa8
[    6.556699]  __arm64_sys_clock_gettime+0x68/0xc8
[    6.561331]  el0_svc_common.constprop.2+0x7c/0x178
[    6.566133]  el0_svc_handler+0x34/0xa0
[    6.569891]  el0_sync_handler+0x114/0x1d0
[    6.573908]  el0_sync+0x140/0x180
[    6.577232] Code: d503201f b00119a1 91022263 b27b7be4 (f9004663)
[    6.583349] ---[ end trace d196b9b14cdae2da ]---
[    6.587977] Kernel panic - not syncing: Fatal exception
[    6.593216] SMP: stopping secondary CPUs
[    6.597151] Kernel Offset: 0x4ada54400000 from 0xffff800010000000
[    6.603261] PHYS_OFFSET: 0xffffd0a7c0000000
[    6.607454] CPU features: 0x10002,21806008
[    6.611558] Memory Limit: none

And now that ocelot->ptp_clock is checked at exit, prevent a potential
error where ptp_clock_register returned a pointer-encoded error, which
we are keeping in the ocelot private data structure. So now,
ocelot->ptp_clock is now either NULL or a valid pointer.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1979,14 +1979,18 @@ static struct ptp_clock_info ocelot_ptp_
 
 static int ocelot_init_timestamp(struct ocelot *ocelot)
 {
+	struct ptp_clock *ptp_clock;
+
 	ocelot->ptp_info = ocelot_ptp_clock_info;
-	ocelot->ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
-	if (IS_ERR(ocelot->ptp_clock))
-		return PTR_ERR(ocelot->ptp_clock);
+	ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
+	if (IS_ERR(ptp_clock))
+		return PTR_ERR(ptp_clock);
 	/* Check if PHC support is missing at the configuration level */
-	if (!ocelot->ptp_clock)
+	if (!ptp_clock)
 		return 0;
 
+	ocelot->ptp_clock = ptp_clock;
+
 	ocelot_write(ocelot, SYS_PTP_CFG_PTP_STAMP_WID(30), SYS_PTP_CFG);
 	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_LOW);
 	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_HIGH);
@@ -2213,6 +2217,8 @@ void ocelot_deinit(struct ocelot *ocelot
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
 	ocelot_ace_deinit();
+	if (ocelot->ptp_clock)
+		ptp_clock_unregister(ocelot->ptp_clock);
 
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		port = ocelot->ports[i];


