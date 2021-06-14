Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEED3A6344
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhFNLLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234480AbhFNLJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB3EA6144F;
        Mon, 14 Jun 2021 10:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667605;
        bh=cG4FSOO0beayRGoWvWbRpqmXB9IzjkrB44QsfWCBHYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0B/ZbTXw/FRl+iyFxSkB1Q6U+e/OHhPO82bre+O+H+P9vF/Q2E7Do3UQI9N/Gkc6
         YvQ9Rp/qeE3btiOIwQC5TLPTpjS+NDd86SNXJtRU0JatMWjMYmR1XkeJUjl966Un3i
         gISwSKmGdRZNyEdVaCzYhZmZ8w83SErzGbL9OT1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, CodyYao-oc <CodyYao-oc@zhaoxin.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 117/131] x86/nmi_watchdog: Fix old-style NMI watchdog regression on old Intel CPUs
Date:   Mon, 14 Jun 2021 12:27:58 +0200
Message-Id: <20210614102656.994029648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: CodyYao-oc <CodyYao-oc@zhaoxin.com>

commit a8383dfb2138742a1bb77b481ada047aededa2ba upstream.

The following commit:

   3a4ac121c2ca ("x86/perf: Add hardware performance events support for Zhaoxin CPU.")

Got the old-style NMI watchdog logic wrong and broke it for basically every
Intel CPU where it was active. Which is only truly old CPUs, so few people noticed.

On CPUs with perf events support we turn off the old-style NMI watchdog, so it
was pretty pointless to add the logic for X86_VENDOR_ZHAOXIN to begin with ... :-/

Anyway, the fix is to restore the old logic and add a 'break'.

[ mingo: Wrote a new changelog. ]

Fixes: 3a4ac121c2ca ("x86/perf: Add hardware performance events support for Zhaoxin CPU.")
Signed-off-by: CodyYao-oc <CodyYao-oc@zhaoxin.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210607025335.9643-1-CodyYao-oc@zhaoxin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -63,7 +63,7 @@ static inline unsigned int nmi_perfctr_m
 		case 15:
 			return msr - MSR_P4_BPU_PERFCTR0;
 		}
-		fallthrough;
+		break;
 	case X86_VENDOR_ZHAOXIN:
 	case X86_VENDOR_CENTAUR:
 		return msr - MSR_ARCH_PERFMON_PERFCTR0;
@@ -96,7 +96,7 @@ static inline unsigned int nmi_evntsel_m
 		case 15:
 			return msr - MSR_P4_BSU_ESCR0;
 		}
-		fallthrough;
+		break;
 	case X86_VENDOR_ZHAOXIN:
 	case X86_VENDOR_CENTAUR:
 		return msr - MSR_ARCH_PERFMON_EVENTSEL0;


