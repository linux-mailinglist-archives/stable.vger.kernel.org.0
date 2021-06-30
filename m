Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFF43B822B
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbhF3MeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234553AbhF3MeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:34:17 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE3561461;
        Wed, 30 Jun 2021 12:31:48 +0000 (UTC)
Date:   Wed, 30 Jun 2021 08:31:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paul Burton <paulburton@google.com>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
Message-ID: <20210630083146.7514cb1f@oasis.local.home>
In-Reply-To: <20210630003406.4013668-1-paulburton@google.com>
References: <20210630003406.4013668-1-paulburton@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Jun 2021 17:34:05 -0700
Paul Burton <paulburton@google.com> wrote:

> The tgid_map array records a mapping from pid to tgid, where the index
> of an entry within the array is the pid & the value stored at that index
> is the tgid.
> 
> The saved_tgids_next() function iterates over pointers into the tgid_map
> array & dereferences the pointers which results in the tgid, but then it
> passes that dereferenced value to trace_find_tgid() which treats it as a
> pid & does a further lookup within the tgid_map array. It seems likely
> that the intent here was to skip over entries in tgid_map for which the
> recorded tgid is zero, but instead we end up skipping over entries for
> which the thread group leader hasn't yet had its own tgid recorded in
> tgid_map.
> 
> A minimal fix would be to remove the call to trace_find_tgid, turning:
> 
>   if (trace_find_tgid(*ptr))
> 
> into:
> 
>   if (*ptr)
> 
> ..but it seems like this logic can be much simpler if we simply let
> seq_read() iterate over the whole tgid_map array & filter out empty
> entries by returning SEQ_SKIP from saved_tgids_show(). Here we take that
> approach, removing the incorrect logic here entirely.
> 
> Signed-off-by: Paul Burton <paulburton@google.com>
> Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Joel Fernandes <joelaf@google.com>
> Cc: <stable@vger.kernel.org>
> ---

Joel,

Can you review this please.

-- Steve
