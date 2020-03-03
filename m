Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E326177EDE
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731345AbgCCRr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbgCCRrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:47:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40B83208C3;
        Tue,  3 Mar 2020 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257643;
        bh=oTYgoWQTfmOG7ZN0sUeME2E5uZ6h8jH+epj1i8hWPwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNwHoBx/l1HnU1nu+auc4TFOmdf7h/R5pUyvtanzxQkALUVk6Xo2uP6k0oR4ISBQC
         i1vV+N5VbyuOLh9CGilF9Y72ruP69JwIowy+xHGFlSwZgG4KUaM+5iTlNcmWoPKZDQ
         eJoQxlnlKfnxdGukDk3Jg8Aw0C4VsoLY3U58Dq78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 041/176] perf/x86/cstate: Add Tremont support
Date:   Tue,  3 Mar 2020 18:41:45 +0100
Message-Id: <20200303174309.272474748@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit ecf71fbccb9ac5cb964eb7de59bb9da3755b7885 ]

Tremont is Intel's successor to Goldmont Plus. From the perspective of
Intel cstate residency counters, there is nothing changed compared with
Goldmont Plus and Goldmont.

Share glm_cstates with Goldmont Plus and Goldmont.
Update the comments for Tremont.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lkml.kernel.org/r/1580236279-35492-2-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index e1daf4151e116..4814c964692cb 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -40,17 +40,18 @@
  * Model specific counters:
  *	MSR_CORE_C1_RES: CORE C1 Residency Counter
  *			 perf code: 0x00
- *			 Available model: SLM,AMT,GLM,CNL
+ *			 Available model: SLM,AMT,GLM,CNL,TNT
  *			 Scope: Core (each processor core has a MSR)
  *	MSR_CORE_C3_RESIDENCY: CORE C3 Residency Counter
  *			       perf code: 0x01
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,GLM,
- *						CNL,KBL,CML
+ *						CNL,KBL,CML,TNT
  *			       Scope: Core
  *	MSR_CORE_C6_RESIDENCY: CORE C6 Residency Counter
  *			       perf code: 0x02
  *			       Available model: SLM,AMT,NHM,WSM,SNB,IVB,HSW,BDW,
- *						SKL,KNL,GLM,CNL,KBL,CML,ICL,TGL
+ *						SKL,KNL,GLM,CNL,KBL,CML,ICL,TGL,
+ *						TNT
  *			       Scope: Core
  *	MSR_CORE_C7_RESIDENCY: CORE C7 Residency Counter
  *			       perf code: 0x03
@@ -60,17 +61,18 @@
  *	MSR_PKG_C2_RESIDENCY:  Package C2 Residency Counter.
  *			       perf code: 0x00
  *			       Available model: SNB,IVB,HSW,BDW,SKL,KNL,GLM,CNL,
- *						KBL,CML,ICL,TGL
+ *						KBL,CML,ICL,TGL,TNT
  *			       Scope: Package (physical package)
  *	MSR_PKG_C3_RESIDENCY:  Package C3 Residency Counter.
  *			       perf code: 0x01
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,KNL,
- *						GLM,CNL,KBL,CML,ICL,TGL
+ *						GLM,CNL,KBL,CML,ICL,TGL,TNT
  *			       Scope: Package (physical package)
  *	MSR_PKG_C6_RESIDENCY:  Package C6 Residency Counter.
  *			       perf code: 0x02
- *			       Available model: SLM,AMT,NHM,WSM,SNB,IVB,HSW,BDW
- *						SKL,KNL,GLM,CNL,KBL,CML,ICL,TGL
+ *			       Available model: SLM,AMT,NHM,WSM,SNB,IVB,HSW,BDW,
+ *						SKL,KNL,GLM,CNL,KBL,CML,ICL,TGL,
+ *						TNT
  *			       Scope: Package (physical package)
  *	MSR_PKG_C7_RESIDENCY:  Package C7 Residency Counter.
  *			       perf code: 0x03
@@ -87,7 +89,8 @@
  *			       Scope: Package (physical package)
  *	MSR_PKG_C10_RESIDENCY: Package C10 Residency Counter.
  *			       perf code: 0x06
- *			       Available model: HSW ULT,KBL,GLM,CNL,CML,ICL,TGL
+ *			       Available model: HSW ULT,KBL,GLM,CNL,CML,ICL,TGL,
+ *						TNT
  *			       Scope: Package (physical package)
  *
  */
@@ -640,8 +643,9 @@ static const struct x86_cpu_id intel_cstates_match[] __initconst = {
 
 	X86_CSTATES_MODEL(INTEL_FAM6_ATOM_GOLDMONT,   glm_cstates),
 	X86_CSTATES_MODEL(INTEL_FAM6_ATOM_GOLDMONT_D, glm_cstates),
-
 	X86_CSTATES_MODEL(INTEL_FAM6_ATOM_GOLDMONT_PLUS, glm_cstates),
+	X86_CSTATES_MODEL(INTEL_FAM6_ATOM_TREMONT_D, glm_cstates),
+	X86_CSTATES_MODEL(INTEL_FAM6_ATOM_TREMONT, glm_cstates),
 
 	X86_CSTATES_MODEL(INTEL_FAM6_ICELAKE_L, icl_cstates),
 	X86_CSTATES_MODEL(INTEL_FAM6_ICELAKE,   icl_cstates),
-- 
2.20.1



