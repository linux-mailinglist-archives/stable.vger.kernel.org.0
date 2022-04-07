Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7D4F7E12
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiDGLcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiDGLcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:32:45 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A89686E28;
        Thu,  7 Apr 2022 04:30:46 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id kd21so4703206qvb.6;
        Thu, 07 Apr 2022 04:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kFSuB7sswMV4SFOXW3tqsCHlWXHHfatJ8gHc/ZBJ388=;
        b=Z4qFaF73uq9WtjjgTsnR+JigYGrV7tuUE0TtZjlDJS+14JOHjQRJPxmqcXOHQtbzjp
         NPZhB48Jzy6DcDWMLQYHu7ib24D616wQr6nt09ARH4nYufNeidAQBLYAzUvupPRrSLaL
         n98rgfYZ73pQacdlbg/5X7WQrvzYycbeGgbB+JPhJrPd1kMCz9TqtEZEaIITIPtylDJ4
         GFIczgDNoWk5J1H1yeaQ4Zwii6EtuPJnp1pfxU+SWKahkbZka3dcLeH6CPZRXigajtxr
         rv6hbyNoQPNJ26euxXQxeBNKQZ2+kV1pr71dl8NXzO16YvQBb9LcJp1HRc/C6KSiGNMl
         iUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kFSuB7sswMV4SFOXW3tqsCHlWXHHfatJ8gHc/ZBJ388=;
        b=hrILrIt+HvAu/A+L3uUeMgRcFswOm3it1Fwms5bTOs0npTSwAGzhbwovhwoe5jW1Cz
         ihF3mNHM2874lM4rUPDHedrjJIAV5XKcJVjuINYJzg2rElfoh7AHzz0kdpCFetVwEkYx
         AnOujKiovKQnYOUqbpHAM6wsKSZGhsWdFvi6yaaEK16hDEQqB3diEBh4nintLFrRmVV7
         GqzlNtYmWxsDjHd1QsLfG251xc9sDslougcz6ZP4Z63eMxtYJ/mEu4qSHkM+OKr4U7Ej
         s6B1Hh5HMwnMg8jVowVFgcrkSS69g1B0jEQKxf8sZF29BA9T82IaCT7vTwqqWEMTyx1W
         +FBw==
X-Gm-Message-State: AOAM531Eehxw54RvVLSLNecZ71mqE5JtVcvTm/hB8fwdO9PF0LgLDYxB
        FkcdKVHWO1GgBn+1NCLNOBJIanySo+Xyswpy/LydAUC9
X-Google-Smtp-Source: ABdhPJyeh0RNO1UHBnBwX6WRfZM+0LBpVt+smYzpQqwYPWHr7fpL/0nxM4axUqQXoMrecprd3cnt1DiSq8pFZpDIu/U=
X-Received: by 2002:a05:6214:2409:b0:432:bf34:362f with SMTP id
 fv9-20020a056214240900b00432bf34362fmr11138280qvb.66.1649331045235; Thu, 07
 Apr 2022 04:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011257.114287-1-sashal@kernel.org> <20220407011257.114287-21-sashal@kernel.org>
 <CAOQ4uxi+Z_YDga+fkcuOjwo5EKfRkhsCp4SwxMHK0ARdJ_-+Aw@mail.gmail.com>
In-Reply-To: <CAOQ4uxi+Z_YDga+fkcuOjwo5EKfRkhsCp4SwxMHK0ARdJ_-+Aw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 7 Apr 2022 14:30:33 +0300
Message-ID: <CAOQ4uxg2c+MtCaA6+how4WOP3a3EAYfR1Rzz-PB9fxX411t3+Q@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.15 21/27] fs: fix an infinite loop in iomap_fiemap
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Guo Xuenan <guoxuenan@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 7, 2022 at 2:28 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Apr 7, 2022 at 7:26 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Guo Xuenan <guoxuenan@huawei.com>
> >
> > [ Upstream commit 49df34221804cfd6384135b28b03c9461a31d024 ]
> >
> > when get fiemap starting from MAX_LFS_FILESIZE, (maxbytes - *len) < start
> > will always true , then *len set zero. because of start offset is beyond
> > file size, for erofs filesystem it will always return iomap.length with
> > zero,iomap iterate will enter infinite loop. it is necessary cover this
> > corner case to avoid this situation.
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 7 PID: 905 at fs/iomap/iter.c:35 iomap_iter+0x97f/0xc70
> > Modules linked in: xfs erofs
> > CPU: 7 PID: 905 Comm: iomap Tainted: G        W         5.17.0-rc8 #27
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > RIP: 0010:iomap_iter+0x97f/0xc70
> > Code: 85 a1 fc ff ff e8 71 be 9c ff 0f 1f 44 00 00 e9 92 fc ff ff e8 62 be 9c ff 0f 0b b8 fb ff ff ff e9 fc f8 ff ff e8 51 be 9c ff <0f> 0b e9 2b fc ff ff e8 45 be 9c ff 0f 0b e9 e1 fb ff ff e8 39 be
> > RSP: 0018:ffff888060a37ab0 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: ffff888060a37bb0 RCX: 0000000000000000
> > RDX: ffff88807e19a900 RSI: ffffffff81a7da7f RDI: ffff888060a37be0
> > RBP: 7fffffffffffffff R08: 0000000000000000 R09: ffff888060a37c20
> > R10: ffff888060a37c67 R11: ffffed100c146f8c R12: 7fffffffffffffff
> > R13: 0000000000000000 R14: ffff888060a37bd8 R15: ffff888060a37c20
> > FS:  00007fd3cca01540(0000) GS:ffff888108780000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020010820 CR3: 0000000054b92000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  iomap_fiemap+0x1c9/0x2f0
> >  erofs_fiemap+0x64/0x90 [erofs]
> >  do_vfs_ioctl+0x40d/0x12e0
> >  __x64_sys_ioctl+0xaa/0x1c0
> >  do_syscall_64+0x35/0x80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  </TASK>
> > ---[ end trace 0000000000000000 ]---
> > watchdog: BUG: soft lockup - CPU#7 stuck for 26s! [iomap:905]
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > [djwong: fix some typos]
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 504e69578112..e0a3455f9a0f 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -173,7 +173,7 @@ int fiemap_prep(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >
> >         if (*len == 0)
> >                 return -EINVAL;
> > -       if (start > maxbytes)
> > +       if (start >= maxbytes)
> >                 return -EFBIG;
> >
> >         /*
> > --
> > 2.35.1
> >
>
> Sasha,
>
> Any reason why I didn't see this patch posted for 5.10.y?
> I happen to know that it applies cleanly to 5.10.109 and I also included it in
> my xfs-5.10.y patch candidates branch [1] which has gone through some
> xfstests cycles already.
>

Nevermind, I see it was just posted :)

Thanks,
Amir.

>
> [1] https://github.com/amir73il/linux/commits/xfs-5.10.y
