Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4182C141D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 20:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390623AbgKWS5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 13:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730447AbgKWS5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 13:57:35 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05BCC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 10:57:35 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id v21so15126018pgi.2
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 10:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zGSY2QBNDVwTrt6UF59/IY0bNzTXH+ThIjhC32RLkXk=;
        b=tDmZ7CoDuJGl3c7A1CSw+9phP9dOx7qPouZuE3PNRR/lCzFhmigHFYUd9TNOJGSyjf
         YkIU5+ZelXbuKSxdXsE+Mv+tTnD8UuCuPnxGR+DAr99Orbd7M/8e5rwV7UrIXffdtsS7
         ESrMN2RP/Bjo3DWxgNz9sXQco4m8coLJsyuRc1y9D7RJvs0vnPeaBdy5qNskek4fudMA
         YNVwkbLSh9ymhpxaIoYOZguukBbebw+jEUgTW/pjhArXiCVOiNTP1LC5PeE5feRiHmxF
         TNevfsoUctjBZHNCJvGSdio95FgX22EiznX20OxTShLbvuSyl8MNieQB/Op1h/D80fVP
         VD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGSY2QBNDVwTrt6UF59/IY0bNzTXH+ThIjhC32RLkXk=;
        b=WzLWNrt+5zlRMXTU35hI4rUbBUp0HWHEOsykNDd9Js1TaqfanY/wtt12IxoEKHzp0X
         B7uIycEHa7ILSVU2kxW+VFCJvEcJVwG23Tt2pOSNcBK+EkcsYYdlY9ISE5eMVvekjaHL
         9bzKhlb+SnSxRfFdFDauKRQHMIiZ1qVnbuxq6akbnc8cdk9UFhuyle3SmzoOds7prwhU
         bjzAKpc1744j6kgCRHl65t+9+M7sLbkY9aJ41Z5jq7JNw0h56mlcnAT8MkFh7a+07VoB
         g7D1zPCwUy1uBr/HlXVafnfHJFabpcDmScKlrT9oLsLosharkCitkUMq8nd58GpJUEyJ
         hxTg==
X-Gm-Message-State: AOAM533JDnJn4Qy1NhrtNPCBJ+hh3Hq5rmCuwk8/PGU0lbtyDx2HLGS3
        ViCH7u/HsZzfMrkUFSMTs59gcngmMn81PFSo6ZLJ0w==
X-Google-Smtp-Source: ABdhPJyFsT7Bu5Ad9nxY28H8VRh0wNFgpzmpQF6uX9rqBmhNj6Wn/jdyE7/8i+D7EMBBdfLIDwkjUgNqOv32tqhfyrU=
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id
 144-20020a6218960000b0290197491cbe38mr772787pfy.15.1606157854988; Mon, 23 Nov
 2020 10:57:34 -0800 (PST)
MIME-Version: 1.0
References: <20201123121819.943135899@linuxfoundation.org> <20201123121822.053682010@linuxfoundation.org>
 <CAKwvOdmX_M6wn-UUO39EqRZNbHCn22dsNND6sZ6q+Tzjyez=7A@mail.gmail.com> <X7wEWQsR6N8KMzVI@kroah.com>
In-Reply-To: <X7wEWQsR6N8KMzVI@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Nov 2020 10:57:23 -0800
Message-ID: <CAKwvOdnrMdMjuJcRuPg6CgeGZds_td2DNrPNaReFuyg9NEMExQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 044/158] compiler.h: fix barrier_data() on clang
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 10:50 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Nov 23, 2020 at 10:31:10AM -0800, Nick Desaulniers wrote:
> > Doesn't this depend on a v2 of
> > https://lore.kernel.org/lkml/fe040988-c076-8dec-8268-3fbaa8b39c0f@infradead.org/
> > ? Oh, looks like v1 got picked up:
> > https://lore.kernel.org/lkml/mhng-8c56f671-512a-45e7-9c94-fa39a80451da@palmerdabbelt-glaptop1/.
> > Won't this break RISCV VDSO?
>
> Oops, let me drop this, I did so in the past for 5.9.y and it looks like
> Sasha missed that and added the fixed patch to 5.4.y...

No worries, I plan to email backports directly to stable with the
dependencies sorted out. Probably after Thanksgiving. Thanks Greg!

-- 
Thanks,
~Nick Desaulniers
