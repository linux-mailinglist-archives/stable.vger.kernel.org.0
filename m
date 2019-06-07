Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE2C393EB
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 20:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfFGSFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 14:05:34 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34739 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729817AbfFGSFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 14:05:34 -0400
Received: by mail-lf1-f66.google.com with SMTP id y198so2308510lfa.1
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 11:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AvJFyeYPhoZ4OqCr1dphehPV0ub1oVxmCWbJKgWsTI=;
        b=d315/RM0DaMH44my3nNzmVmEhTs+nmHZuuQf+pKqz9YU+VjDMhvTt+Yvh514Ss3VZ3
         osVtbUYyVCFBmdkSg2kW5jq84b2tec/7sH0g88lborkaDjwnEQCiquJ2Gjh042t4qJRK
         O0Z2hoSc9g3XgDPMu2hQ/afW7OGSyKvzIuScc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AvJFyeYPhoZ4OqCr1dphehPV0ub1oVxmCWbJKgWsTI=;
        b=VVCTTwa1LxzhcB6HFONcN3GuD4hWG53c/yiHPQeTTlaRoRZH8L511N+YmVGeKvJCub
         8SIGtsX0C/a8l9WMuVsJoY0DQqPcyQ+EqenQ+fm89maR03uEIR+iUcLK29yZLgrZZ9Vl
         76W7c1FXGDNunJ7fXM88PTCGpYpWhrtap2K6iM1JA9h0vZnCyM2i6XEmXDdkOZt4UODM
         igwVcBGEVIBAX0iLUwypo+RjcqlPmXnLG43AXfWv2cfQuo0Ko7sQZfepX1y2LWW5fdTn
         lgHNdAteOJWLvH19DGXvOd2p33siEnXoMP1BS52hmW52BM2wGl01bpxREqJEbomWA114
         My9A==
X-Gm-Message-State: APjAAAUBkzn9wb3UCuHcYCcOh/7KlgVtCXoF7A9LyZZJmfAVKHpitCK4
        2eEqkiYs5Lfq2jRiCgUo8nNiixEqp/M=
X-Google-Smtp-Source: APXvYqzWBByNw4vv5laHYhQSe7JfD+GfQ2r9QHltVo6kt1Xy8DbtdK/3EJe+2Ac70AvVigB//2wlsA==
X-Received: by 2002:a19:6e41:: with SMTP id q1mr19862272lfk.20.1559930731500;
        Fri, 07 Jun 2019 11:05:31 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id a25sm513610lfc.28.2019.06.07.11.05.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 11:05:29 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id q26so2302436lfc.3
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 11:05:29 -0700 (PDT)
X-Received: by 2002:a19:2d41:: with SMTP id t1mr27328138lft.79.1559930729175;
 Fri, 07 Jun 2019 11:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
 <20190606140814.GA13440@redhat.com> <20190606140852.GB13440@redhat.com>
In-Reply-To: <20190606140852.GB13440@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Jun 2019 11:05:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjTWSra20otC3tEGrpHJL3xhUFFe0+-7bZjUpibjwKjzg@mail.gmail.com>
Message-ID: <CAHk-=wjTWSra20otC3tEGrpHJL3xhUFFe0+-7bZjUpibjwKjzg@mail.gmail.com>
Subject: Re: [PATCH 1/2] select: change do_poll() to return -ERESTARTNOHAND
 rather than -EINTR
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 6, 2019 at 7:09 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> do_poll() returns -EINTR if interrupted and after that all its callers
> have to translate it into -ERESTARTNOHAND. Change do_poll() to return
> -ERESTARTNOHAND and update (simplify) the callers.

Ack.

The *right* return value will actually be then chosen by
poll_select_copy_remaining(), which will turn ERESTARTNOHAND to EINTR
when it can't update the timeout.

Except for the cases that use restart_block and do that instead and
don't have the whole timeout restart issue as a result.

              Linus
