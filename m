Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2608A29C127
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780335AbgJ0Oyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773192AbgJ0Ovn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF9A207DE;
        Tue, 27 Oct 2020 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810302;
        bh=dvIZLbACW+xwduXQBY5j9WoNudiInwnxg8U3A+qjvdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bT11fkTw2SFxjEgXtLBji1usA2ct+oGA2fSqlDGH7yuHxGuolOKNBclOjunVzwWVs
         ztibfVUmBM+oR43q1vjGlBNyH+A9zs1pyLNJRkvxIHrarX+HuMprrdwLRZrwHdQdEA
         wm19KfUIAjxisozZ1uZi+UXEXJokm0bVQDF+4cuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH 5.8 092/633] arm64: perf: Add missing ISB in armv8pmu_enable_counter()
Date:   Tue, 27 Oct 2020 14:47:15 +0100
Message-Id: <20201027135527.017508351@linuxfoundation.org>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

[ Upstream commit 490d7b7c0845eacf5593db333fd2ae7715416e16 ]

Writes to the PMXEVTYPER_EL0 register are not self-synchronising. In
armv8pmu_enable_event(), the PE can reorder configuring the event type
after we have enabled the counter and the interrupt. This can lead to an
interrupt being asserted because of the previous event type that we were
counting using the same counter, not the one that we've just configured.

The same rationale applies to writes to the PMINTENSET_EL1 register. The PE
can reorder enabling the interrupt at any point in the future after we have
enabled the event.

Prevent both situations from happening by adding an ISB just before we
enable the event counter.

Fixes: 030896885ade ("arm64: Performance counters support")
Reported-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Sumit Garg <sumit.garg@linaro.org> (Developerbox)
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20200924110706.254996-2-alexandru.elisei@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/perf_event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 581602413a130..c26d84ff0e224 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -510,6 +510,11 @@ static u32 armv8pmu_event_cnten_mask(struct perf_event *event)
 
 static inline void armv8pmu_enable_counter(u32 mask)
 {
+	/*
+	 * Make sure event configuration register writes are visible before we
+	 * enable the counter.
+	 * */
+	isb();
 	write_sysreg(mask, pmcntenset_el0);
 }
 
-- 
2.25.1



