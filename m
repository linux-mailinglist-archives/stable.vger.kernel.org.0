Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DB6150C46
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbgBCQes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730853AbgBCQer (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:47 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B87C20CC7;
        Mon,  3 Feb 2020 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747686;
        bh=+5JA2poJMjR7STyvd8Wt5wYwpE8j6WD4wo/41oMHMv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E27yGvk+Tb5OtpA9V5MYo4z1BdzHFFugjHOiHxv757oeSYg0ZFUesHt4dp7glYwIA
         UAFSZaun6jNHMco9BaG82bDqMwDbRZuCMuNUmDj1qDARQK77vAr3K0Qhx/M8SqoF9k
         6MhdZHwcrKtlKJILiHkH45iPOtBzR0qwcKKu7DOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/90] ARM: dts: beagle-x15-common: Model 5V0 regulator
Date:   Mon,  3 Feb 2020 16:19:31 +0000
Message-Id: <20200203161921.342861160@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit e17e7c498d4f734df93c300441e100818ed58168 ]

On am57xx-beagle-x15, 5V0 is connected to P16, P17, P18 and P19
connectors. On am57xx-evm, 5V0 regulator is used to get 3V6 regulator
which is connected to the COMQ port. Model 5V0 regulator here in order
for it to be used in am57xx-evm to model 3V6 regulator.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/am57xx-beagle-x15-common.dtsi    | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
index 9a94c96b0350e..a813a0cf3ff39 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
@@ -29,6 +29,27 @@
 		reg = <0x0 0x80000000 0x0 0x80000000>;
 	};
 
+	main_12v0: fixedregulator-main_12v0 {
+		/* main supply */
+		compatible = "regulator-fixed";
+		regulator-name = "main_12v0";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
+
+	evm_5v0: fixedregulator-evm_5v0 {
+		/* Output of TPS54531D */
+		compatible = "regulator-fixed";
+		regulator-name = "evm_5v0";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		vin-supply = <&main_12v0>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
+
 	vdd_3v3: fixedregulator-vdd_3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd_3v3";
-- 
2.20.1



