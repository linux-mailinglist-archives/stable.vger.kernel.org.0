Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04053C72D4
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbhGMPNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 11:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236977AbhGMPNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 11:13:32 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B318C0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:10:41 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gb6so42092067ejc.5
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=abBnvCNHoiwPjk+pbO+twHux68rlYki9TXT2SBB9tcw=;
        b=mMSm0wM3NOhKOxlm9bp2OYVdOl2GFv2ww21t4vL5hdSpHzKCDtOD5DtMMu4WhFyB/8
         AA63GR7gN/lLDZ7K4Q469luHcVfOExwwI4EMPCDiGHCEb8RmyTxNoGV/iAB7Y83jJVMs
         8s4Jwa6+oZTnQVFRQiw2wrCoJ6r4/wIMgg+IZnizdwTIikcjk6wuAtys2KkCBD9ypZ2K
         Lk4Kb5FMxAN5iioqSvOExiVpweF1JJR6hnGhNlHZVe+jT+YReH+WsU/AVXqa2PlSZGP7
         qTaCxSVq3fCDypRfz5j0Km4uBs0gmgsjUfFI/rta3CTklHA7NAlqEr73KD3iEdLS4/M9
         jHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=abBnvCNHoiwPjk+pbO+twHux68rlYki9TXT2SBB9tcw=;
        b=HprhE8pmvpR0FcUXDh6FrAdTZRYOwNOnj74TrndfvbR9+0xVmZOkZwASEKfhBy4yNj
         eBk0aUBsHnwFL06dzbSbbeStQgOjT+HA8Un4EiFxITKsQKCnX7NV0lJEkcQu95o7ZQ5E
         L3mLP14lc8SxpBMsF1NbE+ava5T4Rxn1KFmhuYdyH0FoTX8S385lRRTRyvamwPaYe2X/
         qTCP66LZEgCZ434aAABQV0DUi532tpaE9ijXj+595NDu5jlauLBhsMFcFSyrptcAN2IB
         ZK4xvYbka3s94vGyRrheZI823q8qPh58/YEtZH7ibUuls/iNQyFHNF9KmLZqrMpcy8So
         4Akg==
X-Gm-Message-State: AOAM533zJGZCRuSafLPh4lS37ammsAjnpogZdTDmeqh5eXsmNmK8VCKW
        H/776MK731JgoGi0GgFKzJxtTTiDh+/RjqA5qODaog==
X-Google-Smtp-Source: ABdhPJyNpk+yq9jqqqPZ/24v2cTPBYfQ2AjOJJCtVBjGij/qpzOk/dCQ7ciO+D5h7rLmtYU0kt2COYcaM3lBc7W27w8=
X-Received: by 2002:a17:907:76b8:: with SMTP id jw24mr6223309ejc.375.1626189039800;
 Tue, 13 Jul 2021 08:10:39 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Jul 2021 20:40:28 +0530
Message-ID: <CA+G9fYubOg+Pu8N3LYFKn-eL3f=gn4ceK9Asj1RdBDntU_A2ng@mail.gmail.com>
Subject: perf: bench/sched-messaging.c:73:13: error: 'dummy' may be used uninitialized
To:     perf-users <perf-users@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leo Yan <leo.yan@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LKFT have noticed these warnings / errors when we have updated gcc version from
gcc-9 to gcc-11 on stable-rc linux-5.4.y branch. I have provided the steps to
reproduce in this email below.

Following perf builds failed with gcc-11 with linux-5.4.y branch.
- build-arm-gcc-11-perf
- build-arm64-gcc-11-perf
- build-i386-gcc-11-perf
- build-x86-gcc-11-perf

Build error log:
--------------------
find: 'x86_64-linux-gnu-gcc/arch': No such file or directory
error: Found argument '-I' which wasn't expected, or isn't valid in this context
USAGE:
    sccache [FLAGS] [OPTIONS] [cmd]...
For more information try --help
error: Found argument '-I' which wasn't expected, or isn't valid in this context
USAGE:
    sccache [FLAGS] [OPTIONS] [cmd]...
For more information try --help

In function 'ready',
    inlined from 'sender' at bench/sched-messaging.c:87:2:
bench/sched-messaging.c:73:13: error: 'dummy' may be used
uninitialized [-Werror=maybe-uninitialized]
   73 |         if (write(ready_out, &dummy, 1) != 1)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from bench/sched-messaging.c:22:
bench/sched-messaging.c: In function 'sender':
/usr/x86_64-linux-gnu/include/unistd.h:366:16: note: by argument 2 of
type 'const void *' to 'write' declared here
  366 | extern ssize_t write (int __fd, const void *__buf, size_t __n) __wur;
      |                ^~~~~
bench/sched-messaging.c:69:14: note: 'dummy' declared here
   69 |         char dummy;
      |              ^~~~~
cc1: all warnings being treated as errors

ref:
https://builds.tuxbuild.com/1vEIWryaujwVtL4wmodXkz1djUa/
https://builds.tuxbuild.com/1vEIX7NTo5OpaN9nrs2UvO74oxB/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Steps to reproduce:
---------------------------
tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1vEIWryaujwVtL4wmodXkz1djUa/config headers
kernel modules perf

--
Linaro LKFT
https://lkft.linaro.org
