Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98EBCAC914
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 21:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391857AbfIGTuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 15:50:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42642 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbfIGTuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 15:50:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id c9so11229705qth.9;
        Sat, 07 Sep 2019 12:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=br9UBkhsYmfKwHbwURIhiwHEx2D7U37IxyJBS+CBOqM=;
        b=pnwv4tuNZ+rEoKqdMq2my6Lgk3lrXCDFBGRsI6LurPfHJ4PX5UCB5eCwCyy7drhdHT
         +jdBo55/BV69ZL7tEJUHbos+aX4Kd+oobPzlu5lLflTJ+0v1vXdup9qcKA6RmnoKFtHc
         UQG+I/EOi/gnIdkAFRfTZTp6rnb4zGbOxUTVVAL4RvQWVSI/Gshd8q9myh9zG7wnl+kM
         j7dk59crHqSqLAR35EIbfYGDzGQClYfVlqeDCv7Nv0ED4d9rs8DKjEaRQoLWuorcbNbq
         HpQX+D+MzKUIVy1avW5+sduNyrTIKsMiE0lL9Xc4MuX55C2rskapH5rCNS75/d+J7Dry
         Xzgw==
X-Gm-Message-State: APjAAAVBum+N26AnvuxgHDiUpD20YN/AWWFkENGnDsPflk63+F/6sFoF
        3+5A8bz9r4Sh5hzZcVLoj727K5Rq3OO4fMRmYEMfLkmoOlY=
X-Google-Smtp-Source: APXvYqyl+z2FYOtULkvTxobEJ/eyXJNphR9eq/S4BLy0tFekKn44sikIPCRSd1Di8uSwbGOfr/NMwGERySpoQo3jO4I=
X-Received: by 2002:ac8:342a:: with SMTP id u39mr15931998qtb.7.1567885809360;
 Sat, 07 Sep 2019 12:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190905152155.1392871-1-arnd@arndb.de> <20190905152155.1392871-2-arnd@arndb.de>
In-Reply-To: <20190905152155.1392871-2-arnd@arndb.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 7 Sep 2019 21:49:53 +0200
Message-ID: <CAK8P3a3KkH3MeU4H0SJmrs-jQ9ZA5HksG2uGDfe-=NTXh1UeHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ipc: fix sparc64 ipc() wrapper
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christian Brauner <christian@brauner.io>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-arch <linux-arch@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Matt Turner <mattst88@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Anatolij Gustschin <agust@denx.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 5, 2019 at 5:24 PM Arnd Bergmann <arnd@arndb.de> wrote:

> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
> index ccc88926bc00..5ad0494df367 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -340,21 +340,21 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
>         if (call <= SEMTIMEDOP) {
>                 switch (call) {
>                 case SEMOP:
> -                       err = sys_semtimedop(first, ptr,
> -                                            (unsigned int)second, NULL);
> +                       err = ksys_semtimedop(first, ptr,
> +                                             (unsigned int)second, NULL);
>                         goto out;

The zero-day bot found a link error in sparc64 allnoconfig:

   arch/sparc/kernel/sys_sparc_64.o: In function `__se_sys_sparc_ipc':
>> sys_sparc_64.c:(.text+0x724): undefined reference to `ksys_semtimedop'
>> sys_sparc_64.c:(.text+0x76c): undefined reference to `ksys_old_msgctl'
>> sys_sparc_64.c:(.text+0x7a8): undefined reference to `ksys_semget'
>> sys_sparc_64.c:(.text+0x7c8): undefined reference to `ksys_old_semctl'
>> sys_sparc_64.c:(.text+0x7e4): undefined reference to `ksys_msgsnd'
>> sys_sparc_64.c:(.text+0x7fc): undefined reference to `ksys_shmget'
>> sys_sparc_64.c:(.text+0x808): undefined reference to `ksys_shmdt'
   sys_sparc_64.c:(.text+0x828): undefined reference to `ksys_semtimedop'
>> sys_sparc_64.c:(.text+0x844): undefined reference to `ksys_old_shmctl'
>> sys_sparc_64.c:(.text+0x858): undefined reference to `ksys_msgget'
>> sys_sparc_64.c:(.text+0x86c): undefined reference to `ksys_msgrcv'

I've added this hunk to my patch and plan to send both fixes to Linus
in the next few days, after I get a positive report from the bot as well:

--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -336,6 +336,9 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call,
int, first, unsigned long, second
 {
        long err;

+       if (!IS_ENABLED(CONFIG_SYSVIPC))
+               return -ENOSYS;
+
        /* No need for backward compatibility. We can start fresh... */

        if (call <= SEMTIMEDOP) {
                switch (call) {
