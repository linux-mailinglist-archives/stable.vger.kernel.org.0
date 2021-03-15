Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A942233B994
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhCOOGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233442AbhCOOBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A87A364F06;
        Mon, 15 Mar 2021 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816885;
        bh=hrGdOrt4gZVGQEqv/sHRyRlydI/WbwDZ6dUGMlUJots=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7oVyrgBAQTgUEV2LUzVDo3r/UsBxdHYI3T/DsiymS1uFpmbRrUv47/S/pwxZFacc
         QresNtEc5YaLDOX1P5jxyCiPev7pzUGnLZjAhRn6SkcZf9gnMzDZs7mymrc4CUvUs2
         AEx8U612RNZzNYN0xc7mFItDSEtiEyAo2no0ZyPE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.11 182/306] arm64: perf: Fix 64-bit event counter read truncation
Date:   Mon, 15 Mar 2021 14:54:05 +0100
Message-Id: <20210315135513.771484717@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Rob Herring <robh@kernel.org>

commit 7bb8bc6eb550116c504fb25af8678b9d7ca2abc5 upstream.

Commit 0fdf1bb75953 ("arm64: perf: Avoid PMXEV* indirection") changed
armv8pmu_read_evcntr() to return a u32 instead of u64. The result is
silent truncation of the event counter when using 64-bit counters. Given
the offending commit appears to have passed thru several folks, it seems
likely this was a bad rebase after v8.5 PMU 64-bit counters landed.

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: <stable@vger.kernel.org>
Fixes: 0fdf1bb75953 ("arm64: perf: Avoid PMXEV* indirection")
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20210310004412.1450128-1-robh@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -460,7 +460,7 @@ static inline int armv8pmu_counter_has_o
 	return pmnc & BIT(ARMV8_IDX_TO_COUNTER(idx));
 }
 
-static inline u32 armv8pmu_read_evcntr(int idx)
+static inline u64 armv8pmu_read_evcntr(int idx)
 {
 	u32 counter = ARMV8_IDX_TO_COUNTER(idx);
 


