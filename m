Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF342243043
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 22:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLU65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 16:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLU64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 16:58:56 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5FCB20774;
        Wed, 12 Aug 2020 20:58:55 +0000 (UTC)
Date:   Wed, 12 Aug 2020 16:58:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.7 5.8] tracing: Move pipe reference to trace array
 instead of current_tracer
Message-ID: <20200812165854.142bcfb0@oasis.local.home>
In-Reply-To: <20200812205259.229041-1-dann.frazier@canonical.com>
References: <20200812205259.229041-1-dann.frazier@canonical.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Aug 2020 14:52:59 -0600
dann frazier <dann.frazier@canonical.com> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> commit 7ef282e05132d56b6f6b71e3873f317664bea78b upstream
> 
> If a process has the trace_pipe open on a trace_array, the current tracer
> for that trace array should not be changed. This was original enforced by a
> global lock, but when instances were introduced, it was moved to the
> current_trace. But this structure is shared by all instances, and a
> trace_pipe is for a single instance. There's no reason that a process that
> has trace_pipe open on one instance should prevent another instance from
> changing its current tracer. Move the reference counter to the trace_array
> instead.
> 
> This is marked as "Fixes" but is more of a clean up than a true fix.
> Backport if you want, but its not critical.

A note to stable maintainers. I originally thought this was just a
clean up, but it was then found that it actually does fix a bug.

-- Steve


> 
> Fixes: cf6ab6d9143b1 ("tracing: Add ref count to tracer for when they are being read by pipe")
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
