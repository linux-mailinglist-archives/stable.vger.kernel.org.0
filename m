Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C501358019
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 11:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhDHJ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 05:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhDHJ6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 05:58:33 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0DFC061762
        for <stable@vger.kernel.org>; Thu,  8 Apr 2021 02:58:22 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 66so811876vsk.9
        for <stable@vger.kernel.org>; Thu, 08 Apr 2021 02:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vqkcfcLmWPSwGQ7DXIyIlAdTx4eIhz1g0fE/uj8Jq5Q=;
        b=ak4tVPm2ajctg+hnsjp8GHDd5d8rnO+htwb7t/lo2NiatS+hRAXSYXtJ2BFjM6x48U
         pnA3KNNoIxXJdN3FUU5ajyCgsw02XIyHzdNzHBN+7meSGNIFDBPp1Wn0sT3/G/RLW0Wd
         MKbnV+cT/6M5eRpLsuP/tywNIa+EUWls2KYUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vqkcfcLmWPSwGQ7DXIyIlAdTx4eIhz1g0fE/uj8Jq5Q=;
        b=KjJMawCX8KQqG5cHr2s4hTn60uhv/ErW0BjA0eOZMFwOKFvgeCeXqcuoeNnlWqGlOg
         3VRRfFdT9XY/V6N7hyEAh8OKQf0mMOP4LojIXbCjAOyvOVUfjXhkx+yE9xIwZL6NlpGL
         b0Ek7EB9z1W+0bpwcTrY8htlDAAft7wzXZphTBVEhxr4mVKVe9F8owrynHtoCvUz/LPu
         0VJjX+Sbd3xHtWQreMzbEf5pnqll+wTm+OG6WkictC6hYs6JaPR7SVI2KrWS0+sEL4QW
         Q1AXN7FLC3VE8G337bjaz6gsqT0Ql8p4dC42SN56zaTw4A4gcsKD8xze/bgIj+RpD28W
         O1sw==
X-Gm-Message-State: AOAM533rVilxbmczkRuSJO8oQraha3/wgOAvJ9hVDsrr5c48jtDLXrpw
        2D0rbIZWP1UHXQ0gohLJLs1mBZz4v17ID/h82iAcAQ==
X-Google-Smtp-Source: ABdhPJyjZoMXzPL6CXTNPSH+BhhMdLuVrO7eLmf1th5EWTHfKQwxBWgSOV4WX90df7ZbQ6ru8A72X72+OSsEU0sNU2I=
X-Received: by 2002:a67:b005:: with SMTP id z5mr4869666vse.47.1617875901207;
 Thu, 08 Apr 2021 02:58:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210329164907.2133175-1-mic@digikod.net>
In-Reply-To: <20210329164907.2133175-1-mic@digikod.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 8 Apr 2021 11:58:10 +0200
Message-ID: <CAJfpegu=8L7Fd_qYK0cJRQ18NqyVeSvTp-vcC4KmqZEcw28naw@mail.gmail.com>
Subject: Re: [PATCH v1] ovl: Fix leaked dentry
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 6:48 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>
> Since commit 6815f479ca90 ("ovl: use only uppermetacopy state in
> ovl_lookup()"), overlayfs doesn't put temporary dentry when there is a
> metacopy error, which leads to dentry leaks when shutting down the
> related superblock:
>
>   overlayfs: refusing to follow metacopy origin for (/file0)
>   ...
>   BUG: Dentry (____ptrval____){i=3D3f33,n=3Dfile3}  still in use (1) [unm=
ount of overlay overlay]
>   ...
>   WARNING: CPU: 1 PID: 432 at umount_check.cold+0x107/0x14d
>   CPU: 1 PID: 432 Comm: unmount-overlay Not tainted 5.12.0-rc5 #1
>   ...
>   RIP: 0010:umount_check.cold+0x107/0x14d
>   ...
>   Call Trace:
>    d_walk+0x28c/0x950
>    ? dentry_lru_isolate+0x2b0/0x2b0
>    ? __kasan_slab_free+0x12/0x20
>    do_one_tree+0x33/0x60
>    shrink_dcache_for_umount+0x78/0x1d0
>    generic_shutdown_super+0x70/0x440
>    kill_anon_super+0x3e/0x70
>    deactivate_locked_super+0xc4/0x160
>    deactivate_super+0xfa/0x140
>    cleanup_mnt+0x22e/0x370
>    __cleanup_mnt+0x1a/0x30
>    task_work_run+0x139/0x210
>    do_exit+0xb0c/0x2820
>    ? __kasan_check_read+0x1d/0x30
>    ? find_held_lock+0x35/0x160
>    ? lock_release+0x1b6/0x660
>    ? mm_update_next_owner+0xa20/0xa20
>    ? reacquire_held_locks+0x3f0/0x3f0
>    ? __sanitizer_cov_trace_const_cmp4+0x22/0x30
>    do_group_exit+0x135/0x380
>    __do_sys_exit_group.isra.0+0x20/0x20
>    __x64_sys_exit_group+0x3c/0x50
>    do_syscall_64+0x45/0x70
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   ...
>   VFS: Busy inodes after unmount of overlay. Self-destruct in 5 seconds. =
 Have a nice day...
>
> This fix has been tested with a syzkaller reproducer.
>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.7+
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 6815f479ca90 ("ovl: use only uppermetacopy state in ovl_lookup()")
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Link: https://lore.kernel.org/r/20210329164907.2133175-1-mic@digikod.net

Thanks, applied.

Miklos
