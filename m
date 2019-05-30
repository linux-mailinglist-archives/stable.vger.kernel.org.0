Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88D9301EE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE3S2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 14:28:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33904 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3S2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 14:28:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id h1so8228571qtp.1;
        Thu, 30 May 2019 11:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/lAesORefc6bhlBeQ2Gn091+SjcoN/8Ir1iuEsW99A=;
        b=QhzkmGMypMm9pHr7YV2l2l3kwhSgGYYTPo9Ui6fbzivhiUmeUEkLQ+vWUflEDcxswU
         oA0/XS7gEIH+kWhfS5fMV/BCdkBLwHz3vTTiJtRN99dVRlesKrkmqCkexsucoxBoZFoE
         oCmzavHc9QEHTQaJ69U3obalRJYxv70kjk+dPlYQ95ddEcJWesAwE8TZMscNVoYhsRHi
         b9MKVDvFmLuXmU3CoBjklRpQSAfg6YQgPXQ2w7723BT44YUz2eAtlzz81JAL027vcA3X
         qbFYtb2Ik54tPoS3BdPn8ql5ZmfF5t3yxzr3ZMqZYB6oPkLy7WhW0RlAgKm3jK7njIm6
         f6Vg==
X-Gm-Message-State: APjAAAWFz66nDB82toN9GYf+rVzYGpUKEH5O/wPHkVTxjyppzcFnMoLt
        YbzTcybHjqhqlC6bvformNebIY/+n60nujpxPuA=
X-Google-Smtp-Source: APXvYqwJZtIYaMrmM7kBP31g8e8y4dFZ6guBPLQBIpcazgz32TcKxbacQZ3BiQaq4nHfJv7EzcWESGiPWz6vCSB3pMY=
X-Received: by 2002:ac8:2433:: with SMTP id c48mr4854798qtc.18.1559240921162;
 Thu, 30 May 2019 11:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <CAK8P3a1fsrz6kAB1z-mqcaNvXL4Hf3XMiN=Q5rzAJ3rLGPK_Yg@mail.gmail.com>
 <874l5czozi.fsf@xmission.com>
In-Reply-To: <874l5czozi.fsf@xmission.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 May 2019 20:28:24 +0200
Message-ID: <CAK8P3a3BkgrT2vvX8NhZ8y1G_1tyefb8LPSk+EZKBrHqPuXoqQ@mail.gmail.com>
Subject: Re: pselect/etc semantics
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, dbueso@suse.de,
        Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 3:54 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> > On Wed, May 29, 2019 at 6:12 PM Oleg Nesterov <oleg@redhat.com> wrote:

> >
> > Not sure about the order of the cleanups, but probably something like
> > this would work:
> >
> > 1. fix the race (to be backported)
> > 2. unify set_compat_user_sigmask/set_user_sigmask
> > 3. remove unneeded compat handlers
> > 4. replace restore_user_sigmask with restore_saved_sigmask_if()
> > 5. also unify compat_get_fd_set()/get_fd_set() and kill off
> >     compat select() variants.
>
> Are new system calls added preventing a revert of the patch in question
> for stable kernels?

Yes, a straight revert would not work, as it was done as a cleanup in
order to simplify the following conversion. I suppose one could undo
the cleanup in both the time32 and time64 versions of each syscall,
but I would consider that a more risky change than just fixing the
bug that was reported.

       Arnd
