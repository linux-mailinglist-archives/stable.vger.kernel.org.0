Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95614188025
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgCQLHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbgCQLHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:07:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 703E120719;
        Tue, 17 Mar 2020 11:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443252;
        bh=WVG87XCiIaYQdxJYduoYD3LytzBx6SKV3+lKGnE86QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UONHATI2Fn4DU0UuTzZkjJ8XDsXXldasqWGNwum+dckkeYM4AaovqqWaP5MiC61HW
         rsUJyR8WjZRsQR3IyMoA1qPDA4j6o8/FBMQjSIj9S9ecqa91Zqn05Uvs2pH0N4bKJV
         La7S1uWkqHp4JSjMVhUE8fSIhb0UjsuOQVtckz9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 025/151] net: phy: bcm63xx: fix OOPS due to missing driver name
Date:   Tue, 17 Mar 2020 11:53:55 +0100
Message-Id: <20200317103328.533077928@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 43de81b0601df7d7988d3f5617ee0987df65c883 ]

719655a14971 ("net: phy: Replace phy driver features u32 with link_mode
bitmap") was a bit over-eager and also removed the second phy driver's
name, resulting in a nasty OOPS on registration:

[    1.319854] CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 804dd50c, ra == 804dd4f0
[    1.330859] Oops[#1]:
[    1.333138] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.22 #0
[    1.339217] $ 0   : 00000000 00000001 87ca7f00 805c1874
[    1.344590] $ 4   : 00000000 00000047 00585000 8701f800
[    1.349965] $ 8   : 8701f800 804f4a5c 00000003 64726976
[    1.355341] $12   : 00000001 00000000 00000000 00000114
[    1.360718] $16   : 87ca7f80 00000000 00000000 80639fe4
[    1.366093] $20   : 00000002 00000000 806441d0 80b90000
[    1.371470] $24   : 00000000 00000000
[    1.376847] $28   : 87c1e000 87c1fda0 80b90000 804dd4f0
[    1.382224] Hi    : d1c8f8da
[    1.385180] Lo    : 5518a480
[    1.388182] epc   : 804dd50c kset_find_obj+0x3c/0x114
[    1.393345] ra    : 804dd4f0 kset_find_obj+0x20/0x114
[    1.398530] Status: 10008703 KERNEL EXL IE
[    1.402833] Cause : 00800008 (ExcCode 02)
[    1.406952] BadVA : 00000000
[    1.409913] PrId  : 0002a075 (Broadcom BMIPS4350)
[    1.414745] Modules linked in:
[    1.417895] Process swapper/0 (pid: 1, threadinfo=(ptrval), task=(ptrval), tls=00000000)
[    1.426214] Stack : 87cec000 80630000 80639370 80640658 80640000 80049af4 80639fe4 8063a0d8
[    1.434816]         8063a0d8 802ef078 00000002 00000000 806441d0 80b90000 8063a0d8 802ef114
[    1.443417]         87cea0de 87c1fde0 00000000 804de488 87cea000 8063a0d8 8063a0d8 80334e48
[    1.452018]         80640000 8063984c 80639bf4 00000000 8065de48 00000001 8063a0d8 80334ed0
[    1.460620]         806441d0 80b90000 80b90000 802ef164 8065dd70 80620000 80b90000 8065de58
[    1.469222]         ...
[    1.471734] Call Trace:
[    1.474255] [<804dd50c>] kset_find_obj+0x3c/0x114
[    1.479141] [<802ef078>] driver_find+0x1c/0x44
[    1.483665] [<802ef114>] driver_register+0x74/0x148
[    1.488719] [<80334e48>] phy_driver_register+0x9c/0xd0
[    1.493968] [<80334ed0>] phy_drivers_register+0x54/0xe8
[    1.499345] [<8001061c>] do_one_initcall+0x7c/0x1f4
[    1.504374] [<80644ed8>] kernel_init_freeable+0x1d4/0x2b4
[    1.509940] [<804f4e24>] kernel_init+0x10/0xf8
[    1.514502] [<80018e68>] ret_from_kernel_thread+0x14/0x1c
[    1.520040] Code: 1060000c  02202025  90650000 <90810000> 24630001  14250004  24840001  14a0fffb  90650000
[    1.530061]
[    1.531698] ---[ end trace d52f1717cd29bdc8 ]---

Fix it by readding the name.

Fixes: 719655a14971 ("net: phy: Replace phy driver features u32 with link_mode bitmap")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/bcm63xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/bcm63xx.c
+++ b/drivers/net/phy/bcm63xx.c
@@ -73,6 +73,7 @@ static struct phy_driver bcm63xx_driver[
 	/* same phy as above, with just a different OUI */
 	.phy_id		= 0x002bdc00,
 	.phy_id_mask	= 0xfffffc00,
+	.name		= "Broadcom BCM63XX (2)",
 	/* PHY_BASIC_FEATURES */
 	.flags		= PHY_IS_INTERNAL,
 	.config_init	= bcm63xx_config_init,


