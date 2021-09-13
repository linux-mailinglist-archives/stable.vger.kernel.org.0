Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D25409C69
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbhIMSkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbhIMSkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 14:40:51 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7263C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:39:35 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id g14so18999704ljk.5
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gsr5LZp4mspjysvxu5nUdPKorXySGG+JMQ2KUyjakOE=;
        b=tcNOwy+hx3G7tDym26NrZiXL2XWVfVOinWzaPRaxtSumdMCEMHyQMS5xN+W+Z2a3Pp
         Yyjh/Aquz4bS5k72F8kzeTZLT6pSCAwxItpi90F1EBgGsfx0a7X5GHKo9kEfQnIw/K5o
         7FmsF1N2fJOdGgHBXU9jSs6LZXwz6kp3GvpswTBmJ4XVr+8MLfvY2DnXC45Tf+PJiita
         sPgwimOij4te8yuQYluDFNeehCU/E13bJ7Z26XkxG5BIjzjHtbrIcJtf/SECJRqEzJoS
         lGMzeeTXj49IrKVF2TkOEbCd9wb8x356nbZqWE8MShw7jmb6O6C2PkQEEgNqFbtUqPLA
         Zngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gsr5LZp4mspjysvxu5nUdPKorXySGG+JMQ2KUyjakOE=;
        b=tNrh5vfT5xjCdufRLTaNPt/2liykbmHWoXGzSbNB/rnprWXyS0sdmU4pGuJ5B8AGMu
         WaiIRIa0DLedMcJwAzcaAa3WDR/m8k0NOJzjDSQwszXyVMcxeoDm6HH6Sa0hySEf9LUE
         GGxRdlyqq7S5e5kecMYkAzGxLYSkpLUJWk24WZ1D2BuW6fpAmx2OjI6XDwk4t/99tyRp
         7mnT4pl3MzDjvp8qiT373p8FT4/Xw8BQKtXrFCB5fOJFZNxh209M5/YVBaPvyz+Xm4J9
         3OXkOlyZ2vwjbWYTZ/ROvRpFFLhoAnP+MyvF4/yNR/u/ktuRT6tarzLXf27ywGZGgrW0
         /U6g==
X-Gm-Message-State: AOAM531OruIQHLI0zpMVB1TYUVWdvQdPYeXDPZuk4kVZ5Sth2iIBrSH3
        gPv+D2UuNxbNTbB5YY0G7cYDcsdahK7TfnryVw2XlVGc525vKA==
X-Google-Smtp-Source: ABdhPJxr4FCmAlu5SlbIY3KpCOou2NcGaA/MSwV9TxbMuHHx3SyU4FoEmbG/iNG0U1htM5yQCZ0AvH3kwb0F3zNiDOw=
X-Received: by 2002:a2e:8808:: with SMTP id x8mr12089846ljh.220.1631558373845;
 Mon, 13 Sep 2021 11:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com> <YT+RKemKfg6GFq0S@kroah.com>
In-Reply-To: <YT+RKemKfg6GFq0S@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 13 Sep 2021 11:39:22 -0700
Message-ID: <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Baokun Li <libaokun1@huawei.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 10:58 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 13, 2021 at 09:52:33PM +0530, Naresh Kamboju wrote:
> > [PATCH 00/10] raise minimum GCC version to 5.1
> > https://lore.kernel.org/lkml/20210910234047.1019925-1-ndesaulniers@google.com/
>
> Has anyone submitted a fix for this upstream yet?  I can't seem to find
> one :(

That lore link has a series to address this, though that's maybe
something we don't want to backport to stable.

I thought about this all weekend; I think I might be able to work
around the one concern I had with my other approach, using
__builtin_choose_expr().

There's an issue with my alternative approach
(https://gist.github.com/nickdesaulniers/2479818f4983bbf2d688cebbab435863)
with declaring the local variable z in div_64() since either operand
could be 64b, which result in an unwanted truncation if the dividend
is 32b (or less, and divisor is 64b). I think (what I realized this
weekend) is that we might be able to replace the `if` with
`__builtin_choose_expr`, then have that whole expression be the final
statement and thus the "return value" of the statement expression.

I need to play with that idea more; maybe that could be a more
manageable patch for stable.  But I also need to eat lunch, and I've
been in the Rust for Linux conference, and trying to organize 3 other
conferences for the next two weeks...
-- 
Thanks,
~Nick Desaulniers
