Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9BB406223
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhIJAow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhIJAUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F37EE610E9;
        Fri, 10 Sep 2021 00:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233174;
        bh=VLjAvUgxy44qM8GoKgrF9Lm6uZ0W/hWCW00zYMDFXNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQC6xGVcbB5mcfgi3IlXTk34DLVLCkvQeI4yY0df4X7Z2WdTKYV7B1FKKL9ARJndA
         OyniLmzRCoRHv3A7hBqNJF2PqqE1BlELAPknT1nao0jb6SHygqCD1e0uQLC+pGQ485
         7xw905WXPBE2Jjy1Y0fZ804LKOZDV+xYgtObNBflwKPK8lmkVVMihFjM9YIiRcq0A+
         INRHPIbmJUdwSk8l3auOMkWxUT7UEo9R7D5Pf9kqXxEZcpWacf2rrzmTpsLZlzGSon
         FS/EOBQJkHzPqJ4ORzS+27McFB2ZVdYgq+vtRG383iFAfvFG6ZCjHQ5CImkYWIU4tH
         aCXfeiy5MgQZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 52/88] MIPS: mscc: ocelot: mark the phy-mode for internal PHY ports
Date:   Thu,  9 Sep 2021 20:17:44 -0400
Message-Id: <20210910001820.174272-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit eba54cbb92d28b4f6dc1ed5f73f5187b09d82c08 ]

The ocelot driver was converted to phylink, and that expects a valid
phy_interface_t. Without a phy-mode, of_get_phy_mode returns
PHY_INTERFACE_MODE_NA, which is not ideal because phylink rejects that.

The ocelot driver was patched to treat PHY_INTERFACE_MODE_NA as
PHY_INTERFACE_MODE_INTERNAL to work with the broken DT blobs, but we
should fix the device trees and specify the phy-mode too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/mscc/ocelot_pcb120.dts | 4 ++++
 arch/mips/boot/dts/mscc/ocelot_pcb123.dts | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
index d2dc6b3d923c..bd240690cb37 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
@@ -71,21 +71,25 @@ phy4: ethernet-phy@3 {
 &port0 {
 	status = "okay";
 	phy-handle = <&phy0>;
+	phy-mode = "internal";
 };
 
 &port1 {
 	status = "okay";
 	phy-handle = <&phy1>;
+	phy-mode = "internal";
 };
 
 &port2 {
 	status = "okay";
 	phy-handle = <&phy2>;
+	phy-mode = "internal";
 };
 
 &port3 {
 	status = "okay";
 	phy-handle = <&phy3>;
+	phy-mode = "internal";
 };
 
 &port4 {
diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
index 7d7e638791dd..0185045c7630 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
@@ -49,19 +49,23 @@ &mdio0 {
 &port0 {
 	status = "okay";
 	phy-handle = <&phy0>;
+	phy-mode = "internal";
 };
 
 &port1 {
 	status = "okay";
 	phy-handle = <&phy1>;
+	phy-mode = "internal";
 };
 
 &port2 {
 	status = "okay";
 	phy-handle = <&phy2>;
+	phy-mode = "internal";
 };
 
 &port3 {
 	status = "okay";
 	phy-handle = <&phy3>;
+	phy-mode = "internal";
 };
-- 
2.30.2

