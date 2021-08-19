Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6283F2215
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 23:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhHSVKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 17:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhHSVKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 17:10:19 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F0976108E;
        Thu, 19 Aug 2021 21:09:40 +0000 (UTC)
Date:   Thu, 19 Aug 2021 17:09:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        metze@samba.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracepoint: Use rcu get state and cond
 sync for static call" failed to apply to 5.10-stable tree
Message-ID: <20210819170933.5c4c6a38@oasis.local.home>
In-Reply-To: <1628500832155134@kroah.com>
References: <1628500832155134@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 09 Aug 2021 11:20:32 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

Crap.

Mathieu, seems that the "slow down 10x" patch was able to be backported
to 5.10, where as this patch was not. Reason being is that
start_poll_synchronize_rcu() was added in 5.13.

This means because the other patch was able to be backported without
this patch, we just slowed down disabling all events! Which may be a
surprise to some people not expecting a stable branch from having such
a big performance regression :-/

-- Steve
