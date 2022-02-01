Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80F74A5458
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiBABA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBABAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:00:55 -0500
Received: from mx1.mailbun.net (unknown [IPv6:2602:fd37:1::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A70BC061714;
        Mon, 31 Jan 2022 17:00:55 -0800 (PST)
Received: from [2607:fb90:d98b:8818:11f7:a587:ba64:9b06] (unknown [172.58.104.31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ariadne@dereferenced.org)
        by mx1.mailbun.net (Postfix) with ESMTPSA id 6562B11B603;
        Tue,  1 Feb 2022 01:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dereferenced.org;
        s=mailbun; t=1643677254;
        bh=vofBEbGEYkBffGz+fe8oMsX9AmKbLrhXNYF6gYB9zA4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=LzXawNxn5sShsRjZW+L97R2qySoeFoZ1c/gI9uSjQh8Xhol10J66MwRGSZ14EYYIs
         4Y6ftMOPBA7SJBTjzig0zQgHRwSa2HhAOpc0pituNUDGLz5mtUKFMGKlYivFfv9p2/
         KoNaS7i6azgh9CRmUsj/hEHMoWkVuX8cPeF9Z/+A0LmVhwN6kFu6VcheLZBsczn5PF
         FsVm+9GMNlYm/FJO50IA09buR4sSZ0U20yF5MCHqKvvyHvD6wbl+3N6pfYsfQNBeol
         0QNGHIIPfYo4uEYWw0zRa6xNiA/BEMFp0lTr2IeDEYwTb/HObU8drbCwuggQ96YEEv
         w+jVuOlhjNJtQ==
Date:   Mon, 31 Jan 2022 19:00:46 -0600 (CST)
From:   Ariadne Conill <ariadne@dereferenced.org>
To:     Kees Cook <keescook@chromium.org>
cc:     Andrew Morton <akpm@linux-foundation.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] exec: Force single empty string when argv is empty
In-Reply-To: <20220201000947.2453721-1-keescook@chromium.org>
Message-ID: <a4dba31f-b96-6220-58cd-16f05c65d113@dereferenced.org>
References: <20220201000947.2453721-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, 31 Jan 2022, Kees Cook wrote:

> Quoting[1] Ariadne Conill:
>
> "In several other operating systems, it is a hard requirement that the
> second argument to execve(2) be the name of a program, thus prohibiting
> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> but it is not an explicit requirement[2]:
>
>    The argument arg0 should point to a filename string that is
>    associated with the process being started by one of the exec
>    functions.
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

Yes, it's a shame this is the case, but we do what we have to do, I guess 
:)

>
> The next best approach is forcing a single empty string into argv and
> adjusting argc to match. The number of programs depending on argc == 0
> seems a smaller set than those calling execve with a NULL argv.
>
> Account for the additional stack space in bprm_stack_limits(). Inject an
> empty string when argc == 0 (and set argc = 1). Warn about the case so
> userspace has some notice about the change:
>
>    process './argc0' launched './argc0' with NULL argv: empty string added
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

In terms of going with this approach as an alternative verses my original 
patch,

Acked-by: Ariadne Conill <ariadne@dereferenced.org>

Ariadne
