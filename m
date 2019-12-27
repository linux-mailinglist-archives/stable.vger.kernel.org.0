Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D27B12B847
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfL0RmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:42:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfL0RmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A924220740;
        Fri, 27 Dec 2019 17:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468536;
        bh=CuHDXm6CnEmH/l+I+Z4tOhOiGH9ZvYgGUysk2Z+MD98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE1O/E0y13n/AeY0F2+lu8TZQ80i6ilEtQr19xPB7ZCWluh1Zix09Rpx6czpZ10jv
         F9T8SN1sN8JlvgdExA+7QAAS9+HX+L52yWft/nBmCXE7WFxPEdrAFQHNG3+Wa3eIJ/
         jWCNK1JPUG8fxJGDppm/F/c9tcldF+5wIu6OPFO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 066/187] ARM: dts: bcm283x: Fix critical trip point
Date:   Fri, 27 Dec 2019 12:38:54 -0500
Message-Id: <20191227174055.4923-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 30e647a764d446723a7e0fb08d209e0104f16173 ]

During definition of the CPU thermal zone of BCM283x SoC family there
was a misunderstanding of the meaning "criticial trip point" and the
thermal throttling range of the VideoCore firmware. The latter one takes
effect when the core temperature is at least 85 degree celsius or higher

So the current critical trip point doesn't make sense, because the
thermal shutdown appears before the firmware has a chance to throttle
the ARM core(s).

Fix these unwanted shutdowns by increasing the critical trip point
to a value which shouldn't be reached with working thermal throttling.

Fixes: 0fe4d2181cc4 ("ARM: dts: bcm283x: Add CPU thermal zone with 1 trip point")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm283x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index 2d191fcbc2cc..90125ce19a1b 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -40,7 +40,7 @@
 
 			trips {
 				cpu-crit {
-					temperature	= <80000>;
+					temperature	= <90000>;
 					hysteresis	= <0>;
 					type		= "critical";
 				};
-- 
2.20.1

