Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCF9429908
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 23:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhJKVlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 17:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhJKVlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 17:41:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCBEC06161C
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 14:39:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t16so51039538eds.9
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 14:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cy+yFGYhU8Dl+HTiVqKCJfmoCLxBdL9eY1HaZR6ohww=;
        b=E2xOqhCa/G27tgig8lRlceYSN6Q2nsUxzkdjTRgJt43eaZqgeV0AdIuonKVgB5Tb2v
         3QXVNvKVm/onpSZo1QRzmFCvtGOoHMK2ECiN23m57RHQNPN4iVNZ2nPn4V+Q3rYR5R0G
         kKUZv7SAEt+nDSj1W0mkSVV3n2mHcL0ReziP4HLQMQvMNa614h0Ss64SM09OUZuk8VzS
         GbuC3K9l5jucq9fI+uIYMZ1hX/LR6Fh/BF+PbfOsGTqPcpDKDdFRgTVZ2vmXivd0A/RN
         rUE6MkrnB1kx6shi0FtCP5GqNBUgELSncxR8Kqw9EAq37ILmJ0UbxogjWYL7tAxvu58J
         Ee+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cy+yFGYhU8Dl+HTiVqKCJfmoCLxBdL9eY1HaZR6ohww=;
        b=RlcqiQc+5E87jg9MSjbFdMuQPW0TGnhn21JSH8T+b84Hum9BYh5z4NhC8dQWBOi96M
         6YnfIRnBORrhjfpvuO5Vhcss6DfArVxlITg+kfmdfJI3XcaN1hXwZEABQpNC0qzhpAYl
         nLy+KGFZfUhor9TgwzrwDcfb5e7/9SMQtlKg8TIFcI+/sKY1pqhRvDJPHmsZCc8JiBL0
         kbsaCLxZEF3O5WgLVHRSZaJmKCpK9/AshY5kyLnvyjhoA1tq6cIeqI/M0fSqZwMsHqzn
         YVQcC6XyoH/NepLz75ZabPNFKvsp54qnaLgJwFdHMDqWmaO+NAIdKVYGiLCxbDZY1s/a
         Cpaw==
X-Gm-Message-State: AOAM532PkiIcVOTj5AMtsWtUc+kYAMX0G4aFllIMTIHpDBpDeljQPLhr
        EvgZ4iW1+PKVQUMubhUfX9q59gOmnd5R5XcaZUcp
X-Google-Smtp-Source: ABdhPJx7CJ3ZIqyUEEfQoxWarEkX7WOi4Hpj/UN4D+hD99Srmu8DlLrayJ8Ib3dueW7FkqYvWAat963ic1eMGKkhVvE=
X-Received: by 2002:a17:907:784b:: with SMTP id lb11mr29054417ejc.307.1633988358027;
 Mon, 11 Oct 2021 14:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211007004629.1113572-1-tkjos@google.com> <20211007004629.1113572-4-tkjos@google.com>
 <CAHC9VhTRTcZW9eyXXvAN7T=ZCQ_zwH5iBz+d0h2ntf7=XHE-Vw@mail.gmail.com> <CAHRSSEy=eC0rbHUzDmCo6Na7Ya=uCq7zJ6_cXysi0oWQB=19YQ@mail.gmail.com>
In-Reply-To: <CAHRSSEy=eC0rbHUzDmCo6Na7Ya=uCq7zJ6_cXysi0oWQB=19YQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 11 Oct 2021 17:39:07 -0400
Message-ID: <CAHC9VhQVKTxwUUP02U43=zVZrEFWc0hhmpaR1YSxe+KHjhnhbw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] binder: use euid from cred instead of using task
To:     Todd Kjos <tkjos@google.com>
Cc:     casey@schaufler-ca.com, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, keescook@chromium.org,
        jannh@google.com, Jeffrey Vander Stoep <jeffv@google.com>,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 8, 2021 at 5:24 PM Todd Kjos <tkjos@google.com> wrote:
>
> On Fri, Oct 8, 2021 at 2:12 PM Paul Moore <paul@paul-moore.com> wrote:
> >
> > On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
> > >
> > > Set a transaction's sender_euid from the 'struct cred'
> > > saved at binder_open() instead of looking up the euid
> > > from the binder proc's 'struct task'. This ensures
> > > the euid is associated with the security context that
> > > of the task that opened binder.
> > >
> > > Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > > Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > > Cc: stable@vger.kernel.org # 4.4+
> > > ---
> > > v3: added this patch to series
> > >
> > >  drivers/android/binder.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > This is an interesting ordering of the patches.  Unless I'm missing
> > something I would have expected patch 3/3 to come first, followed by
> > 2/3, with patch 1/3 at the end; basically the reverse of what was
> > posted here.
>
> 2/3 and 3/3 both depend on 1/3 (add "cred" member of struct
> binder_proc). I kept that in 1/3 to keep that patch the same as what
> had already been reviewed. I didn't think much about the ordering
> between 2/3 and 3/3 -- but I agree that it would have been sensible to
> reverse their order.
>
> >
> > My reading of the previous thread was that Casey has made his peace
> > with these changes so unless anyone has any objections I'll plan on
> > merging 2/3 and 3/3 into selinux/stable-5.15 and merging 1/3 into
> > selinux/next.
>
> Thanks Paul. I'm not familiar with the branch structure, but you need
> 1/3 in selinux/stable-5.15 to resolve the dependency on proc->cred.

Yep, thanks.  My eyes kinda skipped over that part when looking at the
patchset but that would have fallen out as soon as I merged them.

Unfortunately that pretty much defeats the purpose of splitting this
into three patches.  While I suppose one could backport patches 2/3
and 3/3 individually, both of them have a very small footprint
especially considering their patch 1/3 dependency.  At the very least
it looks like patch 2/3 needs to be respun to address the
!CONFIG_SECURITY case and seeing the split patches now I think the
smart thing is to just combine them into a single patch.  I apologize
for the bad recommendation earlier, I should have followed that thread
a bit closer after the discussion with Casey and Stephen.

-- 
paul moore
www.paul-moore.com
