Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D503272E6D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgIUQtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbgIUQtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1C6B238EE;
        Mon, 21 Sep 2020 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706941;
        bh=ajxv40LnFW7y9K8fxklgXlh4q0L+riISNzxE3VeDs2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOs/HFQcNcAdv49X8sR9Hv7c1lgLj2sugOwXn3tg39MHoWoofaNosln+/lkTj4LIB
         EVaaCOvvzxsyXoGP+qVqb6NRbFwhVTJDA+Lo2WyHCoKQkGi6ql8D22jdx3UEILi+1O
         3fGsy+ljuzrzBW88iJx+qp8+CzHDSgNL+sXWE8eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/72] arm64: Allow CPUs unffected by ARM erratum 1418040 to come in late
Date:   Mon, 21 Sep 2020 18:31:15 +0200
Message-Id: <20200921163123.587652167@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit ed888cb0d1ebce69f12794e89fbd5e2c86d40b8d ]

Now that we allow CPUs affected by erratum 1418040 to come in late,
this prevents their unaffected sibblings from coming in late (or
coming back after a suspend or hotplug-off, which amounts to the
same thing).

To allow this, we need to add ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU,
which amounts to set .type to ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE.

Fixes: bf87bb0881d0 ("arm64: Allow booting of late CPUs affected by erratum 1418040")
Reported-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200911181611.2073183-1-maz@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 51462c59ab5da..d2e738c455566 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -917,8 +917,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 1418040",
 		.capability = ARM64_WORKAROUND_1418040,
 		ERRATA_MIDR_RANGE_LIST(erratum_1418040_list),
-		.type = (ARM64_CPUCAP_SCOPE_LOCAL_CPU |
-			 ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU),
+		/*
+		 * We need to allow affected CPUs to come in late, but
+		 * also need the non-affected CPUs to be able to come
+		 * in at any point in time. Wonderful.
+		 */
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_1165522
-- 
2.25.1



