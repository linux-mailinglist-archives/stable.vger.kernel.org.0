Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BD38DB50
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfHNRGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbfHNRGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:06:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC028216F4;
        Wed, 14 Aug 2019 17:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802406;
        bh=BluXNTtUwEK0Jl4OaSu1C2M9EndSW854P3+bDniEGPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKMSgQydPzsYgasprJyWlgvOSLgQiP4py9QOh53n+PDE76iqJJdYwGc0S4vuMBY2P
         /3qkCmMoqBH8B4nj6OCexIILE+mhUhm7j7ilvN7kGszb1bNuQVNCocuHXPpe/jD4Cy
         R4mkLdalRJ6gmM9zpJ/G9c7FC0ZwOdmZXCEJUa9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunying Sun <yunying.sun@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, acme@kernel.org,
        alexander.shishkin@linux.intel.com, bp@alien8.de, hpa@zytor.com,
        jolsa@redhat.com, namhyung@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 113/144] perf/x86/intel: Fix invalid Bit 13 for Icelake MSR_OFFCORE_RSP_x register
Date:   Wed, 14 Aug 2019 19:01:09 +0200
Message-Id: <20190814165804.637162453@linuxfoundation.org>
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

[ Upstream commit 3b238a64c3009fed36eaea1af629d9377759d87d ]

The Intel SDM states that bit 13 of Icelake's MSR_OFFCORE_RSP_x
register is valid, and used for counting hardware generated prefetches
of L3 cache. Update the bitmask to allow bit 13.

Before:
$ perf stat -e cpu/event=0xb7,umask=0x1,config1=0x1bfff/u sleep 3
 Performance counter stats for 'sleep 3':
   <not supported>      cpu/event=0xb7,umask=0x1,config1=0x1bfff/u

After:
$ perf stat -e cpu/event=0xb7,umask=0x1,config1=0x1bfff/u sleep 3
 Performance counter stats for 'sleep 3':
             9,293      cpu/event=0xb7,umask=0x1,config1=0x1bfff/u

Signed-off-by: Yunying Sun <yunying.sun@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: acme@kernel.org
Cc: alexander.shishkin@linux.intel.com
Cc: bp@alien8.de
Cc: hpa@zytor.com
Cc: jolsa@redhat.com
Cc: namhyung@kernel.org
Link: https://lkml.kernel.org/r/20190724082932.12833-1-yunying.sun@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2889dd0235668..e9042e3f3052c 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -263,8 +263,8 @@ static struct event_constraint intel_icl_event_constraints[] = {
 };
 
 static struct extra_reg intel_icl_extra_regs[] __read_mostly = {
-	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3fffff9fffull, RSP_0),
-	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3fffff9fffull, RSP_1),
+	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3fffffbfffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3fffffbfffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
 	EVENT_EXTRA_END
-- 
2.20.1



