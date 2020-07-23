Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E7822A4EB
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733270AbgGWBxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGWBxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 21:53:50 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53143C0619DC
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 18:53:50 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id u15so643801qvx.7
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 18:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eZ1Y6JgB5YQDwf0UWHu1kuE7jjX29/VB5+ImlAYZvZc=;
        b=WQTCSsicE8gIgOIVhK0TlDfWgekG9c3ORxPInSSdetgi2IPNff4Uwj3Yfe7skXGJmV
         Dfr/g2b/z6guIjdzlpDzEMyuKcMZCXP/2WGiyavktKI79dwId47uBXl1bHlAof/5SV4v
         e4jZWeqZxeOtWswRmTth91RFVDkbNNRiwSQwhhXhJxyBmeGoRAaWrJAVWDxnlGv4yY+a
         0Fj3Y/3bvT5yJQJRDjcXQXdfJj9iIYkN5lE5heMuPEj/iziWZXoJsR+hTkWzjQ12HzxK
         pHXjl0I030d2doF3mFLideu/ZqNHqD4uei4JfvTqnMNP/v6nvGOuCbneRxbyo+aH+qFL
         Olfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eZ1Y6JgB5YQDwf0UWHu1kuE7jjX29/VB5+ImlAYZvZc=;
        b=ngVffRKXnPEwb7CvtZFWH0LnfTTIL96N7UbwujTIH9PCURu12ZlHxKPP/V6v4abUND
         Ao2aIcxmBa+UiaMGOHAp3UnaObQYbFz/GcyZzRQsb/OrcU6DJ7ZqIjhhnhBWKGbtQ5ZV
         vwTbVkIBpYp9Bz/oCYaO7TXGWr11iZf/bTcP3e4FxzpoPvjm2iAMR8oWqeFgXKKCUl3c
         AIU7ljLTirWEMzKbYc4g3Qv0HV0FX71mXHGi++gEfa2VzMKWQ5W6eF6mlvSoAJGO3y1U
         lg+wO2RdwX6LmhhTi2+0XdY/1n5+iwxazo/pShxAYkzZiJ7SLGwzMEoR0vuMof7S3PDO
         wBXw==
X-Gm-Message-State: AOAM530YDJRnSBcfBgR+menznKCC/naYWV2bw6nnm+PDMdct76r7+nok
        RSj+/4UTTqtDWRJR3MtvNo9apr5XRMdg8z7SP+DqZmAF
X-Google-Smtp-Source: ABdhPJxp5lKV6INUj9GdYoX3xVQNZ/VswwaweU8IbQU+dW1JYSk0ZvnBwAiiZB09sZNI7hXATPY0lGobua9a2FsvSkg=
X-Received: by 2002:a0c:a306:: with SMTP id u6mr2838976qvu.88.1595469229448;
 Wed, 22 Jul 2020 18:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <1595220978-9890-1-git-send-email-iamjoonsoo.kim@lge.com> <20200721142009.676A920714@mail.kernel.org>
In-Reply-To: <20200721142009.676A920714@mail.kernel.org>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Thu, 23 Jul 2020 10:53:38 +0900
Message-ID: <CAAmzW4OqGaDSYg=j6MYCxpjXYGpV--qd10RhcVbcYuKcUk5NaA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/page_alloc: fix non cma alloc context
To:     Sasha Levin <sashal@kernel.org>
Cc:     Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020=EB=85=84 7=EC=9B=94 21=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 11:24, =
Sasha Levin <sashal@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: d7fefcc8de91 ("mm/cma: add PF flag to force non cma alloc"=
).
>
> The bot has tested the following trees: v5.7.9, v5.4.52.
>
> v5.7.9: Failed to apply! Possible dependencies:
>     01c0bfe061f30 ("mm: rename gfpflags_to_migratetype to gfp_migratetype=
 for same convention")
>     16867664936e3 ("mm,page_alloc,cma: conditionally prefer cma pageblock=
s for movable allocations")
>     3334a45eb9e2b ("mm/page_alloc: use ac->high_zoneidx for classzone_idx=
")
>     63b44f01f1974 ("include/linux/sched/mm.h: optimize current_gfp_contex=
t()")
>     97a225e69a1f8 ("mm/page_alloc: integrate classzone_idx and high_zonei=
dx")
>     a65064938b815 ("page_alloc: consider highatomic reserve in watermark =
fast")
>
> v5.4.52: Failed to apply! Possible dependencies:
>     01c0bfe061f30 ("mm: rename gfpflags_to_migratetype to gfp_migratetype=
 for same convention")
>     16867664936e3 ("mm,page_alloc,cma: conditionally prefer cma pageblock=
s for movable allocations")
>     3334a45eb9e2b ("mm/page_alloc: use ac->high_zoneidx for classzone_idx=
")
>     5644e1fbbfe15 ("mm/vmscan.c: fix data races using kswapd_classzone_id=
x")
>     63b44f01f1974 ("include/linux/sched/mm.h: optimize current_gfp_contex=
t()")
>     97a225e69a1f8 ("mm/page_alloc: integrate classzone_idx and high_zonei=
dx")
>     a65064938b815 ("page_alloc: consider highatomic reserve in watermark =
fast")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>

I sent the patch that is against the mainline. Note that the subject is cha=
nged.
See the following link please.

http://lkml.kernel.org/r/1595468942-29687-1-git-send-email-iamjoonsoo.kim@l=
ge.com

Thanks.
