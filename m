Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A951486D8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391163AbgAXOSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403796AbgAXOSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F702467F;
        Fri, 24 Jan 2020 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875534;
        bh=DQJTMTJ1h1GWsR0/XHAdmkje0pVuVeFEUGMSPLzpH3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfNjrm44AgHK1KpHY2ZIn6twjeT8/SUp2T1JFXIWfr9oRwXIyFbHqgvmmvA0JxJE4
         aj0AqwewlUfVupa3UJXxFEI/ol3kQ9MBKVxsSKZBvqyjs9ZmySFU0bwsIE6Q8AxGZD
         tNILNTD0cN3rjjkzct0EfeqJfzJgWIKZFXwfIYfc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 031/107] ARM: dts: imx6qdl-sabresd: Remove incorrect power supply assignment
Date:   Fri, 24 Jan 2020 09:17:01 -0500
Message-Id: <20200124141817.28793-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 4521de30fbb3f5be0db58de93582ebce72c9d44f ]

The vdd3p0 LDO's input should be from external USB VBUS directly, NOT
PMIC's power supply, the vdd3p0 LDO's target output voltage can be
controlled by SW, and it requires input voltage to be high enough, with
incorrect power supply assigned, if the power supply's voltage is lower
than the LDO target output voltage, it will return fail and skip the LDO
voltage adjustment, so remove the power supply assignment for vdd3p0 to
avoid such scenario.

Fixes: 93385546ba36 ("ARM: dts: imx6qdl-sabresd: Assign corresponding power supply for LDOs")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index 71ca76a5e4a51..fe59dde41b649 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -749,10 +749,6 @@
 	vin-supply = <&vgen5_reg>;
 };
 
-&reg_vdd3p0 {
-	vin-supply = <&sw2_reg>;
-};
-
 &reg_vdd2p5 {
 	vin-supply = <&vgen5_reg>;
 };
-- 
2.20.1

