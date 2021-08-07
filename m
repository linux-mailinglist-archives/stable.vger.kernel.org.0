Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22493E3291
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 03:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhHGBSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 21:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhHGBSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 21:18:32 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B81461186;
        Sat,  7 Aug 2021 01:18:15 +0000 (UTC)
Date:   Fri, 6 Aug 2021 21:18:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tracing: define needed config DYNAMIC_FTRACE_WITH_ARGS
Message-ID: <20210806211808.6d927880@oasis.local.home>
In-Reply-To: <20210806195027.16808-1-lukas.bulwahn@gmail.com>
References: <20210806195027.16808-1-lukas.bulwahn@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  6 Aug 2021 21:50:27 +0200
Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:

> Commit 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of
> REGS when ARGS is available") intends to enable config LIVEPATCH when
> ftrace with ARGS is available. However, the chain of configs to enable
> LIVEPATCH is incomplete, as HAVE_DYNAMIC_FTRACE_WITH_ARGS is available,
> but the definition of DYNAMIC_FTRACE_WITH_ARGS, combining DYNAMIC_FTRACE
> and HAVE_DYNAMIC_FTRACE_WITH_ARGS, needed to enable LIVEPATCH, is missing
> in the commit.
> 
> Fortunately, ./scripts/checkkconfigsymbols.py detects this and warns:
> 
> DYNAMIC_FTRACE_WITH_ARGS
> Referencing files: kernel/livepatch/Kconfig
> 
> So, define the config DYNAMIC_FTRACE_WITH_ARGS analogously to the already
> existing similar configs, DYNAMIC_FTRACE_WITH_REGS and
> DYNAMIC_FTRACE_WITH_DIRECT_CALLS, in ./kernel/trace/Kconfig to connect the
> chain of configs.
> 
> Fixes: 2860cd8a2353 ("livepatch: Use the default ftrace_ops instead of REGS when ARGS is available")
> Cc: <stable@vger.kernel.org> # 5.10.x

FYI, we don't add # 5.10.x anymore. The Fixes tag above is what
determines where it gets backported to.

> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> 
> Steven, thanks for the quick response; please pick this quick config fix.

I placed it in my queue to go into the 5.14-rc cycle.

Since this affects live kernel patching, can I get a Tested-by from one
of the live kernel patching  folks?

Thanks!

-- Steve
