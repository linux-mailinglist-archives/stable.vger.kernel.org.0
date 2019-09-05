Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FF1AAD2D
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbfIEUis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 16:38:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45010 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbfIEUis (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 16:38:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id p2so2994757edx.11;
        Thu, 05 Sep 2019 13:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dBIKCItK0rh9/iwZ4eQJEEcGA16rM0H8xyFxTA3Y7k4=;
        b=NICxO0N2EREg50tY+4E+4rlKX8CcW3ZfFSqtUQ0llYIh9UPPyeABIIy2t2V5z2hijF
         rrwUZuaydk0ariXYhSobS3PND1DtI8rx64Sp40w2K4zY8QroLxCOJJ7jbRdXrVjVI+r3
         BHQYZ4s8kffawKAc1weGw95ZmSoKouKN33eQn6nfl4tJqmGFUKCVHaItqMKfEgy+XexF
         o1YvpS7cz3e9p8PwZoObUGaEk6D4xadYKax3H5XHfU3uxc1I0ihBj63yGI1jPo4m1OTs
         0yzCC3QddXaUYPbB8NGAN+0O/c6G4ISo8xfBYXOIPHJQrhDyUFWYXo+z7uU0QORRaczQ
         +W1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dBIKCItK0rh9/iwZ4eQJEEcGA16rM0H8xyFxTA3Y7k4=;
        b=DYfugXJYbZYw7py2B+T5ZyIyoexeWKEQGNOz1IrwH0IFsV5hZAPlKo7ZEgrY7O3ybA
         YjxfusDQstSaL/stfyqPh7Uv6nUIs97KCMFp/jSaTvr16AI8EpCC2aPlO0vi0dR92ws8
         uzKEpbmk/xdtkeZxGFm3YwumSxP6NJ2yrAJIy3V5wmzrUXTW2H9unhE5l17w7Izs2TSp
         J7N+RsqVnGMq4U45C0HrWAZW5pDm6vVKsqIo7S4llWGDri7gUmR13KzsljS/RI3756Iv
         ggXlaR1MbE/8FX78oqddLwHk1KHdkExglxkGj7kEcfD7/owtQWjxrls1rJNBhf5imo6f
         nWGQ==
X-Gm-Message-State: APjAAAWkCTZfJ0uZ7u1nsADuiuvr+aYFjfNt/cAQD0LBhXwF6w+YxBuF
        ALbge+P1+1pF9qu5mVGbGgUXSQoX8Zrjo1cVJ6Ec2Q==
X-Google-Smtp-Source: APXvYqy2OdI8EsLhW2Y7oXVHwZQmNRL6O8HtEy55XYCqDOjB5PsUAoIoxQ30pCasY01my6SD395aiKJlh0kfeGKhzGM=
X-Received: by 2002:a17:906:4056:: with SMTP id y22mr4632710ejj.230.1567715925860;
 Thu, 05 Sep 2019 13:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190905152155.1392871-1-arnd@arndb.de> <20190905152155.1392871-2-arnd@arndb.de>
In-Reply-To: <20190905152155.1392871-2-arnd@arndb.de>
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Thu, 5 Sep 2019 23:38:39 +0300
Message-ID: <CADxRZqxkj+vdAOtZYmKtavy5nCtNFAUgfZ6k12nYeNcPYB+ssw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ipc: fix sparc64 ipc() wrapper
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christian Brauner <christian@brauner.io>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-arch@vger.kernel.org, y2038@lists.linaro.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Matt Turner <mattst88@gmail.com>, stable@vger.kernel.org,
        Sparc kernel list <sparclinux@vger.kernel.org>,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 5, 2019 at 9:39 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Matt bisected a sparc64 specific issue with semctl, shmctl and msgctl
> to a commit from my y2038 series in linux-5.1, as I missed the custom
> sys_ipc() wrapper that sparc64 uses in place of the generic version that
> I patched.
>
> The problem is that the sys_{sem,shm,msg}ctl() functions in the kernel
> now do not allow being called with the IPC_64 flag any more, resulting
> in a -EINVAL error when they don't recognize the command.
>
> Instead, the correct way to do this now is to call the internal
> ksys_old_{sem,shm,msg}ctl() functions to select the API version.
>
> As we generally move towards these functions anyway, change all of
> sparc_ipc() to consistently use those in place of the sys_*() versions,
> and move the required ksys_*() declarations into linux/syscalls.h
>
> Reported-by: Matt Turner <mattst88@gmail.com>
> Fixes: 275f22148e87 ("ipc: rename old-style shmctl/semctl/msgctl syscalls")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


Not Matt,

but this patch fixes util-linux.git ipcs test-suite (make check)
regression for me on current sparc64 git kernel (5.3.0-rc7), which was
broken somewhere in between 4.19 (debian unstable kernel) and 5.3-rcX.

Thanks!

PS: wanted to bisect kernel, but Matt did it first.
