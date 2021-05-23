Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB7238D85A
	for <lists+stable@lfdr.de>; Sun, 23 May 2021 04:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhEWCrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 22:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhEWCrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 May 2021 22:47:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0C9C06138A
        for <stable@vger.kernel.org>; Sat, 22 May 2021 19:45:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 10so17982701pfl.1
        for <stable@vger.kernel.org>; Sat, 22 May 2021 19:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQdUw3i+6qH8wFbd5nMBYnK83/wdZDOwLJNKJGHXsj0=;
        b=fpn18oPM6RIf1AMR5ZWpyJeeBER/NanNQyNlOf2w2iYmrZ9lXJIfGKSMn7faSEN5RU
         TO3xTaOKh93kuhFdibL2zBFdoyOVuqoGO0dhkwNZnl01OyLsT2hHTDa37h085TF1R5TC
         MY3B5lYIYJ9EUYsnF9Yx5o9j6cCL2MlZwbg9MSAoQwoRXcVj50gBfctZu1JMaw077d21
         5rdrMrpypQvf4r/8Vy24MQY6MELqXuWwls+ZPiKM4DVS0vX1qKCR2dOt9aVmJBPr6FIp
         5EVZUFcXeSaFnuHqZbTBGnpwyThYQAgvZtQjTHw9ALEw/e1OmJTGp++InaN8WGVIM+F0
         4DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQdUw3i+6qH8wFbd5nMBYnK83/wdZDOwLJNKJGHXsj0=;
        b=X9A62YP5BipIj8L/5cPSO8r6S96Pzy6X6aS6salAuKQ4CHt0TUAocuOhU71ckUfR96
         vHHKcrGh9UaxLsIjoWzhfyC4Vhn8Hyr/vDGm936hbYo7seVxRfd7W4OjBdtWggIfEzut
         4So5y2H9gYXI/5QHFZKowIrXmwbheh11u79NsqMrImhYS0TnJsDcsOzNdyjvTefVGpix
         dO+vO7FK2cvtzQcWK23/xVFLENRHlLBIGgTWWFdi1Sj1ekFs7lpWiUDi0aG60gPnwVge
         laW9vipzghbJYJiVQeSxjdd/y7h9oGNwyIBGt4syBpgWGLQopbiWZij4TU86nZEsfd2S
         btDQ==
X-Gm-Message-State: AOAM530BEKiWvVbT6q3ee4NlNuZNREQvhEieUSreWeq4oQBLbW0ZXbIH
        e+WK/AcjnYVj5sU1Lv2emTDht4uugW3DMP0q2kMBOA==
X-Google-Smtp-Source: ABdhPJwgBkyP397O0+9s9cKSsRDOY4ZvePTqlUHuWy+35wC/4F3ltLJqeZ04WYbdApqDYJMFSzshuEx6Zi0uoohw04o=
X-Received: by 2002:a05:6a00:2493:b029:2c4:b6dd:d389 with SMTP id
 c19-20020a056a002493b02902c4b6ddd389mr17975096pfv.2.1621737948711; Sat, 22
 May 2021 19:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210521233952.236434-1-mike.kravetz@oracle.com>
In-Reply-To: <20210521233952.236434-1-mike.kravetz@oracle.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Sun, 23 May 2021 10:45:11 +0800
Message-ID: <CAMZfGtVnGMu9SU8U+aXp6YKz0p1pBxcYy4OMpNftpkxTbJBM8w@mail.gmail.com>
Subject: Re: [External] [PATCH] userfaultfd: hugetlbfs: fix new flag usage in
 error path
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mina Almasry <almasrymina@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 22, 2021 at 7:40 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> In commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
> page flags") the use of PagePrivate to indicate a reservation count
> should be restored at free time was changed to the hugetlb specific flag
> HPageRestoreReserve.  Changes to a userfaultfd error path as well as a
> VM_BUG_ON() in remove_inode_hugepages() were overlooked.
>
> Users could see incorrect hugetlb reserve counts if they experience an
> error with a UFFDIO_COPY operation.  Specifically, this would be the
> result of an unlikely copy_huge_page_from_user error.  There is not an
> increased chance of hitting the VM_BUG_ON.
>
> Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks Mike.
