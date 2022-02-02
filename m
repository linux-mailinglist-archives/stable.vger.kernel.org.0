Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7964A74F2
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 16:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345579AbiBBPuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 10:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345576AbiBBPuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 10:50:44 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFEAC06173E
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 07:50:44 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso6377285pjm.4
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 07:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=n2Bdj/sV7I9YYST/a6Ee+uQKpWStxnhqS6FCuPodXGI=;
        b=F3ZMKUgp1tN25A8goPns7uiIg6+q4JCdBIfHNcLOjskWhHLztZ3IOsMjBPb9EYpP41
         NlKix/zibD64RhL0/Gff9y2zuBiSFX5dVLWUOokhFGNetNeRL8JA3E8Ch2D5samJ+RdJ
         MQaWo7gjXWDOd3F40H32FV3yLyI+ehlw4QRy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=n2Bdj/sV7I9YYST/a6Ee+uQKpWStxnhqS6FCuPodXGI=;
        b=g6nHXQeG1UKHBPguFxDJXmXEBiOoVr6Xxkct5X0S0PGJnGXLENPCrsg4dXornEVhRs
         sAYCWRyfO/GGpjFgtgXRrxcwvpyXFmHIb3tDJAuZzFOV14S+eZjixVpc8uXIanTTB4Ar
         6re0cHQmTY8p6yAdRA64jrZbzwGSvf6l5Z3vZ7y7DdsPrmlVpgz9H8hcvZm9St/xkK0m
         o8/99iiCm5CnfmVYDpNMB+9tC2oKu18Y+4VWuPWEN0ZU3hNzyNUmxEGQzIqlwyjwNJCx
         W7+jvGxZNuOmfVDLy1/MkD04snDRGxPHgWJXRJfLRzkuWetyif195Zd7uar9jBY7mQtI
         yIcw==
X-Gm-Message-State: AOAM5327Gsi96XitloShiw3kkHeUV8Y7WDcs/stYFWS5n1NM9D/kIG2t
        95sC+Ri4bE+aii3hwTEZuNvelA==
X-Google-Smtp-Source: ABdhPJzOAbgWypiDTkn1zBlB8teQw5RfDJocPB4d/hP/ydQr3CtMkR74WzhAsep9R8qH82gACMoSuw==
X-Received: by 2002:a17:902:eacc:: with SMTP id p12mr31311692pld.123.1643817043774;
        Wed, 02 Feb 2022 07:50:43 -0800 (PST)
Received: from [127.0.0.1] (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h11sm14933953pfe.214.2022.02.02.07.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 07:50:43 -0800 (PST)
Date:   Wed, 02 Feb 2022 07:50:42 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Rich Felker <dalias@libc.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] exec: Force single empty string when argv is empty
User-Agent: K-9 Mail for Android
In-Reply-To: <20220201145324.GA29634@brightrain.aerifal.cx>
References: <20220201000947.2453721-1-keescook@chromium.org> <20220201145324.GA29634@brightrain.aerifal.cx>
Message-ID: <1A24DA4E-2B15-4A95-B2A1-F5F963E0CD6F@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On February 1, 2022 6:53:25 AM PST, Rich Felker <dalias@libc=2Eorg> wrote:
>On Mon, Jan 31, 2022 at 04:09:47PM -0800, Kees Cook wrote:
>> Quoting[1] Ariadne Conill:
>>=20
>> "In several other operating systems, it is a hard requirement that the
>> second argument to execve(2) be the name of a program, thus prohibiting
>> a scenario where argc < 1=2E POSIX 2017 also recommends this behaviour,
>> but it is not an explicit requirement[2]:
>>=20
>>     The argument arg0 should point to a filename string that is
>>     associated with the process being started by one of the exec
>>     functions=2E
>> =2E=2E=2E=2E
>> Interestingly, Michael Kerrisk opened an issue about this in 2008[3],
>> but there was no consensus to support fixing this issue then=2E
>> Hopefully now that CVE-2021-4034 shows practical exploitative use[4]
>> of this bug in a shellcode, we can reconsider=2E
>>=20
>> This issue is being tracked in the KSPP issue tracker[5]=2E"
>>=20
>> While the initial code searches[6][7] turned up what appeared to be
>> mostly corner case tests, trying to that just reject argv =3D=3D NULL
>> (or an immediately terminated pointer list) quickly started tripping[8]
>> existing userspace programs=2E
>>=20
>> The next best approach is forcing a single empty string into argv and
>> adjusting argc to match=2E The number of programs depending on argc =3D=
=3D 0
>> seems a smaller set than those calling execve with a NULL argv=2E
>>=20
>> Account for the additional stack space in bprm_stack_limits()=2E Inject=
 an
>> empty string when argc =3D=3D 0 (and set argc =3D 1)=2E Warn about the =
case so
>> userspace has some notice about the change:
>>=20
>>     process '=2E/argc0' launched '=2E/argc0' with NULL argv: empty stri=
ng added
>>=20
>> Additionally WARN() and reject NULL argv usage for kernel threads=2E
>>=20
>> [1] https://lore=2Ekernel=2Eorg/lkml/20220127000724=2E15106-1-ariadne@d=
ereferenced=2Eorg/
>> [2] https://pubs=2Eopengroup=2Eorg/onlinepubs/9699919799/functions/exec=
=2Ehtml
>> [3] https://bugzilla=2Ekernel=2Eorg/show_bug=2Ecgi?id=3D8408
>> [4] https://www=2Equalys=2Ecom/2022/01/25/cve-2021-4034/pwnkit=2Etxt
>> [5] https://github=2Ecom/KSPP/linux/issues/176
>> [6] https://codesearch=2Edebian=2Enet/search?q=3Dexecve%5C+*%5C%28%5B%5=
E%2C%5D%2B%2C+*NULL&literal=3D0
>> [7] https://codesearch=2Edebian=2Enet/search?q=3Dexeclp%3F%5Cs*%5C%28%5=
B%5E%2C%5D%2B%2C%5Cs*NULL&literal=3D0
>> [8] https://lore=2Ekernel=2Eorg/lkml/20220131144352=2EGE16385@xsang-Opt=
iPlex-9020/
>>=20
>> Reported-by: Ariadne Conill <ariadne@dereferenced=2Eorg>
>> Reported-by: Michael Kerrisk <mtk=2Emanpages@gmail=2Ecom>
>> Cc: Matthew Wilcox <willy@infradead=2Eorg>
>> Cc: Christian Brauner <brauner@kernel=2Eorg>
>> Cc: Rich Felker <dalias@libc=2Eorg>
>> Cc: Eric Biederman <ebiederm@xmission=2Ecom>
>> Cc: Alexander Viro <viro@zeniv=2Elinux=2Eorg=2Euk>
>> Cc: linux-fsdevel@vger=2Ekernel=2Eorg
>> Cc: stable@vger=2Ekernel=2Eorg
>> Signed-off-by: Kees Cook <keescook@chromium=2Eorg>
>> ---
>>  fs/exec=2Ec | 26 +++++++++++++++++++++++++-
>>  1 file changed, 25 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/fs/exec=2Ec b/fs/exec=2Ec
>> index 79f2c9483302=2E=2Ebbf3aadf7ce1 100644
>> --- a/fs/exec=2Ec
>> +++ b/fs/exec=2Ec
>> @@ -495,8 +495,14 @@ static int bprm_stack_limits(struct linux_binprm *=
bprm)
>>  	 * the stack=2E They aren't stored until much later when we can't
>>  	 * signal to the parent that the child has run out of stack space=2E
>>  	 * Instead, calculate it here so it's possible to fail gracefully=2E
>> +	 *
>> +	 * In the case of argc =3D 0, make sure there is space for adding a
>> +	 * empty string (which will bump argc to 1), to ensure confused
>> +	 * userspace programs don't start processing from argv[1], thinking
>> +	 * argc can never be 0, to keep them from walking envp by accident=2E
>> +	 * See do_execveat_common()=2E
>>  	 */
>> -	ptr_size =3D (bprm->argc + bprm->envc) * sizeof(void *);
>> +	ptr_size =3D (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
>
>From #musl:
>
><mixi> kees: shouldn't the min(bprm->argc, 1) be max(=2E=2E=2E) in your p=
atch?

Fix has already been sent, yup=2E

>I'm pretty sure without fixing that, you're introducing a giant vuln
>here=2E

I wouldn't say "giant", but yes, it weakened a defense in depth for avoidi=
ng high stack utilization=2E

> I believe this is the second time a patch attempting to fix this
>non-vuln has proposed adding a new vuln=2E=2E=2E

Mistakes happen, and that's why there is review and testing=2E Thank you f=
or being part of the review process! :)

-Kees

--=20
Kees Cook
