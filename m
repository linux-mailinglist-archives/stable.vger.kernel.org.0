Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7361F1880
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgFHMIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbgFHMIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 08:08:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440CDC08C5C3;
        Mon,  8 Jun 2020 05:08:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u8so625959pje.4;
        Mon, 08 Jun 2020 05:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GgBLJ7JgYkUWmLexKJuiXlhG+mT6+4JFyp/4DW8tzGE=;
        b=vJ/uPackHiPEJpZBFGnMo0PZ+sGgOm0fjmWvkr04D7egXmPEkO7765q7IUD80bf47p
         yNiQ1KAqLgbb/VH1WwLqld0pq6TENtx1IWKkr2R9EVrCww+3BzJqxtuN8CXfsQw33gr2
         7RbgwWrYzuJ/l0x7Jz89G/3lSH3K77eXgtyDI/h/Smp6H7TUKjn/Ap/+cCcTHPRI3HSB
         aFD72mATaPb8OMMuAY4jvN+y6vLeCdwjNSUthRZ68UjU3TlMFIZ1jhztXa0EzqZKWamc
         PQWzGy7lCE6n1JbgiV/Bc2jA9k1ktjPPu5q/8gYFvH+qZRgFyT5dIsaAWKGQPFEQL+dy
         w82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GgBLJ7JgYkUWmLexKJuiXlhG+mT6+4JFyp/4DW8tzGE=;
        b=JGUogKpZNvgEy739GNIuIgfrIPw1cMPq0ApLU40LK+oWsgmQhoydhlK1J2a2jOViTh
         aWUw/LEj2RglI3IMzyWGRXkhacgrK8zSnTt5Z2JHt9nADx1CepZMlVWBj13zrSlQzJzI
         RMtT25SKk1gv+dvgRqeZLExtMyaEL4hpoYBHtDGCfvoXBRsGzEgyS2ET0vnQ2ramtm30
         UytwEncajG0nmRwEOL6/Q2hJhkqy82ZmPQJ/ZRwXRZqSvazaCxVjOSP7VJeTGswXU9Ik
         col1ILoKjEDxVZ1Co+IVDCsnhwyp4w+qMybWLe0/StVSU4VJ5Crz1hsOPCKtKLcLtfbW
         qkIQ==
X-Gm-Message-State: AOAM5333GrIfAzRvihmp3OLiTvTlzqW6PSMJcNXRJIPvHOHcAfjyiIYm
        O99tTj1cZ3mnRFF4HA1WmVHLrgVNpNgDdW7Evz0=
X-Google-Smtp-Source: ABdhPJxAPNmHSfHtvMBx5TWv9upG1K159+p1oEp8DWJbk7GDq5o7a0a9+BJV/Hn+lXIAa8n6+PaeEPGzGGJeqEi1EYA=
X-Received: by 2002:a17:90a:b30d:: with SMTP id d13mr10169919pjr.181.1591618113794;
 Mon, 08 Jun 2020 05:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <1591611829-23071-1-git-send-email-agordeev@linux.ibm.com> <CAHp75VcFdrvNMj0TL8ZHxShqqGDM31Hy8vitmn9HOPjZ6f9uYw@mail.gmail.com>
In-Reply-To: <CAHp75VcFdrvNMj0TL8ZHxShqqGDM31Hy8vitmn9HOPjZ6f9uYw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 8 Jun 2020 15:08:22 +0300
Message-ID: <CAHp75Ve98sbs9do=vD7fk+iWWgTPfQ=8HT1Nh4ehBtdtp7joKQ@mail.gmail.com>
Subject: Re: [PATCH RESEND2] lib: fix bitmap_parse() on 64-bit big endian archs
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 8, 2020 at 3:03 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Mon, Jun 8, 2020 at 1:26 PM Alexander Gordeev <agordeev@linux.ibm.com> wrote:

...

> Can't we simple do
>
>         int chunk_index = 0;
>         ...
>         do {
> #if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
>                end = bitmap_get_x32_reverse(start, end,
> bitmap[chunk_index ^ 1]);
> #else
>                end = bitmap_get_x32_reverse(start, end, bitmap[chunk_index]);
> #endif
>         ...
>         } while (++chunk_index);
>
> ?

And moreover, we simple can replace bitmap by maskp here, and drop it
from definition block.

-- 
With Best Regards,
Andy Shevchenko
