Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1358134DCB
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 18:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfFDQho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 12:37:44 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36792 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfFDQho (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 12:37:44 -0400
Received: by mail-qk1-f196.google.com with SMTP id g18so3262506qkl.3;
        Tue, 04 Jun 2019 09:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aE1/cHd8DzTD9FjBXgqCGhUsUZ/Ac0/w2Hl806C0EWM=;
        b=gBZi01V6we8APcZYiBHBU8npGyh1ko7XZA+weiRBOCKEk6+rZUepKd7at1Y1GJUzXI
         0HjNgHij9va6VYS6Hd7y37zamsi2pCQftku47zA4pPT/IA1BwWv4Jwt8LLbZ9YB1IpeP
         u2ZWC9zaVaEiLyfYg5WViwQ0zSesnalr2ivIzzNx2EWnkGSjZKf7EWnGPEFihd6L2w9K
         qr8vfx9F64jUyMeWhJlD3hcqsbYXT5Iq7S2HRGAg3+u53HnbzvE/10nYD66IYTYjGv1S
         3lsvpvcoCXM0HI7ffmV//7oFe1/R+FM0fuN8xK7J381tTD6uO987VkqT6rVGC9OPNIOx
         BFww==
X-Gm-Message-State: APjAAAWkIaBx2izAtaO3FH0O8D+0u4Tng1tKUTJkjsMFa9IE94swWuKQ
        +l2/L57qr0WMZLcwA9vOJ98P+cWZqg1xB2+3+ho=
X-Google-Smtp-Source: APXvYqzfmP62dYOeVk1OlzWSMTrM9bPNziXx52FwlTOC/Ho6r8b/7WoZJpMUG9U+NaP2WQiW5cUyXhoGL5f0SB1c034=
X-Received: by 2002:a37:a4d3:: with SMTP id n202mr27466154qke.84.1559666262799;
 Tue, 04 Jun 2019 09:37:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
In-Reply-To: <20190604134117.GA29963@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 4 Jun 2019 18:37:26 +0200
Message-ID: <CAK8P3a3Dv+hqnQHWU2nG5rB+hGrqbcDC3DUoNGZAzNGJgJwizA@mail.gmail.com>
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in restore_user_sigmask()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dbueso@suse.de, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 3:41 PM Oleg Nesterov <oleg@redhat.com> wrote:
>
> This is the minimal fix for stable, I'll send cleanups later.
>
> The commit 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add
> restore_user_sigmask()") introduced the visible change which breaks
> user-space: a signal temporary unblocked by set_user_sigmask() can
> be delivered even if the caller returns success or timeout.
>
> Change restore_user_sigmask() to accept the additional "interrupted"
> argument which should be used instead of signal_pending() check, and
> update the callers.
>
> Reported-by: Eric Wong <e@80x24.org>
> Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
> cc: stable@vger.kernel.org (v5.0+)
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I hope Eric can test this with the original reproducer, or maybe someone
could create a test case that can be added into LTP.

      Arnd
