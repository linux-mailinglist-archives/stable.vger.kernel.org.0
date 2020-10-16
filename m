Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F9C2909E4
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409200AbgJPQpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:45:45 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48994 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409082AbgJPQpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:45:44 -0400
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5531C2090E5A;
        Fri, 16 Oct 2020 09:45:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5531C2090E5A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602866745;
        bh=542QDJZ+B/cg0axnQiCfQ5sg56CaXctfu4kzaV0IpAA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OhuM4ZtC17UMj1v9vK1hUJrfXUdM30RUw7qJkyUUF6q5goZwS7ZWxZZo4kCuIvEgm
         ZDbYAf+8oD2a6fT1CXUoGnjuy4BF92KyfXu08oou7gMFjH94CE1rXIp6VYQ+6vxZXF
         cvn5rnLBpzWQNiidRlq2W17qpMJrX6pgn5Lq9pzQ=
Received: by mail-qk1-f181.google.com with SMTP id a23so2384106qkg.13;
        Fri, 16 Oct 2020 09:45:45 -0700 (PDT)
X-Gm-Message-State: AOAM5321C9HzQOwp5N9T+EP1F4smfLcJBEmdLXTcX2pqkf3X9Qb+/6mG
        YWG5G+gRkrQbXJfY9lO4z52DUyMNxWwWyn0n8so=
X-Google-Smtp-Source: ABdhPJw27DGni4F09kKQV25U5EziCkq3TkVrjSarep1ui3JDxtgLa+zPKbml6e3cNcid8ugJexx0GwNP8JBKQVNSvCw=
X-Received: by 2002:ae9:e108:: with SMTP id g8mr4687994qkm.220.1602866744338;
 Fri, 16 Oct 2020 09:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201014212746.161363-1-mcroce@linux.microsoft.com> <20201016122039.GH8871@alley>
In-Reply-To: <20201016122039.GH8871@alley>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 16 Oct 2020 18:45:08 +0200
X-Gmail-Original-Message-ID: <CAFnufp1-0jj8Tq=NLRgFnUP5_j4GooguLz1AVTu16L8XR4e6Sw@mail.gmail.com>
Message-ID: <CAFnufp1-0jj8Tq=NLRgFnUP5_j4GooguLz1AVTu16L8XR4e6Sw@mail.gmail.com>
Subject: Re: [PATCH] reboot: fix parsing of reboot cpu number
To:     Petr Mladek <pmladek@suse.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 2:20 PM Petr Mladek <pmladek@suse.com> wrote:
>
> On Wed 2020-10-14 23:27:46, Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> >
> > The kernel cmdline reboot= argument allows to specify the CPU used
> > for rebooting, with the syntax `s####` among the other flags, e.g.
> >
> >   reboot=soft,s4
> >   reboot=warm,s31,force
> >
> > In the early days the parsing was done with simple_strtoul(), later
> > deprecated in favor of the safer kstrtoint() which handles overflow.
> >
> > But kstrtoint() returns -EINVAL if there are non-digit characters
> > in a string, so if this flag is not the last given, it's silently
> > ignored as well as the subsequent ones.
> >
> > To fix it, use _parse_integer() which still handles overflow, but
> > restores the old behaviour of parsing until a non-digit character
> > is found.
>
> Hmm, _parse_integer() is an internal function. And even the comment
> says "Don't you dare use this function."
>
> I guess the it is because the base must be hardcoded. And
> KSTRTOX_OVERFLOW bit must be handled.
>

I know, but it's the only function that I know which has the same
behaviour of simple_strtoul(). Other than sscanf, which uses
simple_strtoul().
I didn't know that simple_strtoul() is no longer obsolete, I will
revert to it then.

> I suggest to go back to simple_strtoul(). It is not longer obsolete.
> It still exists because it is needed for exactly this purpose,
> see the comment in include/linux/kernel.h
>
> The potentional overflow is not a big deal. The result will be
> that the system will reboot on another rCPU than expected. But
> it might happen also with any typo.
>
> > While at it, limit the CPU number to num_possible_cpus(),
> > because setting it to a value lower than INT_MAX but higher
> > than NR_CPUS produces the following error on reboot and shutdown:
>
> Great catch! Please, fix this in a separate patch.
>

Ok, thanks!

-- 
per aspera ad upstream
