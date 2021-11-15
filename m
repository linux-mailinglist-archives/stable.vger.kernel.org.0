Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E491451370
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348251AbhKOTvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbhKOTVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 14:21:20 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92DBC03D78D
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 10:17:43 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id ay21so36746882uab.12
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 10:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+a8ZktNn6ZKD5SR+F36fH6n6kb1h7BS7jd1Wp45NaFM=;
        b=gKjpO0lLV7NAzCVw+nwCxA8yC44R21WAWD2XjYYi0XvHIj7m390XTLd0lEN5Nn7rcB
         BuK4C1Cfgw1j9IVR5y4ccOOC9HnZhA9Q9ERm3Q22nj0xyYhHPPZ+IYpHX27qbjUCyDa9
         FjBo+0o5USkN9WjUnl/bLBY+ePanR03FsUeaamVOMTsyk1ZuvITwcd6QcOScign6Qmun
         u7WUTMpODzERw1+OGJLsaUtAupMXVPh3UXvanz5tAdren74UjX5wDmMwtt0tuKXcncWg
         TUyJQc40cjABQb16NUrbV/xR8FV0L6K9gaV5knCQzF0+juocFBSz2mXCLAEddrjvWuAo
         708w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+a8ZktNn6ZKD5SR+F36fH6n6kb1h7BS7jd1Wp45NaFM=;
        b=iYmNr6SXHKuuvrl+nB93vpkrX58yWjjPpdYQ7nII9Un6Q5ymY36znwrnl8aimrrK2c
         0D4nYOPs9pETT/ieVR1QhtDswclmHR9TnLiGDqDLemyUTofoIV8/ERRoOcKJITIAiFw2
         U33l7QfFKZF8FLd9CekNj82sZVN1hy/Mx+OVb1/IRQZUK9X96tMjp/z5s2CBuAn1dDYs
         ZVkLF3+L+V16X0qlg54vq4KFvJAfTWlbk0Y4ublDPU6QJAjRre5p4XLf8nuwI7umVvkS
         5xZq7EF8g7o7t6+iTVe5z8ZpocF41Q7ZVfVjqSyUK413xa4IDp8bVA8cYgItMDV6Xt4J
         6Xyg==
X-Gm-Message-State: AOAM5322/OO3SDfIAa1gWRKF+95ZhncYVvA8YkXBEqaC8BRCZ+oe6AT8
        RuIriKmj+4S4tfFtXNGPLBX1CnPZLCMN/wPzHyUxgw==
X-Google-Smtp-Source: ABdhPJya8J9a4P+RjZgEeXSNntVJy86MJNmzIPw9P4CUF+9L+z4wnWDoOasaaQi9RrdEFaJXT3F+c+2vxQUEakzHjTg=
X-Received: by 2002:a67:df96:: with SMTP id x22mr46045260vsk.9.1637000262835;
 Mon, 15 Nov 2021 10:17:42 -0800 (PST)
MIME-Version: 1.0
References: <20211115173850.3598768-1-adelva@google.com> <74179f08-3529-7502-db33-2ea18cab3f58@kernel.dk>
In-Reply-To: <74179f08-3529-7502-db33-2ea18cab3f58@kernel.dk>
From:   Alistair Delva <adelva@google.com>
Date:   Mon, 15 Nov 2021 10:17:30 -0800
Message-ID: <CANDihLE5oO2=MDiPtGmUzZgaPuzT2_X7da-vKe+ybBJkXgnsAQ@mail.gmail.com>
Subject: Re: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 10:04 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/15/21 10:38 AM, Alistair Delva wrote:
> > Booting to Android userspace on 5.14 or newer triggers the following
> > SELinux denial:
> >
> > avc: denied { sys_nice } for comm="init" capability=23
> >      scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
> >      permissive=0
> >
> > Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
> > better compatibility with older SEPolicy, check ADMIN before NICE.
>
> Seems a bit wonky to me, but the end result is the same.

No argument from me..

> In any case,
> this warrants a comment above it detailing why the ordering is
> seemingly important.

Sent v2.

> --
> Jens Axboe
>
