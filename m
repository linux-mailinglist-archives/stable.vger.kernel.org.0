Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523924A915C
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 01:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244642AbiBDAA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 19:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbiBDAA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 19:00:27 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D25C06173B
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 16:00:27 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id z20so6245588ljo.6
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 16:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W6vWO5phbqbJOK15XWRuJznkX1ivVtRshDIXGjGnpb4=;
        b=O8w4WotJ2b6rKmKKBJUWufCSv8dzfdHoarzVcOzZdSr+s/PqUwLyF3Ue2tY/unRIz2
         t8ScfVaD++YGalUdIVCUijauCnQxT2Mi26HFXWtPcjhBkU/TVYHOxnr3tl4N2OGO+Yzk
         IYURFJ2SWm7yedjm+OHMjip0qE7cQcTs5iUiaWTI/sImxJIq4tcF/BJN0aCYjL1vSwIM
         RHLlA6mde4MueRj/hCeQCZwH3riRVeC/F4XnG2hp0lSgf3KXJJzpD2OQNb3uLhbTvuvH
         /SWuQvQKnSfBpeuhsfmzTs3/rzdpHv3m9h0wwbaUJMzkg60K5QzAfDUsbsJgpL2GrV++
         lIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6vWO5phbqbJOK15XWRuJznkX1ivVtRshDIXGjGnpb4=;
        b=rDx9+eJ/CxAX6781qoV4WeGFFNx0nsNITNYWj5h0g/Dgc8Wkziu/UJmtn3Zm8QJsv+
         Q2YRK1Gq9p7BMOpKEVdiRndafXstyV8z0uqhWipyIO+6MKf+mXwWZELit8cK8n1Lh3Ea
         bUoslCL5oPODrQsqaURq62Nu+b9nobjtlDIVm8AkwjBNk3UAh+YubyMnaHINSw1n+J8h
         /aDfgsdDo2Cz1Fi/Npil81Hqo23gswlus2E7LV9+B3ZY1QkPZO3fg1IaX2vnIDmF8paz
         GRShySDBCNQxZ351RLH1tr9Cc0m4rTGlZoiI4rIIdDB3cqEBjYThLW6gUw2b27yUPh1m
         X+3A==
X-Gm-Message-State: AOAM5339+12VeOmjQghBK41byNXKIOIC3w3MuCJABsqPDnockBp8aTeo
        Ht3FwVqinE29Yd0i4VJ+U7jeV1E6yXPlIyXWQ09ZJQ==
X-Google-Smtp-Source: ABdhPJwqnKLO1BWi4vxnVtC5ADx5qhgj0i+dCH1oMioRtJ0A+yCanphIAmcv0oK4faOF84+sxzP6HgxOzGH15JBCK84=
X-Received: by 2002:a05:651c:1249:: with SMTP id h9mr234541ljh.375.1643932825587;
 Thu, 03 Feb 2022 16:00:25 -0800 (PST)
MIME-Version: 1.0
References: <20220126025739.2014888-1-jannh@google.com> <87czk5l2i6.fsf@email.froward.int.ebiederm.org>
 <CAG48ez3byq=Cn4xGt5HmLBy9fWBapX9RdF-9JOaAus=rDR2TYQ@mail.gmail.com>
In-Reply-To: <CAG48ez3byq=Cn4xGt5HmLBy9fWBapX9RdF-9JOaAus=rDR2TYQ@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 4 Feb 2022 00:59:59 +0100
Message-ID: <CAG48ez1RzO8KrbAv_9kwRCyjS7E3K+adJzdqV6uLqKPoyQmPnw@mail.gmail.com>
Subject: Re: [PATCH] coredump: Also dump first pages of non-executable ELF libraries
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Bill Messmer <wmessmer@microsoft.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 2, 2022 at 6:43 PM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Feb 2, 2022 at 4:19 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > Jann Horn <jannh@google.com> writes:
> >
> > > When I rewrote the VMA dumping logic for coredumps, I changed it to
> > > recognize ELF library mappings based on the file being executable instead
> > > of the mapping having an ELF header. But turns out, distros ship many ELF
> > > libraries as non-executable, so the heuristic goes wrong...
> > >
> > > Restore the old behavior where FILTER(ELF_HEADERS) dumps the first page of
> > > any offset-0 readable mapping that starts with the ELF magic.
> > >
> > > This fix is technically layer-breaking a bit, because it checks for
> > > something ELF-specific in fs/coredump.c; but since we probably want to
> > > share this between standard ELF and FDPIC ELF anyway, I guess it's fine?
> > > And this also keeps the change small for backporting.
> >
> > In light of the conflict with my other changes, and in light of the pain
> > of calling get_user.
> >
> > Is there any reason why the doesn't unconditionally dump all headers?
> > Something like the diff below?
> >
> > I looked in the history and the code was filtering for ELF headers
> > there already.  I am just thinking this feels like a good idea
> > regardless of the file format to help verify the file on-disk
> > is the file we think was mapped.
>
> Yeah, I guess that's reasonable. The main difference will probably be
> that the starting pages of some font files, locale files and python
> libraries will also be logged.

Are you planning to turn that into a proper patch and take it through
your tree, or something like that? If so, we should tell akpm to take
this one back out...
