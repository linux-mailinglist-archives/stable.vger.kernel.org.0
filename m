Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9211D29AB05
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 12:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899404AbgJ0Lkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 07:40:39 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43990 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899401AbgJ0Lkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 07:40:39 -0400
Received: by mail-lf1-f67.google.com with SMTP id l28so1852339lfp.10
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 04:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hf+Yr5OHguGnitODZ40FBDMEpRJ9+vItxU02ipIbvU=;
        b=e9AOgaMlXzBNM73A0tEOsY1hJGMsqjFJ0Y6HkyTPBhdvmV89NeLE26BFhMyMW+nuNa
         qFY811lxm94aKLyF5cXrJt1JjptmyUMkxrlNQEWS06aR3uenMy0wgs74/u37CmYdiP/a
         s8Aq6Zuu8ZbUHolPn6ack/Xh9KJpk9X/E5BqC7B3bmVlwZqewoDqjczhItSAEE2SaPIo
         n4LBh4X8YjQdwrdQSTx4yXmmStwIKzMRQ4AwUE5dvr/OfsdiK/ogW1Aj0zRNTm5mslN0
         PH+gqcRvEeqD++daGzb9Q9v4OBvrcGolyoyyl44PJMTbNyArxUEnmi75Q3ppnR7E6Gr7
         6/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hf+Yr5OHguGnitODZ40FBDMEpRJ9+vItxU02ipIbvU=;
        b=L/In7t64xdJmvfE31z4CilmUDk0WjbnULWrnHJIX0qPaU0Gb4c+mUyYfH3FnLv2/Ce
         ju80CuPLkSQoPi3J08FvMGn9VevGCdX7N5WOXOvXfov2Sygsf2p01BOZanLEIwWcTY9s
         Cxun8bDqSVjz5Fq4REKe5tAeqzh4Rl4kIwmojLz/XGMVrLGuAjIGGmmP4HSZM42JjQ49
         Sphr2I6MZqc9ouAohZL+hKkQU9jAqs3f8sql33hkJQ7k3T4WVfIgJ5jQyYm7NOk0TEjk
         aqQit8vgvXoSsz5EktzUQ/ngAzyy2Cn70iRyt78hzpnqJHtcJXeYjaz4OzzqfMUWWwb+
         cjXA==
X-Gm-Message-State: AOAM531lQyk67AGq4OGqH+JS5q2fZdos4f4qMh2qxdeGiOf+j2vZD7aN
        MZCCqO7qR8wiX2X2BHmQw9sfMtUewsg6cm5EDz/mbpb2S34=
X-Google-Smtp-Source: ABdhPJwaOnp/Lo+JGFouNl/RVd5VGDvf0iTytnqnj8gaxA5yzh+1YgFyiPmb9Moa4RATKhrNVMi6LS/xQobxsl1irC4=
X-Received: by 2002:a19:e308:: with SMTP id a8mr672404lfh.573.1603798836426;
 Tue, 27 Oct 2020 04:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201026235205.1023962-1-sashal@kernel.org> <20201026235205.1023962-100-sashal@kernel.org>
In-Reply-To: <20201026235205.1023962-100-sashal@kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 27 Oct 2020 12:40:10 +0100
Message-ID: <CAG48ez1GefwfXUBaFXWDmgsfQxVzNSUsYntgbG763C59eP+4uQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.8 100/132] binfmt_elf: take the mmap lock around find_extend_vma()
To:     Sasha Levin <sashal@kernel.org>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 12:54 AM Sasha Levin <sashal@kernel.org> wrote:
> [ Upstream commit b2767d97f5ff758250cf28684aaa48bbfd34145f ]
>
> create_elf_tables() runs after setup_new_exec(), so other tasks can
> already access our new mm and do things like process_madvise() on it.  (At
> the time I'm writing this commit, process_madvise() is not in mainline
> yet, but has been in akpm's tree for some time.)
>
> While I believe that there are currently no APIs that would actually allow
> another process to mess up our VMA tree (process_madvise() is limited to
> MADV_COLD and MADV_PAGEOUT, and uring and userfaultfd cannot reach an mm
> under which no syscalls have been executed yet), this seems like an
> accident waiting to happen.
>
> Let's make sure that we always take the mmap lock around GUP paths as long
> as another process might be able to see the mm.

While this commit makes the kernel less prone to future accidents, and
it is arguably fixing locking misbehavior, I don't think it belongs
into stable trees? As far as I know, it is not fixing any bugs that
can actually materialize in current or past kernels.
