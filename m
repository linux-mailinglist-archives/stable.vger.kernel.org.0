Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB333287BC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbhCAR2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237030AbhCARSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:18:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B99E6504D;
        Mon,  1 Mar 2021 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617231;
        bh=1aUp4WnQ0d6xW1Xx1eaYpX3/zb8vkFgrgPhQ4ud/oec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPF+549TIhCJiUedaiCbULyFeac/LK2drlV/umBJL7ubVQL0TFnY4WbfwWJY/lBDm
         1BjQhSxA4H0DHaL580jQb19WcGjCNOtD25nYTldxdiCrOT4tR41UuszXBAGOZzaQ0R
         ZqFBsFGbnBJBcugrYP6IagjiupN7NB9g+IIflEvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 4.19 223/247] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
Date:   Mon,  1 Mar 2021 17:14:03 +0100
Message-Id: <20210301161042.603544161@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
@@ -473,7 +473,7 @@ config ARM64_ERRATUM_1024718
 	help
 	  This option adds work around for Arm Cortex-A55 Erratum 1024718.
 
-	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0) could cause incorrect
+	  Affected Cortex-A55 cores (all revisions) could cause incorrect
 	  update of the hardware dirty bit when the DBM/AP bits are updated
 	  without a break-before-make. The work around is to disable the usage
 	  of hardware DBM locally on the affected cores. CPUs not affected by
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1012,7 +1012,7 @@ static bool cpu_has_broken_dbm(void)
 	/* List of CPUs which have broken DBM support. */
 	static const struct midr_range cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
 #endif
 		{},
 	};


