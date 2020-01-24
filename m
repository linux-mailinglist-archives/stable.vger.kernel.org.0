Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08B1481FE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391410AbgAXLYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391419AbgAXLYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:24:22 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A51320704;
        Fri, 24 Jan 2020 11:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865061;
        bh=fNwLqIQXWpTRM0BWiYhC2Sv//o860N/+wIiIwGXNRgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=116s54mL4BzJ0mj+Fgbta7sNaFeZ0sRW4A+qYRoLtoXSyHFnEnkJZ1zEipqFvDWxB
         wHrswFQnzM28V+KXlaVmMLZ9cDjxyepZu0yGC6p7yNqPe3aKUXI02CrhoMEr6QWgUG
         apRo9c2lq2tUyesn/Un7iXjsxcCh5NVIglJ2BFvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 442/639] ARM: dts: iwg20d-q7-common: Fix SDHI1 VccQ regularor
Date:   Fri, 24 Jan 2020 10:30:12 +0100
Message-Id: <20200124093142.426801281@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

[ Upstream commit d211650a87edc7f4130651c0ccbc0a4583fd72d3 ]

SDR50 isn't working anymore because the GPIO regulator
driver is using descriptors since
commit d6cd33ad7102 ("regulator: gpio: Convert to use descriptors")
which in turn causes the system to use the polarity of the
GPIOs (as specified in the DT) for selecting the states,
but the polarity specified in the DT is wrong.
This patch fixes the regulator DT definition, and that fixes
SDR50.

Fixes: 029efb3a03c5 ("ARM: dts: iwg20d-q7: Add SDHI1 support")
Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/iwg20d-q7-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/iwg20d-q7-common.dtsi b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
index 5cae74eb6cddf..a2c9a1e88c1a3 100644
--- a/arch/arm/boot/dts/iwg20d-q7-common.dtsi
+++ b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
@@ -87,7 +87,7 @@
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpios = <&gpio2 30 GPIO_ACTIVE_LOW>;
+		gpios = <&gpio2 30 GPIO_ACTIVE_HIGH>;
 		gpios-states = <1>;
 		states = <3300000 1
 			  1800000 0>;
-- 
2.20.1



