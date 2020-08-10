Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE900240A1A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgHJPZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgHJPZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43CC920658;
        Mon, 10 Aug 2020 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073134;
        bh=8aTXwZ4opx8LLQJfKMRpxPVdMjiXrdDmraPtP16ipPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJ9V2mWvfgouekQ/8P4txSPjnW1WFGDk900eiaaZ+QrtWV3v75CL8iq8iYQCKJwyM
         RTdKH/tHJj1HlXFjJgEmLeCNMOJgrPSE08kHeFN9+TiLvOEg/kse9+XLG7zEZNvUGb
         bA7VTHK7H9Al9pDeQ/aTzBFZCi7iDHCmeuU855IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.7 79/79] arm64: kaslr: Use standard early random function
Date:   Mon, 10 Aug 2020 17:21:38 +0200
Message-Id: <20200810151816.114898609@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 9bceb80b3cc483e6763c39a4928402fa82815d3e upstream.

Commit 585524081ecd ("random: random.h should include archrandom.h, not
the other way around") tries to fix a problem with recursive inclusion
of linux/random.h and arch/archrandom.h for arm64.  Unfortunately, this
results in the following compile error if ARCH_RANDOM is disabled.

  arch/arm64/kernel/kaslr.c: In function 'kaslr_early_init':
  arch/arm64/kernel/kaslr.c:128:6: error: implicit declaration of function '__early_cpu_has_rndr'; did you mean '__early_pfn_to_nid'? [-Werror=implicit-function-declaration]
    if (__early_cpu_has_rndr()) {
        ^~~~~~~~~~~~~~~~~~~~
        __early_pfn_to_nid
  arch/arm64/kernel/kaslr.c:131:7: error: implicit declaration of function '__arm64_rndr' [-Werror=implicit-function-declaration]
     if (__arm64_rndr(&raw))
         ^~~~~~~~~~~~

The problem is that arch/archrandom.h is only included from
linux/random.h if ARCH_RANDOM is enabled.  If not, __arm64_rndr() and
__early_cpu_has_rndr() are undeclared, causing the problem.

Use arch_get_random_seed_long_early() instead of arm64 specific
functions to solve the problem.

Reported-by: Qian Cai <cai@lca.pw>
Fixes: 585524081ecd ("random: random.h should include archrandom.h, not the other way around")
Cc: Qian Cai <cai@lca.pw>
Cc: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/kaslr.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -84,6 +84,7 @@ u64 __init kaslr_early_init(u64 dt_phys)
 	void *fdt;
 	u64 seed, offset, mask, module_range;
 	const u8 *cmdline, *str;
+	unsigned long raw;
 	int size;
 
 	/*
@@ -122,15 +123,12 @@ u64 __init kaslr_early_init(u64 dt_phys)
 	}
 
 	/*
-	 * Mix in any entropy obtainable architecturally, open coded
-	 * since this runs extremely early.
+	 * Mix in any entropy obtainable architecturally if enabled
+	 * and supported.
 	 */
-	if (__early_cpu_has_rndr()) {
-		unsigned long raw;
 
-		if (__arm64_rndr(&raw))
-			seed ^= raw;
-	}
+	if (arch_get_random_seed_long_early(&raw))
+		seed ^= raw;
 
 	if (!seed) {
 		kaslr_status = KASLR_DISABLED_NO_SEED;


