Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B129F71C
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbfD3LtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730278AbfD3LtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C858B21670;
        Tue, 30 Apr 2019 11:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624952;
        bh=3Tq88hR5hv0Ak6dU50bZT9K8PkyxvQU6ZbbPLIXGtXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZjC8/T4kZg8JQ/cB/8jdivw+P59pDzk7czZzyGv8ZhT3niOVAc3VouiTg0JyIOl+
         8Q6CNHL4bT/OufsjMv5ZiuJx/HaF10Q669xzUwNNSqjHqwp7sFuAnvdho6OqyZdBMw
         G1qNxQSZf9YXj+a3a9HWl0lDX0H/pHYXo2LoNcGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Pan <harry.pan@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, gs0622@gmail.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.0 34/89] perf/x86/intel: Update KBL Package C-state events to also include PC8/PC9/PC10 counters
Date:   Tue, 30 Apr 2019 13:38:25 +0200
Message-Id: <20190430113611.481702887@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Pan <harry.pan@intel.com>

commit 82c99f7a81f28f8c1be5f701c8377d14c4075b10 upstream.

Kaby Lake (and Coffee Lake) has PC8/PC9/PC10 residency counters.

This patch updates the list of Kaby/Coffee Lake PMU event counters
from the snb_cstates[] list of events to the hswult_cstates[]
list of events, which keeps all previously supported events and
also adds the PKG_C8, PKG_C9 and PKG_C10 residency counters.

This allows user space tools to profile them through the perf interface.

Signed-off-by: Harry Pan <harry.pan@intel.com>
Cc: <stable@vger.kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: gs0622@gmail.com
Link: http://lkml.kernel.org/r/20190424145033.1924-1-harry.pan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/cstate.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -76,15 +76,15 @@
  *			       Scope: Package (physical package)
  *	MSR_PKG_C8_RESIDENCY:  Package C8 Residency Counter.
  *			       perf code: 0x04
- *			       Available model: HSW ULT,CNL
+ *			       Available model: HSW ULT,KBL,CNL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C9_RESIDENCY:  Package C9 Residency Counter.
  *			       perf code: 0x05
- *			       Available model: HSW ULT,CNL
+ *			       Available model: HSW ULT,KBL,CNL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C10_RESIDENCY: Package C10 Residency Counter.
  *			       perf code: 0x06
- *			       Available model: HSW ULT,GLM,CNL
+ *			       Available model: HSW ULT,KBL,GLM,CNL
  *			       Scope: Package (physical package)
  *
  */
@@ -572,8 +572,8 @@ static const struct x86_cpu_id intel_cst
 	X86_CSTATES_MODEL(INTEL_FAM6_SKYLAKE_DESKTOP, snb_cstates),
 	X86_CSTATES_MODEL(INTEL_FAM6_SKYLAKE_X, snb_cstates),
 
-	X86_CSTATES_MODEL(INTEL_FAM6_KABYLAKE_MOBILE,  snb_cstates),
-	X86_CSTATES_MODEL(INTEL_FAM6_KABYLAKE_DESKTOP, snb_cstates),
+	X86_CSTATES_MODEL(INTEL_FAM6_KABYLAKE_MOBILE,  hswult_cstates),
+	X86_CSTATES_MODEL(INTEL_FAM6_KABYLAKE_DESKTOP, hswult_cstates),
 
 	X86_CSTATES_MODEL(INTEL_FAM6_CANNONLAKE_MOBILE, cnl_cstates),
 


