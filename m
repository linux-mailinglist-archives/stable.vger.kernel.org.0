Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D12331113A
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhBERtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233338AbhBEPyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:54:33 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4202064FFF;
        Fri,  5 Feb 2021 14:51:13 +0000 (UTC)
Date:   Fri, 5 Feb 2021 09:51:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Ivan Babrou <ivan@cloudflare.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/unwind/orc: Disable KASAN checking in the ORC
 unwinder, part 2
Message-ID: <20210205095111.2dba8515@gandalf.local.home>
In-Reply-To: <9583327904ebbbeda399eca9c56d6c7085ac20fe.1612534649.git.jpoimboe@redhat.com>
References: <cover.1612534649.git.jpoimboe@redhat.com>
        <9583327904ebbbeda399eca9c56d6c7085ac20fe.1612534649.git.jpoimboe@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  5 Feb 2021 08:24:02 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> KASAN reserves "redzone" areas between stack frames in order to detect
> stack overruns.  A read or write to such an area triggers a KASAN
> "stack-out-of-bounds" BUG.
> 
> Normally, the ORC unwinder stays in-bounds and doesn't access the
> redzone.  But sometimes it can't find ORC metadata for a given
> instruction.  This can happen for code which is missing ORC metadata, or
> for generated code.  In such cases, the unwinder attempts to fall back
> to frame pointers, as a best-effort type thing.
> 
> This fallback often works, but when it doesn't, the unwinder can get
> confused and go off into the weeds into the KASAN redzone, triggering
> the aforementioned KASAN BUG.
> 
> But in this case, the unwinder's confusion is actually harmless and
> working as designed.  It already has checks in place to prevent
> off-stack accesses, but those checks get short-circuited by the KASAN
> BUG.  And a BUG is a lot more disruptive than a harmless unwinder
> warning.
> 
> Disable the KASAN checks by using READ_ONCE_NOCHECK() for all stack
> accesses.  This finishes the job started by commit 881125bfe65b
> ("x86/unwind: Disable KASAN checking in the ORC unwinder"), which only
> partially fixed the issue.
> 
> Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
> Reported-by: Ivan Babrou <ivan@cloudflare.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
