Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A4B5F4AAA
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 23:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJDVGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 17:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJDVGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 17:06:11 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2872A6B151
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 14:06:10 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id kg6so16160769ejc.9
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 14:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PGXp3VOaj51mo3NAOboUEy2QOQRbII2zrb0XhYBKtGM=;
        b=ei9P+Bd8IeYaUbJs/c5FUcgm+e2dtUe8rcWZVo37eSWgUxP4UD6QIGM56JRbUsdKAq
         4ChHOm92aseqM7vhWHDHYMlhdU4mpHqDSVbRYUQtjYgUHVj3Ewp87aHLGcd92ibTqxNU
         2IGstbKW8X5ojiiNgUj0SQuMnL9V9JtF3auD/RllL0djegSirzfVdKiYefVkgtWql0Ui
         FPpD9GZc3H9ebBi3c7N2NFImWUYv8+LyW95cg8EwHPK4pjqhyJKcUIGMqHjkSE/9cOIM
         FjV23SIMC2JLakD2F+Htd1704Wd9H3+8iaB5WOQW5T8vEPL0q7CVDVkVUWIg8kMr3WjP
         Mnmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PGXp3VOaj51mo3NAOboUEy2QOQRbII2zrb0XhYBKtGM=;
        b=j0+6MXDWDPUi+Zzv1abmBudqtdN4z+x7TNp9/aVjlavrRGRjyogUl0w42om0yTVzm8
         4wWiDHP3cRfRQYSf1S1PE5CP7xXbVY727Y9latSFI8gaOInSCiNkPnmaIXQVOKcjIIkc
         bEJf77Sj5DzIsp9IcCYLwUFGp+dM2z0cSIsfUrWgsF3iAa8kRF4V9PsabcRXkRI0wcfL
         vH/k4DbHJ5PIyeMlTJubs0AzidJTBBkOC+BAc1YX8OGd3hCjNF9nifMfBMGkHFVVEa6H
         BqGtSwTNwkHqQV/C+7A9LF+DpAxbyDxWb1yBV7nLlgNnbQw5JxzhMN/FDyxP87QFE5tX
         NfyA==
X-Gm-Message-State: ACrzQf3EWF2Q7IF658NAux9dJq/uAdHl0fiXcInTcURpvwuqWdsncNQR
        j5fygehA6kwd/sIKDS/Dh39ZTAzCN0/FJWtOrACtVg==
X-Google-Smtp-Source: AMsMyM6miuRPK7ev9MZ5sjWqzSrdpKNre547CDGwOeRVZ1Z48m1CIIGuRzThsoRIBOpqKcU0yJDkhB88phMaaOnIcJE=
X-Received: by 2002:a17:907:6d28:b0:782:32ad:7b64 with SMTP id
 sa40-20020a1709076d2800b0078232ad7b64mr22349233ejc.23.1664917568615; Tue, 04
 Oct 2022 14:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221003224531.1930646-1-sethjenkins@google.com> <20221004114621.7b539d2c3618b25037c4f2d0@linux-foundation.org>
In-Reply-To: <20221004114621.7b539d2c3618b25037c4f2d0@linux-foundation.org>
From:   Seth Jenkins <sethjenkins@google.com>
Date:   Tue, 4 Oct 2022 17:05:57 -0400
Message-ID: <CALxfFW6vLiASgY8BBBS8fJETTwv7iApnPjT0NJYJWTbDbRVJ-g@mail.gmail.com>
Subject: Re: [PATCH] mm: /proc/pid/smaps_rollup: fix no vma's null-deref
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I concur, mm-stable looks fine to me as well.

Jann and I conversed today and the tentative decision since this isn't
considered a high-priority security bug is to wait for maple tree to
merge into Linus's branch before submitting this patch to stable.

On Tue, Oct 4, 2022 at 2:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon,  3 Oct 2022 18:45:31 -0400 FirstName LastName <sethjenkins@google.com> wrote:
>
> > From: Seth Jenkins <sethjenkins@google.com>
> >
> > Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
> > seq_file") introduced a null-deref if there are no vma's in the task in
> > show_smaps_rollup.
> >
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -969,7 +969,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> >               vma = vma->vm_next;
> >       }
> >
> > -     show_vma_header_prefix(m, priv->mm->mmap->vm_start,
> > +     show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
> >                              last_vma_end, 0, 0, 0, 0);
> >       seq_pad(m, ' ');
> >       seq_puts(m, "[rollup]\n");
>
> The current mm tree is very different here.  In fact the bug might not
> exist any more.  Please take a look at the mm-stable branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm?
>
> If no fixes are needed in mm-stable then I guess the process is to
> propose this patch to the stable tree maintainers.
>
