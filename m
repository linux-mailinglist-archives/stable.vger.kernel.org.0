Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DC52E3E61
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502244AbgL1O1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502225AbgL1O1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE83F22B2E;
        Mon, 28 Dec 2020 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165622;
        bh=/wY3/37D7ZQyGMdrybsJuDdFPlJTJU1cdaim5Hjs0GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7muLXvsJ8nCLRMDmRzB+iZZDumLULHVKxZ1TDvOcW0XL98ue4wqFqDcTnA0e8MGU
         x932jez7gXhHV1KFl07zmPnxXkV+DvzV/adNOg9bAzz48gK1j9KnxkSkVCGIacZkEb
         8T76USYv8HpwPMVsKTEfKtkvh/BrAhd+KRuuONic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.10 596/717] arm64: dts: marvell: keep SMMU disabled by default for Armada 7040 and 8040
Date:   Mon, 28 Dec 2020 13:49:54 +0100
Message-Id: <20201228125049.467143019@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Nowicki <tn@semihalf.com>

commit f43cadef2df260101497a6aace05e24201f00202 upstream.

FW has to configure devices' StreamIDs so that SMMU is able to lookup
context and do proper translation later on. For Armada 7040 & 8040 and
publicly available FW, most of the devices are configured properly,
but some like ap_sdhci0, PCIe, NIC still remain unassigned which
results in SMMU faults about unmatched StreamID (assuming
ARM_SMMU_DISABLE_BYPASS_BY_DEFAUL=y).

Since there is dependency on custom FW let SMMU be disabled by default.
People who still willing to use SMMU need to enable manually and
use ARM_SMMU_DISABLE_BYPASS_BY_DEFAUL=n (or via kernel command line)
with extra caution.

Fixes: 83a3545d9c37 ("arm64: dts: marvell: add SMMU support")
Cc: <stable@vger.kernel.org> # 5.9+
Signed-off-by: Tomasz Nowicki <tn@semihalf.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-7040.dtsi |    4 ----
 arch/arm64/boot/dts/marvell/armada-8040.dtsi |    4 ----
 2 files changed, 8 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-7040.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-7040.dtsi
@@ -15,10 +15,6 @@
 		     "marvell,armada-ap806";
 };
 
-&smmu {
-	status = "okay";
-};
-
 &cp0_pcie0 {
 	iommu-map =
 		<0x0   &smmu 0x480 0x20>,
--- a/arch/arm64/boot/dts/marvell/armada-8040.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-8040.dtsi
@@ -15,10 +15,6 @@
 		     "marvell,armada-ap806";
 };
 
-&smmu {
-	status = "okay";
-};
-
 &cp0_pcie0 {
 	iommu-map =
 		<0x0   &smmu 0x480 0x20>,


