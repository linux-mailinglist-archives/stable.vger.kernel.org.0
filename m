Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A397E657F94
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiL1QHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiL1QG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:06:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AE3315
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47256B817F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68721C433D2;
        Wed, 28 Dec 2022 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243573;
        bh=NSnjBrBZ+AWvoKzJjSIouAQFi7wI3pN0wxopmdHS8LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBvBIp0MLzvgMhX9k686HeBU/g6UQl4tBOOAoUH+T2AbOfWKT9vGdp8Vkpgy2iguB
         mE7D1J9ZsTd/MdlXnf/1DLqOXe7rd7GO3mBPs7pPXzxPwOHixg5o5TfKskwtMSYdzH
         PXA9LM1FEVN0ZKbNAxedR3LKcPlimudJieyqdh8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0550/1073] stmmac: fix potential division by 0
Date:   Wed, 28 Dec 2022 15:35:38 +0100
Message-Id: <20221228144342.993205541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>

[ Upstream commit ede5a389852d3640a28e7187fb32b7f204380901 ]

When the MAC is connected to a 10 Mb/s PHY and the PTP clock is derived
from the MAC reference clock (default), the clk_ptp_rate becomes too
small and the calculated sub second increment becomes 0 when computed by
the stmmac_config_sub_second_increment() function within
stmmac_init_tstamp_counter().

Therefore, the subsequent div_u64 in stmmac_init_tstamp_counter()
operation triggers a divide by 0 exception as shown below.

[   95.062067] socfpga-dwmac ff700000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   95.076440] socfpga-dwmac ff700000.ethernet eth0: PHY [stmmac-0:08] driver [NCN26000] (irq=49)
[   95.095964] dwmac1000: Master AXI performs any burst length
[   95.101588] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found
[   95.109428] Division by zero in kernel.
[   95.113447] CPU: 0 PID: 239 Comm: ifconfig Not tainted 6.1.0-rc7-centurion3-1.0.3.0-01574-gb624218205b7-dirty #77
[   95.123686] Hardware name: Altera SOCFPGA
[   95.127695]  unwind_backtrace from show_stack+0x10/0x14
[   95.132938]  show_stack from dump_stack_lvl+0x40/0x4c
[   95.137992]  dump_stack_lvl from Ldiv0+0x8/0x10
[   95.142527]  Ldiv0 from __aeabi_uidivmod+0x8/0x18
[   95.147232]  __aeabi_uidivmod from div_u64_rem+0x1c/0x40
[   95.152552]  div_u64_rem from stmmac_init_tstamp_counter+0xd0/0x164
[   95.158826]  stmmac_init_tstamp_counter from stmmac_hw_setup+0x430/0xf00
[   95.165533]  stmmac_hw_setup from __stmmac_open+0x214/0x2d4
[   95.171117]  __stmmac_open from stmmac_open+0x30/0x44
[   95.176182]  stmmac_open from __dev_open+0x11c/0x134
[   95.181172]  __dev_open from __dev_change_flags+0x168/0x17c
[   95.186750]  __dev_change_flags from dev_change_flags+0x14/0x50
[   95.192662]  dev_change_flags from devinet_ioctl+0x2b4/0x604
[   95.198321]  devinet_ioctl from inet_ioctl+0x1ec/0x214
[   95.203462]  inet_ioctl from sock_ioctl+0x14c/0x3c4
[   95.208354]  sock_ioctl from vfs_ioctl+0x20/0x38
[   95.212984]  vfs_ioctl from sys_ioctl+0x250/0x844
[   95.217691]  sys_ioctl from ret_fast_syscall+0x0/0x4c
[   95.222743] Exception stack(0xd0ee1fa8 to 0xd0ee1ff0)
[   95.227790] 1fa0:                   00574c4f be9aeca4 00000003 00008914 be9aeca4 be9aec50
[   95.235945] 1fc0: 00574c4f be9aeca4 0059f078 00000036 be9aee8c be9aef7a 00000015 00000000
[   95.244096] 1fe0: 005a01f0 be9aec38 004d7484 b6e67d74

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Fixes: 91a2559c1dc5 ("net: stmmac: Fix sub-second increment")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/de4c64ccac9084952c56a06a8171d738604c4770.1670678513.git.piergiorgio.beruto@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 3 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h      | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 764832f4dae1..8b50f03056b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -47,7 +47,8 @@ static void config_sub_second_increment(void __iomem *ioaddr,
 	if (!(value & PTP_TCR_TSCTRLSSR))
 		data = (data * 1000) / 465;
 
-	data &= PTP_SSIR_SSINC_MASK;
+	if (data > PTP_SSIR_SSINC_MAX)
+		data = PTP_SSIR_SSINC_MAX;
 
 	reg_value = data;
 	if (gmac4)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
index 53172a439810..bf619295d079 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
@@ -64,7 +64,7 @@
 #define	PTP_TCR_TSENMACADDR	BIT(18)
 
 /* SSIR defines */
-#define	PTP_SSIR_SSINC_MASK		0xff
+#define	PTP_SSIR_SSINC_MAX		0xff
 #define	GMAC4_PTP_SSIR_SSINC_SHIFT	16
 
 /* Auxiliary Control defines */
-- 
2.35.1



