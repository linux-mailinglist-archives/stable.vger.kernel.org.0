Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527A54728B0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhLMKOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241519AbhLMKEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:04:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3377C025493;
        Mon, 13 Dec 2021 01:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA7E9B80E3A;
        Mon, 13 Dec 2021 09:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C98C341C5;
        Mon, 13 Dec 2021 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389021;
        bh=XY+5QjQkfAzoqtBLjsjFlqQGFCZdy4KKgQnncCaeXJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEbyGa1UP2nxqRK0+x64xH3FSUvRVelv6k13NRmTrt76t16jEOT86NuuMgl7NFiN6
         diM6VlxrfSm9l3cgtqfq1JwE8U5zVt5jeDPAETA2YUO52lWsucoYjAAfGXgz8Cw17d
         SapVbV1/f2rFrpMrWPFtyvfAjadMMZo0Omqe9jHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 091/132] Documentation/locking/locktypes: Update migrate_disable() bits.
Date:   Mon, 13 Dec 2021 10:30:32 +0100
Message-Id: <20211213092942.231632373@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 6a631c0432dcccbcf45839016a07c015e335e9ae upstream.

The initial implementation of migrate_disable() for mainline was a
wrapper around preempt_disable(). RT kernels substituted this with
a real migrate disable implementation.

Later on mainline gained true migrate disable support, but the
documentation was not updated.

Update the documentation, remove the claims about migrate_disable()
mapping to preempt_disable() on non-PREEMPT_RT kernels.

Fixes: 74d862b682f51 ("sched: Make migrate_disable/enable() independent of RT")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211127163200.10466-2-bigeasy@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/locking/locktypes.rst |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/Documentation/locking/locktypes.rst
+++ b/Documentation/locking/locktypes.rst
@@ -439,11 +439,9 @@ preemption. The following substitution w
   spin_lock(&p->lock);
   p->count += this_cpu_read(var2);
 
-On a non-PREEMPT_RT kernel migrate_disable() maps to preempt_disable()
-which makes the above code fully equivalent. On a PREEMPT_RT kernel
 migrate_disable() ensures that the task is pinned on the current CPU which
 in turn guarantees that the per-CPU access to var1 and var2 are staying on
-the same CPU.
+the same CPU while the task remains preemptible.
 
 The migrate_disable() substitution is not valid for the following
 scenario::
@@ -456,9 +454,8 @@ scenario::
     p = this_cpu_ptr(&var1);
     p->val = func2();
 
-While correct on a non-PREEMPT_RT kernel, this breaks on PREEMPT_RT because
-here migrate_disable() does not protect against reentrancy from a
-preempting task. A correct substitution for this case is::
+This breaks because migrate_disable() does not protect against reentrancy from
+a preempting task. A correct substitution for this case is::
 
   func()
   {


