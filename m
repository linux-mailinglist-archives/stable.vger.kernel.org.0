Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECAA413DF9A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgAPQIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:08:09 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46681 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgAPQIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:08:09 -0500
Received: by mail-ot1-f67.google.com with SMTP id r9so19821507otp.13
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 08:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDuFqql+JEz7x/898HzhnsGGGeg+dfg/2JIhrphhmK8=;
        b=QFapwm462FQoVQl/kr91qj9NPenciw8IdAY/MBoZZvB5FkBJouBJWY72zIhfjlXMmv
         tIh55LDJ59bntriovGTpODK8Uf1lsLIpRkIMnrBizZKw8h6XSfD44lOAKvSj9RDIOLrz
         Hj11BnlA6gcU2fYaq3nDBARDU1eYJy57jykhmVS3zZUKDgGCSrUdQQ+20Ow/B0xnu2/b
         rr34682IkCzR2ZeEQG/oanziSN6bJ0W/Q4/kX4MmaWCIeALT3IUF6RNwrGd8+ZN0KcOF
         qYHDBjrASd/RjsswAznOjdVVl9MIlAiBtrl8qH+9rGo7QG+VhXeND7bZxgNO67eKmdBz
         Dobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDuFqql+JEz7x/898HzhnsGGGeg+dfg/2JIhrphhmK8=;
        b=Hla4+JBMGdmtovpWY+mEtGtJ2p+jcdxA+A3yug98RvMCazyzFVMQemtv2oHCPpHKwV
         jCrm+ASZMqJo+PEPxXyiQU4Hxy4dYjAzNW+Yy6IP3uQWigt5Mx1hJBF65tXWknRLATOg
         8EhBhl1Xcw1SaxknaNe2e32S9ivsMEf4w2pNUHkaYMRz5dwGNZNtJJmyUxNL497FjoGh
         WQjDHqByOJ4tisShOLoLIbkSqXbUL7AIt8GC6/c/zhZkZTACFH5eQKptkkPAspGw9aFm
         EQGl64WklizmIR5aeAEOLbhIgSSruIRPiW0l3aPwlulDdW93T8W8rRhUp/tnGn757u8J
         DTYw==
X-Gm-Message-State: APjAAAU8MWRPgzdB5yFhIZJiQJbjse5nJNN5JTEmid3XZn/PCG7eoZHb
        Tnr69g2je9+3v5B9qFbdB6WXwm/jiHaFnmOYbVCxTA==
X-Google-Smtp-Source: APXvYqxQX9t8r7n1iRpGm0j4l9pOfa1uE5y26Y+Rg3OeezMPwD/NbD3sjZEpkA3QRPBTaGot1G4JzghIK9kWJ8Pzp1A=
X-Received: by 2002:a05:6830:44e:: with SMTP id d14mr2454184otc.228.1579190888095;
 Thu, 16 Jan 2020 08:08:08 -0800 (PST)
MIME-Version: 1.0
References: <20200115171736.16994-1-christian.brauner@ubuntu.com> <20200115172355.19209-1-christian.brauner@ubuntu.com>
In-Reply-To: <20200115172355.19209-1-christian.brauner@ubuntu.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 16 Jan 2020 17:07:42 +0100
Message-ID: <CAG48ez2LhxbnfF1Y6u_QhrqXcPKVQZyG6N9-GgSw1D6fLgsfwA@mail.gmail.com>
Subject: Re: [PATCH v2] ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     eparis@redhat.com, kernel list <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, shallyn@cisco.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 6:24 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> introduced the ability to opt out of audit messages for accesses to
> various proc files since they are not violations of policy.
> While doing so it somehow switched the check from ns_capable() to
> has_ns_capability{_noaudit}(). That means it switched from checking the
> subjective credentials of the task to using the objective credentials. I
> couldn't find the original lkml thread and so I don't know why this switch
> was done. But it seems wrong since ptrace_has_cap() is currently only used
> in ptrace_may_access(). And it's used to check whether the calling task
> (subject) has the CAP_SYS_PTRACE capability in the provided user namespace
> to operate on the target task (object). According to the cred.h comments
> this would mean the subjective credentials of the calling task need to be
> used.
> This switches it to use security_capable() because we only call
> ptrace_has_cap() in ptrace_may_access() and in there we already have a
> stable reference to the calling tasks creds under cred_guard_mutex so
> there's no need to go through another series of dereferences and rcu
> locking done in ns_capable{_noaudit}().

Reviewed-by: Jann Horn <jannh@google.com>
