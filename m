Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4F12E69BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 18:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgL1RcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 12:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgL1RcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 12:32:00 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96B7C0613D6;
        Mon, 28 Dec 2020 09:31:19 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id x16so15082505ejj.7;
        Mon, 28 Dec 2020 09:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6jMggetbrrUEJcKxjzuL9oTosulpOnPLZ2l3XhwKRs=;
        b=sTNImozLG8IUJ7j7UwjMpqjYlF4QAZZpCW/LSq75Vt0RO1PNnl+NlthpsCUNTS+oEY
         Oji8WEtUKftUwXdtwbJzUQPnMJGy3Jv4UTXDo6EiV5zRGfTHvxEXGd0GtAD2rOKX8c5J
         Hb+ec3q1e8ssIeDfVC+hOSCnKd/LiTdq5ZP5h0pMDXO9SKgijrI7UZ5fld2y3w48q7Zu
         jByVPXR06kOSCI7JBI4qkUv+/ASVdjPP6ai0lrfqwJxiRxO9jtHe8mYAzbmh6RlHdJ+M
         HL8UADYYuHy/ja4ArNgBGG15iWstN9HGqBT7aEtva3IvIKH77bETrMrW+u+s9Q6mS4/B
         6E3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6jMggetbrrUEJcKxjzuL9oTosulpOnPLZ2l3XhwKRs=;
        b=XHq3H/o4/5aJ/sHFlRuP+6BtmSb+8f1xFpQ7X4gVhfF3VQMpWdSx0dSLerjD1NqPB2
         a0dKhZFfk2is6ORbon6uMJrZb6qVafBxNQEXxuxTJdgDzoUnqxKWBZVp36LAiWxcJYV2
         ruY7upC1HTPATrbS1cQgvisiDgYz0WQzWO5yRaLgAay/079mJgwAgMwhJhEZuMDDFXW4
         4B94JX9ZXiiFhqxqQiqzp+euBAu4yXjCvfFSuNXpK1XATVss7gYk9+L+SKsSkRfKZtdA
         9abOqys0nr3KLpbMHmoHPmol8WxLgCCKV5Nzp9rqhmAypg4avc22gBVl/PY+SzanNRPI
         bAIg==
X-Gm-Message-State: AOAM5309KyWPf2c/znQHbM1JTY1v3k6bL/FtEV7zQfk0Ncx7CwqUsw2e
        VB45dpT6z5MgGXqH8/g3E1HVduWLCCyL5u5igQQ=
X-Google-Smtp-Source: ABdhPJwnGEJ77oSQj1FpVI6e1CvKlbyKgsHA+UHCeVILPPWIBeIAH1mKdtiFuhAXf57/MP63eN9cjUHniQLXulXtYgc=
X-Received: by 2002:a17:906:b04f:: with SMTP id bj15mr41116505ejb.383.1609176677425;
 Mon, 28 Dec 2020 09:31:17 -0800 (PST)
MIME-Version: 1.0
References: <20201227181310.3235210-1-shakeelb@google.com>
In-Reply-To: <20201227181310.3235210-1-shakeelb@google.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 28 Dec 2020 09:31:05 -0800
Message-ID: <CAHbLzkr16NLLLj2QoJRTsVBwvJHcfeHeubnx7sT28J4G3FYx2w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: memcg: fix memcg file_dirty numa stat
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 10:13 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> The kernel updates the per-node NR_FILE_DIRTY stats on page migration
> but not the memcg numa stats. That was not an issue until recently the
> commit 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface
> for cgroup v2") exposed numa stats for the memcg. So fixing the
> file_dirty per-memcg numa stat.
>
> Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Yang Shi <shy828301@gmail.com>

> ---
>  mm/migrate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ee5e612b4cd8..613794f6a433 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -500,9 +500,9 @@ int migrate_page_move_mapping(struct address_space *mapping,
>                         __inc_lruvec_state(new_lruvec, NR_SHMEM);
>                 }
>                 if (dirty && mapping_can_writeback(mapping)) {
> -                       __dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
> +                       __dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
>                         __dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
> -                       __inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
> +                       __inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
>                         __inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
>                 }
>         }
> --
> 2.29.2.729.g45daf8777d-goog
>
>
