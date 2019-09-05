Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1056CAA9E4
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbfIERWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 13:22:50 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37904 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387700AbfIERWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 13:22:50 -0400
Received: by mail-io1-f66.google.com with SMTP id p12so6572282iog.5;
        Thu, 05 Sep 2019 10:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h6XoJHJRp5DArbWmdsadcBh6z83BVCBg1lEJgWUn+MU=;
        b=qtt0GUuuzbT+VVZKgagf+GRHgGI0fW1B4GMj/VCLED/LaUQtC3Doa6lDQZmwnyIvkV
         9psItuNC8ixEYfpe0kkcXATOMiVrDlbNR3wVgMnjNbZ56FIzek+nJpUq0PkvjVd2Piuk
         3p9T409z7ubUuFeyV52eRAj4mu0pAcHM7GJ7KwHH6ZmBk7yTAHIlZt0zdaqhiml2jHTg
         zd89V+AFtTv5neOc3WUAJIJ/sKDy7Evom/9L+XLF66QJdSrTWr5S8ZbEGuIfbY7X6HEv
         m57Q/8YcJE2ZRvsH6OYv6HCXOHjRsVnVkwyWjDDp5+1kii6M9kxBNSirWw0CjEsJLlN0
         VOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h6XoJHJRp5DArbWmdsadcBh6z83BVCBg1lEJgWUn+MU=;
        b=Z53e4uNx0Ju+YgQ/ROJ3wNB8EiujsUVWaOGwKzNkDUcFUUQHJDyhONyWegWkKNS/0L
         bfPuoRCuBz7OORuneanxaUAJ9DoFXgngE9A1WyCwoGoz1Ep8+wsiEEhJbrDn36IoVqEE
         c/+lz4SrK97nClkM0+PSkF8Vb/xDoSmV6bNEUYRo2IjRbJCwMMEYLbkrwAQIzop4qm7t
         czYxSzETwTFfNiGAsUpzZaOdjIeMUBxL6sDyPVnMGuHwcqn2LoZRgqstsyeJJkQyfrX9
         LAgNpTNylkdYJcs/x3Z87oAUi3LXQk1U9D7G9/wxCLEm38fGND9CRW8T3q+nuIaNbYu2
         P+LQ==
X-Gm-Message-State: APjAAAVt54JaVM2UrhYudXImmcDiWSKFR5Tpr957jtD/trq5sRYMAI81
        x1gZLz7qrCIdwWwjG2w2Ar5LxOUvG8YlsAVF7RU=
X-Google-Smtp-Source: APXvYqwR6nUdIEnweUzSLPMmz8Y4JAgL2rhI2t+NPwcMEOMxKH7cQoHHYETKZPPYFXTwePI2PBrbWLvEK7QmYjbydaQ=
X-Received: by 2002:a6b:cac2:: with SMTP id a185mr5529429iog.142.1567704168865;
 Thu, 05 Sep 2019 10:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190905152155.1392871-1-arnd@arndb.de> <20190905152155.1392871-2-arnd@arndb.de>
In-Reply-To: <20190905152155.1392871-2-arnd@arndb.de>
From:   Matt Turner <mattst88@gmail.com>
Date:   Thu, 5 Sep 2019 10:22:36 -0700
Message-ID: <CAEdQ38G24-s0x+xKzUfg1GH8JAPtcAq5e5L37SnOZ3gQth1STQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ipc: fix sparc64 ipc() wrapper
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christian Brauner <christian@brauner.io>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        stable@vger.kernel.org, sparclinux@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 5, 2019 at 8:23 AM Arnd Bergmann <arnd@arndb.de> wrote:
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
> ---
> Hi Matt,
>
> Can you check that this solves your problem?

Works great. Thank you Arnd!

Tested-by: Matt Turner <mattst88@gmail.com>
