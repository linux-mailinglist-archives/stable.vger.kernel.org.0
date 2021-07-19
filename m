Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71983CE283
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347807AbhGSPao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348019AbhGSPYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B33A6113E;
        Mon, 19 Jul 2021 16:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710435;
        bh=cRYCjUdDlhOq4YgUVWWEjwCkCoRdUvLBX1KFsmpGVtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScboHwpNehzaNaz4nt5hb0PIKXbZyOzsEAXaWk8NSuUkSOGzzYSeyAfKQghzNP/vD
         PsIDT2p6nbHtv7ZDJzuHoi91AiboX+Po4QAqMTFdN9+MsG/hXGxnpJHeENtFy2gOK5
         yZPg0QJ9i2fDHQsrz/XdUX5LIqtGl+kJp8E9Ben4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/243] arm64: dts: renesas: r8a779a0: Drop power-domains property from GIC node
Date:   Mon, 19 Jul 2021 16:54:03 +0200
Message-Id: <20210719144947.829704160@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 86ec32a919d2..bfbb53bf5375 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -111,7 +111,6 @@
 			      <0x0 0xf1060000 0 0x110000>;
 			interrupts = <GIC_PPI 9
 				      (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_HIGH)>;
-			power-domains = <&sysc R8A779A0_PD_ALWAYS_ON>;
 		};
 
 		prr: chipid@fff00044 {
-- 
2.30.2



