Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1344B3F63B4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhHXQ54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhHXQ5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BAD661371;
        Tue, 24 Aug 2021 16:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824200;
        bh=bvT5m81UI7+XHRIhUEyWYmDSsqyF6OqCQSwc9xjVBvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPSN/l9nZKwqwVrdXv6rCBZ01F/tvd9P2sxZNt8HAXo+f2h6X3gIO/0rNiXr1AWx1
         q1mbNfA+4S7SnwdtHoRiO0Ro/qugQMXRhj+Zx4/0jbhn+Byd+t3MZn32tlxY3TIAZH
         7Ivx0Fq1D0aDtyvYXMinaE87TbZXc73OMTkLEw2+N8+DrSbcHJkHCp99eIaiAYqjYM
         juK67Vh+feaUGZj1e59O5PPhsTRJt5z8s5RyX9vbQAfKQ2QprP3ZJ1+gB5C9Gm88z5
         733rgcxsNmg4W7ROy+6EHxxKexchzkSWMyNpsRduYRm76nlX6gHOguh9kcIo50xmz9
         KloUx7B2zPKUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konradybcio@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 032/127] arm64: dts: qcom: msm8994-angler: Disable cont_splash_mem
Date:   Tue, 24 Aug 2021 12:54:32 -0400
Message-Id: <20210824165607.709387-33-sashal@kernel.org>
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

[ Upstream commit 0e5ded926f2a0f8b57dfa7f0d69a30767e1ea2ce ]

As the default definition breaks booting angler:
[    1.862561] printk: console [ttyMSM0] enabled
[    1.872260] msm_serial: driver initialized
D -     15524 - pm_driver_init, Delta

cont_splash_mem was introduced in 74d6d0a145835, but the problem
manifested after commit '86588296acbf ("fdt: Properly handle "no-map"
field in the memory region")'.

Disabling it because Angler's firmware does not report where the memory
is allocated (dmesg from downstream kernel):
[    0.000000] cma: Found cont_splash_mem@0, memory base 0x0000000000000000, size 16 MiB, limit 0x0000000000000000
[    0.000000] cma: CMA: reserved 16 MiB at 0x0000000000000000 for cont_splash_mem

Similar issue might be on Google Nexus 5X (lg-bullhead). Other MSM8992/4
are known to report correct address.

Fixes: 74d6d0a145835 ("arm64: dts: qcom: msm8994/8994-kitakami: Fix up the memory map")
Suggested-by: Konrad Dybcio <konradybcio@gmail.com>
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Link: https://lore.kernel.org/r/20210622191019.23771-1-petr.vorel@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
index baa55643b40f..801995af3dfc 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, Huawei Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
  */
 
 /dts-v1/;
 
 #include "msm8994.dtsi"
 
+/* Angler's firmware does not report where the memory is allocated */
+/delete-node/ &cont_splash_mem;
+
 / {
 	model = "Huawei Nexus 6P";
 	compatible = "huawei,angler", "qcom,msm8994";
-- 
2.30.2

