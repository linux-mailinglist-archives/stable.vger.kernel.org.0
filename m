Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13533F2427
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 02:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhHTAmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 20:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233644AbhHTAmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 20:42:44 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62532610A5;
        Fri, 20 Aug 2021 00:42:06 +0000 (UTC)
Date:   Thu, 19 Aug 2021 20:42:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        metze@samba.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracepoint: Use rcu get state and cond
 sync for static call" failed to apply to 5.10-stable tree
Message-ID: <20210819204204.00f9ad28@rorschach.local.home>
In-Reply-To: <20210819170933.5c4c6a38@oasis.local.home>
References: <1628500832155134@kroah.com>
        <20210819170933.5c4c6a38@oasis.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Aug 2021 17:09:33 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Mathieu, seems that the "slow down 10x" patch was able to be backported
> to 5.10, where as this patch was not. Reason being is that
> start_poll_synchronize_rcu() was added in 5.13.

I can get this to work if I backport the following RCU patches:

29d2bb94a8a126ce80ffbb433b648b32fdea524e
srcu: Provide internal interface to start a Tree SRCU grace period

5358c9fa54b09b5d3d7811b033aa0838c1bbaaf2
srcu: Provide polling interfaces for Tree SRCU grace periods

1a893c711a600ab57526619b56e6f6b7be00956e
srcu: Provide internal interface to start a Tiny SRCU grace period

8b5bd67cf6422b63ee100d76d8de8960ca2df7f0
srcu: Provide polling interfaces for Tiny SRCU grace periods

The first three can be cherry-picked without issue. The last one has a
small conflict, of:

include/linux/srcutiny.h.rej:
--- include/linux/srcutiny.h
+++ include/linux/srcutiny.h
@@ -16,6 +16,7 @@
 struct srcu_struct {
        short srcu_lock_nesting[2];     /* srcu_read_lock() nesting depth. */
        unsigned short srcu_idx;        /* Current reader array element in bit 0x2. */
+       unsigned short srcu_idx_max;    /* Furthest future srcu_idx request. */
        u8 srcu_gp_running;             /* GP workqueue running? */
        u8 srcu_gp_waiting;             /* GP waiting for readers? */
        struct swait_queue_head srcu_wq;


Which I just added that line, and everything worked.

Paul, do you have any issues with these four patches getting backported?

Greg, Are you OK with them too?

Once those are backported, this patch can be backported as well, and
everything should work. This patch really needs to stay with:

231264d6927f6740af36855a622d0e240be9d94c
tracepoint: Fix static call function vs data state mismatch

Otherwise I would say to revert it if this one can't be backported with
it.

-- Steve
