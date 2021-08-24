Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67DA3F63AE
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhHXQ5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhHXQ5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8BE0613E8;
        Tue, 24 Aug 2021 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824197;
        bh=ZOcgwKbm5nIdqPe3lzCOmutXRonodFE/uiWfF8pp+jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gklw8EW0KN1RLzeYteVWNCl+S21PtLlZwSx7x4gDDMwccYglnpgx2I7V2cD7p08js
         uWxtKpNW5mg0YmOBL9+h8XT3HOzs2szb+7TWIjDrxQuhh/Oh6ZZTYboOzustbhwXTj
         SXcKVAA+kjenXEC8CCW28tLFnejGVHwOx/OdEliE78mzUpAMe6QQsygCZcnvOyVhmx
         bFVsa0PbRc6MHCMm6Q2/2cemSDdHFVFrra2PVy7c1/Nux9vzifKHXoWvJ/mUGsUSkT
         uW+Lg2+vKZ518gLJOwAOdrsW070Jr0OeNwX0ksZVMh+ZuJz38IyUpZDZk1xLdIYHuy
         +31GFcYzE6QIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 029/127] arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem mapping
Date:   Tue, 24 Aug 2021 12:54:29 -0400
Message-Id: <20210824165607.709387-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit 3cb6a271f4b04f11270111638c24fa5c0b846dec ]

cont_splash_mem has different memory mapping than generic from msm8994.dtsi:

[    0.000000] cma: Found cont_splash_mem@0, memory base 0x0000000003400000, size 12 MiB, limit 0xffffffffffffffff
[    0.000000] cma: CMA: reserved 12 MiB at 0x0000000003400000 for cont_splash_mem

This fixes boot.

Fixes: 976d321f32dc ("arm64: dts: qcom: msm8992: Make the DT an overlay on top of 8994")
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Link: https://lore.kernel.org/r/20210713185734.380-3-petr.vorel@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index 5c6e17f11ee9..1ccca83292ac 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -10,6 +10,9 @@
 #include "pm8994.dtsi"
 #include "pmi8994.dtsi"
 
+/* cont_splash_mem has different memory mapping */
+/delete-node/ &cont_splash_mem;
+
 / {
 	model = "LG Nexus 5X";
 	compatible = "lg,bullhead", "qcom,msm8992";
@@ -42,6 +45,11 @@
 			ftrace-size = <0x10000>;
 			pmsg-size = <0x20000>;
 		};
+
+		cont_splash_mem: memory@3400000 {
+			reg = <0 0x03400000 0 0x1200000>;
+			no-map;
+		};
 	};
 };
 
-- 
2.30.2

