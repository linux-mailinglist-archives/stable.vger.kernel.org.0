Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545AE186305
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgCPCj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729849AbgCPCe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38A1206EB;
        Mon, 16 Mar 2020 02:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326066;
        bh=Yif/MN9EuU1cH8MxcNoZmPCJ/pA6Q1Lff4fYJ2Nk1PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxtak+0n2aLcbxqhEQqdlsyqoRB9SXrGpv18tGW0myJdYC/sPP4UVksY1AXPVzPur
         UfN2nMMh5nSpRwEkUETFMfBulxWy7Qb/Xn6vMOSW9LXulVCuTXWgXS8K0ZkxiXVtCt
         5vKaZelV9DldzcbSbpd+ViMTeGPwj1lIkzi3UzFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/35] ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes
Date:   Sun, 15 Mar 2020 22:33:49 -0400
Message-Id: <20200316023411.1263-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 27f13774654ea6bd0b6fc9b97cce8d19e5735661 ]

'dma-ranges' in a PCI bridge node does correctly set dma masks for PCI
devices not described in the DT. Certain DRA7 platforms (e.g., DRA76)
has RAM above 32-bit boundary (accessible with LPAE config) though the
PCIe bridge will be able to access only 32-bits. Add 'dma-ranges'
property in PCIe RC DT nodes to indicate the host bridge can access
only 32 bits.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 953f0ffce2a90..6481d2b7d6b6f 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -184,6 +184,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
@@ -238,6 +239,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x30013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
-- 
2.20.1

