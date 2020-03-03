Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9589C1780B1
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733279AbgCCR6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:58:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732661AbgCCR6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C29C020656;
        Tue,  3 Mar 2020 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258291;
        bh=cnid36DS5aI6TzXGB8aHNni9i5ItBK61vhrHUwmm3Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+6QXM8JW/PKvuo9ImyMst5zg26XL/96qB2opFPL27xMatBUYrKZpF0hw+ryr6Ji8
         Fxfv1T+2I6Bxxasfks1XUtWklRu5vw2LS29k36qFbXmA4kaE0CFAe/t05fuZ6ufkx9
         fUkNsUdtQIKwqPoLvJT7osAWqWCj7vji70qk3S4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.4 146/152] locking/lockdep: Fix lockdep_stats indentation problem
Date:   Tue,  3 Mar 2020 18:44:04 +0100
Message-Id: <20200303174319.397527559@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit a030f9767da1a6bbcec840fc54770eb11c2414b6 upstream.

It was found that two lines in the output of /proc/lockdep_stats have
indentation problem:

  # cat /proc/lockdep_stats
     :
   in-process chains:                   25057
   stack-trace entries:                137827 [max: 524288]
   number of stack traces:        7973
   number of stack hash chains:   6355
   combined max dependencies:      1356414598
   hardirq-safe locks:                     57
   hardirq-unsafe locks:                 1286
     :

All the numbers displayed in /proc/lockdep_stats except the two stack
trace numbers are formatted with a field with of 11. To properly align
all the numbers, a field width of 11 is now added to the two stack
trace numbers.

Fixes: 8c779229d0f4 ("locking/lockdep: Report more stack trace statistics")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lkml.kernel.org/r/20191211213139.29934-1-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/locking/lockdep_proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -286,9 +286,9 @@ static int lockdep_stats_show(struct seq
 	seq_printf(m, " stack-trace entries:           %11lu [max: %lu]\n",
 			nr_stack_trace_entries, MAX_STACK_TRACE_ENTRIES);
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING)
-	seq_printf(m, " number of stack traces:        %llu\n",
+	seq_printf(m, " number of stack traces:        %11llu\n",
 		   lockdep_stack_trace_count());
-	seq_printf(m, " number of stack hash chains:   %llu\n",
+	seq_printf(m, " number of stack hash chains:   %11llu\n",
 		   lockdep_stack_hash_count());
 #endif
 	seq_printf(m, " combined max dependencies:     %11u\n",


