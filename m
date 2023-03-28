Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C572F6CC26E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbjC1OpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjC1OpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087CDCDC1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D8F61804
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A53C433EF;
        Tue, 28 Mar 2023 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014700;
        bh=0VVFZBmv0NFrwioYNSCHljYCfnPQe5YZM8rYXqQRThw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTNLyvqSiI2h9yFFYJd9+kryCxKPOQ2jF1ODzvgiX+slda3orsbQ7sNIxKnliOyij
         CisIWVcShiXnCc5B9aGoT6hEqwdKH3FvLkDJxNSU5rgi9FkxOukZmjc2juf14gfBUH
         1zZvf54moan4P0LCiRnuTGazc9u1rLnVvfUULTds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Fang <wei.fang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 020/240] arm64: dts: imx8dxl-evk: Disable hibernation mode of AR8031 for EQOS
Date:   Tue, 28 Mar 2023 16:39:43 +0200
Message-Id: <20230328142620.499592486@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 0deefb5bd1382aae0aed7c8b266d5088a5308a26 ]

The hibernation mode of AR8031 PHY defaults to be enabled after hardware
reset. When the cable is unplugged, the PHY will enter hibernation mode
after about 10 senconds and the PHY clocks will be stopped to save
power. However, due to the design of EQOS, the mac needs the RX_CLK of
PHY for software reset to complete. Otherwise the software reset of EQOS
will be failed and do not work correctly. The only way is to disable
hibernation mode of AR8031 PHY for EQOS, the "qca,disable-hibernation-mode"
property is used for this purpose and has already been submitted to the
upstream, for more details please refer to the below link:
https://lore.kernel.org/netdev/20220818030054.1010660-2-wei.fang@nxp.com/

This issue is easy to reproduce, just unplug the cable and "ifconfig eth0
down", after about 10 senconds, then "ifconfig eth0 up", you will see
failure log on the serial port. The log is shown as following:
root@imx8dxlevk:~#
[34.941970] imx-dwmac 5b050000.ethernet eth0: Link is Down
root@imx8dxlevk:~# ifconfig eth0 down
[35.437814] imx-dwmac 5b050000.ethernet eth0: FPE workqueue stop
[35.507913] imx-dwmac 5b050000.ethernet eth0: PHY [stmmac-1:00] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
[35.518613] imx-dwmac 5b050000.ethernet eth0: configuring for phy/rgmii-id link mode
root@imx8dxlevk:~# ifconfig eth0 up
[71.143044] imx-dwmac 5b050000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[71.215855] imx-dwmac 5b050000.ethernet eth0: PHY [stmmac-1:00] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
[72.230417] imx-dwmac 5b050000.ethernet: Failed to reset the dma
[72.236512] imx-dwmac 5b050000.ethernet eth0: stmmac_hw_setup: DMA engine initialization failed
[72.245258] imx-dwmac 5b050000.ethernet eth0: __stmmac_open: Hw setup failed
SIOCSIFFLAGS: Connection timed out

After applying this patch, the software reset of EQOS will be
successful. And the log is shown as below.
root@imx8dxlevk:~# ifconfig eth0 up
[96.114344] imx-dwmac 5b050000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[96.171466] imx-dwmac 5b050000.ethernet eth0: PHY [stmmac-1:00] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
[96.188883] imx-dwmac 5b050000.ethernet eth0: No Safety Features support found
[96.196221] imx-dwmac 5b050000.ethernet eth0: IEEE 1588-2008 Advanced Timestamp supported
[96.204846] imx-dwmac 5b050000.ethernet eth0: registered PTP clock
[96.225558] imx-dwmac 5b050000.ethernet eth0: FPE workqueue start
[96.236858] imx-dwmac 5b050000.ethernet eth0: configuring for phy/rgmii-id link mode
[96.249358] 8021q: adding VLAN 0 to HW filter on device eth0

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: feafeb53140a ("arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index 280a9c9d8bd98..1bcf228a22b8b 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -135,6 +135,7 @@ ethphy0: ethernet-phy@0 {
 			reg = <0>;
 			eee-broken-1000t;
 			qca,disable-smarteee;
+			qca,disable-hibernation-mode;
 			vddio-supply = <&vddio0>;
 
 			vddio0: vddio-regulator {
-- 
2.39.2



