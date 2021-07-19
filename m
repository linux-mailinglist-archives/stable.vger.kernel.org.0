Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80563CE382
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346584AbhGSPi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348953AbhGSPfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62BD961363;
        Mon, 19 Jul 2021 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711340;
        bh=nQeAaTWWY4/VN7Kg6FQONv+WkXezfjMBgP7RZVW+Rl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8YX1VDU5vqNSsOcYf6DPoloK+Z9FEhwWZ2wkACF3oOSULAyiN1Q+Yx0hmd5BiT5Y
         RI51E6nhngzFmaPCLILEa50QWXgap04BMjZmFAA92fZHodqpfh0JdOf3UmdbVZ99Cg
         lpCq3dq+bzcJgwBpm9brSyMA4ZtegPKFxgXGhcNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 310/351] arm64: dts: renesas: r8a779a0: Drop power-domains property from GIC node
Date:   Mon, 19 Jul 2021 16:54:16 +0200
Message-Id: <20210719144955.304869832@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1771a33b34421050c7b830f0a8af703178ba9d36 ]

"make dtbs_check":

    arm64/boot/dts/renesas/r8a779a0-falcon.dt.yaml: interrupt-controller@f1000000: 'power-domains' does not match any of the regexes: '^(msi-controller|gic-its|interrupt-controller)@[0-9a-f]+$', '^gic-its@', '^interrupt-controller@[0-9a-f]+$', 'pinctrl-[0-9]+'
	    From schema: Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml

Remove the "power-domains" property, as the GIC on R-Car V3U is
always-on, and not part of a clock domain.

Fixes: 834c310f541839b6 ("arm64: dts: renesas: Add Renesas R8A779A0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/a9ae5cbc7c586bf2c6b18ddc665ad7051bd1d206.1622560236.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
index 70b3604e56cd..9a7d1aca4998 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -1096,7 +1096,6 @@
 			      <0x0 0xf1060000 0 0x110000>;
 			interrupts = <GIC_PPI 9
 				      (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_HIGH)>;
-			power-domains = <&sysc R8A779A0_PD_ALWAYS_ON>;
 		};
 
 		fcpvd0: fcp@fea10000 {
-- 
2.30.2



