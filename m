Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5F5149C69
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 20:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgAZTDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 14:03:47 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45114 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZTDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 14:03:46 -0500
Received: by mail-yw1-f65.google.com with SMTP id a125so835855ywe.12
        for <stable@vger.kernel.org>; Sun, 26 Jan 2020 11:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uRTKFC8tkNpVzZjh1xTaFB0CylTteHOERXk+IQjSUU4=;
        b=tT9U55m2toAaypKCHa3uaKkjYNiBEQ6MSN043rjhb/jbWOGwPMLokOoScfHEKlmHic
         +MplA1sARTVuRlhld2lE0IrIiNIV7z2ydBaTgqnmhQbKTUy/9qMF4cjRREKJMscGMafV
         nlkWQ/w9Bg4ZL/ucG/O7EaN5PBfSmUwZA6RkjuwzSYgbt58fxsghvNM+wfZTGGSmLE+w
         oPqUIW6N72BRLAtXZ6QQWW1coEbAuf4OGeDTgHiNZ02U3tveyV3IQ/MrrWGETKNbCcWN
         YjzwN1PL4K3AdEoAShD9cmYrV4V5qtsMxWJzTX+Li5EtqiucpjJ+5VAUNIBA8ijY/z5Z
         WDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uRTKFC8tkNpVzZjh1xTaFB0CylTteHOERXk+IQjSUU4=;
        b=MLY7Wk6KP3A+Kj9Y+CsspcYnjxoktmbI284wre5IAG6iKH0oOJSyYt15yleHSS3c7q
         qoxq6ZOm8dq+e6Ko5VfnFEZlVXnGOAbivUNrMVo7yP2BX1kfCZbAajZY0WkXGyT8EHhl
         pkMYbm57nSErN9+sAlB5xPtm4u5eY882WySRHYH9tNTnaJPYkGDJcnD5naeuTvUn8Lu0
         IUb5stUhvWtKLs4BFPuYVjSOy9Sk1Q45aUF+T4PRJepyU8wyKJTC76mrg/npChwPhpj2
         WMjFTfaURyBgxCK/7K2slYU2wm8By9IMTcSEvjULUCk/EXFRY/GCOiQsV64KQx/k9Hv7
         XYLg==
X-Gm-Message-State: APjAAAVUf2P9oaA3Dh7pYROTknuT19AgiB2iR6kAQxU4XWvn8zfpQEZi
        yOCJdrxZcHgJltGY3k2mZLe+8h9ACk6yhvTsZbbxMw==
X-Google-Smtp-Source: APXvYqzG6ESP151wQdhyAf8/g4tYA71B5x5G8VytepUfspekee2MwQgF71vP/HUjuNjJK+KmtsqqDrX4Nv30tAzNiRM=
X-Received: by 2002:a81:b38a:: with SMTP id r132mr10556836ywh.114.1580065425509;
 Sun, 26 Jan 2020 11:03:45 -0800 (PST)
MIME-Version: 1.0
References: <20200124093047.008739095@linuxfoundation.org> <20200124093204.391643194@linuxfoundation.org>
 <20200126171505.GD19082@duo.ucw.cz>
In-Reply-To: <20200126171505.GD19082@duo.ucw.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 26 Jan 2020 11:03:34 -0800
Message-ID: <CANn89iJLuoQ=R3k_Fz7ZFdhrcsvhH5WxDKbLLhEN-jkzpzz6+w@mail.gmail.com>
Subject: Re: [PATCH 4.19 599/639] net: avoid possible false sharing in sk_leave_memory_pressure()
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 26, 2020 at 9:15 AM Pavel Machek <pavel@denx.de> wrote:
>
> On Fri 2020-01-24 10:32:49, Greg Kroah-Hartman wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > [ Upstream commit 503978aca46124cd714703e180b9c8292ba50ba7 ]
> >
> > As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
> > a C compiler can legally transform :
> >
> > if (memory_pressure && *memory_pressure)
> >         *memory_pressure = 0;
> >
> > to :
> >
> > if (memory_pressure)
> >         *memory_pressure = 0;
>
> Well, C compiler can do a lot of stuff, and we rely on C compiler
> being "sane" -- that is gcc.
>
> Even if compiler did the transformation, that will only result in
> slightly slower performance, right?
>
> Is there any evidence this is problem in practice? Should this be in
> stable?

There is evidence of this problem in practice yes.

Should it be in stable I do not know.
Should stable kernels only be compiled by old compilers, I do not know.
