Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC53419BB3
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhI0RV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236839AbhI0RTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C5B261351;
        Mon, 27 Sep 2021 17:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762769;
        bh=+GhK0bDX6LvkCyLXmdoqKui7v2KvZh5h9Ot+wuqJovQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXUWf7m19fJb7TyNPmaKokH4pn+7gF8NTmSo5qUgGAyoZsHFl7Z8rFfF3LkRZFeCJ
         BKmab+psULBkTVL+J71qR5GJsdTzs0MCp28PoA1Zj67/cH6bb2xqwTBpp8shHnizsa
         kXQXfD/puA7KM3xhJHSBlatG9iG8TlHmD7qUEKc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dann frazier <dann.frazier@canonical.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.14 044/162] arm64: Restore forced disabling of KPTI on ThunderX
Date:   Mon, 27 Sep 2021 19:01:30 +0200
Message-Id: <20210927170235.029974872@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dann frazier <dann.frazier@canonical.com>

commit 22b70e6f2da0a4c8b1421b00cfc3016bc9d4d9d4 upstream.

A noted side-effect of commit 0c6c2d3615ef ("arm64: Generate cpucaps.h")
is that cpucaps are now sorted, changing the enumeration order. This
assumed no dependencies between cpucaps, which turned out not to be true
in one case. UNMAP_KERNEL_AT_EL0 currently needs to be processed after
WORKAROUND_CAVIUM_27456. ThunderX systems are incompatible with KPTI, so
unmap_kernel_at_el0() bails if WORKAROUND_CAVIUM_27456 is set. But because
of the sorting, WORKAROUND_CAVIUM_27456 will not yet have been considered
when unmap_kernel_at_el0() checks for it, so the kernel tries to
run w/ KPTI - and quickly falls over.

Because all ThunderX implementations have homogeneous CPUs, we can remove
this dependency by just checking the current CPU for the erratum.

Fixes: 0c6c2d3615ef ("arm64: Generate cpucaps.h")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: dann frazier <dann.frazier@canonical.com>
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210923145002.3394558-1-dann.frazier@canonical.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1500,9 +1500,13 @@ static bool unmap_kernel_at_el0(const st
 	/*
 	 * For reasons that aren't entirely clear, enabling KPTI on Cavium
 	 * ThunderX leads to apparent I-cache corruption of kernel text, which
-	 * ends as well as you might imagine. Don't even try.
+	 * ends as well as you might imagine. Don't even try. We cannot rely
+	 * on the cpus_have_*cap() helpers here to detect the CPU erratum
+	 * because cpucap detection order may change. However, since we know
+	 * affected CPUs are always in a homogeneous configuration, it is
+	 * safe to rely on this_cpu_has_cap() here.
 	 */
-	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_27456)) {
+	if (this_cpu_has_cap(ARM64_WORKAROUND_CAVIUM_27456)) {
 		str = "ARM64_WORKAROUND_CAVIUM_27456";
 		__kpti_forced = -1;
 	}


