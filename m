Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4916E186239
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgCPCfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgCPCfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:35:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA5A20726;
        Mon, 16 Mar 2020 02:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326142;
        bh=Dxdis/KJKogw06PdKI7YE6I+j6JbrgSMNU1dghE2T48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUhpqMXk0g2J7ZqzjxQOdNv2M1uvA1bqc16qdqVhz5g79BoYa0XKrHTV71DjkmzuP
         vn/PiQcev/p2bV9e3m9AJk0a04ayVJymLORnzk2fvKaX5q5zFme7AHaOTnF9rwU4gN
         8azATqxQVVfIKZEN/JPKMIrWi8YvvAKBR9F/L1G8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/7] ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes
Date:   Sun, 15 Mar 2020 22:35:34 -0400
Message-Id: <20200316023538.2232-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023538.2232-1-sashal@kernel.org>
References: <20200316023538.2232-1-sashal@kernel.org>
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
index a1a928064b53d..f94064c687789 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -282,6 +282,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
@@ -319,6 +320,7 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x30013000 0x13000 0 0xffed000>;
+				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
-- 
2.20.1

