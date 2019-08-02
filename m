Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 171A07FAA8
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405653AbfHBNeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393853AbfHBNWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:22:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D6852186A;
        Fri,  2 Aug 2019 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752168;
        bh=cHHC/6BH3hEEaUaPDgk9Foc2zUvFdzdsqjlgF27ogsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3KPZIm/BSgeqDMibegzfxOkDWu+PSbBj7JelTJ0sfJRlQg2znxWPPwHEeftXkmkW
         HGJw0TvAJrzW4kk2lA2BD28algk4ROe4r0wlmcbHvOdNnP1AtAywlH2oe0I7626gKi
         z19vFz1JhDfH1WnNnwEB/xovydzLhlyxVyDyaAZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 73/76] perf/x86: Apply more accurate check on hypervisor platform
Date:   Fri,  2 Aug 2019 09:19:47 -0400
Message-Id: <20190802131951.11600-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

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

