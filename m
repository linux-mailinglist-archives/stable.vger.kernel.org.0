Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422291A7039
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 02:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390557AbgDNAlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 20:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390520AbgDNAlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 20:41:55 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23724C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:41:55 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id n10so11460037iom.3
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HlavIvaaNds85GLQ5z8/oP0O9rNUrTQr5Z3E8erJn+0=;
        b=np0EAQVnkyWkJqEjk1BqoJlb2LWNjE9yJq0cGxdvN3OQ4jn4scMhYN75VK25/jrMvO
         OosbAemM46NOAQ88Z/i2wTi99MoctlUUSc4DGTfQsDuW4e8LNot9USDi2wu6wEFuDfdE
         V03nHrLG7z+FQpmE+iTN1oSrbvD7xDOLlsbx9N6+hF4utHCkw3LaggpA0/TXfusDWeCq
         Zh/5Wz5H+dG7l8tFNG6WfgCqAnJdtlHwTnvUvc9/lIm2cU6qZRD6lpO+zQFbqD/Di5eK
         WRTMGl/t4ipqqwNB6dvC59pq7VLxbx6w6mr1Q7F9qmqr21jxvBI9YW+N66nAv1AL6PfB
         9xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HlavIvaaNds85GLQ5z8/oP0O9rNUrTQr5Z3E8erJn+0=;
        b=QjDwO8tzdYevxm9Zhw0eroSBlNlNt1tV7BDcK4Ql4aVkh/nJZgDevtlnF75Y4QtByI
         N/T/LUA+V7eaxxDX1duXWxXCOyzwQfIE1ZCkNGgQDfu0h2NEz4yXEsFRVvyrHZJOKqGz
         jlmw8ewU3vkGrtZg7HGoTWVYvFiQzjN09T72mdrO4zuoCRfPzlZokDlWWDcdZlDiRkw6
         sH9Y/RiRS/whF0rSp6mMjHhDgSYKQOQzj7mePbS/iG3MRmkweyf8TOGCgjb1CguFV0LG
         4e8/YG3uGxyXs17ySSpVwiKy1/CXobZj1JarrnVVH/WUOGKNp5MGDQBW2tNwMrcLzSoy
         PQKA==
X-Gm-Message-State: AGi0PubiC2KEHiBOfUNmOK8ekH4HNWBNlRmK6gjIB6RBNS7EgKcNAXXt
        fr+3q8NGIuRq6sR4AgTnMWuBcz/0n6/PTkfvXPs=
X-Google-Smtp-Source: APiQypIJnbC6b13RwLCDLQJJK9YuSUShjPTSL0jl90YC4sJbPKrNBLeGV+zhV64EN0soB6WGaEsBfDhpZPjZL32c7c0=
X-Received: by 2002:a02:716b:: with SMTP id n43mr18305172jaf.97.1586824914341;
 Mon, 13 Apr 2020 17:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200412140427.6732-1-laoar.shao@gmail.com> <20200413193111.GA1559372@chrisdown.name>
In-Reply-To: <20200413193111.GA1559372@chrisdown.name>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 14 Apr 2020 08:41:18 +0800
Message-ID: <CALOAHbC9Gz23Dv+6bXgD=Rimp1QkfiPFx=+OH_cPk2Zd_J_XYA@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix inconsistent oom event behavior
To:     Chris Down <chris@chrisdown.name>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 3:31 AM Chris Down <chris@chrisdown.name> wrote:
>
> Hi Yafang,
>
> Yafang Shao writes:
> >A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> >memory.events") changes the behavior of memcg events, which will
> >consider subtrees in memory.events. But oom_kill event is a special one
> >as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> >in memory.oom_control. The file memory.oom_control is in both root memcg
> >and non root memcg, that is different with memory.event as it only in
> >non-root memcg. That commit is okay for cgroup2, but it is not okay for
> >cgroup1 as it will cause inconsistent behavior between root memcg and
> >non-root memcg.
> >Let's recover the original behavior for cgroup1.
>
> Can you please explain the practical ramifications of this and show an
> explicitly laid out example of how this manifests, with numbers and scenarios?
> It's unclear to me that this is a real problem as is -- it may be, but there
> certainly needs to be more information.
>

Here's an example.

     root memcg
     /
  memcg foo
   /
memcg bar

Suppose there's an oom_kill in memcg bar, then the oon_kill will be

     root memcg : memory.oom_control(oom_kill)  0
     /
  memcg foo : memory.oom_control(oom_kill)  1
   /
memcg bar : memory.oom_control(oom_kill)  1

Then the user has to know whether the memcg is root or not, if it is
root memcg, then memory.oom_control(oom_kill)  is its local event
only, while if it is not root memcg, then memory.oom_control(oom_kill)
includes all its descendants' oom_kill events.


Thanks
Yafang
