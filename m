Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6E1EDFA0
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 10:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgFDIRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 04:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgFDIRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 04:17:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1505DC03E96D
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 01:17:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f130so7066115yba.9
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 01:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dBhjvQ74rk87+xvmHCHMByl/N/LCyKOoeijL1Gf/O4E=;
        b=PTgQ328YnDam3JMX89/M53yQXWYuipuKp4wnwdFku6bBvCivR7xb1c6eFbsE+H+Kf4
         kUz2G12JgF+LiQiAvLcWiRPuS0BSKFkpjKDRGWJQU89Um5iJXLvZzIIvV6LxQ283D9F+
         UfAsuYZVjO+4tzvsTuDLhBPoFbJSSRZDif7PNa+4qrRuQYyG41Ts9TU6opuqooH4lOEn
         ldJUeiGFtsgSHv/VsJ3A4ZpuG5nrBSLfJ7WXy6/KT4T1L6RxrFlTuKyHPs0hOqWc9Bql
         KpLW0eUirQTTztYWMtEFOJdK3aCJjOX6KyAN15F4dJAqw+nrHapuFvPs4ZDklaAw/JBl
         uhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dBhjvQ74rk87+xvmHCHMByl/N/LCyKOoeijL1Gf/O4E=;
        b=Ltoh23XQV5L/1SrAffwv/lR1UArKZSV/N/8H7vV5FdEoR1AXe2vCMXeBfDLz3lgugf
         lUjdvJE7k3BvVwDiwbfb9ROoMzQ/Eh5GboJ+oRRXsu8JHNm8fd87EkGvqiDZjofaNETC
         qJQLv5PabF7EHT4hyM3HGjb9XpBdODhPkPmQeHSAFDF0GzAcFmRzHZ3gqUAVZRfO+dNk
         jXn1K3JwOqP+EflZ3I5fZSwEQfW/W/wvbfslqXhlVXb/QyS2t1Urkz4P0MmtWFMk6z2E
         Dd45XX6xGZslhaNHH0OYiDlB+ATo+ExmbMQmPYsVGpFJNT0iPlqhHmn16xw9RAFxmB7/
         asIg==
X-Gm-Message-State: AOAM530Vx/VNi6nR8Wn9YGLFfbfr04OnyzyeAQz0jz7KRvzbwXs3pBJQ
        2hXfchRXFCWYg7Do/REryExT1l1sgaXi
X-Google-Smtp-Source: ABdhPJw8DqlSWOZDSYtk3HzYUQDUrhkIKVQXAMPIq2tKNiuSr8cBaTwCXqaZggl1HvweWqrSm1EDwrkxlI++
X-Received: by 2002:a25:cb48:: with SMTP id b69mr1168096ybg.252.1591258624144;
 Thu, 04 Jun 2020 01:17:04 -0700 (PDT)
Date:   Thu, 04 Jun 2020 01:17:01 -0700
In-Reply-To: <CAHbLzkq84qtOqfvP5SmPoAyL+Pyffd9K3108AOYk5yKF03jBmw@mail.gmail.com>
Message-Id: <xr937dwn454y.fsf@gthelen.svl.corp.google.com>
Mime-Version: 1.0
References: <20200601032204.124624-1-gthelen@google.com> <CAHbLzkq84qtOqfvP5SmPoAyL+Pyffd9K3108AOYk5yKF03jBmw@mail.gmail.com>
Subject: Re: [PATCH] shmem, memcg: enable memcg aware shrinker
From:   Greg Thelen <gthelen@google.com>
To:     Yang Shi <shy828301@gmail.com>
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

Yang Shi <shy828301@gmail.com> wrote:

> On Sun, May 31, 2020 at 8:22 PM Greg Thelen <gthelen@google.com> wrote:
>>
>> Since v4.19 commit b0dedc49a2da ("mm/vmscan.c: iterate only over charged
>> shrinkers during memcg shrink_slab()") a memcg aware shrinker is only
>> called when the per-memcg per-node shrinker_map indicates that the
>> shrinker may have objects to release to the memcg and node.
>>
>> shmem_unused_huge_count and shmem_unused_huge_scan support the per-tmpfs
>> shrinker which advertises per memcg and numa awareness.  The shmem
>> shrinker releases memory by splitting hugepages that extend beyond
>> i_size.
>>
>> Shmem does not currently set bits in shrinker_map.  So, starting with
>> b0dedc49a2da, memcg reclaim avoids calling the shmem shrinker under
>> pressure.  This leads to undeserved memcg OOM kills.
>> Example that reliably sees memcg OOM kill in unpatched kernel:
>>   FS=/tmp/fs
>>   CONTAINER=/cgroup/memory/tmpfs_shrinker
>>   mkdir -p $FS
>>   mount -t tmpfs -o huge=always nodev $FS
>>   # Create 1000 MB container, which shouldn't suffer OOM.
>>   mkdir $CONTAINER
>>   echo 1000M > $CONTAINER/memory.limit_in_bytes
>>   echo $BASHPID >> $CONTAINER/cgroup.procs
>>   # Create 4000 files.  Ideally each file uses 4k data page + a little
>>   # metadata.  Assume 8k total per-file, 32MB (4000*8k) should easily
>>   # fit within container's 1000 MB.  But if data pages use 2MB
>>   # hugepages (due to aggressive huge=always) then files consume 8GB,
>>   # which hits memcg 1000 MB limit.
>>   for i in {1..4000}; do
>>     echo . > $FS/$i
>>   done
>
> It looks all the inodes which have tail THP beyond i_size are on one
> single list, then the shrinker actually just splits the first
> nr_to_scan inodes. But since the list is not memcg aware, so it seems
> it may split the THPs which are not charged to the victim memcg and
> the victim memcg still may suffer from pre-mature oom, right?

Correct.  shmem_unused_huge_shrink() is not memcg aware.  In response to
memcg pressure it will split the post-i_size tails of nr_to_scan tmpfs
inodes regardless of if they're charged to the under-pressure memcg.
do_shrink_slab() looks like it'll repeatedly call
shmem_unused_huge_shrink().  So it will split tails of many inodes.  So
I think it'll avoid the oom by over shrinking.  This is not ideal.  But
it seems better than undeserved oom kill.

I think the solution (as Kirill Tkhai suggested) a memcg-aware index
would solve both:
1) avoid premature oom by registering shrinker to responding to memcg
   pressure
2) avoid shrinking/splitting inodes unrelated to the under-pressure
   memcg

I can certainly look into that (thanks Kirill for the pointers).  In the
short term I'm still interested in avoiding premature OOMs with the
original thread (i.e. restore pre-4.19 behavior to shmem shrinker for
memcg pressure).  I plan to test and repost v2.
