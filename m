Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81B74298FE
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 23:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbhJKVga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 17:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbhJKVg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 17:36:29 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FEEC061749
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 14:34:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y12so59962668eda.4
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 14:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ASvbaX4mULlaQ5VNPfAMnoxqnz/X2X3p0hluU+FIx0=;
        b=GiaUqRzMzNZdxYScPjPe67tmbRfAkynuVW7jg+j+0HBDVYAZ68l2sqeWVWgHuZrcBU
         k6U7oTLA4aSdUOyJNK92QwUQlGj8rxB0exbbQpz1TWi70ip96mgchR3g5BpCZXnQwRMz
         H+lXteD9kB9UeLgfxAE/A7DZMwh4T1CLoYvQ1dSezaMFim857pG5rcZ1bH+r0wmceFAs
         OEW87b2KDx+sdoXDzWliapO3EmyyxQbo1T2z2wDIuy0Gtu0fEuv8qmg2TBrLvCLBepJm
         H01rmaiD2lU2pNAU2sCoIHLBayWlWbtQcGUzWQSuIyTIxd1ZozWZMrw6e8DPm6ydlhsF
         fyGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ASvbaX4mULlaQ5VNPfAMnoxqnz/X2X3p0hluU+FIx0=;
        b=B+kno7avgLPZjbkibxqu9xEEmSS69SPEwCETE0ni26h76U8pYXC6D2UTtCpkmMZSVF
         OJYAQCK5BfrITw6jdkXvax8btvEDjpLr7fSav/IyuNXN+fmYosz3zn01OZGIDWyL6ZdS
         MHAAL0wqebnX/0e545EzvEGU6VCCDLOWfvkG0EbwDakCM58KAgr/N6tlOX1iXa0wasGx
         HtsyRETzeDbSaamwvGCtAQp6ow6exOCrqqOfczETszkCS6sJAlrsn0oY0g2eLDMThNsv
         Hv67fP2V2HXcZHZCUXOES2MyiQV3MtZccG50lBFjnAypxexn4U88+QAAMuILuWfE1d+n
         SsaA==
X-Gm-Message-State: AOAM532aI64RViOppOjaeNhbpKaCSNdInIsuW6VzSM7vvIwiv0tgan0C
        8jCx+lLscSpwJN2Qi2K4g39/Vf8UCavokLKWHPqP
X-Google-Smtp-Source: ABdhPJyO3wD+tHrVQmXHAZ7sE5WYEdQl0aKMJ//KoLlskSOmk+AfJORoEj9x9vQTLaFdFxfB1vfKy3dWfszaiXIkUn8=
X-Received: by 2002:a17:906:2f16:: with SMTP id v22mr27539784eji.126.1633988066527;
 Mon, 11 Oct 2021 14:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211007004629.1113572-1-tkjos@google.com> <20211007004629.1113572-4-tkjos@google.com>
 <CAHC9VhTRTcZW9eyXXvAN7T=ZCQ_zwH5iBz+d0h2ntf7=XHE-Vw@mail.gmail.com> <6dd3cdff-c4eb-6457-f04c-199263acd80b@schaufler-ca.com>
In-Reply-To: <6dd3cdff-c4eb-6457-f04c-199263acd80b@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 11 Oct 2021 17:34:15 -0400
Message-ID: <CAHC9VhQfPn88QZSMEw1d04V4f9MWwJxUDd-ibTd+6GTBiYLAPg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] binder: use euid from cred instead of using task
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
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 8, 2021 at 5:25 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 10/8/2021 2:12 PM, Paul Moore wrote:
> > On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
> >> Set a transaction's sender_euid from the 'struct cred'
> >> saved at binder_open() instead of looking up the euid
> >> from the binder proc's 'struct task'. This ensures
> >> the euid is associated with the security context that
> >> of the task that opened binder.
> >>
> >> Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> >> Signed-off-by: Todd Kjos <tkjos@google.com>
> >> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> >> Cc: stable@vger.kernel.org # 4.4+
> >> ---
> >> v3: added this patch to series
> >>
> >>  drivers/android/binder.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > This is an interesting ordering of the patches.  Unless I'm missing
> > something I would have expected patch 3/3 to come first, followed by
> > 2/3, with patch 1/3 at the end; basically the reverse of what was
> > posted here.
> >
> > My reading of the previous thread was that Casey has made his peace
> > with these changes
>
> Yes. I will address the stacking concerns more directly.
> I am still somewhat baffled by the intent of the hook, the data
> passed to it, and the SELinux policy enforcement decisions, but
> that's beyond my scope.

Okay, I just wanted to make sure there were no objections.

-- 
paul moore
www.paul-moore.com
