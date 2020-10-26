Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B6A2991C1
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 17:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784728AbgJZQEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 12:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784724AbgJZQDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 12:03:50 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1800722404;
        Mon, 26 Oct 2020 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603728229;
        bh=h5o3KPrk9jciKwrxsOK8xD5GWwug93Z9pyZ535cbSrE=;
        h=From:To:Cc:Subject:Date:From;
        b=aNA7OSHiRYPuMjVVMjUdSIVv6a1NrDK92k47wbUdSPoQOvkIlKpPsX1BnQg7JjVLE
         aQTX2P85AAeknQA5/AXXy54ddpRIOs7+5ZbrdHoAuMjGUPQ/3Wzn8ijVUQoYOz4URS
         UwFP3cBGkMFDwhhJELdCopkeTSErByPu/zp9lZvA=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Steven Price <steven.price@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] arm64: cpu_errata: fix override-init warnings
Date:   Mon, 26 Oct 2020 17:03:28 +0100
Message-Id: <20201026160342.3705327-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The CPU table causes a handful of warnings because of fields that
have more than one initializer, e.g.

arch/arm64/kernel/cpu_errata.c:127:13: warning: initialized field overwritten [-Woverride-init]
  127 |  .matches = is_affected_midr_range,   \
      |             ^~~~~~~~~~~~~~~~~~~~~~
arch/arm64/kernel/cpu_errata.c:139:2: note: in expansion of macro 'CAP_MIDR_RANGE'
  139 |  CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)
      |  ^~~~~~~~~~~~~~
arch/arm64/kernel/cpu_errata.c:151:2: note: in expansion of macro 'ERRATA_MIDR_RANGE'
  151 |  ERRATA_MIDR_RANGE(model, var, rev, var, rev)
      |  ^~~~~~~~~~~~~~~~~
arch/arm64/kernel/cpu_errata.c:317:3: note: in expansion of macro 'ERRATA_MIDR_REV'
  317 |   ERRATA_MIDR_REV(MIDR_BRAHMA_B53, 0, 0),
      |   ^~~~~~~~~~~~~~~

Address all of these by removing the extra initializer that
has no effect on the output.

Fixes: 1cf45b8fdbb8 ("arm64: apply ARM64_ERRATUM_843419 workaround for Brahma-B53 core")
Fixes: bf87bb0881d0 ("arm64: Allow booting of late CPUs affected by erratum 1418040")
Fixes: 93916beb7014 ("arm64: Enable workaround for Cavium TX2 erratum 219 when running SMT")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kernel/cpu_errata.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 24d75af344b1..2321f52e396f 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -307,13 +307,11 @@ static const struct midr_range erratum_845719_list[] = {
 static const struct arm64_cpu_capabilities erratum_843419_list[] = {
 	{
 		/* Cortex-A53 r0p[01234] */
-		.matches = is_affected_midr_range,
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A53, 0, 0, 4),
 		MIDR_FIXED(0x4, BIT(8)),
 	},
 	{
 		/* Brahma-B53 r0p[0] */
-		.matches = is_affected_midr_range,
 		ERRATA_MIDR_REV(MIDR_BRAHMA_B53, 0, 0),
 	},
 	{},
@@ -475,7 +473,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "ARM erratum 1418040",
 		.capability = ARM64_WORKAROUND_1418040,
-		ERRATA_MIDR_RANGE_LIST(erratum_1418040_list),
+		CAP_MIDR_RANGE_LIST(erratum_1418040_list),
 		/*
 		 * We need to allow affected CPUs to come in late, but
 		 * also need the non-affected CPUs to be able to come
@@ -504,8 +502,8 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "Cavium ThunderX2 erratum 219 (KVM guest sysreg trapping)",
 		.capability = ARM64_WORKAROUND_CAVIUM_TX2_219_TVM,
-		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
 		.matches = needs_tx2_tvm_workaround,
+		.midr_range_list = tx2_family_cpus,
 	},
 	{
 		.desc = "Cavium ThunderX2 erratum 219 (PRFM removal)",
-- 
2.27.0

