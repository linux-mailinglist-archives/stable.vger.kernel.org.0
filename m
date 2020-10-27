Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556DC29B6A7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797485AbgJ0PXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797480AbgJ0PXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E001B2064B;
        Tue, 27 Oct 2020 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812228;
        bh=XBLdbZUf+DS/2+fvUEOHn/+m/1xPuSESQ1wuvtoRIaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4H9eV8ixHLLYpJyYR3dVnsUQWLxRRF++T429ODpxCdZJNeO91oKiqZtMoGxCjFU5
         /CPB0yeGhpayHl4Ow89FWyb22QoUL4aBSqI5GMrkXrZP0Fdf3NH+YsVhRNGhBo3ueb
         zq/DuVcAwO2RC7iut1On1CqBLFRMlo7j/opQ4l0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Libing Zhou <libing.zhou@nokia-sbell.com>,
        Borislav Petkov <bp@suse.de>,
        Changbin Du <changbin.du@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 109/757] x86/nmi: Fix nmi_handle() duration miscalculation
Date:   Tue, 27 Oct 2020 14:45:59 +0100
Message-Id: <20201027135455.670777020@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libing Zhou <libing.zhou@nokia-sbell.com>

[ Upstream commit f94c91f7ba3ba7de2bc8aa31be28e1abb22f849e ]

When nmi_check_duration() is checking the time an NMI handler took to
execute, the whole_msecs value used should be read from the @duration
argument, not from the ->max_duration, the latter being used to store
the current maximal duration.

 [ bp: Rewrite commit message. ]

Fixes: 248ed51048c4 ("x86/nmi: Remove irq_work from the long duration NMI handler")
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Libing Zhou <libing.zhou@nokia-sbell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Changbin Du <changbin.du@gmail.com>
Link: https://lkml.kernel.org/r/20200820025641.44075-1-libing.zhou@nokia-sbell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/nmi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 4fc9954a95600..47381666d6a55 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -102,7 +102,6 @@ fs_initcall(nmi_warning_debugfs);
 
 static void nmi_check_duration(struct nmiaction *action, u64 duration)
 {
-	u64 whole_msecs = READ_ONCE(action->max_duration);
 	int remainder_ns, decimal_msecs;
 
 	if (duration < nmi_longest_ns || duration < action->max_duration)
@@ -110,12 +109,12 @@ static void nmi_check_duration(struct nmiaction *action, u64 duration)
 
 	action->max_duration = duration;
 
-	remainder_ns = do_div(whole_msecs, (1000 * 1000));
+	remainder_ns = do_div(duration, (1000 * 1000));
 	decimal_msecs = remainder_ns / 1000;
 
 	printk_ratelimited(KERN_INFO
 		"INFO: NMI handler (%ps) took too long to run: %lld.%03d msecs\n",
-		action->handler, whole_msecs, decimal_msecs);
+		action->handler, duration, decimal_msecs);
 }
 
 static int nmi_handle(unsigned int type, struct pt_regs *regs)
-- 
2.25.1



