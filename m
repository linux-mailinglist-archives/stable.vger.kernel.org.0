Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D371317201C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbgB0NxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731635AbgB0NxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:53:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17CC220578;
        Thu, 27 Feb 2020 13:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811587;
        bh=VRa34IfViZroycYjGfVtmgTTnuPf/AMVcnWpiULlePE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQu9FDQfZHIm3YvjWGZKdczzWW5GvmEs4DOME836vSQ3dOLoG+s/gLLi+KGz2gI2g
         ih8/9xXPsBgLHba2NJBCaXF5PDqAkwMN0seRljc9s1NhHHRd2+iJnBmz22NhuLPJVP
         GSUULGNyZCfEQfDo8K9qOyQq/+vqJud8nrbkLM4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.14 024/237] perf/x86/amd: Add missing L2 misses event spec to AMD Family 17hs event map
Date:   Thu, 27 Feb 2020 14:33:58 +0100
Message-Id: <20200227132258.085471347@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 25d387287cf0330abf2aad761ce6eee67326a355 upstream.

Commit 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h"),
claimed L2 misses were unsupported, due to them not being found in its
referenced documentation, whose link has now moved [1].

That old documentation listed PMCx064 unit mask bit 3 as:

    "LsRdBlkC: LS Read Block C S L X Change to X Miss."

and bit 0 as:

    "IcFillMiss: IC Fill Miss"

We now have new public documentation [2] with improved descriptions, that
clearly indicate what events those unit mask bits represent:

Bit 3 now clearly states:

    "LsRdBlkC: Data Cache Req Miss in L2 (all types)"

and bit 0 is:

    "IcFillMiss: Instruction Cache Req Miss in L2."

So we can now add support for L2 misses in perf's genericised events as
PMCx064 with both the above unit masks.

[1] The commit's original documentation reference, "Processor Programming
    Reference (PPR) for AMD Family 17h Model 01h, Revision B1 Processors",
    originally available here:

        https://www.amd.com/system/files/TechDocs/54945_PPR_Family_17h_Models_00h-0Fh.pdf

    is now available here:

        https://developer.amd.com/wordpress/media/2017/11/54945_PPR_Family_17h_Models_00h-0Fh.pdf

[2] "Processor Programming Reference (PPR) for Family 17h Model 31h,
    Revision B0 Processors", available here:

	https://developer.amd.com/wp-content/resources/55803_0.54-PUB.pdf

Fixes: 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h")
Reported-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Babu Moger <babu.moger@amd.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200121171232.28839-1-kim.phillips@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/amd/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -245,6 +245,7 @@ static const u64 amd_f17h_perfmon_event_
 	[PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
 	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
 	[PERF_COUNT_HW_CACHE_REFERENCES]	= 0xff60,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x0964,
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
 	[PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x0287,


