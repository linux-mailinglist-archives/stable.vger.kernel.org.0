Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4EB451187
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbhKOTJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243961AbhKOTHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 14:07:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637003060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v/SBXUx2gshVEpRR5lkDqOIRh1bD4WZmOak2pzCj75s=;
        b=CI+RBIVCNAGb7wL9M+nRNMMmRAezEua6e/g7R20OS0FeZQTCD2CC1A6rYMFkFJw3Lk5GFv
        e7sU5mUq5yW3DnnKwdkblnkjpJrelGP34BXl1Mw6pEaTLTfr7qrsvLetiklzFaJyzgVXlC
        a9aF434o1u198t13DZSymtSjfAgGT6I=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-m5aVwxgUPWyy9xU-5cVZ5g-1; Mon, 15 Nov 2021 14:04:19 -0500
X-MC-Unique: m5aVwxgUPWyy9xU-5cVZ5g-1
Received: by mail-yb1-f199.google.com with SMTP id b15-20020a25ae8f000000b005c20f367790so28282059ybj.2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 11:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/SBXUx2gshVEpRR5lkDqOIRh1bD4WZmOak2pzCj75s=;
        b=ULN6KQaFf/pqUxcM7CWIdPH/ouenB5GrYCUJh3sEc2LYaoZfpCv9+X755kNitASc+f
         If555pQCGKHasPqlR+2W8uH8u3bOKTiK8xKtfgHA0LFL5GEujUniLQ/JoG5+T+wK2QCg
         Uh94lwamTE1+uIQRjGpVdf/ln9Z/CmhU4jghLdo+Pr/6Gr3T7k5gnrKNe6VvPQNg5vU7
         t97SBgGJIdSXBB0xmddMX9q7zjlCm9txCeMrrV/N96sPHmpCZqpVB3DVoSjy3GJtL0bQ
         dn+ZRjjkMG4PgEQ1bVcltBO3Z26ckdJ4ByP9AQjYHTI+pgBzTtReyI0B5TInamkmT7LI
         RiFg==
X-Gm-Message-State: AOAM530GtsC79JNHxyMU9/0WFW1UyEXTcT/aPNMLTKLSugXrRz6ozXCI
        N+5t94fch30XCu18nhe1cOv3y/J9MX+csGLF6siIY1p7VlnULM5gCzolpdJ6NdkUN0nrXG3TTEQ
        KBZULcJUDjLg91wtF/n0qdV1qynzeCBHn
X-Received: by 2002:a25:3283:: with SMTP id y125mr1233683yby.479.1637003058346;
        Mon, 15 Nov 2021 11:04:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDg/2EKuxykc6+iQIz1Ve049nNfAryXwGXOETwxe8O1IwCanztgTBfr04ISJwL8oujwWmHkrKy78vI+kFMlCQ=
X-Received: by 2002:a25:3283:: with SMTP id y125mr1233623yby.479.1637003057823;
 Mon, 15 Nov 2021 11:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20211115173850.3598768-1-adelva@google.com>
In-Reply-To: <20211115173850.3598768-1-adelva@google.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 15 Nov 2021 20:04:05 +0100
Message-ID: <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
Subject: Re: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
To:     Alistair Delva <adelva@google.com>
Cc:     Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 7:14 PM Alistair Delva <adelva@google.com> wrote:
> Booting to Android userspace on 5.14 or newer triggers the following
> SELinux denial:
>
> avc: denied { sys_nice } for comm="init" capability=23
>      scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
>      permissive=0
>
> Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
> better compatibility with older SEPolicy, check ADMIN before NICE.

But with this patch you in turn punish the new/better policies that
try to avoid giving domains CAP_SYS_ADMIN unless necessary (using only
the more granular capabilities wherever possible), which may now get a
bogus sys_admin denial. IMHO the order is better as it is, as it
motivates the "good" policy writing behavior - i.e. spelling out the
capability permissions more explicitly and avoiding CAP_SYS_ADMIN.

IOW, if you domain does CAP_SYS_NICE things, and you didn't explicitly
grant it that (and instead rely on the CAP_SYS_ADMIN fallback), then
the denial correctly flags it as an issue in your policy and
encourages you to add that sys_nice permission to the domain. Then
when one beautiful hypothetical day the CAP_SYS_ADMIN fallback is
removed, your policy will be ready for that and things will keep
working.

Feel free to carry that patch downstream if patching the kernel is
easier for you than fixing the policy, but for the upstream kernel
this is just a step in the wrong direction.

>
> Fixes: 9d3a39a5f1e4 ("block: grant IOPRIO_CLASS_RT to CAP_SYS_NICE")
> Signed-off-by: Alistair Delva <adelva@google.com>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: selinux@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org # v5.14+
> ---
>  block/ioprio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/ioprio.c b/block/ioprio.c
> index 0e4ff245f2bf..4d59c559e057 100644
> --- a/block/ioprio.c
> +++ b/block/ioprio.c
> @@ -69,7 +69,7 @@ int ioprio_check_cap(int ioprio)
>
>         switch (class) {
>                 case IOPRIO_CLASS_RT:
> -                       if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
> +                       if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
>                                 return -EPERM;
>                         fallthrough;
>                         /* rt has prio field too */
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

