Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B6848B2F8
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243212AbiAKRM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241342AbiAKRM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:12:27 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB274C061748
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 09:12:26 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id u25so69960755edf.1
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 09:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tfcv3LOjoZMWqQGvBmAf8nUIn5zyclnjzGnZnDfGdts=;
        b=TGmlVsU/v1plmsnMbMvESAq6iFYnNyQSCyvTyifMIdhcWktJ+qmY/k87QFdEm6Rl5C
         l9/fqQoIkUJ0wYCiiMnW4zVloQghqTegp8OkotI/wF560f27KyEbPdP5TAOaAzJj3ll1
         4/NyjAvQG8ScYqBZ5paKSrhfgGmOyTt7rVkR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tfcv3LOjoZMWqQGvBmAf8nUIn5zyclnjzGnZnDfGdts=;
        b=kkglvRPsuU9Eriu9A9EHegnF2eSS6TbKjhJJLgcmocu7Aim4TPXVmNPK71XzdrRBwU
         lflMCOf9hyW3ootAqJPqoxNmnemPqDhzt+uEF0IFu+spHsf5q0fvtrikf1XSEh1yuYEc
         H1DCmJwfyYkPtgCbzynMJGsKQF+52sB9YksDTEoS9WtPZ2O8Fs2I+Ma4httvi6VIPjZb
         M0uvQza1HzVwisPqV6S3DwMo0MCWk3fojwQm4mKSClhlvH6YBzcTyS+oelOgzWnn2sE8
         5rIqj2hs6ELuJVnbOT1ctN/Yu0yM2J72Umgx2oJrt/qqSh//tNIYdIAAQx6PHiHCjvym
         rx1A==
X-Gm-Message-State: AOAM532sY7dW7nFBZLHY8LJEowSyfJxZkPoJVXDNFIqABl6v+wtSCK3d
        HJ2AA1eCfOh78ZAwjBSjIGJejF99LBpNvmV42no=
X-Google-Smtp-Source: ABdhPJxCSXhkwU1bJO4fGSZTuxh4F25kM05QSOxw4epzBc+uXVSUyxzmUEqBO1ipQf0jfb0G2tXimw==
X-Received: by 2002:a17:907:2a85:: with SMTP id fl5mr4677513ejc.595.1641921145147;
        Tue, 11 Jan 2022 09:12:25 -0800 (PST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id j13sm5320830edw.89.2022.01.11.09.12.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 09:12:24 -0800 (PST)
Received: by mail-wr1-f43.google.com with SMTP id e9so32753138wra.2
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 09:12:24 -0800 (PST)
X-Received: by 2002:adf:e3c9:: with SMTP id k9mr4589697wrm.193.1641921144246;
 Tue, 11 Jan 2022 09:12:24 -0800 (PST)
MIME-Version: 1.0
References: <20220110181923.5340-1-jack@suse.cz>
In-Reply-To: <20220110181923.5340-1-jack@suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Jan 2022 09:12:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj39rpqNZX99dJUpErT+yX9aZN-Z1Lyfx8tbUqFUFeEqw@mail.gmail.com>
Message-ID: <CAHk-=wj39rpqNZX99dJUpErT+yX9aZN-Z1Lyfx8tbUqFUFeEqw@mail.gmail.com>
Subject: Re: [PATCH v2] select: Fix indefinitely sleeping task in poll_schedule_timeout()
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 10:19 AM Jan Kara <jack@suse.cz> wrote:
>
> A task can end up indefinitely sleeping in do_select() ->
> poll_schedule_timeout() when the following race happens:
> {...]

Ok, I decided to just take this as-is right now, and get it in early
in the merge window, and see if anybody hollers.

I don't think the stable people will try to apply it until after the
merge window closes anyway, but it's worth pointing out that this
change (commit 68514dacf271: "select: Fix indefinitely sleeping task
in poll_schedule_timeout()" in my tree now) is very much a change of
behavior, and we may have to revert it if it causes any issues.

The most likely issue it would cause is that some program uses
select() with an fd mask with extra garbage in it, and stale fd bits
that pointed to closed file descriptors used to just be ignored. Now
they'll cause select() to return immediately with those bits set.

And that might then cause a program to perhaps still work, but
busy-spin on select(), wasting CPU time. Or it will walk the result
bits, see them set, try to read/write to them, get EBADF, and clear
them. Or not clear them and just be very unhappy indeed.

So while I think this version of the patch is still safer than the
EBADF one - and I think better semantics that happen to match poll()
too - I think this is a patch that could expose existing bad user
space.

We'll see. I considered adding a WARN_ON_ONCE() just to make the
change in behavior more visible, but ended up not really feeling it.

End result: I took this patch eagerly not because I was happy to do
it, but simply because the earlier we test this, the earlier we'll
know of any problems.  Let's hope there are none.

               Linus
