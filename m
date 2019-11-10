Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73171F66CF
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfKJClH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbfKJClG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35165215EA;
        Sun, 10 Nov 2019 02:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353665;
        bh=HJKuEjihpRVj7ywHu4OgY4KZpDHLxi5jwLvtGXQc/Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPq1D2byhuaeHGanpu8k3tW43mw4ojjDy3Fk/oVykLfqcd94rPnB6DARMck6S0qoI
         BhRko8QC9sqoO2XyGo3vx5/bZgJZLqRj94jfj0LWoL0w6YfRkfOhg0wm6VOqOU8g4m
         Ic8lIXmO+a+lpmKyG6Uz787DFb0MGuP2jHrwY2K4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 035/191] of/unittest: Fix I2C bus unit-address error
Date:   Sat,  9 Nov 2019 21:37:37 -0500
Message-Id: <20191110024013.29782-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 62287dce5d0ee207b6a09a0a1abd06b61cee1094 ]

dtc has new checks for I2C buses. Fix the warnings in unit-addresses in
the unittests.

drivers/of/unittest-data/testcases.dtb: Warning (i2c_bus_reg): /testcase-data/overlay-node/test-bus/i2c-test-bus/test-unittest14/i2c@0/test-mux-dev: I2C bus unit address format error, expected "20"
drivers/of/unittest-data/overlay_15.dtb: Warning (i2c_bus_reg): /fragment@0/__overlay__/test-unittest15/i2c@0/test-mux-dev: I2C bus unit address format error, expected "20"

Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest-data/overlay_15.dts     | 4 ++--
 drivers/of/unittest-data/tests-overlay.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest-data/overlay_15.dts b/drivers/of/unittest-data/overlay_15.dts
index b98f2514df4b3..5728490474f6b 100644
--- a/drivers/of/unittest-data/overlay_15.dts
+++ b/drivers/of/unittest-data/overlay_15.dts
@@ -20,8 +20,8 @@
 			#size-cells = <0>;
 			reg = <0>;
 
-			test-mux-dev {
-				reg = <32>;
+			test-mux-dev@20 {
+				reg = <0x20>;
 				compatible = "unittest-i2c-dev";
 				status = "okay";
 			};
diff --git a/drivers/of/unittest-data/tests-overlay.dtsi b/drivers/of/unittest-data/tests-overlay.dtsi
index 25cf397b8f6b6..4ea024d908ee2 100644
--- a/drivers/of/unittest-data/tests-overlay.dtsi
+++ b/drivers/of/unittest-data/tests-overlay.dtsi
@@ -103,8 +103,8 @@
 							#size-cells = <0>;
 							reg = <0>;
 
-							test-mux-dev {
-								reg = <32>;
+							test-mux-dev@20 {
+								reg = <0x20>;
 								compatible = "unittest-i2c-dev";
 								status = "okay";
 							};
-- 
2.20.1

