Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C333B49D3CC
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 21:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiAZUqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 15:46:23 -0500
Received: from mx1.mailbun.net ([170.39.20.100]:42882 "EHLO mx1.mailbun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbiAZUqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 15:46:23 -0500
Received: from [2607:fb90:d98b:8818:5079:94eb:24d5:e5c3] (unknown [172.58.104.31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ariadne@dereferenced.org)
        by mx1.mailbun.net (Postfix) with ESMTPSA id 660281029F2;
        Wed, 26 Jan 2022 20:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dereferenced.org;
        s=mailbun; t=1643229983;
        bh=F8wCk/NyUAzIdnRmsKCm4QEKnB2JLGsv/olNhoue6DY=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=J6Johoj5XjsytkFMCIbO4nFebCWDZZDOaC/XOmNeRRdiJVaG6lVhJ4UvCylzXjEZM
         TrR/aUf6/EPqLcAKxp83hm25qMfiYI898ZPXqi5nUjAmLb4FAt55jxwkfjJ6+i4CDD
         owqe2wtKEOZqLsY5G0N6eVl39/XOMLuDjhuhsAg8wXnJou4QVnQ/tKgu3UdisThYPi
         jdqfyOkhYlo6bao36c9IDZ9c1p06iBVEEY6hs78OfNwsQ/ixKbHMZlU5cTrn0lcls4
         3jnap/kbWuiizhpyn9Jp3NNDj+yMG6CWjuoWYhiTP+M33b+XHy3IzZp3/TfVJinMsc
         mNEdlWq3mpbVw==
Date:   Wed, 26 Jan 2022 14:46:15 -0600 (CST)
From:   Ariadne Conill <ariadne@dereferenced.org>
To:     Ariadne Conill <ariadne@dereferenced.org>
cc:     Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf: Add padding NULL when argc == 0
In-Reply-To: <af7838bd-4cc1-fc2c-6cb9-8ddd65d5f96@dereferenced.org>
Message-ID: <4df29574-b147-d42d-45f5-a57082d6a2ed@dereferenced.org>
References: <20220126175747.3270945-1-keescook@chromium.org> <af7838bd-4cc1-fc2c-6cb9-8ddd65d5f96@dereferenced.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, 26 Jan 2022, Ariadne Conill wrote:

> Hi,
>
> On Wed, 26 Jan 2022, Kees Cook wrote:
>
>> Quoting Ariadne Conill:
>> 
>> "In several other operating systems, it is a hard requirement that the
>> first argument to execve(2) be the name of a program, thus prohibiting
>> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
>> but it is not an explicit requirement[1]:
>>
>>    The argument arg0 should point to a filename string that is
>>    associated with the process being started by one of the exec
>>    functions.
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
>> 
>> [1] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
>> [2] https://bugzilla.kernel.org/show_bug.cgi?id=8408
>> [3] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
>> [4] 
>> https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
>> 
>> Reported-by: Ariadne Conill <ariadne@dereferenced.org>
>> Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: Rich Felker <dalias@libc.org>
>> Cc: Eric Biederman <ebiederm@xmission.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Tested-by: Ariadne Conill <ariadne@dereferenced.org>
>
> It seems to work, but I still think bailing early with -EINVAL is a more 
> reasonable position to take.  For example, the following code, when used with 
> BusyBox applets results in a segfault, as the multicall stub does not support 
> scenarios where argc < 1:
>
> #include <stdio.h>
> #include <unistd.h>
> #include <sys/syscall.h>
>
> int main(int argc, const char **argv) {
>        if (syscall(SYS_execve, "/bin/date", NULL, NULL) < 0)
>                perror("execve");
>        return 0;
> }
>

Further testing indicates that while things *mostly* work, it results in 
memory corruption in various tasks, for example, trying to build a new 
kernel hung, and the gcc process's name was a bunch of uninitialized 
memory.  So, I don't think { NULL, NULL } is a good way to go.

Ariadne
