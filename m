Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947A81BCBA6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgD1S67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729262AbgD1S2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D8B20730;
        Tue, 28 Apr 2020 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098533;
        bh=CuotRLngCO9FT5A0gb2kCZe4KvFkWTY71lykbHFyFJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiqstQeXwC3Qx86wqbY0JgMVRhcuwa86Hs62ypsZ08o1eoW+U0/hhAo943qhMo+AI
         mUQFOw67JoBri1zcRRHkodBYittQl+wdk7pSG/+PW5weM333KLf+s7kgxJQkuOvcZc
         n0MwfhKX+Drpe4WmYoZJY+idIKrfpA/SYVyXPFlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/131] arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space
Date:   Tue, 28 Apr 2020 20:23:41 +0200
Message-Id: <20200428182226.363035019@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit: 222fc0c8503d98cec3cb2bac2780cdd21a6e31c0 ]

Compat user-space is unable to perform ICIMVAU instructions from
user-space. Instead it uses a compat-syscall. Add the workaround for
Neoverse-N1 #1542419 to this code path.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/sys_compat.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index 010212d35700e..5a9b220aef6cf 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/compat.h>
+#include <linux/cpufeature.h>
 #include <linux/personality.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
@@ -28,6 +29,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/system_misc.h>
+#include <asm/tlbflush.h>
 #include <asm/unistd.h>
 
 static long
@@ -41,6 +43,15 @@ __do_compat_cache_op(unsigned long start, unsigned long end)
 		if (fatal_signal_pending(current))
 			return 0;
 
+		if (cpus_have_const_cap(ARM64_WORKAROUND_1542419)) {
+			/*
+			 * The workaround requires an inner-shareable tlbi.
+			 * We pick the reserved-ASID to minimise the impact.
+			 */
+			__tlbi(aside1is, 0);
+			dsb(ish);
+		}
+
 		ret = __flush_cache_user_range(start, start + chunk);
 		if (ret)
 			return ret;
-- 
2.20.1



