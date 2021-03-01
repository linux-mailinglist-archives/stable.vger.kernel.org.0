Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2632918B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243276AbhCAU1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238711AbhCAUVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0B02651D5;
        Mon,  1 Mar 2021 18:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621893;
        bh=OVUP3hpq4sPVzg+WMZs4HT5LnDJMZeVlsL/StL5zzxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMwpJ3AwQ5hmOf9nHj0t7j9z16q8WDkIeLDAFzdV2Koy8oqsFWvO4I2R1sgI72Zqm
         yHi2eVrHdeZMg7LS+Eo4OmnwsTMTRkG2sxNzImxeCQpmiAB26NVOMPTjWp4fIVmi+J
         pk1BqJs0kFQnC+uvBVk8H6dnTTRH99bvI+HSfrx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.11 682/775] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
Date:   Mon,  1 Mar 2021 17:14:10 +0100
Message-Id: <20210301161235.086937434@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit c0b15c25d25171db4b70cc0b7dbc1130ee94017d upstream.

The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
we apply the work around for r0p0 - r1p0. Unfortunately this
won't be fixed for the future revisions for the CPU. Thus
extend the work around for all versions of A55, to cover
for r2p0 and any future revisions.

Cc: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20210203230057.3961239-1-suzuki.poulose@arm.com
[will: Update Kconfig help text]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig             |    2 +-
 arch/arm64/kernel/cpufeature.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -522,7 +522,7 @@ config ARM64_ERRATUM_1024718
 	help
 	  This option adds a workaround for ARM Cortex-A55 Erratum 1024718.
 
-	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0) could cause incorrect
+	  Affected Cortex-A55 cores (all revisions) could cause incorrect
 	  update of the hardware dirty bit when the DBM/AP bits are updated
 	  without a break-before-make. The workaround is to disable the usage
 	  of hardware DBM locally on the affected cores. CPUs not affected by
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1455,7 +1455,7 @@ static bool cpu_has_broken_dbm(void)
 	/* List of CPUs which have broken DBM support. */
 	static const struct midr_range cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
 		/* Kryo4xx Silver (rdpe => r1p0) */
 		MIDR_REV(MIDR_QCOM_KRYO_4XX_SILVER, 0xd, 0xe),
 #endif


