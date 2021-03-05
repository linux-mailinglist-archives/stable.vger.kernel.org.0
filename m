Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C7632DFF3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 04:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCEDLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 22:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCEDLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 22:11:40 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24553C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 19:11:39 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b1so1150211lfb.7
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 19:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1SzMrfj44v5ad8/vjKQPwkulCcKubsSMyWBXlMUKW+g=;
        b=DWb3FTnptNyi6PKHqbMWKGaeBsYzOicXjNxwtldl+kcr58Zd3f99dmXY/f+CrR7Ir+
         vU31i5uBhMH2IATH21U8ooukZ6ozjnIc4BM0NpFB/oCyvcznYzYEx1EAc8yIwbWFgW4J
         ygGadAvfQvQwtsIVxydwiEGHrdg5u6HRv/i6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1SzMrfj44v5ad8/vjKQPwkulCcKubsSMyWBXlMUKW+g=;
        b=lHoJCN4BV9IoomUBmfdBRH+FvsvLwm9Gl+0w4DYeYDb9ydi15C4I5ueYonTUSHkaYA
         SgsXudgwV2z7BZ/zHtyqp7A3d3hWSWgcRu2kHGC7UaVHz5Crob9e+L/KQLrZ2jpVcTVW
         /1TNE40G3s/lDHvOT4G0MtIYcdksQ9o/bB97/LTwuwld/PO36e232vNpfUXzLigfqzig
         N0CSJskxq0v0eXWDe3R6HZP0HA8gwZFEYWkkNEDG5GobNnwOy/sz0o07kZsfNdC4rcS1
         iXZW2D1p0whQuKROoOIf8wNyqJTnNkNvwf8pPsaA3B7AhoXAfXHngBGBkC860/aHe5wn
         0g2Q==
X-Gm-Message-State: AOAM531MlHrTdLkaGYYqqfcroyk0qIhCScxCbaoDnoceM5TvlXECxr1P
        G5nMNf0BIngfsD7XIbYN/irVVZtDEtVPEQ==
X-Google-Smtp-Source: ABdhPJy+sE6PfOQNFv8Anvw8g+UvDCz6k+qhKtrV6C+VYJozV5C4TtwCjLTElZopAs+kgXTt6wPSrw==
X-Received: by 2002:a19:8b45:: with SMTP id n66mr4143620lfd.252.1614913897437;
        Thu, 04 Mar 2021 19:11:37 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id d10sm142451ljg.112.2021.03.04.19.11.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 19:11:36 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id a17so988179ljq.2
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 19:11:36 -0800 (PST)
X-Received: by 2002:a2e:99c4:: with SMTP id l4mr3911643ljj.13.1614913896317;
 Thu, 04 Mar 2021 19:11:36 -0800 (PST)
MIME-Version: 1.0
References: <1614520628114242@kroah.com> <20210305024407.2631499-1-wu-yan@tcl.com>
In-Reply-To: <20210305024407.2631499-1-wu-yan@tcl.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 4 Mar 2021 19:11:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjxbt8uqFqbTAUcVyTdHfr8p5Q_+sgFX3AJvYc-gz+Ydg@mail.gmail.com>
Message-ID: <CAHk-=wjxbt8uqFqbTAUcVyTdHfr8p5Q_+sgFX3AJvYc-gz+Ydg@mail.gmail.com>
Subject: Re: [PATCH] zsmalloc: account the number of compacted pages correctly
To:     Rokudo Yan <wu-yan@tcl.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 4, 2021 at 6:44 PM Rokudo Yan <wu-yan@tcl.com> wrote:
>
> commit 2395928158059b8f9858365fce7713ce7fef62e4 upstream.

I'm not Greg, but I feel his pain.

I think it would have made it much easier for him, had you explicitly
mentioned which stable tree each of your backported fixes is for, so
that he doesn't have to guess (or try to match up git blob object ID
names from the git patch).

            Linus
