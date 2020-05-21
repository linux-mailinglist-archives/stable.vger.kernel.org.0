Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A741DD26B
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 17:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgEUPzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgEUPzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 11:55:33 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3C7C061A0F
        for <stable@vger.kernel.org>; Thu, 21 May 2020 08:55:32 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 17so7577897ilj.3
        for <stable@vger.kernel.org>; Thu, 21 May 2020 08:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PYhboJAJ7RUBKUATlYhVk5ySk5gU8YKi+aCx6DRehKg=;
        b=dATQhHHQvJut0ZdygKw6g8AVHjd45Sqhq824JTQz3o6b/bur/kKqQ/50Asso5pexJn
         LZMlI99ySYlyVBwxVeWOx7L88HOPdVuLsE/R4OTPgjl8K4DkM9irR8FiBPwd2ysSZgiv
         xdtRA3KgWuxo2+dCzkmMg6FNqCbRUHSzVgMO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PYhboJAJ7RUBKUATlYhVk5ySk5gU8YKi+aCx6DRehKg=;
        b=OHkc92L2lUI8qJsegpCwGdPfnF5qqrFZsnp0vtJdXyFFRQ6dmXtIi+JPElFfWMrhT9
         mJXUqMn5SCF/m9nIQhSjR9DMs3N4uDYSipTbmi4wza2tf3ulOtLwhYB22z9EvVpqFRa6
         KlqBrijPsGHzd8Ka66BQHRPH78okWNIvdkD8qDo0bQMxg2cR1T5z7wGwAAakT8UuKBWo
         qeCGt1UE2CnI2cjUCEup06hEA/J9jScp2NMzT0UCyJ4IWTerZ5kLJ9I3k4+ZD6/UpIgg
         hYVSF96bjs698XVaQ6dBfizW2EWV8muA8xsJmKs++0kijkazceJUBroDh1ZyP3g5Pw8J
         X2jg==
X-Gm-Message-State: AOAM533U/YGyqmOhkcVppd43XF0Hg2uPrUKCNiQYjmB+sulnP1CIH2iU
        2N8lwOxR65OcNYMIThUfeHyo3i7ogD45ReZZilmDBrFr
X-Google-Smtp-Source: ABdhPJyoa5zm89sVnN9Gx9+B/moZwqm85Wya5bEMLTeH4USwyojqOZgpl+YvxIKAJrXIhkq0vx/jG8rH9qgUkNBRQ1c=
X-Received: by 2002:a05:6e02:ec2:: with SMTP id i2mr9391335ilk.262.1590076532103;
 Thu, 21 May 2020 08:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200521155346.168413-1-joel@joelfernandes.org>
In-Reply-To: <20200521155346.168413-1-joel@joelfernandes.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 21 May 2020 11:55:21 -0400
Message-ID: <CAEXW_YTj83gO0STovrOuL9zgDwEYWRJusUZ3ebVw_jOG6yJxTg@mail.gmail.com>
Subject: Re: [PATCH RFC] sched/headers: Fix sched_setattr userspace
 compilation issues
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Matthew Blecker <matthewb@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Mike Frysinger <vapier@google.com>,
        Christian Brauner <christian@brauner.io>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        vineethrp@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 11:53 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> On a modern Linux distro, compiling the following program fails:
>  #include<stdlib.h>
>  #include<stdint.h>
>  #include<pthread.h>
>  #include<linux/sched/types.h>
>
>  void main() {
>          struct sched_attr sa;
>
>          return;
>  }
>
> with:
> /usr/include/linux/sched/types.h:8:8: \
>                         error: redefinition of =E2=80=98struct sched_para=
m=E2=80=99
>     8 | struct sched_param {
>       |        ^~~~~~~~~~~
> In file included from /usr/include/x86_64-linux-gnu/bits/sched.h:74,
>                  from /usr/include/sched.h:43,
>                  from /usr/include/pthread.h:23,
>                  from /tmp/s.c:4:
> /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23:8:
> note: originally defined here
>    23 | struct sched_param
>       |        ^~~~~~~~~~~
>
> This is also causing a problem on using sched_attr Chrome. The issue is
> sched_param is already provided by glibc.
>
> Guard the kernel's UAPI definition of sched_param with __KERNEL__ so
> that userspace can compile.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

If it is more preferable, another option is to move sched_param to
include/linux/sched/types.h

 - Joel


> ---
>  include/uapi/linux/sched/types.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/=
types.h
> index c852153ddb0d3..1f10d935a63fe 100644
> --- a/include/uapi/linux/sched/types.h
> +++ b/include/uapi/linux/sched/types.h
> @@ -4,9 +4,11 @@
>
>  #include <linux/types.h>
>
> +#if defined(__KERNEL__)
>  struct sched_param {
>         int sched_priority;
>  };
> +#endif
>
>  #define SCHED_ATTR_SIZE_VER0   48      /* sizeof first published struct =
*/
>  #define SCHED_ATTR_SIZE_VER1   56      /* add: util_{min,max} */
> --
> 2.26.2.761.g0e0b3e54be-goog
>
