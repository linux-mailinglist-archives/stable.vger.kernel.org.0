Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7046D0E48
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjC3TEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjC3TEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:04:49 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E08A1FEC
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:04:48 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id bx10so2362853ljb.8
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680203086; x=1682795086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViRntU/RBw/t4ZG4j3zD5QSxaRXCjDm7pTbD6yzt3a8=;
        b=dV0eOrY64A8f3Aifg1ktecdTLHjwppffuR9U+jgLkYvX5MPPYsv9GweFII+I3t3v0o
         9jDUXsvJMrPGEHZdm2GTi65Hfmw3a4ibc8v8r1yPTfDacXDy2tuui059sb/LWhFr6H+H
         UP9us03F/CeqELxCEVFGNRLtAJxBsJVpPwkAky/qVzjej7ZzN8fa8tNm2d3W32e31tbu
         BtK/YWj1gJaR8aOw8FQ95nsRGqgYD9gg/k+zm6oxnRW5a1ko9Odd1OOYs48mxEoGd5eX
         c3+9Vum6jH3lt36eOSVGmAFLUpEM4wQoaph53BHMmdalSnMjSX5gQGgZ+DPtuMYw0KF/
         Yx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680203086; x=1682795086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ViRntU/RBw/t4ZG4j3zD5QSxaRXCjDm7pTbD6yzt3a8=;
        b=o/0yjzApua8O5BPICK3FSfso2l2ewIXIR7OeDcx+3iQTOUz4YQH/0Vn/e/2vw5JPlH
         NEXyLXp22UqzOp49zhgWzIEFb0T8BBWXtTnrJ1IQUAUHZ6N9eAePopalkWaVG9HsNsB4
         emxMolzj7ZVzzeJTN/AmrWbM0q1Hg6RvlBel1Ud71ySygwj1rPiCJJAPnbdHnfRXHjm7
         b6YZWbErzHJTS9VkC7OKtpgooBzHHrxDOWnftEjXXSUXlptJsCwz3NzREUX56vLEoE29
         mgomB+litWqlpXsMOBcWiNKqANy2F3SUcDMntSzyLGoZ3m6T55vFWCHnPNWVW8WCO/WF
         bcRg==
X-Gm-Message-State: AAQBX9eEe3Ec4CbFzFv9U3EDlQRMZcA0nNu/YwkSstBtHgjQmbnvATn8
        CMohWlQthD6g+BA8p58U3mYTEIyjExokGsADdMo87w==
X-Google-Smtp-Source: AKy350ZvsfzrmBwt4dNUcCAGb/P/J4h6ZV4gG939299gXsIjuhp+FqawIQXRd32zcR9EZBP4mKkY9XmmXGBdtQgJZ6o=
X-Received: by 2002:a2e:3203:0:b0:299:9de5:2f0c with SMTP id
 y3-20020a2e3203000000b002999de52f0cmr7643353ljy.6.1680203086265; Thu, 30 Mar
 2023 12:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230330155707.3106228-1-peterx@redhat.com> <20230330155707.3106228-2-peterx@redhat.com>
In-Reply-To: <20230330155707.3106228-2-peterx@redhat.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Thu, 30 Mar 2023 12:04:09 -0700
Message-ID: <CAJHvVcgDZBi6pH0BD12sQ3T+7Kr9exX1QU3-YLTd1voYhVBN0w@mail.gmail.com>
Subject: Re: [PATCH 01/29] Revert "userfaultfd: don't fail on unrecognized features"
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 8:57=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> This is a proposal to revert commit 914eedcb9ba0ff53c33808.
>
> I found this when writting a simple UFFDIO_API test to be the first unit
> test in this set.  Two things breaks with the commit:
>
>   - UFFDIO_API check was lost and missing.  According to man page, the
>   kernel should reject ioctl(UFFDIO_API) if uffdio_api.api !=3D 0xaa.  Th=
is
>   check is needed if the api version will be extended in the future, or
>   user app won't be able to identify which is a new kernel.

100% agreed, this was a mistake.

>
>   - Feature flags checks were removed, which means UFFDIO_API with a
>   feature that does not exist will also succeed.  According to the man
>   page, we should (and it makes sense) to reject ioctl(UFFDIO_API) if
>   unknown features passed in.

I still strongly disagree with reverting this part, my feeling is
still that doing so makes things more complicated for no reason.

Re: David's point, it's clearly wrong to change semantics so a thing
that used to work now fails. But this instead makes it more permissive
- existing userspace programs continue to work as-is, but *also* one
can achieve the same thing more simply (combine probing +
configuration into one step). I don't see any problem with that,
generally.

But, if David and others don't find my argument convincing, it isn't
the end of the world. It just means I have to go update my userspace
code to be a bit more complicated. :)

I also still think the man page is incorrect or at least incomplete no
matter what we do here; we should be sure to update it as a follow-up.

>
> Link: https://lore.kernel.org/r/20220722201513.1624158-1-axelrasmussen@go=
ogle.com
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-stable <stable@vger.kernel.org>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  fs/userfaultfd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 8395605790f6..3b2a41c330e6 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1977,8 +1977,10 @@ static int userfaultfd_api(struct userfaultfd_ctx =
*ctx,
>         ret =3D -EFAULT;
>         if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
>                 goto out;
> -       /* Ignore unsupported features (userspace built against newer ker=
nel) */
> -       features =3D uffdio_api.features & UFFD_API_FEATURES;
> +       features =3D uffdio_api.features;
> +       ret =3D -EINVAL;
> +       if (uffdio_api.api !=3D UFFD_API || (features & ~UFFD_API_FEATURE=
S))
> +               goto err_out;
>         ret =3D -EPERM;
>         if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRA=
CE))
>                 goto err_out;
> --
> 2.39.1
>
