Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B673B3C5104
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345107AbhGLHgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243302AbhGLHde (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:33:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FE0561132;
        Mon, 12 Jul 2021 07:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075045;
        bh=rcMWKjnOz5x+MWZvUufn6ZR0qZGG4sgmNJRoQX0w/vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gj5U1tEPUdeZmZBsCX6TdTz05nPHVdSuCxJkL44aZetDh03ShIFqsaOXX5linIhjw
         24Lo/WD+2xgzNIcoL+oHYYhQFQ5q7QtX2rIrNFy6t8e3VLwDZAPoUK91IPyuVHTCQz
         I4kcOVAi5Qp8gv+YXTFBsDMpt1EMzExehfnrSlJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Jihong <yangjihong1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.13 043/800] arm_pmu: Fix write counter incorrect in ARMv7 big-endian mode
Date:   Mon, 12 Jul 2021 08:01:06 +0200
Message-Id: <20210712060919.411632040@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

commit fdbef8c4e68ad423416aa6cc93d1616d6f8ac5b3 upstream.

Commit 3a95200d3f89 ("arm_pmu: Change API to support 64bit counter values")
changes the input "value" type from 32-bit to 64-bit, which introduces the
following problem: ARMv7 PMU counters is 32-bit width, in big-endian mode,
write counter uses high 32-bit, which writes an incorrect value.

Before:

 Performance counter stats for 'ls':

              2.22 msec task-clock                #    0.675 CPUs utilized
                 0      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                49      page-faults               #    0.022 M/sec
        2150476593      cycles                    #  966.663 GHz
        2148588788      instructions              #    1.00  insn per cycle
        2147745484      branches                  # 965435.074 M/sec
        2147508540      branch-misses             #   99.99% of all branches

None of the above hw event counters are correct.

Solution:

"value" forcibly converted to 32-bit type before being written to PMU register.

After:

 Performance counter stats for 'ls':

              2.09 msec task-clock                #    0.681 CPUs utilized
                 0      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                46      page-faults               #    0.022 M/sec
           2807301      cycles                    #    1.344 GHz
           1060159      instructions              #    0.38  insn per cycle
            250496      branches                  #  119.914 M/sec
             23192      branch-misses             #    9.26% of all branches

Fixes: 3a95200d3f89 ("arm_pmu: Change API to support 64bit counter values")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210430012659.232110-1-yangjihong1@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event_v7.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -773,10 +773,10 @@ static inline void armv7pmu_write_counte
 		pr_err("CPU%u writing wrong counter %d\n",
 			smp_processor_id(), idx);
 	} else if (idx == ARMV7_IDX_CYCLE_COUNTER) {
-		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" (value));
+		asm volatile("mcr p15, 0, %0, c9, c13, 0" : : "r" ((u32)value));
 	} else {
 		armv7_pmnc_select_counter(idx);
-		asm volatile("mcr p15, 0, %0, c9, c13, 2" : : "r" (value));
+		asm volatile("mcr p15, 0, %0, c9, c13, 2" : : "r" ((u32)value));
 	}
 }
 


