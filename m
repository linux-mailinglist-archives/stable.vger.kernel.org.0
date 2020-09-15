Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D13D26B564
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgIOXnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93ECD2220B;
        Tue, 15 Sep 2020 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179364;
        bh=x76QfqFMZg95e1IvXhNz9c04gVwR6koHhP7rr85Thpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jwxk3gb8hL6XVfirNoIAsedvRhnl3JLrwfHejihaDJ+cBhBqb9OfjGm8sV3mDUG/+
         fdCYGlfFas2SEUvwL4rHjM3tqodEJP6Z2MyE0/4Jx0nnuypATI1ui7iIjY1jsG/A7P
         C3tj5SOeBimey/oGLrhacBD2UqXQJFRFSyzNtV9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/78] ARM: dts: ls1021a: fix QuadSPI-memory reg range
Date:   Tue, 15 Sep 2020 16:12:29 +0200
Message-Id: <20200915140633.753221988@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 81dbbb417da4d1ac407dca5b434d39d5b6b91ef3 ]

According to the Reference Manual, the correct size is 512 MiB.

Without this fix, probing the QSPI fails:

    fsl-quadspi 1550000.spi: ioremap failed for resource
        [mem 0x40000000-0x7fffffff]
    fsl-quadspi 1550000.spi: Freescale QuadSPI probe failed
    fsl-quadspi: probe of 1550000.spi failed with error -12

Fixes: 85f8ee78ab72 ("ARM: dts: ls1021a: Add support for QSPI with ls1021a SoC")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ls1021a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index d18c043264440..b66b2bd1aa856 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -168,7 +168,7 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0x0 0x1550000 0x0 0x10000>,
-			      <0x0 0x40000000 0x0 0x40000000>;
+			      <0x0 0x40000000 0x0 0x20000000>;
 			reg-names = "QuadSPI", "QuadSPI-memory";
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 			clock-names = "qspi_en", "qspi";
-- 
2.25.1



