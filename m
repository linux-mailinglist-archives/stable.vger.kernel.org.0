Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DDE3CE3B4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhGSPkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349034AbhGSPfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9373B61287;
        Mon, 19 Jul 2021 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711362;
        bh=gOWZPvUwpqkulmVjVCCAwQS+gJTvdhBIbHnGweJFv1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oqz/FJ4/GtT9wwRamOm8A/1Ykg0HK72A3DVZMcHiYDf5eK49VD4n6prXCGiTVq73G
         QrGokrV3RY7YwQlL/T/FIoxx4xfG2ZxzU9lJR2K384yhwxSFrjxrFNLO/Cs7pk2e0r
         lWRvHdL8IgFEWHPlRCTfTmDkHZa9sP0zSm4uWNho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 326/351] arm64: dts: ti: k3-am642-main: fix ports mac properties
Date:   Mon, 19 Jul 2021 16:54:32 +0200
Message-Id: <20210719144955.843945988@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 50c9bfca1bfe9ffd56d8c5deecf9204d14e20bfd ]

The current device tree CPSW3g node adds non-zero "mac-address" property to
the ports, which prevents random MAC address assignment to network devices
if bootloader failed to update DT. This may cause more then one host to
have the same MAC in the network.

 mac-address = [00 00 de ad be ef];
 mac-address = [00 01 de ad be ef];

In addition, there is one MAC address available in eFuse registers which
can be used for default port 1.

Hence, fix ports MAC properties by:
- resetting "mac-address" property to 0
- adding ti,syscon-efuse = <&main_conf 0x200> to Port 1

Fixes: 3753b12877b6 ("arm64: dts: ti: k3-am64-main: Add CPSW DT node")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210608184940.25934-1-grygorii.strashko@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index ca59d1f711f8..bcbf436a96b5 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -489,7 +489,8 @@
 				ti,mac-only;
 				label = "port1";
 				phys = <&phy_gmii_sel 1>;
-				mac-address = [00 00 de ad be ef];
+				mac-address = [00 00 00 00 00 00];
+				ti,syscon-efuse = <&main_conf 0x200>;
 			};
 
 			cpsw_port2: port@2 {
@@ -497,7 +498,7 @@
 				ti,mac-only;
 				label = "port2";
 				phys = <&phy_gmii_sel 2>;
-				mac-address = [00 01 de ad be ef];
+				mac-address = [00 00 00 00 00 00];
 			};
 		};
 
-- 
2.30.2



