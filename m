Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869CC76AC6
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfGZNjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbfGZNjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C86F22BEF;
        Fri, 26 Jul 2019 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148386;
        bh=eemSfMtBsnGD9SpL7qlKq+QFqILAbZoChgumTr5OSfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dFcQ33m1bL+ukdl9LHgVfImbmpcMb6gAPxyANX8F+uriZMmB+tYY498HzOcsxiKz
         vURuCLY/rXhEqN6OAx3KFpt9Id04dnQUBAd0Cnc4UEPQGlAfbQufFUgK2LvYHxUsBw
         6YtgldWDAjBk8AePyh2BMyHDXkuZGgimOAccbmzM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 09/85] arm64: dts: marvell: mcbin: enlarge PCI memory window
Date:   Fri, 26 Jul 2019 09:38:19 -0400
Message-Id: <20190726133936.11177-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

[ Upstream commit d3446b266a8c72a7bbc94b65f5fc6d206be77d24 ]

Running a graphics adapter on the MACCHIATObin fails due to an
insufficiently sized memory window.

Enlarge the memory window for the PCIe slot to 512 MiB.

With the patch I am able to use a GT710 graphics adapter with 1 GB onboard
memory.

These are the mapped memory areas that the graphics adapter is actually
using:

Region 0: Memory at cc000000 (32-bit, non-prefetchable) [size=16M]
Region 1: Memory at c0000000 (64-bit, prefetchable) [size=128M]
Region 3: Memory at c8000000 (64-bit, prefetchable) [size=32M]
Region 5: I/O ports at 1000 [size=128]
Expansion ROM at ca000000 [disabled] [size=512K]

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
index 329f8ceeebea..205071b45a32 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
@@ -184,6 +184,8 @@
 	num-lanes = <4>;
 	num-viewport = <8>;
 	reset-gpios = <&cp0_gpio2 20 GPIO_ACTIVE_LOW>;
+	ranges = <0x81000000 0x0 0xf9010000 0x0 0xf9010000 0x0 0x10000
+		  0x82000000 0x0 0xc0000000 0x0 0xc0000000 0x0 0x20000000>;
 	status = "okay";
 };
 
-- 
2.20.1

