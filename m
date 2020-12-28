Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F002E3FA4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506305AbgL1OmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502456AbgL1O1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D73CB207B2;
        Mon, 28 Dec 2020 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165650;
        bh=Z0h+6bmR7wNimKkpK7ZfJsCK9K1YgiLPBioUdJ2aJFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtulNGZYR1irNX4mwg06A047Dk1Zk+cUWVijh/sK6PXlYdPGk6XHOlZ3X8+yHdP2W
         UEE88DwqtBsctqslFqSyE31WwV4sGTI8M9o4Yqds5SfNbFbi0ewyb+/s8d4LYUzhB8
         e46h9cp06sDl7nwDjWVPa4EdovrCi1xF6sag+j6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 605/717] ARM: tegra: Populate OPP table for Tegra20 Ventana
Date:   Mon, 28 Dec 2020 13:50:03 +0100
Message-Id: <20201228125049.895071844@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

commit bd7cd7e05a42491469ca19861da44abc3168cf5f upstream.

Commit 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver
(Tegra30 supported now)") update the Tegra20 CPUFREQ driver to use the
generic CPUFREQ device-tree driver. Since this change CPUFREQ support
on the Tegra20 Ventana platform has been broken because the necessary
device-tree nodes with the operating point information are not populated
for this platform. Fix this by updating device-tree for Venata to
include the operating point informration for Tegra20.

Fixes: 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver (Tegra30 supported now)")
Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/tegra20-ventana.dts |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -3,6 +3,7 @@
 
 #include <dt-bindings/input/input.h>
 #include "tegra20.dtsi"
+#include "tegra20-cpu-opp.dtsi"
 
 / {
 	model = "NVIDIA Tegra20 Ventana evaluation board";
@@ -592,6 +593,16 @@
 		#clock-cells = <0>;
 	};
 
+	cpus {
+		cpu0: cpu@0 {
+			operating-points-v2 = <&cpu0_opp_table>;
+		};
+
+		cpu@1 {
+			operating-points-v2 = <&cpu0_opp_table>;
+		};
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 


