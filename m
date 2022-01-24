Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB0497C3B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 10:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiAXJmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 04:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbiAXJkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 04:40:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D3AC061751
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 01:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9310CB80EE0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D4CC340E1;
        Mon, 24 Jan 2022 09:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643017233;
        bh=1tTifthnsni0ibQGbH3QAEgOXUWfWXejv0g3Rel0IPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E7xsq++9CDaupWmkEoZ2dsbsB2tuJLOA0UI/LEsILprLFIItElGeRRJVeSUi0/EuG
         Kx3BAXhsAl8E7GZKwBGFci9fB/ylPP7ybsZqDKzjYDWx7rWYPKAUj+/AwktMnU/ZoK
         wHEy2NIbrdj/gH0iSwqqw8l/nZjAw/Ocf0iLVK3Y=
Date:   Mon, 24 Jan 2022 10:40:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Cc:     bristot@kernel.org, rostedt@goodmis.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y] tracing/osnoise: Properly unhook events if
 start_per_cpu_kthreads() fails
Message-ID: <Ye50DfAHDBRE2Mdu@kroah.com>
References: <1642956398125157@kroah.com>
 <20220124053356.495768-1-nikita.yushchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124053356.495768-1-nikita.yushchenko@virtuozzo.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 08:33:57AM +0300, Nikita Yushchenko wrote:
> commit 0878355b51f5f26632e652c848a8e174bb02d22d upstream.
> 
> If start_per_cpu_kthreads() called from osnoise_workload_start() returns
> error, event hooks are left in broken state: unhook_irq_events() called
> but unhook_thread_events() and unhook_softirq_events() not called, and
> trace_osnoise_callback_enabled flag not cleared.
> 
> On the next tracer enable, hooks get not installed due to
> trace_osnoise_callback_enabled flag.
> 
> And on the further tracer disable an attempt to remove non-installed
> hooks happened, hitting a WARN_ON_ONCE() in tracepoint_remove_func().
> 
> Fix the error path by adding the missing part of cleanup.
> While at this, introduce osnoise_unhook_events() to avoid code
> duplication between this error path and normal tracer disable.
> 
> Link: https://lkml.kernel.org/r/20220109153459.3701773-1-nikita.yushchenko@virtuozzo.com
> 
> Cc: stable@vger.kernel.org
> Fixes: bce29ac9ce0b ("trace: Add osnoise tracer")
> Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> Signed-off-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_osnoise.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)

Now queued up, thanks.

greg k-h
