Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F35B5758A
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF0Aa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF0Aa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:30:26 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CAE2083B;
        Thu, 27 Jun 2019 00:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595426;
        bh=jJl5kpA+E32dBal3DNwg0dA7AW6IVwSm/fbfo6drkYw=;
        h=From:To:Cc:Subject:Date:From;
        b=d5IdQFqP2sUpqxxv28WzsyYTCaHZcFTQ3srQ7jjMmSu2EbFNRELYaBglP6P1Js++4
         /nma/Rgo1A43IGZASrqbJSt+fPsoPmTi35/Z19UGKpmO1fbs4k8qavlLe3c0lcNvZl
         OyApoPB4KmySijwQZRS41wbIMq0qHHCKiWhk8xx8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keerthy <j-keerthy@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 01/95] ARM: dts: dra76x: Disable rtc target module
Date:   Wed, 26 Jun 2019 20:28:46 -0400
Message-Id: <20190627003021.19867-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

[ Upstream commit f7b9cb944a5d41fdede4e928a47e9d5fce5169d7 ]

rtc is fused out on dra76 and accessing target module
register is causing a boot crash hence disable it.

Fixes: 549fce068a3112 ("ARM: dts: dra7: Add l4 interconnect hierarchy and ti-sysc data")
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-l4.dtsi | 2 +-
 arch/arm/boot/dts/dra76x.dtsi  | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 414f1cd68733..73f5c050f586 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3543,7 +3543,7 @@
 			};
 		};
 
-		target-module@38000 {			/* 0x48838000, ap 29 12.0 */
+		rtctarget: target-module@38000 {			/* 0x48838000, ap 29 12.0 */
 			compatible = "ti,sysc-omap4-simple", "ti,sysc";
 			ti,hwmods = "rtcss";
 			reg = <0x38074 0x4>,
diff --git a/arch/arm/boot/dts/dra76x.dtsi b/arch/arm/boot/dts/dra76x.dtsi
index 9ee45aa365d8..5c437271d307 100644
--- a/arch/arm/boot/dts/dra76x.dtsi
+++ b/arch/arm/boot/dts/dra76x.dtsi
@@ -81,3 +81,7 @@
 		reg = <0x3fc>;
 	};
 };
+
+&rtctarget {
+	status = "disabled";
+};
-- 
2.20.1

