Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E598B8D96F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbfHNRIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730128AbfHNRIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:08:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CAE22133F;
        Wed, 14 Aug 2019 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802500;
        bh=8d+DXjxnTBnpLKRX5659bJcWsiMINxWaioAMrxT+YZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pgg80KAxm8uc9x2/uWB20X38pCdmD2IYiTPLF7KUlIYKDKKbNDs0gatlB6M4cVGfM
         +OJgmo7979wjFLw8rDHk9ROlr720nF2SZheRULjQOjwPMgJncj2S+5b570m3pTzwOJ
         qAjzexj4NCzgllQ5cJRwB5fZloSjEvi2YsFHuLxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 114/144] perf/x86: Apply more accurate check on hypervisor platform
Date:   Wed, 14 Aug 2019 19:01:10 +0200
Message-Id: <20190814165804.682059835@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5ea3f6fb37b79da33ac9211df336fd2b9f47c39f ]

check_msr is used to fix a bug report in guest where KVM doesn't support
LBR MSR and cause #GP.

The msr check is bypassed on real HW to workaround a false failure,
see commit d0e1a507bdc7 ("perf/x86/intel: Disable check_msr for real HW")

When running a guest with CONFIG_HYPERVISOR_GUEST not set or "nopv"
enabled, current check isn't enough and #GP could trigger.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/1564022366-18293-1-git-send-email-zhenzhong.duan@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e9042e3f3052c..6179be624f357 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -20,7 +20,6 @@
 #include <asm/intel-family.h>
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
-#include <asm/hypervisor.h>
 
 #include "../perf_event.h"
 
@@ -4057,7 +4056,7 @@ static bool check_msr(unsigned long msr, u64 mask)
 	 * Disable the check for real HW, so we don't
 	 * mess with potentionaly enabled registers:
 	 */
-	if (hypervisor_is_type(X86_HYPER_NATIVE))
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return true;
 
 	/*
-- 
2.20.1



