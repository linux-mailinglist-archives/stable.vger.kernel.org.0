Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8B54A5D5C
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 14:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbiBANWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 08:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbiBANWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 08:22:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6924FC061714;
        Tue,  1 Feb 2022 05:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D69BB82DE3;
        Tue,  1 Feb 2022 13:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F364C340EB;
        Tue,  1 Feb 2022 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643721760;
        bh=GBHBnprdZykprL9bYedIbto9NFGIskkFqjHe8SWv3Q4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oly/voj/i5cunpQSgrBjwHxTPjdu/Ry1YmPmDQQilRTI/jae0x2lkjDzXth7y3Cth
         GiWYi3DlnRivMWntEqMmQ6/8G5Yg/7q8Wo9M34wfLPmyYU144voTytNLmaAnHc8U6o
         LOX3rLghu9HAIemc879REFufbxxaLmqqgJuW2T5xuRjZ+EA6LGNcYeXaoNhZpfrowO
         ptKvtOQkNy6p+Uz5Pfrw+OqVuPINZRpf9VNJ9GEEKicBxcxODRsqPtQIJQdP/7dixQ
         iqLBYfbPyzwreG8Ysz/Yivwfwuz4Jq5yhMXrW4nXsJtSlS8/9RkfIyG5xOEUlC5fz3
         TkjlRq4zqqVTQ==
Date:   Tue, 1 Feb 2022 14:22:35 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] exec: Force single empty string when argv is empty
Message-ID: <20220201132235.c7yk7rpngpvcw5z3@wittgenstein>
References: <20220201000947.2453721-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220201000947.2453721-1-keescook@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 04:09:47PM -0800, Kees Cook wrote:
> Quoting[1] Ariadne Conill:
> 
> "In several other operating systems, it is a hard requirement that the
> second argument to execve(2) be the name of a program, thus prohibiting
> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> but it is not an explicit requirement[2]:
> 
>     The argument arg0 should point to a filename string that is
>     associated with the process being started by one of the exec
>     functions.
> ...
> Interestingly, Michael Kerrisk opened an issue about this in 2008[3],
> but there was no consensus to support fixing this issue then.
> Hopefully now that CVE-2021-4034 shows practical exploitative use[4]
> of this bug in a shellcode, we can reconsider.
> 
> This issue is being tracked in the KSPP issue tracker[5]."
> 
> While the initial code searches[6][7] turned up what appeared to be
> mostly corner case tests, trying to that just reject argv == NULL
> (or an immediately terminated pointer list) quickly started tripping[8]
> existing userspace programs.
> 
> The next best approach is forcing a single empty string into argv and
> adjusting argc to match. The number of programs depending on argc == 0
> seems a smaller set than those calling execve with a NULL argv.
> 
> Account for the additional stack space in bprm_stack_limits(). Inject an
> empty string when argc == 0 (and set argc = 1). Warn about the case so
> userspace has some notice about the change:
> 
>     process './argc0' launched './argc0' with NULL argv: empty string added
> 
> Additionally WARN() and reject NULL argv usage for kernel threads.
> 
> [1] https://lore.kernel.org/lkml/20220127000724.15106-1-ariadne@dereferenced.org/
> [2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=8408
> [4] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
> [5] https://github.com/KSPP/linux/issues/176
> [6] https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
> [7] https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0
> [8] https://lore.kernel.org/lkml/20220131144352.GE16385@xsang-OptiPlex-9020/
> 
> Reported-by: Ariadne Conill <ariadne@dereferenced.org>
> Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Looks good,
Acked-by: Christian Brauner <brauner@kernel.org>
