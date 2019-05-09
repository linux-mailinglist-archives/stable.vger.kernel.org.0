Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF941921C
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfEISsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfEISsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:48:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6327321848;
        Thu,  9 May 2019 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427682;
        bh=h2N+hDNITwH/Ke3AALEIDpBX62l9aCHbEXOmbu49DlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWfTta4q5OpMc1H4TYX5pc9CmKjwlLg4OwdS97S3gAgvRDB+KvRT5++1oZQ8ETsHI
         1Pmng7ipO8FaocGEQBWeCj1bE5II1nijVDlSrpoCzFy/VY3qVlE0fY6x5vKUCIqIh0
         L4uahYVvVNemSQewou5cklyrpVPc7lbFIq5TYqTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Nelson DSouza <nelson.dsouza@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, tonyj@suse.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/66] perf/x86/intel: Initialize TFA MSR
Date:   Thu,  9 May 2019 20:42:05 +0200
Message-Id: <20190509181305.094955192@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d7262457e35dbe239659e62654e56f8ddb814bed ]

Stephane reported that the TFA MSR is not initialized by the kernel,
but the TFA bit could set by firmware or as a leftover from a kexec,
which makes the state inconsistent.

Reported-by: Stephane Eranian <eranian@google.com>
Tested-by: Nelson DSouza <nelson.dsouza@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: tonyj@suse.com
Link: https://lkml.kernel.org/r/20190321123849.GN6521@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 26432ee4590e3..f9958ad4d3353 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3447,6 +3447,12 @@ static void intel_pmu_cpu_starting(int cpu)
 
 	cpuc->lbr_sel = NULL;
 
+	if (x86_pmu.flags & PMU_FL_TFA) {
+		WARN_ON_ONCE(cpuc->tfa_shadow);
+		cpuc->tfa_shadow = ~0ULL;
+		intel_set_tfa(cpuc, false);
+	}
+
 	if (x86_pmu.version > 1)
 		flip_smm_bit(&x86_pmu.attr_freeze_on_smi);
 
-- 
2.20.1



