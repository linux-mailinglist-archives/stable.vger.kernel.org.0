Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC13214F33
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfEFOgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfEFOga (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:36:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82317214AE;
        Mon,  6 May 2019 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153390;
        bh=2p+eSt2DirTYJ5ttOzIdiVQkYNsWKfn+uZw18Wm1ey8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbzzEImqhJn2nb1G59fjWPpok1oV6rqkl6NpSHyiADoxRMOLj+XuPKCnjDZ4m6Jm8
         m25UMfZvXPuV53aNdJYUkyxBoLLSy4CoNefA4ve+bBW5LITkIgUDAYZ4Qp2ptxUSh9
         2Z50mxcf+c7ypadAEkxQb/ZLicPOG7dKUwOrO9vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 070/122] net: hns: Fix probabilistic memory overwrite when HNS driver initialized
Date:   Mon,  6 May 2019 16:32:08 +0200
Message-Id: <20190506143101.231819017@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c0b0984426814f3a9251873b689e67d34d8ccd84 ]

When reboot the system again and again, may cause a memory
overwrite.

[   15.638922] systemd[1]: Reached target Swap.
[   15.667561] tun: Universal TUN/TAP device driver, 1.6
[   15.676756] Bridge firewalling registered
[   17.344135] Unable to handle kernel paging request at virtual address 0000000200000040
[   17.352179] Mem abort info:
[   17.355007]   ESR = 0x96000004
[   17.358105]   Exception class = DABT (current EL), IL = 32 bits
[   17.364112]   SET = 0, FnV = 0
[   17.367209]   EA = 0, S1PTW = 0
[   17.370393] Data abort info:
[   17.373315]   ISV = 0, ISS = 0x00000004
[   17.377206]   CM = 0, WnR = 0
[   17.380214] user pgtable: 4k pages, 48-bit VAs, pgdp = (____ptrval____)
[   17.386926] [0000000200000040] pgd=0000000000000000
[   17.391878] Internal error: Oops: 96000004 [#1] SMP
[   17.396824] CPU: 23 PID: 95 Comm: kworker/u130:0 Tainted: G            E     4.19.25-1.2.78.aarch64 #1
[   17.414175] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.54 08/16/2018
[   17.425615] Workqueue: events_unbound async_run_entry_fn
[   17.435151] pstate: 00000005 (nzcv daif -PAN -UAO)
[   17.444139] pc : __mutex_lock.isra.1+0x74/0x540
[   17.453002] lr : __mutex_lock.isra.1+0x3c/0x540
[   17.461701] sp : ffff000100d9bb60
[   17.469146] x29: ffff000100d9bb60 x28: 0000000000000000
[   17.478547] x27: 0000000000000000 x26: ffff802fb8945000
[   17.488063] x25: 0000000000000000 x24: ffff802fa32081a8
[   17.497381] x23: 0000000000000002 x22: ffff801fa2b15220
[   17.506701] x21: ffff000009809000 x20: ffff802fa23a0888
[   17.515980] x19: ffff801fa2b15220 x18: 0000000000000000
[   17.525272] x17: 0000000200000000 x16: 0000000200000000
[   17.534511] x15: 0000000000000000 x14: 0000000000000000
[   17.543652] x13: ffff000008d95db8 x12: 000000000000000d
[   17.552780] x11: ffff000008d95d90 x10: 0000000000000b00
[   17.561819] x9 : ffff000100d9bb90 x8 : ffff802fb89d6560
[   17.570829] x7 : 0000000000000004 x6 : 00000004a1801d05
[   17.579839] x5 : 0000000000000000 x4 : 0000000000000000
[   17.588852] x3 : ffff802fb89d5a00 x2 : 0000000000000000
[   17.597734] x1 : 0000000200000000 x0 : 0000000200000000
[   17.606631] Process kworker/u130:0 (pid: 95, stack limit = 0x(____ptrval____))
[   17.617438] Call trace:
[   17.623349]  __mutex_lock.isra.1+0x74/0x540
[   17.630927]  __mutex_lock_slowpath+0x24/0x30
[   17.638602]  mutex_lock+0x50/0x60
[   17.645295]  drain_workqueue+0x34/0x198
[   17.652623]  __sas_drain_work+0x7c/0x168
[   17.659903]  sas_drain_work+0x60/0x68
[   17.666947]  hisi_sas_scan_finished+0x30/0x40 [hisi_sas_main]
[   17.676129]  do_scsi_scan_host+0x70/0xb0
[   17.683534]  do_scan_async+0x20/0x228
[   17.690586]  async_run_entry_fn+0x4c/0x1d0
[   17.697997]  process_one_work+0x1b4/0x3f8
[   17.705296]  worker_thread+0x54/0x470

Every time the call trace is not the same, but the overwrite address
is always the same:
Unable to handle kernel paging request at virtual address 0000000200000040

The root cause is, when write the reg XGMAC_MAC_TX_LF_RF_CONTROL_REG,
didn't use the io_base offset.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index ba4316910dea..a60f207768fc 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -129,7 +129,7 @@ static void hns_xgmac_lf_rf_control_init(struct mac_driver *mac_drv)
 	dsaf_set_bit(val, XGMAC_UNIDIR_EN_B, 0);
 	dsaf_set_bit(val, XGMAC_RF_TX_EN_B, 1);
 	dsaf_set_field(val, XGMAC_LF_RF_INSERT_M, XGMAC_LF_RF_INSERT_S, 0);
-	dsaf_write_reg(mac_drv, XGMAC_MAC_TX_LF_RF_CONTROL_REG, val);
+	dsaf_write_dev(mac_drv, XGMAC_MAC_TX_LF_RF_CONTROL_REG, val);
 }
 
 /**
-- 
2.20.1



