Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F3D1F02BA
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 00:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgFEWFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 18:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgFEWFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 18:05:51 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B1C08C5C2;
        Fri,  5 Jun 2020 15:05:51 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so11681457ejd.8;
        Fri, 05 Jun 2020 15:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4f2rdGGtN0GdTt9TdrQV5swgjUs+uNX78VGk5PqhDq0=;
        b=X+1JcSe1mzZv+JApwt8xnJpPUibiJBVICxz3EvKfLWyQRjTAYU6MhWSV2ULjQ/KsfG
         mhbUPvHUIEMAaWhiKXNaWNCI0bei7OYeYeRiEwAmsVW34upMyy3LdJ01FgIy5zmFNkAV
         wFYGQJa140sC3KHXGUnnMOZhKOW7qdW9F7gxbfPa58B+Nj+fkXqiW0RRydvx1tF0/ShX
         BzfyAQuEVpX9hswye5BMFtykNHCjYgMeHacKZI+gnvIAqcdFa2w3LPa38RlRcc3QiwrL
         +OP/C5MuWOi+jnVF4wZto0iA3XT9V3mDYjkHhsG7Hw5JP2Klg8A2sV5S9bGnngcKf7hs
         YWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4f2rdGGtN0GdTt9TdrQV5swgjUs+uNX78VGk5PqhDq0=;
        b=fF+NbFL4j0FW11+VvY1pzEoqEfEMoVMV7XW8+ovhiyn6l9unfZME4dl56Rlazf7xpJ
         tthF89m7m0m2DcAKVvI7PKIlGdkiv1bSCVM7m6+sAkCygpXklfhWoObX5SYMWw1L94A+
         6U4f8/i2EpHPHm0MbntMfP2R2iSGLRJ9HF+jOU81DqeKRLmBZ1F7C4RoyETm74ETOIfd
         LU+P9yULMu8LpD5uo/PYuJ7WVQ86BpF1mBshnXgtxwXgZz+ptDQlsESybqfH1YfUzX2B
         4gwyik9n7KVsZNUV6+0lV7SoWcTuz7NwHY9i9/om5JiDpSNUo5CGnsjf2cyAn3+vcjU9
         LSeQ==
X-Gm-Message-State: AOAM533JzAdpyMxLM0Puxczco+qpz8nwfSpW238RPBT7RybPyqlZfFK6
        DfECwxsEAoEOo6ngER3Cmg86skEWelRwf6Sl1RAc2A==
X-Google-Smtp-Source: ABdhPJx0dvE7wkkiwQjrYiP1Jwh+Vekc7J7SHcXZpU27A/ESoitKKr80KD3XhNSjydSLiu+NqY0EFtYd8PrId2ukjag=
X-Received: by 2002:a17:906:ae85:: with SMTP id md5mr10688752ejb.213.1591394750297;
 Fri, 05 Jun 2020 15:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200601032204.124624-1-gthelen@google.com> <CAHbLzkq84qtOqfvP5SmPoAyL+Pyffd9K3108AOYk5yKF03jBmw@mail.gmail.com>
 <xr937dwn454y.fsf@gthelen.svl.corp.google.com>
In-Reply-To: <xr937dwn454y.fsf@gthelen.svl.corp.google.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Fri, 5 Jun 2020 15:05:16 -0700
Message-ID: <CAHbLzkrCdXu0rqEAodyV_f-QnUFcgs7H_ZryX7RfMb9Jb+HpKQ@mail.gmail.com>
Subject: Re: [PATCH] shmem, memcg: enable memcg aware shrinker
To:     Greg Thelen <gthelen@google.com>
Cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 4, 2020 at 1:17 AM Greg Thelen <gthelen@google.com> wrote:
>
> Yang Shi <shy828301@gmail.com> wrote:
>
> > On Sun, May 31, 2020 at 8:22 PM Greg Thelen <gthelen@google.com> wrote:
> >>
> >> Since v4.19 commit b0dedc49a2da ("mm/vmscan.c: iterate only over charged
> >> shrinkers during memcg shrink_slab()") a memcg aware shrinker is only
> >> called when the per-memcg per-node shrinker_map indicates that the
> >> shrinker may have objects to release to the memcg and node.
> >>
> >> shmem_unused_huge_count and shmem_unused_huge_scan support the per-tmpfs
> >> shrinker which advertises per memcg and numa awareness.  The shmem
> >> shrinker releases memory by splitting hugepages that extend beyond
> >> i_size.
> >>
> >> Shmem does not currently set bits in shrinker_map.  So, starting with
> >> b0dedc49a2da, memcg reclaim avoids calling the shmem shrinker under
> >> pressure.  This leads to undeserved memcg OOM kills.
> >> Example that reliably sees memcg OOM kill in unpatched kernel:
> >>   FS=/tmp/fs
> >>   CONTAINER=/cgroup/memory/tmpfs_shrinker
> >>   mkdir -p $FS
> >>   mount -t tmpfs -o huge=always nodev $FS
> >>   # Create 1000 MB container, which shouldn't suffer OOM.
> >>   mkdir $CONTAINER
> >>   echo 1000M > $CONTAINER/memory.limit_in_bytes
> >>   echo $BASHPID >> $CONTAINER/cgroup.procs
> >>   # Create 4000 files.  Ideally each file uses 4k data page + a little
> >>   # metadata.  Assume 8k total per-file, 32MB (4000*8k) should easily
> >>   # fit within container's 1000 MB.  But if data pages use 2MB
> >>   # hugepages (due to aggressive huge=always) then files consume 8GB,
> >>   # which hits memcg 1000 MB limit.
> >>   for i in {1..4000}; do
> >>     echo . > $FS/$i
> >>   done
> >
> > It looks all the inodes which have tail THP beyond i_size are on one
> > single list, then the shrinker actually just splits the first
> > nr_to_scan inodes. But since the list is not memcg aware, so it seems
> > it may split the THPs which are not charged to the victim memcg and
> > the victim memcg still may suffer from pre-mature oom, right?
>
> Correct.  shmem_unused_huge_shrink() is not memcg aware.  In response to
> memcg pressure it will split the post-i_size tails of nr_to_scan tmpfs
> inodes regardless of if they're charged to the under-pressure memcg.
> do_shrink_slab() looks like it'll repeatedly call
> shmem_unused_huge_shrink().  So it will split tails of many inodes.  So
> I think it'll avoid the oom by over shrinking.  This is not ideal.  But
> it seems better than undeserved oom kill.
>
> I think the solution (as Kirill Tkhai suggested) a memcg-aware index
> would solve both:
> 1) avoid premature oom by registering shrinker to responding to memcg
>    pressure
> 2) avoid shrinking/splitting inodes unrelated to the under-pressure
>    memcg

I do agree with Kirill. Using list_lru sounds optimal. But, it looks
the memcg index is tricky. The index of memcg which the beyond i_size
THP is charged to should be used instead of the inode's memcg which
may charge to different memcg.

>
> I can certainly look into that (thanks Kirill for the pointers).  In the
> short term I'm still interested in avoiding premature OOMs with the
> original thread (i.e. restore pre-4.19 behavior to shmem shrinker for
> memcg pressure).  I plan to test and repost v2.
