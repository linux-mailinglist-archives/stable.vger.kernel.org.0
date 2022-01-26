Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41B649D20C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbiAZSs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:48:56 -0500
Received: from mx1.mailbun.net ([170.39.20.100]:35960 "EHLO mx1.mailbun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244249AbiAZSs4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 13:48:56 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2022 13:48:56 EST
Received: from [2607:fb90:d98b:8818:5079:94eb:24d5:e5c3] (unknown [172.58.104.31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ariadne@dereferenced.org)
        by mx1.mailbun.net (Postfix) with ESMTPSA id 5A0A111A9EF;
        Wed, 26 Jan 2022 18:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dereferenced.org;
        s=mailbun; t=1643222555;
        bh=B9sZSpn37qjYqPXp6j+5pKTlfv3WGOaoXVIWz/eiUKA=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=NTExFgBVmn5euHiNIO9blmd8dKdOHfl6aKpAYF4lhE1kKSgaBmzyc/diAbCOyE0dh
         hgQ6MG3BHKyfRg/iYLhI9RdkIbFhVftsLK3mzHbZwdr5pyTzKReIVL80ni27j4YYml
         d8r9oyUOqnF6nad4hvJB6sCrs/k93LyGCA8SXmIy3IWGVNo+YXvHYJOZGD6AUVlum9
         Corh5NXXh56eLZ2ByXVq9VNqpRAKYBpOkkbM0AqQ3t2Ytrv+Uyk8mwuoaxt3lVWaNh
         HB2kpDERbk+w1OupAd0SX8wyZ0WSbH1UcRKXnGl19BcK6TleK5Fw23zkL7MFefC4jt
         1cvAJE5YZdWDQ==
Date:   Wed, 26 Jan 2022 12:42:27 -0600 (CST)
From:   Ariadne Conill <ariadne@dereferenced.org>
To:     Jann Horn <jannh@google.com>
cc:     Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf: Add padding NULL when argc == 0
In-Reply-To: <CAG48ez3hN8+zNCmLVP0yU0A5op6BAS+A-rs05aiLm4RQvzzBpg@mail.gmail.com>
Message-ID: <a89bb47f-677f-4ce7-fd-d3893fe0abbd@dereferenced.org>
References: <20220126175747.3270945-1-keescook@chromium.org> <CAG48ez3hN8+zNCmLVP0yU0A5op6BAS+A-rs05aiLm4RQvzzBpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, 26 Jan 2022, Jann Horn wrote:

> On Wed, Jan 26, 2022 at 6:58 PM Kees Cook <keescook@chromium.org> wrote:
>> Quoting Ariadne Conill:
>>
>> "In several other operating systems, it is a hard requirement that the
>> first argument to execve(2) be the name of a program, thus prohibiting
>> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
>> but it is not an explicit requirement[1]:
>>
>>     The argument arg0 should point to a filename string that is
>>     associated with the process being started by one of the exec
>>     functions.
>> ...
>> Interestingly, Michael Kerrisk opened an issue about this in 2008[2],
>> but there was no consensus to support fixing this issue then.
>> Hopefully now that CVE-2021-4034 shows practical exploitative use[3]
>> of this bug in a shellcode, we can reconsider."
>>
>> An examination of existing[4] users of execve(..., NULL, NULL) shows
>> mostly test code, or example rootkit code. While rejecting a NULL argv
>> would be preferred, it looks like the main cause of userspace confusion
>> is an assumption that argc >= 1, and buggy programs may skip argv[0]
>> when iterating. To protect against userspace bugs of this nature, insert
>> an extra NULL pointer in argv when argc == 0, so that argv[1] != envp[0].
>>
>> Note that this is only done in the argc == 0 case because some userspace
>> programs expect to find envp at exactly argv[argc]. The overlap of these
>> two misguided assumptions is believed to be zero.
>
> Will this result in the executed program being told that argc==0 but
> having an extra NULL pointer on the stack?
> If so, I believe this breaks the x86-64 ABI documented at
> https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf - page 29,
> figure 3.9 describes the layout of the initial process stack.

I'm presently compiling a kernel with the patch to see if it works or not.

> Actually, does this even work? Can a program still properly access its
> environment variables when invoked with argc==0 with this patch
> applied? AFAIU the way userspace locates envv on x86-64 is by
> calculating 8*(argc+1)?

In the other thread, it was suggested that perhaps we should set up an 
argv of {"", NULL}.  In that case, it seems like it would be safe to claim 
argc == 1.

What do you think?

Ariadne
