Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CC23D29FA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhGVQHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234724AbhGVQGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5DE61DBB;
        Thu, 22 Jul 2021 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972433;
        bh=b33whv90cBXAjsxVWLqFdVGyqSkVfOU3IOL43OTqb/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrA7VMahtEjc4nDHWQbis31e+Ql1SxA7TjlsKWNmoB/AP9PtxQ/0sa+pK/Kw92zJZ
         gCcELaxWQoxeL+YfVwpHxEKh5rvpt+PeLD66zuF1oBPRw6lGTp2sfSB20cKHCOoQ7e
         nCZIxooxZdo7aqjdXwR5jzKT31K0WZ2N1rYW15YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 078/156] arm64: dts: ls208xa: remove bus-num from dspi node
Date:   Thu, 22 Jul 2021 18:30:53 +0200
Message-Id: <20210722155630.917011166@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit 8240c972c1798ea013cbb407722295fc826b3584 ]

On LS2088A-RDB board, if the spi-fsl-dspi driver is built as module
then its probe fails with the following warning:

[   10.471363] couldn't get idr
[   10.471381] WARNING: CPU: 4 PID: 488 at drivers/spi/spi.c:2689 spi_register_controller+0x73c/0x8d0
...
[   10.471651] fsl-dspi 2100000.spi: Problem registering DSPI ctlr
[   10.471708] fsl-dspi: probe of 2100000.spi failed with error -16

Reason for the failure is that bus-num property is set for dspi node.
However, bus-num property is not set for the qspi node. If probe for
spi-fsl-qspi happens first then id 0 is dynamically allocated to it.
Call to spi_register_controller() from spi-fsl-dspi driver then fails.
Since commit 29d2daf2c33c ("spi: spi-fsl-dspi: Make bus-num property
optional") bus-num property is optional. Remove bus-num property from
dspi node to fix the issue.

Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 135ac8210871..801ba9612d36 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -929,7 +929,6 @@
 					    QORIQ_CLK_PLL_DIV(4)>;
 			clock-names = "dspi";
 			spi-num-chipselects = <5>;
-			bus-num = <0>;
 		};
 
 		esdhc: esdhc@2140000 {
-- 
2.30.2



