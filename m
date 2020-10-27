Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3BB29B3BD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771553AbgJ0Oyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773243AbgJ0Ovv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FBD20773;
        Tue, 27 Oct 2020 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810310;
        bh=/yjX6vWPcSo7hUEymnALcsehntK9X15tfQ6E/cEgXA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbernrvZHu0RBjuEVfsT6+fgzliH1zY6sRfIf3IJ4tYA26srRGXuVxJNrHlDXnS0z
         quS5PYW3eEPrdp4IpjY2V44/bK11eCAdIZfK27zrLL3eXsvZLyShPdJs5xyI41cYXT
         QKR55G8ztSeqhILec6Osxxql9uQc9FcU42fMetHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 094/633] perf/x86/intel/uncore: Reduce the number of CBOX counters
Date:   Tue, 27 Oct 2020 14:47:17 +0100
Message-Id: <20201027135527.110071499@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit ee139385432e919f4d1f59b80edbc073cdae1391 ]

An oops is triggered by the fuzzy test.

[  327.853081] unchecked MSR access error: RDMSR from 0x70c at rIP:
0xffffffffc082c820 (uncore_msr_read_counter+0x10/0x50 [intel_uncore])
[  327.853083] Call Trace:
[  327.853085]  <IRQ>
[  327.853089]  uncore_pmu_event_start+0x85/0x170 [intel_uncore]
[  327.853093]  uncore_pmu_event_add+0x1a4/0x410 [intel_uncore]
[  327.853097]  ? event_sched_in.isra.118+0xca/0x240

There are 2 GP counters for each CBOX, but the current code claims 4
counters. Accessing the invalid registers triggers the oops.

Fixes: 6e394376ee89 ("perf/x86/intel/uncore: Add Intel Icelake uncore support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200925134905.8839-3-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index 300937cc8795b..3b70c2ff177c0 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -314,7 +314,7 @@ static struct intel_uncore_ops icl_uncore_msr_ops = {
 
 static struct intel_uncore_type icl_uncore_cbox = {
 	.name		= "cbox",
-	.num_counters   = 4,
+	.num_counters   = 2,
 	.perf_ctr_bits	= 44,
 	.perf_ctr	= ICL_UNC_CBO_0_PER_CTR0,
 	.event_ctl	= SNB_UNC_CBO_0_PERFEVTSEL0,
-- 
2.25.1



