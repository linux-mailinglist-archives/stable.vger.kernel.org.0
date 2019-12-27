Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203CD12B6AF
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfL0Roc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbfL0Rob (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 458D721927;
        Fri, 27 Dec 2019 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468670;
        bh=4YIWANv+xk2ULjgUiU9TKCAH+VD5k1p14EtAPNJLawo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVEAZ66xZKfQ5MAnfhyiPpI2yRXycAiTA6231AL+h1glUyucPuw0lON5kxNHKy2Ds
         IVhCg0B5ZqAXG0oGQA6MsTH+0wpQ6d7iyj41FWa2LpByoYxvL/7AetbCBA1vO0hAxO
         zLzfO/9WsB27zaYCiubWEFi/kWejoL7mUQUrtfHE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 31/84] ARM: dts: bcm283x: Fix critical trip point
Date:   Fri, 27 Dec 2019 12:42:59 -0500
Message-Id: <20191227174352.6264-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
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
index 31b29646b14c..c9322a56300d 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -39,7 +39,7 @@
 
 			trips {
 				cpu-crit {
-					temperature	= <80000>;
+					temperature	= <90000>;
 					hysteresis	= <0>;
 					type		= "critical";
 				};
-- 
2.20.1

