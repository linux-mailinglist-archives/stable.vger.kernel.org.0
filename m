Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D1420BF7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhJDNB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhJDM7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6004761994;
        Mon,  4 Oct 2021 12:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352265;
        bh=iN6shAK1uMj87NTIcvDPLrlffVNZbrfpLNn2NEQRmkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0wh3ISoiy2TDBlFUtr60fhMFjUeX30g8ZfEAWesnU0eadyWAVPPVckNJFhCjF/+S
         7xwbsJYHYAxdOmy2LcKXZQ9AcO+fVz36UfN+XwTq8AHo2SuLMBtXd/mdchVulDMbzO
         Z5dU+S4P+HwFhVIZrBX2pn6K1HBJ6TdUqJVdiW5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Nanyong Sun <sunnanyong@huawei.com>
Subject: [PATCH 4.9 53/57] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
Date:   Mon,  4 Oct 2021 14:52:37 +0200
Message-Id: <20211004125030.623951794@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
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
[Nanyon: adjust for stable version below v4.16, which set TCR_HD earlier
in assembly code]
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Kconfig   |    2 +-
 arch/arm64/mm/proc.S |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -433,7 +433,7 @@ config ARM64_ERRATUM_1024718
 	help
 	  This option adds work around for Arm Cortex-A55 Erratum 1024718.
 
-	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0) could cause incorrect
+	  Affected Cortex-A55 cores (all revisions) could cause incorrect
 	  update of the hardware dirty bit when the DBM/AP bits are updated
 	  without a break-before-make. The work around is to disable the usage
 	  of hardware DBM locally on the affected cores. CPUs not affected by
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -442,8 +442,8 @@ ENTRY(__cpu_setup)
 	cmp	x9, #2
 	b.lt	1f
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-	/* Disable hardware DBM on Cortex-A55 r0p0, r0p1 & r1p0 */
-	cpu_midr_match MIDR_CORTEX_A55, MIDR_CPU_VAR_REV(0, 0), MIDR_CPU_VAR_REV(1, 0), x1, x2, x3, x4
+	/* Disable hardware DBM on Cortex-A55 all versions */
+	cpu_midr_match MIDR_CORTEX_A55, MIDR_CPU_VAR_REV(0, 0), MIDR_CPU_VAR_REV(0xf, 0xf), x1, x2, x3, x4
 	cbnz	x1, 1f
 #endif
 	orr	x10, x10, #TCR_HD		// hardware Dirty flag update


