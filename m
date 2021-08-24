Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7F63F63B6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhHXQ55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhHXQ5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5203561401;
        Tue, 24 Aug 2021 16:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824200;
        bh=4/yDNZfuUkREv729VOe2JN3wzuZB9NpNkK30rovI7Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFjm2T9HLWDMG4ocH75UpbCIC5zl9GWMI9GCwmMEJR9TFHOqkAfokJG6XACFP3aKv
         bLOjfESF2JNNrJk2nSW6qaYPOGFT0H3PyyrU+ybiiH1UNI1ubX23+TFSVGStbJtysY
         OqErAqSdSaCM4EFBiiBir0A0sLzTGO/p/G7QD1YGrOqT0ingrf7jyTMY7ZgQvE+quG
         Z51eAzJ3xSb4ReV5VoXZOL1clzTcnY2sn8mY/W/q15q9WVISZwYui/C6WbxGHqgF8J
         /jEGfMEMyUqlBsDb0lHX53K/u4reW0vjv7w3miiAX8cY9OU1fKCLD0rCw6idd2tR8w
         X6Ed3qa0WUFSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Caleb Connolly <caleb@connolly.tech>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 033/127] arm64: dts: qcom: sdm845-oneplus: fix reserved-mem
Date:   Tue, 24 Aug 2021 12:54:33 -0400
Message-Id: <20210824165607.709387-34-sashal@kernel.org>
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

From: Caleb Connolly <caleb@connolly.tech>

[ Upstream commit d77c95bf9a64d8620662151b2b10efd8221f4bcc ]

Fix the upper guard and the "removed_region", this fixes the random
crashes which used to occur in memory intensive loads. I'm not sure WHY
the upper guard being 0x2000 instead of 0x1000 doesn't fix this, but it
HAS to be 0x1000.

Fixes: e60fd5ac1f68 ("arm64: dts: qcom: sdm845-oneplus-common: guard rmtfs-mem")
Signed-off-by: Caleb Connolly <caleb@connolly.tech>
Link: https://lore.kernel.org/r/20210720153125.43389-2-caleb@connolly.tech
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index f712771df0c7..846eebebd831 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -69,7 +69,7 @@
 		};
 		rmtfs_upper_guard: memory@f5d01000 {
 			no-map;
-			reg = <0 0xf5d01000 0 0x2000>;
+			reg = <0 0xf5d01000 0 0x1000>;
 		};
 
 		/*
@@ -78,7 +78,7 @@
 		 */
 		removed_region: memory@88f00000 {
 			no-map;
-			reg = <0 0x88f00000 0 0x200000>;
+			reg = <0 0x88f00000 0 0x1c00000>;
 		};
 
 		ramoops: ramoops@ac300000 {
-- 
2.30.2

