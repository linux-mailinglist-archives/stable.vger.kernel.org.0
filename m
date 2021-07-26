Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE13D5E20
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbhGZPFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236106AbhGZPFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F88460F38;
        Mon, 26 Jul 2021 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314350;
        bh=VutoOwHTv5LZaekxAGkf+s/P02190QD1UY/iea5cRWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSiZZUwOGVh5RWmUARbYRfuYjyeUgnZ/vHsHj43AfvCVt6LkBI40e+tQ8KpbVkglL
         /4OzFdNq54dxVlfAj87bXIQncJharE1pyIWEVQKv0Cn07t7DKnV+tJ82tpGVsdVwok
         qupiCHfeWFI0TJl9WQKsPY7zmUkr56RKlc8JgqTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/82] arm64: dts: ls208xa: remove bus-num from dspi node
Date:   Mon, 26 Jul 2021 17:38:16 +0200
Message-Id: <20210726153828.686912073@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index 4fb9a0966a84..4b459167a746 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -515,7 +515,6 @@
 			clocks = <&clockgen 4 3>;
 			clock-names = "dspi";
 			spi-num-chipselects = <5>;
-			bus-num = <0>;
 		};
 
 		esdhc: esdhc@2140000 {
-- 
2.30.2



