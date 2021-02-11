Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719FF319279
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhBKSrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhBKSq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 13:46:58 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6F7C061788
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 10:46:18 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id g84so7258639oib.0
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 10:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=91GcU1VsBVz3FYSR+U/pa4MztTHbqU+7RC9yCYvzYc0=;
        b=D75yU+4hQYTZNquIdcs8budOC8Xa/TjmEPESrTS6vnG1TcE3DidrBRttPPRsawIXxy
         /lxfWlpqAg+LbTH7UwR6MCcjagqL7K/15Xio7Ua91TS082iUBO5trwzNXxZPZrQ4098M
         7lA4V2N8q+gOvNB9KGMRFAPk3ggi7XiTzoeUdDd4HBtfFKh57mo4V4J21OiZE00esE+8
         oygAEsgp9VrumXQ69HdVk/efA3aWIeunaJZ2Vxbk+7U5QPLvv+pOuG3/9XHHMpBPRjnF
         3fU7EeDs1aAROMHMyLl8Uxy6r48LMELXXLxW8gBPEHv3VEMtBaM/DUQq6ggMB/v/aZx0
         zYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=91GcU1VsBVz3FYSR+U/pa4MztTHbqU+7RC9yCYvzYc0=;
        b=Ij+qDdBtwURzVuRAmpt/jaYMEYtxk0TBVYiRVrz4kimBd/pkte7w00qJcEaQL0fKss
         AQlVFf9OMzHfYWFylhACFXS6jN2KrWQ2bHz2mDDz32mjsy5He5rYz0hCT1QjcZdL3JJM
         OKTtupGs3DaP1BjEf6EeeFQ51UnPrZ8cO5aXzCuvF6ZM9MKqUvbqPZSMqkFyF0GC7uOI
         h4pM3af0UURz4BKOqpqwxd9BuyG8MpiNchiZm5ROddLlVgelp5Mem0IfEueg0vUD3oqz
         oUk59taXtDfIhjftjLI0Hrxz4WAOb+lOrPeETQpZu5VjEt9Q8datRE69+O3II7zhCNt5
         ufKA==
X-Gm-Message-State: AOAM533xn5c6XHBNTPh3uOP9jGVI+E0jo2LF3bhzV9b9f7Av2p9ziJcm
        t2AvRvKnJdq1UkwhWJNfX2vWxqjXBi8+3jloiiAhaw==
X-Google-Smtp-Source: ABdhPJwnLvs6LPAcpWrc/9dCYZHZYfS+QKV2BP8u5znNiYmi4A5EUDRhQnB5T/HqH2lP0H40DExXmh5igB9xCy9ahFA=
X-Received: by 2002:a05:6808:294:: with SMTP id z20mr3709431oic.14.1613069177774;
 Thu, 11 Feb 2021 10:46:17 -0800 (PST)
MIME-Version: 1.0
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
 <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2> <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
 <YCU3Vdoqd+EI+zpv@kroah.com>
In-Reply-To: <YCU3Vdoqd+EI+zpv@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 11 Feb 2021 10:46:05 -0800
Message-ID: <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xi Ruoyao <xry111@mengyan1223.wang>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 5:55 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Feb 11, 2021 at 09:32:03PM +0800, Xi Ruoyao wrote:
> > Hi all,
> >
> > The latest GNU assembler (binutils-2.36.1) is removing unused section symbols
> > like Clang [1].  So linux-5.10.15 can't be built with binutils-2.36.1 now.  It
> > has been reported as https://bugzilla.kernel.org/show_bug.cgi?id=211693.

Xi,
Happy Lunar New Year to you, too, and thanks for the report.  Did you
observe such segfaults for older branches of stable?

> 2.36 of binutils fails to build the 4.4.y tree right now as well, but as
> objtool isn't there, I don't know what to do about it :(

Greg,
There may be multiple issues in the latest binutils release for the
kernel; we should still avoid segfaults in host tools so I do
recommend considering this patch for inclusion at least into 5.10.y.
Arnd's report in https://github.com/ClangBuiltLinux/linux/issues/1207
mentions this was found via randconfig testing, so likely some set of
configs is needed to reproduce reliably.

Do you have more info about the failure you're observing? Trolling
lore, I only see:
https://lore.kernel.org/stable/YCLeJcQFsDIsrAEc@kroah.com/
(Maybe it was reported on a different list; I only searched stable ML).
-- 
Thanks,
~Nick Desaulniers
