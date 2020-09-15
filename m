Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF526AFC6
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 23:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgIOVmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 17:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgIOVbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 17:31:48 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B693C06178B
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 14:31:20 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id 7so2783354vsp.6
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 14:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dFv9Gx6tvlxqa0/RzOqnD6QC+ix0oiRzcNzkhnH/umg=;
        b=J6c70s4fTxjUka3LSjMXvXapX2EgOftb7Jx/0Me/tYRCMZ1Fry/85pl56tcuFKxXXy
         Hn6VPz59EluVLdwPyOMvouhWA0gghHAc7i5k+Vo3KoU8DIIoJBYX0MCA36yjVqUsJnNw
         N5pWQiuwt2wPnbYwhP6JiECPP4K3ptOVviZOYJouJ575MXwMfUWbT1DoyimZvjd3xaVN
         2jcrfwNX0HcUgam9EA21L7Ublef3WMLoaxVThb9bfzekMoL5rltMNUY349yGWo2GTcjG
         hQu9E1I4nysVbjWAd/dT2u2GTFGwOWuhUcVEaw/GmULzBI1/htO6DRfwVyem85s8CN4i
         LqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dFv9Gx6tvlxqa0/RzOqnD6QC+ix0oiRzcNzkhnH/umg=;
        b=lQhIVs6Fi5sEZWW2vttTc4MZcRluGTg+ywtaXxVF2smvZcYcuB4Se7Su+9WcCSj48h
         ODVXSvmVyh6z47LLcYOd5gxwkqCr5owj5RAIq2CC6qLe6Dzvh8eF6sdU450Fgl/wnjSe
         zQZEYqLQ+LY8hXbRCyXlborxVN6Yt5FJglFqUThprJx1MxBNtxf47Xp3iOyPljzqEtFj
         TyMZmiI4dh/WIkP4uOeDubhhfLFI7oFCiHI5M4C9tDXchcd79+qmPxcpgT1FMTszsLcX
         PkWRN3UuU6vlFWCbbMDHU+qq3vgi6G0quiDWt9PmtU5coJnQ4CnjroAunvOZeWBap056
         JtqA==
X-Gm-Message-State: AOAM531lM+yc7ZwSaY1KBRsy+miW6npysAqkCjYrsMbb4ewocaBFvvp/
        mZBZSPPWZNYygvaCQGCMJzMevzGyqqaDZ/NaJm1t
X-Google-Smtp-Source: ABdhPJxLINW13QOxGnh3QVD4VYNyS7XfvbgeJoOWRLap1E8aGmIK5kjDY0bGJdnXxK0L10z9PeNWjBlMkrCVHhWnCqQ=
X-Received: by 2002:a67:e248:: with SMTP id w8mr2932477vse.40.1600205479121;
 Tue, 15 Sep 2020 14:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <9f513eef618b6e72a088cc8b2787496f190d1c2d.1600203307.git.luto@kernel.org>
 <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
In-Reply-To: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 15 Sep 2020 14:31:07 -0700
Message-ID: <CAGG=3QUfqup=Uv1mdwe6qecsZFAqfZUxXX+a+CnJLvfufWUykA@mail.gmail.com>
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 2:24 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> On Tue, Sep 15, 2020 at 1:56 PM Andy Lutomirski <luto@kernel.org> wrote:
> > Fixes: e74deb11931f ("x86/uaccess: Introduce user_access_{save,restore}()")
> > Cc: stable@vger.kernel.org
> > Reported-by: Bill Wendling <morbo@google.com> # I think
>
> LOL, yes, the comment can be dropped...though I guess someone else may
> have reported the problem to Bill?
>
I found this instance, but not the general issue. :-)

-bw
