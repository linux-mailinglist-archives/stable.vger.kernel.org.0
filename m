Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444F01671A5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgBUHz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730396AbgBUHz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:55:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7158C2073A;
        Fri, 21 Feb 2020 07:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271755;
        bh=PDMV9NL7oAVwioQiltJHDGJGsryMCmbpfpVrnmp6Hao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRhitN/uvFXRQHHhQ0XY9P9HAV7EjmFwQLNFz0KGo1qCoPSU/MTIV5mTgBhCK1MUs
         5LFWqbtsoiTDdmfAjC3G5oTRzjzZD13UQ1Tgvl3/RsQC3PKIph2JvMF84x5dDEw44N
         MNExgiIIT3P3UKk5ni04hF81DJoh+iLuzzVVaPUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 287/399] arm64: dts: ti: k3-j721e-main: Add missing power-domains for smmu
Date:   Fri, 21 Feb 2020 08:40:12 +0100
Message-Id: <20200221072429.751482870@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lokesh Vutla <lokeshvutla@ti.com>

[ Upstream commit 3f03a58b25753843ce9e4511e9e246c51bd11011 ]

Add power-domains entry for smmu, so that the it is accessible as long
as the driver is active. Without this device shutdown is throwing the
below warning:
"[   44.736348] arm-smmu-v3 36600000.smmu: failed to clear cr0"

Reported-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 1e4c2b78d66d6..68d478af7a3e6 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -43,6 +43,7 @@
 	smmu0: smmu@36600000 {
 		compatible = "arm,smmu-v3";
 		reg = <0x0 0x36600000 0x0 0x100000>;
+		power-domains = <&k3_pds 229 TI_SCI_PD_EXCLUSIVE>;
 		interrupt-parent = <&gic500>;
 		interrupts = <GIC_SPI 772 IRQ_TYPE_EDGE_RISING>,
 			     <GIC_SPI 768 IRQ_TYPE_EDGE_RISING>;
-- 
2.20.1



