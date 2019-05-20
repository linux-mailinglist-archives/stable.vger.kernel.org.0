Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E09D23770
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbfETMs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387576AbfETMWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 797A4213F2;
        Mon, 20 May 2019 12:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354930;
        bh=+haWhBeLMgW5hj6mugJTA23hdoTpHOeeUglrpzTFYug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muz36mvP3VC7AHktTCBCLQf1lj2BGkwUedhxz9kbduy1ESYqqyiR7UE5aNMQB+qor
         g2yZ5860keZFayKDpSnps8hrmTpIjaX6zDnkgloSat44RWW5b0bAmUU1IWbfEs7unN
         wC69HRpJHZlEiQNm4S+41CYbAetb6PzDV4VjjO+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Muellner <christoph.muellner@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.19 005/105] arm64: dts: rockchip: Disable DCMDs on RK3399s eMMC controller.
Date:   Mon, 20 May 2019 14:13:11 +0200
Message-Id: <20190520115247.424974813@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Muellner <christoph.muellner@theobroma-systems.com>

commit a3eec13b8fd2b9791a21fa16e38dfea8111579bf upstream.

When using direct commands (DCMDs) on an RK3399, we get spurious
CQE completion interrupts for the DCMD transaction slot (#31):

[  931.196520] ------------[ cut here ]------------
[  931.201702] mmc1: cqhci: spurious TCN for tag 31
[  931.206906] WARNING: CPU: 0 PID: 1433 at /usr/src/kernel/drivers/mmc/host/cqhci.c:725 cqhci_irq+0x2e4/0x490
[  931.206909] Modules linked in:
[  931.206918] CPU: 0 PID: 1433 Comm: irq/29-mmc1 Not tainted 4.19.8-rt6-funkadelic #1
[  931.206920] Hardware name: Theobroma Systems RK3399-Q7 SoM (DT)
[  931.206924] pstate: 40000005 (nZcv daif -PAN -UAO)
[  931.206927] pc : cqhci_irq+0x2e4/0x490
[  931.206931] lr : cqhci_irq+0x2e4/0x490
[  931.206933] sp : ffff00000e54bc80
[  931.206934] x29: ffff00000e54bc80 x28: 0000000000000000
[  931.206939] x27: 0000000000000001 x26: ffff000008f217e8
[  931.206944] x25: ffff8000f02ef030 x24: ffff0000091417b0
[  931.206948] x23: ffff0000090aa000 x22: ffff8000f008b000
[  931.206953] x21: 0000000000000002 x20: 000000000000001f
[  931.206957] x19: ffff8000f02ef018 x18: ffffffffffffffff
[  931.206961] x17: 0000000000000000 x16: 0000000000000000
[  931.206966] x15: ffff0000090aa6c8 x14: 0720072007200720
[  931.206970] x13: 0720072007200720 x12: 0720072007200720
[  931.206975] x11: 0720072007200720 x10: 0720072007200720
[  931.206980] x9 : 0720072007200720 x8 : 0720072007200720
[  931.206984] x7 : 0720073107330720 x6 : 00000000000005a0
[  931.206988] x5 : ffff00000860d4b0 x4 : 0000000000000000
[  931.206993] x3 : 0000000000000001 x2 : 0000000000000001
[  931.206997] x1 : 1bde3a91b0d4d900 x0 : 0000000000000000
[  931.207001] Call trace:
[  931.207005]  cqhci_irq+0x2e4/0x490
[  931.207009]  sdhci_arasan_cqhci_irq+0x5c/0x90
[  931.207013]  sdhci_irq+0x98/0x930
[  931.207019]  irq_forced_thread_fn+0x2c/0xa0
[  931.207023]  irq_thread+0x114/0x1c0
[  931.207027]  kthread+0x128/0x130
[  931.207032]  ret_from_fork+0x10/0x20
[  931.207035] ---[ end trace 0000000000000002 ]---

The driver shows this message only for the first spurious interrupt
by using WARN_ONCE(). Changing this to WARN() shows, that this is
happening quite frequently (up to once a second).

Since the eMMC 5.1 specification, where CQE and CQHCI are specified,
does not mention that spurious TCN interrupts for DCMDs can be simply
ignored, we must assume that using this feature is not working reliably.

The current implementation uses DCMD for REQ_OP_FLUSH only, and
I could not see any performance/power impact when disabling
this optional feature for RK3399.

Therefore this patch disables DCMDs for RK3399.

Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Signed-off-by: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
Cc: stable@vger.kernel.org
[the corresponding code changes are queued for 5.2 so doing that as well]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -305,6 +305,7 @@
 		phys = <&emmc_phy>;
 		phy-names = "phy_arasan";
 		power-domains = <&power RK3399_PD_EMMC>;
+		disable-cqe-dcmd;
 		status = "disabled";
 	};
 


