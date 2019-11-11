Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6926F7DCE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfKKSzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730623AbfKKSz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C994C21925;
        Mon, 11 Nov 2019 18:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498527;
        bh=WnFA7oiZERpmd60xOy6aeNpoUKb+ts+wqlxEfGaYfMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fv5LzZ3s8bnpisPX2cNhEUqgRHVEsNzuhzDgMMORRSi0U7bF0idy1H5LRq1MFC3qu
         KWtl6YTNNlIxQyE36YgksBNoU2StbLpVMfN4i6/rTIHbQrVZ7noOBrFkfX2ySzOvux
         Usi/Je2RfnGmts9AqwiVfdhQRjEB7iSgWkSMnfmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 144/193] perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus precise RIP validity
Date:   Mon, 11 Nov 2019 19:28:46 +0100
Message-Id: <20191111181511.780625977@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 317b96bb14303c7998dbcd5bc606bd8038fdd4b4 ]

The loop that reads all the IBS MSRs into *buf stopped one MSR short of
reading the IbsOpData register, which contains the RipInvalid status bit.

Fix the offset_max assignment so the MSR gets read, so the RIP invalid
evaluation is based on what the IBS h/w output, instead of what was
left in memory.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: d47e8238cd76 ("perf/x86-ibs: Take instruction pointer from ibs sample")
Link: https://lkml.kernel.org/r/20191023150955.30292-1-kim.phillips@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 5b35b7ea5d728..98ba21a588a15 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -614,7 +614,7 @@ fail:
 	if (event->attr.sample_type & PERF_SAMPLE_RAW)
 		offset_max = perf_ibs->offset_max;
 	else if (check_rip)
-		offset_max = 2;
+		offset_max = 3;
 	else
 		offset_max = 1;
 	do {
-- 
2.20.1



