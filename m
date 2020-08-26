Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD66B253597
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHZQ6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgHZQ6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:58:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F2CC061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:58:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q1so1137623pjd.1
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ruBxf096ym9usi++FSuEPp4K8G47UnSV5rxmh+VEh4=;
        b=CNAj0WU7APXwzXX7Pgh0wY1PTwPfSLIPM5Jil5o+T5N4jUGo5+EKR/ChLR9FR90DTb
         adL6ook8RKLqITnw6Uh9udX1zaxH4UMUnmaO9hKk849lcueGmnYaaxPsY/Jao2lDUFIx
         9jFJKxNUCI1Xy/sGKlKpYagCZRlRYeSgkYeag8jL7QlgMlHj+d31DaUd3w3X5Wp7cJth
         r//+rpBCTWorGq8bX9LyNC+pNGHmqBpgYaK+Q+iniIAaKUrmBdUlI3hbpSKf96WQ3fBO
         /mr836uIMuRWulestTquHy5rOEhED5XzSDvnMOV9X4c0IHYkdjzoM9OGPkaSE5Ca7w0G
         pWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ruBxf096ym9usi++FSuEPp4K8G47UnSV5rxmh+VEh4=;
        b=Wu4QShQPiChUN1dIw9CncooiEC7w7v3q6mPd7lZplbNFffkZ8LIOKjwgJTGVYWfuUD
         KdRQ12g/DxczoDP56n1HLnQySeFGH7abhH9jap3OnbbAdWgTSWTPfERObh88ubiVyR/f
         RyKoam5vD+YYThX3+6wXYKdaRD6cS+ESVHxWfhMqrI44H4C7Xcu54vMU63E+NtzYerkO
         A4jqm3Xl/tBA/wfxLJscxlA6mL92hnrIqAvS0YF1ATOCRdFSZPsXKodGZEAtX468n1EA
         xJl1Ev+PQEQvpmywPXvpLNdXDqRWhnIMdwSlbqjuL50AGyzHIdIGVlb7yLsGOHFVTAmz
         1syw==
X-Gm-Message-State: AOAM532Bo2Q8DCqFo/B3CVfpiO8l/TJ8diBuejXFSeC4v2U47QVGJ77O
        8FP63jVVe6jourI0rB4LKD7GTpdfVtYTgYlvku7Ehg==
X-Google-Smtp-Source: ABdhPJzTSgzt4IMtUGn18bHtBzPXj8CcOOTUT4AYBvrGLdEOW3RKHpfc5ZfYx8biM/CSPtPDInAtTaQtC+a7s9SwTpE=
X-Received: by 2002:a17:902:be0f:: with SMTP id r15mr12843216pls.84.1598461092696;
 Wed, 26 Aug 2020 09:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com> <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
In-Reply-To: <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 26 Aug 2020 09:58:01 -0700
Message-ID: <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
To:     Joe Perches <joe@perches.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 9:57 AM Joe Perches <joe@perches.com> wrote:
>
> On Thu, 2020-08-27 at 01:49 +0900, Masahiro Yamada wrote:
> > I do not have time to keep track of the discussion fully,
> > but could you give me a little more context why
> > the usage of stpcpy() is not recommended ?
> >
> > The implementation of strcpy() is almost the same.
> > It is unclear to me what makes stpcpy() unsafe..

https://lore.kernel.org/lkml/202008150921.B70721A359@keescook/

>
> It's the same thing that makes strcpy unsafe:
>
> Unchecked buffer lengths with no guarantee src is terminated.

-- 
Thanks,
~Nick Desaulniers
