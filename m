Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA6E21B69
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 18:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfEQQRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 12:17:52 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40195 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729236AbfEQQRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 12:17:52 -0400
Received: by mail-qt1-f193.google.com with SMTP id k24so8632004qtq.7
        for <stable@vger.kernel.org>; Fri, 17 May 2019 09:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gpiccoli-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y4FffnAnwdRE+1PgwVKRrOC66n7RnysXVy2HJUpNb2M=;
        b=c1Geez7bVZbVWrY4f+4RoXhbwUhzklz/7bC0OK5tQLJ7Bqwo2i4ZRZN+WyhS7YjMRX
         OigAhZQafsBif5DZx+nzKNAnFTPJPtDJNIIsGXVv+hYf7GdpoRBCcIq3Sm3eJEWn0uOm
         KE06l+A/nU5cszw5p9lZqZFu8BgXlk7C98t0NwBl6Q1pPQvfcyvPmqO4P0pyc0nNb8Pe
         hvea1fmleiuAgn5jdS2KgdJIAi9JZavLtc8mgHBB2aBCl7B0Syf7/MXuCwq4Gx5Xy9jX
         4LYkN1Z1r1DAQIlJNLZ2dJkpH0TgyvTd4FWN+XzmAa29nCx9kjF8BWUM0k/0psETkJrQ
         OO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y4FffnAnwdRE+1PgwVKRrOC66n7RnysXVy2HJUpNb2M=;
        b=R4+6vsncjVXDEma7micybOEklORSHlqHL6WaUBCCqKWXlzXV69GAlVKUvCerKYbyfk
         hYZRnIU1TCKtvA65GAqKvOu05tHSRQIJdEgGoCMwxovTGeb76lzrNEeUD0K7MwEbRc19
         4nNOUv+osvcCKs2UncVJJQY+hd6KXiKA5EqT2aAO5VdsM4Tca2N4+93yeiToHaCr69VC
         dGtgqA1SlP+R58W0OCwxcjJS5nUEhvxmnG08SRo+0ylPSr5N/pBs3erMkK7TQ7thfuBF
         a9QqK2RO5H2l8Zu2QuyFk61pOIgZoWU0srotkq9B6cBla4J3mDDQ4igBnJCR8IiryPhD
         H4iw==
X-Gm-Message-State: APjAAAUIfNkW90QGCPsT8qSVpOgRO5XHb2zDWyk+7eM7EBxFxVMH3EB4
        W6P8QyUGZ5ccNrv7aamkk+gioTAoVOUq0OemGu4c+w==
X-Google-Smtp-Source: APXvYqzbeRUmj6xRCLSv9g2lWjKr1SwKV3qpXEK7UfptQnDMaaQvvApWUcRABpavgtAEHwcAbEJT7QLHUWF8CTer57s=
X-Received: by 2002:ac8:2ac5:: with SMTP id c5mr44962908qta.332.1558109871467;
 Fri, 17 May 2019 09:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190430223722.20845-1-gpiccoli@canonical.com> <CAKM4Aez=eC96uyqJa+=Aom2M2eQnknQW_uY4v9NMVpROSiuKSg@mail.gmail.com>
In-Reply-To: <CAKM4Aez=eC96uyqJa+=Aom2M2eQnknQW_uY4v9NMVpROSiuKSg@mail.gmail.com>
From:   "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Date:   Fri, 17 May 2019 13:17:15 -0300
Message-ID: <CALJn8nME9NQGsSqLXHQPEizFfKUzxozfYy-2510MHyMPHRzhfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     Eric Ren <renzhengeek@gmail.com>
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 12:33 AM Eric Ren <renzhengeek@gmail.com> wrote:
>
> Hello,
> [...]
> Thanks for the bugfix. I also had a panic having very similar
> calltrace below as this one,
> when using devicemapper in container scenario and deleting many thin
> snapshots by dmsetup
> remove_all -f, meanwhile executing lvm command like vgs.
>
> After applied this one, my testing doesn't crash kernel any more for
> one week.  Could the block
> developers please give more feedback/priority on this one?
>

Thanks Eric, for the testing! I think you could send your Tested-by[0]
tag, which could be added
in the patch before merge. It's good to know the patch helped somebody
and your testing improves
confidence in the change.

Cheers,


Guilherme

[0] https://www.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes
