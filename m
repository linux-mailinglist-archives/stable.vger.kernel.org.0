Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C67F3C8F92
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbhGNTww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240183AbhGNTte (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 650E461428;
        Wed, 14 Jul 2021 19:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291887;
        bh=7CRownILOEHraGQb/+o7G60263aYdP+BP0g8NUMrV/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuAZ5W8aqlYIlzpBum0jSoZ2g4fqx2Jh9Qd3G3Oz33inR2WCZko5B4slpsJrnEeWA
         ZtspyKWClVIE7Zw/3IYi8XJdAfWS/BemjLE3f2KboDFZE8IriLYo2Smmld6grxRrZh
         jtN8w147b/O2BeqEsxplJ18kq1of18oKfARwpVaqAi1g4VnvwmGlfWyaM5Xlhz8Aic
         9VoTmTISkTDFxUV6HgAtT9ofMan82uJ3gjlwjOoC6AX7D6e0ctSNXEs44CWUPVcbjp
         u8yZxDkFnKKDL0yN3/scQ3jy1RGoKZh9m7da2pWkQ3FtG4HIqviFM8+XRsSSGFekyN
         uE0hs0JMbJ+/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mian Yousaf Kaukab <ykaukab@suse.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 69/88] arm64: dts: ls208xa: remove bus-num from dspi node
Date:   Wed, 14 Jul 2021 15:42:44 -0400
Message-Id: <20210714194303.54028-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e7abb74bd816..4d34d82b898a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -625,7 +625,6 @@ dspi: spi@2100000 {
 			clocks = <&clockgen 4 3>;
 			clock-names = "dspi";
 			spi-num-chipselects = <5>;
-			bus-num = <0>;
 		};
 
 		esdhc: esdhc@2140000 {
-- 
2.30.2

