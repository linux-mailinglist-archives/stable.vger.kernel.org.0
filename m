Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327064062C2
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhIJAqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234012AbhIJAWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D316023D;
        Fri, 10 Sep 2021 00:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233271;
        bh=VLjAvUgxy44qM8GoKgrF9Lm6uZ0W/hWCW00zYMDFXNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnFdmZrtiPBHj+w8S6C0/bem/3eFt6gN/m+J7WxqXUPGCD8Tb3uCrSSR9S9o3+9ne
         hsPCuG+j02btrR9prdJ9H0KDe1t4w6vEFVjOGhT1jDM47xWgTDGSokNbxupQBNBnNx
         /RqVIVlPwqnxJUsEmClZQKHieiESptmVIGM0uT6gQ2duXR9zei9Lq3Atm3GlbbecPF
         vtBSUWD2CCA9Hfk5QrbwIBhWRYQaG2+wMTs8bqpyUwfvEl1ZdL1a9fD5dd8HeWS6o7
         SAxVntnqWl3rrU80kQlv+nuXxiuoFL0RVhHoPA4FjGpQE0nOYoGiUrKBW/t+xd5zXf
         JueoIGDYoxB+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 31/53] MIPS: mscc: ocelot: mark the phy-mode for internal PHY ports
Date:   Thu,  9 Sep 2021 20:20:06 -0400
Message-Id: <20210910002028.175174-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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

