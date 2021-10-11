Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE154299A2
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 01:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhJKXNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 19:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbhJKXNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 19:13:06 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7250BC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 16:11:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d9so49661035edh.5
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 16:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1aojVMiAC+dTJJ9CxG9nUezJ612JW4LOoadws/Wdgg=;
        b=ibryuqSlxRvY3tcfhcqgvog5M3wbrRAapyw8XCWWSuXm8vG56eJfeVmy2Xbv4z/zZF
         8pwYzCKKrrdVgveJzQeaCsghTrjV9hu5ZmSJw/V1tjPokRHPYnJWZtsathabPyNqFzvp
         ESHhUWgDfmPsALNVSkGr/+18KBjVZbyQUSHD3IFzJccyCVaLrt+lPkvNk0F3vbRguonh
         HGJpf5sRFAFTZjGWFFNnp3x/BmvQka0TlBfhM6FBuSZ3aCZmx4LDDx+WUPQ5mU42hbKq
         G67TAms50uVImTBEpvs00E7JyuGMsYa7gPtrZ5+ethDTWjDBKPQamhJw707s8Sm1/1vk
         +yQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1aojVMiAC+dTJJ9CxG9nUezJ612JW4LOoadws/Wdgg=;
        b=qXWn/NBwNw5XaQpmch5xqd5a9fuKZd50vChWUfjduq0NASGMwX+GplEV3wjGCY8AIX
         VuS8LP0P9WvxVkJSV0OIrCXuXCuLDw9FfI9N2uSD8bnYRiwB4Gjnk46XPBX7HeXF19Jx
         UEiTQuyc23PC6sCOUEjlFF37Vme12cl69Hf2zda3TW1j3gdTrjnk4rM3mmTWyy2OfBqi
         M4RG3TtkaEakLVs3BG6d49S42a/wqC0EwQsPjME833QkCHpNgqjrhboPPV90nRjDsDtf
         h0rM2MEk7RajAZZ/ekgJ532cCQnQNtEKolKPOHqwO1jHKUzM4vrcborUBMXLO1jaZXSq
         gGlA==
X-Gm-Message-State: AOAM531ObfVF2EBnncFUln2dN4AyiGJ771T0LvBUjBYHg34/oMVlwIWY
        T3qjnfQadBVhblvOcm0QLbmHyeusKW60IBQVmeMA
X-Google-Smtp-Source: ABdhPJxF6p6SBEimtPUNrEkSQF+zX9DJpwgGk4iFPWdSD+Id4rVokmvAN6idcgQhVjJ7yAcuLfiu8m9JyNw2bU7wl94=
X-Received: by 2002:a17:907:784b:: with SMTP id lb11mr29565002ejc.307.1633993863523;
 Mon, 11 Oct 2021 16:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211007004629.1113572-1-tkjos@google.com> <20211007004629.1113572-3-tkjos@google.com>
 <CAHC9VhSDnwapGk6Pvn5iuKv0zCtZSbfnGAkZwKcxVYLVRH6CLg@mail.gmail.com> <8c07f9b7-58b8-18b5-84f8-9b6c78acb08b@schaufler-ca.com>
In-Reply-To: <8c07f9b7-58b8-18b5-84f8-9b6c78acb08b@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 11 Oct 2021 19:10:52 -0400
Message-ID: <CAHC9VhRZz8ORWfQpQ8Wix845Zx3xGyusc3ne_UM7AmeLUpz9Eg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] binder: use cred instead of task for getsecid
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Todd Kjos <tkjos@google.com>, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, keescook@chromium.org,
        jannh@google.com, Jeffrey Vander Stoep <jeffv@google.com>,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, kernel test robot <lkp@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 5:59 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 10/11/2021 2:33 PM, Paul Moore wrote:
> > On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
> >> Use the 'struct cred' saved at binder_open() to lookup
> >> the security ID via security_cred_getsecid(). This
> >> ensures that the security context that opened binder
> >> is the one used to generate the secctx.
> >>
> >> Fixes: ec74136ded79 ("binder: create node flag to request sender's
> >> security context")
> >> Signed-off-by: Todd Kjos <tkjos@google.com>
> >> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Cc: stable@vger.kernel.org # 5.4+
> >> ---
> >> v3: added this patch to series
> >> v4: fix build-break for !CONFIG_SECURITY
> >>
> >>  drivers/android/binder.c | 11 +----------
> >>  include/linux/security.h |  4 ++++
> >>  2 files changed, 5 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> >> index ca599ebdea4a..989afd0804ca 100644
> >> --- a/drivers/android/binder.c
> >> +++ b/drivers/android/binder.c
> >> @@ -2722,16 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
> >>                 u32 secid;
> >>                 size_t added_size;
> >>
> >> -               /*
> >> -                * Arguably this should be the task's subjective LSM secid but
> >> -                * we can't reliably access the subjective creds of a task
> >> -                * other than our own so we must use the objective creds, which
> >> -                * are safe to access.  The downside is that if a task is
> >> -                * temporarily overriding it's creds it will not be reflected
> >> -                * here; however, it isn't clear that binder would handle that
> >> -                * case well anyway.
> >> -                */
> >> -               security_task_getsecid_obj(proc->tsk, &secid);
> >> +               security_cred_getsecid(proc->cred, &secid);
> >>                 ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
> >>                 if (ret) {
> >>                         return_error = BR_FAILED_REPLY;
> >> diff --git a/include/linux/security.h b/include/linux/security.h
> >> index 6344d3362df7..f02cc0211b10 100644
> >> --- a/include/linux/security.h
> >> +++ b/include/linux/security.h
> >> @@ -1041,6 +1041,10 @@ static inline void security_transfer_creds(struct cred *new,
> >>  {
> >>  }
> >>
> >> +static inline void security_cred_getsecid(const struct cred *c, u32 *secid)
> >> +{
> >> +}
> >
> > Since security_cred_getsecid() doesn't return an error code we should
> > probably set the secid to 0 in this case, for example:
> >
> >   static inline void security_cred_getsecid(...)
> >   {
> >     *secid = 0;
> >   }
>
> If CONFIG_SECURITY is unset there shouldn't be any case where
> the secid value is ever used for anything. Are you suggesting that
> it be set out of an abundance of caution?

It follows a pattern with the other LSM hooks when !CONFIG_SECURITY,
and I'd much rather us keep things consistent.

-- 
paul moore
www.paul-moore.com
