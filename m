Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81ED81A20
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfHENAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfHENAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:00:23 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87700206C1;
        Mon,  5 Aug 2019 13:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010022;
        bh=kIuzPEzoAQvM9Uzt8oUxERvbNp9WuBy9kkAhfsoxQfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0WXj7LphRmsxrayQ/39HNFQ5aoQRrdtb5MvCFwMV7UJgfrg26+KPijqDAInP83KDd
         O68qTSwzLssidItVFnRLa+70bwx/bSxeFxucg9yxkbwA0u2xZLqJzQK1YKiwtavgaX
         dNjOsUWdRCQjDpIdx1VDuTtCFjdCsjmK1zsaYk1E=
Date:   Mon, 5 Aug 2019 14:00:18 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: compat: Allow single-byte
 watchpoints on all addresses" failed to apply to 4.4-stable tree
Message-ID: <20190805130017.zxm7ky6fuwgwmifs@willie-the-truck>
References: <1564983146189130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564983146189130@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 07:32:26AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Backport for 4.4, 4.9 and 4.14 below.

Will

--->8

From 4cf2e5aed205d7a3958e67b9fa1e76be64543b1b Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Mon, 29 Jul 2019 11:06:17 +0100
Subject: [PATCH] arm64: compat: Allow single-byte watchpoints on all addresses

commit 849adec41203ac5837c40c2d7e08490ffdef3c2c upstream.

Commit d968d2b801d8 ("ARM: 7497/1: hw_breakpoint: allow single-byte
watchpoints on all addresses") changed the validation requirements for
hardware watchpoints on arch/arm/. Update our compat layer to implement
the same relaxation.

Cc: <stable@vger.kernel.org> # 4.4.y, 4.9.y, 4.14.y
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/hw_breakpoint.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index eeebfc315526..036fbb959821 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -504,13 +504,14 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 			/* Aligned */
 			break;
 		case 1:
-			/* Allow single byte watchpoint. */
-			if (info->ctrl.len == ARM_BREAKPOINT_LEN_1)
-				break;
 		case 2:
 			/* Allow halfword watchpoints and breakpoints. */
 			if (info->ctrl.len == ARM_BREAKPOINT_LEN_2)
 				break;
+		case 3:
+			/* Allow single byte watchpoint. */
+			if (info->ctrl.len == ARM_BREAKPOINT_LEN_1)
+				break;
 		default:
 			return -EINVAL;
 		}
-- 
2.11.0

