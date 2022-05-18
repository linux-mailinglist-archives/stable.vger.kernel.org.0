Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7358852BA14
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiERMYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiERMYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14844F9E7;
        Wed, 18 May 2022 05:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A190615EA;
        Wed, 18 May 2022 12:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790F7C34100;
        Wed, 18 May 2022 12:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876682;
        bh=3lU46kCHe5tdlbox2dKjE7etFJXfokiRv7DTKdip0eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cN75GKwa3LQke+xO71hSKwhjT5wbxJPWtE/QnWu1sOlEPNayorSj3aK+VU3+TCUlt
         QrxYdIOA4fIaCsMT+FiDfEizRTPXiiLu2ZQT9sWbdpSH7UyFBRrJVD04/IwDKgDyNk
         WkqKuQUbT95AoHixI9+/HWMFC5qKvAHja7DGKELMIbEGOXlFym61dqg/3SA31NmeHy
         S1hIvz0X6MCCweUrbju2rUUgvPMnc8P/nQHJmWLGSOxpOoQsNXs0aiIcn4YTQIx3sF
         m1RjS7ms5SLfr86BRc4pHXPRpiq9Ke9vZFB+Pre1DrJOX/vQgGT6djIM1Uy7yVx9M1
         Oku1Bsu3nlYrw==
Date:   Wed, 18 May 2022 08:24:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     stable <stable@vger.kernel.org>, Guo Xuenan <guoxuenan@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.15 21/27] fs: fix an infinite loop in
 iomap_fiemap
Message-ID: <YoTlidnOZqNMKqU/@sashalap>
References: <20220407011257.114287-1-sashal@kernel.org>
 <20220407011257.114287-21-sashal@kernel.org>
 <CAOQ4uxi+Z_YDga+fkcuOjwo5EKfRkhsCp4SwxMHK0ARdJ_-+Aw@mail.gmail.com>
 <CAOQ4uxg2c+MtCaA6+how4WOP3a3EAYfR1Rzz-PB9fxX411t3+Q@mail.gmail.com>
 <CAOQ4uxjcCnp3ctMZ4QL4Yc2McfLPZhRnfu=8E2YQVXRbTrJv1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjcCnp3ctMZ4QL4Yc2McfLPZhRnfu=8E2YQVXRbTrJv1w@mail.gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 08:33:05PM +0300, Amir Goldstein wrote:
>On Thu, Apr 7, 2022 at 2:30 PM Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Thu, Apr 7, 2022 at 2:28 PM Amir Goldstein <amir73il@gmail.com> wrote:
>> >
>> > On Thu, Apr 7, 2022 at 7:26 AM Sasha Levin <sashal@kernel.org> wrote:
>> > >
>> > > From: Guo Xuenan <guoxuenan@huawei.com>
>> > >
>> > > [ Upstream commit 49df34221804cfd6384135b28b03c9461a31d024 ]
>> > >
>> > > when get fiemap starting from MAX_LFS_FILESIZE, (maxbytes - *len) < start
>> > > will always true , then *len set zero. because of start offset is beyond
>> > > file size, for erofs filesystem it will always return iomap.length with
>> > > zero,iomap iterate will enter infinite loop. it is necessary cover this
>> > > corner case to avoid this situation.
>> > >
>> > > ------------[ cut here ]------------
>> > > WARNING: CPU: 7 PID: 905 at fs/iomap/iter.c:35 iomap_iter+0x97f/0xc70
>> > > Modules linked in: xfs erofs
>> > > CPU: 7 PID: 905 Comm: iomap Tainted: G        W         5.17.0-rc8 #27
>> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>> > > RIP: 0010:iomap_iter+0x97f/0xc70
>> > > Code: 85 a1 fc ff ff e8 71 be 9c ff 0f 1f 44 00 00 e9 92 fc ff ff e8 62 be 9c ff 0f 0b b8 fb ff ff ff e9 fc f8 ff ff e8 51 be 9c ff <0f> 0b e9 2b fc ff ff e8 45 be 9c ff 0f 0b e9 e1 fb ff ff e8 39 be
>> > > RSP: 0018:ffff888060a37ab0 EFLAGS: 00010293
>> > > RAX: 0000000000000000 RBX: ffff888060a37bb0 RCX: 0000000000000000
>> > > RDX: ffff88807e19a900 RSI: ffffffff81a7da7f RDI: ffff888060a37be0
>> > > RBP: 7fffffffffffffff R08: 0000000000000000 R09: ffff888060a37c20
>> > > R10: ffff888060a37c67 R11: ffffed100c146f8c R12: 7fffffffffffffff
>> > > R13: 0000000000000000 R14: ffff888060a37bd8 R15: ffff888060a37c20
>> > > FS:  00007fd3cca01540(0000) GS:ffff888108780000(0000) knlGS:0000000000000000
>> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > > CR2: 0000000020010820 CR3: 0000000054b92000 CR4: 00000000000006e0
>> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> > > Call Trace:
>> > >  <TASK>
>> > >  iomap_fiemap+0x1c9/0x2f0
>> > >  erofs_fiemap+0x64/0x90 [erofs]
>> > >  do_vfs_ioctl+0x40d/0x12e0
>> > >  __x64_sys_ioctl+0xaa/0x1c0
>> > >  do_syscall_64+0x35/0x80
>> > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> > >  </TASK>
>> > > ---[ end trace 0000000000000000 ]---
>> > > watchdog: BUG: soft lockup - CPU#7 stuck for 26s! [iomap:905]
>> > >
>> > > Reported-by: Hulk Robot <hulkci@huawei.com>
>> > > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
>> > > [djwong: fix some typos]
>> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > > ---
>> > >  fs/ioctl.c | 2 +-
>> > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > >
>> > > diff --git a/fs/ioctl.c b/fs/ioctl.c
>> > > index 504e69578112..e0a3455f9a0f 100644
>> > > --- a/fs/ioctl.c
>> > > +++ b/fs/ioctl.c
>> > > @@ -173,7 +173,7 @@ int fiemap_prep(struct inode *inode, struct fiemap_extent_info *fieinfo,
>> > >
>> > >         if (*len == 0)
>> > >                 return -EINVAL;
>> > > -       if (start > maxbytes)
>> > > +       if (start >= maxbytes)
>> > >                 return -EFBIG;
>> > >
>> > >         /*
>> > > --
>> > > 2.35.1
>> > >
>> >
>> > Sasha,
>> >
>> > Any reason why I didn't see this patch posted for 5.10.y?
>> > I happen to know that it applies cleanly to 5.10.109 and I also included it in
>> > my xfs-5.10.y patch candidates branch [1] which has gone through some
>> > xfstests cycles already.
>> >
>>
>> Nevermind, I see it was just posted :)
>>
>
>Sasha,
>
>I do not see this patch in either of the stable trees.
>Did it fall through the cracks?

Great question... Looks like I've never queued up this entire batch. Let
me see what happened and I'll queue it up if it's still relevant.

-- 
Thanks,
Sasha
