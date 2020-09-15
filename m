Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECE626B6D0
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgIPAMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358F52245D;
        Tue, 15 Sep 2020 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179567;
        bh=TMdG5HmMwVupIufEfyCI7/i+7smjIp9+JuwevDTLexA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFqob0ytXPt9/iV4p+xOLe7lrnGgxXvCaOb40ySZ7aQ/53DSUAiRDjvtKMIyptKZ5
         RBQSLXXrxEiiwReubl0I0Ue7Z+ttmPxOB9OLjk2x6b9SsklsWhqC4SksGnDlhur5nW
         JaajU6ecmceqMKzGKE0bUkSlhMkEZqxHrPPy8atw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/132] ARM: dts: ls1021a: fix QuadSPI-memory reg range
Date:   Tue, 15 Sep 2020 16:11:50 +0200
Message-Id: <20200915140644.489818597@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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
index 5a8e58b663420..c62fcca7b4263 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -181,7 +181,7 @@
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



