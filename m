Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607216319D9
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 07:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiKUGsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 01:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKUGsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 01:48:24 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C57711446;
        Sun, 20 Nov 2022 22:48:23 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id k67so10317935vsk.2;
        Sun, 20 Nov 2022 22:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OKwZYjUpgcMpjUPaMufxFd6lTmMS5OdhYd7iJvzeHqo=;
        b=ou4XNZbV8BAIFC9D5DIJAnNRKqiiQAfMwc79hpIFIQ1lAqnuTq6I7AypZJsNKK3m+Q
         E9IjrHdcnOYzMSs46EIgjid2K/qu/UMdz03T83kLtzOpFB6hZGy66Ta/zz7bASNSQxby
         I6fsyWjt6+HLB3t8Trsm8kH82MCe27JH8/vE3IfQw+XexbA/INk3ADulFY5G/u+viZvx
         CYPhzcRyLSI5lyb2KzvrANz+q9ZQIdVJ/QfZFj+TCC2BtmNmV4U/PjFusZ/ePdfwmywc
         RXfSAlYZQFQXYRce+U2/wwb21ZiozicmNuns2G+SRsPeolkXThOr4cGe8CwZTSI5xV4y
         HkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKwZYjUpgcMpjUPaMufxFd6lTmMS5OdhYd7iJvzeHqo=;
        b=edCIEMO4g72aZyJeoxe1mA1OxF8zyKejgs8+BmZ7KsJJODoymVO4bV//sX/MrRxjMy
         g+vSru6dnx9Ve/s44dno1Xo++jlFNMvJAm9cGJHK+IdyGGGXNEzju5tDdm24+W4dofP7
         U0FuYAEd+94rhnYvFd2kCpon8MME1DtdIH5n/wyy6DYIXo9Ou7GUHCaH/jT1ZU3TR7sk
         ZTJFqN8hfO4P1CApGQBHhow6KWlxFG1WvdzC3nm6b0MulKdUFKpJ6xv4q/fP11+GGEFi
         1FDRktSZPb39B2gtE5fxuh9tTSEuGguDwxPcOsPF5WfbUShiXuwhGeSYq6H1xvHTHeLP
         J2gA==
X-Gm-Message-State: ANoB5pmf8GRwMdbZAU3g7XwDLo2qMxaLygX3+xB3k7kQHyGFtq8NGYj4
        X753gBWf+SiwsUZskJlcvo8/wLOsjHeBzmgiB2yLiTPvAT8=
X-Google-Smtp-Source: AA0mqf6G3PAykFZVtBS6r14XOfEFcq7qcYIbz6JjXkkCDSJ5GVIS0VTtdNvPl0fTbC4a+diuW5XpnJqTCSIpB3R9t28=
X-Received: by 2002:a67:e94e:0:b0:3a7:91c0:5915 with SMTP id
 p14-20020a67e94e000000b003a791c05915mr31226vso.84.1669013301929; Sun, 20 Nov
 2022 22:48:21 -0800 (PST)
MIME-Version: 1.0
References: <20221119093424.193145-1-chenzhongjin@huawei.com>
 <CAKFNMokEHD4FfPRcuRB4GrVquiT_RkWkNGKgb+ZPLPSGwfbDHQ@mail.gmail.com> <db11fe6a-356b-a522-f275-9b8ce8ab3b4a@huawei.com>
In-Reply-To: <db11fe6a-356b-a522-f275-9b8ce8ab3b4a@huawei.com>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Mon, 21 Nov 2022 15:48:05 +0900
Message-ID: <CAKFNMo=SsnbZxrAU-ho_37J4ZBqG+VY0kDJxDa3widrb2Gkj1g@mail.gmail.com>
Subject: Re: [PATCH v2] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 11:16 AM Chen Zhongjin wrote:
>
> Hi,
>
> On 2022/11/19 22:09, Ryusuke Konishi wrote:
> > On Sat, Nov 19, 2022 at 6:37 PM Chen Zhongjin wrote:
> >> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> >> nilfs_segment_usage is not set dirty, which makes it can be found by
> >> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
> > The body of the patch looks OK, but this part of the commit log is a
> > bit misleading.
> > Could you please modify the expression so that we can understand this
> > patch fixes the issue when the disk image is corrupted and the leak
> > wasn't always there ?
>
> Makes sense. I'm going to fix the message as this:

Thank you for responding to my comment.

>
> When extending segment, the current segment is allocated and set dirty
> by previous nilfs_sufile_alloc().
> But for some special cases such as corrupted image it can be unreliable,
> so nilfs_sufile_mark_dirty()
> is called to promise that current segment is dirty.

This sentence is a little different because nilfs_sufile_mark_dirty()
is originally called to dirty the buffer to include it as a part of
the log of nilfs ahead, where the completed usage data will be stored
later.

And, unlike the dirty state of buffers and inodes, the dirty state of
segments is persistent and resides on disk until it's freed by
nilfs_sufile_free() unless it's destroyed on disk.

>
> However, nilfs_sufile_mark_dirty() only sets buffer and inode dirty
> while nilfs_segment_usage can
> still be clean an used by following nilfs_sufile_alloc() because it
> checks nilfs_segment_usage_clean(su).
>
> This will cause the problem reported...

So, how about a description like this:

When extending segments, nilfs_sufile_alloc() is called to get an
unassigned segment.
nilfs_sufile_alloc() then marks it as dirty to avoid accidentally
allocating the same segment in the future.
But for some special cases such as a corrupted image it can be unreliable.

If such corruption of the dirty state of the segment occurs, nilfs2
may reallocate a segment that is in use and pick the same segment for
writing twice at the same time.
...
This will cause the reported problem.
...
Fix the problem by setting usage as dirty every time in
nilfs_sufile_mark_dirty() which is called for the current segment
before allocating additional segments during constructing segments to
be written out.

Regards,
Ryusuke Konishi

>
> Could you please have a check? Thanks!
>
> Best,
> Chen
> > Originally, the assumption was that the current and next segments
> > pointed to by log headers had been made dirty, and in fact mkfs.nilfs2
> > and nilfs2 itself had created metadata that way, so it wasn't really a
> > problem.  Usually the segment usage that this patch tries to dirty is
> > already marked dirty and usually results in duplicate processing.
> > nilfs_sufile_mark_dirty() is really only supposed to dirty that buffer
> > and inode, and this patch changes the role.
> >
> > However, that assumption was incomplete in the sense that it does not
> > assume broken metadata (whether intentionally or as a result of
> > device/media failure), and lacked checks or protection from it.  In
> > the meantime, you showed the simple and safe workaround even though it
> > duplicates in almost all cases and even changes the semantics of the
> > function.
> > In terms of the stability and safety, your patch is good that we can
> > ignore the inefficiency, so I am pushing for this change.
> >
> > Thanks,
> > Ryusuke Konishi
> >
> >> This will cause the problem reported by syzkaller:
> >> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
> >>
> >> It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
> >> nilfs_sufile_alloc() not called to allocate a new segment.
> >>
> >> The first time nilfs_segctor_extend_segments() allocated segment
> >> segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
> >> nextnextnum = 4 segment because its su is not set dirty.
> >> So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.
> >>
> >> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> >> added to both buffer lists of two segbuf.
> >> It makes the list head of second list linked to the first one. When
> >> iterating the first one, it will access and deref the head of second,
> >> which causes NULL pointer dereference.
> >>
> >> Fix this by setting usage as dirty in nilfs_sufile_mark_dirty(),
> >> and add lock in it to protect the usage modification.
> >>
> >> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> >> Cc: stable@vger.kernel.org
> >> Reported-by: syzbot+77e4f005cb899d4268d1@syzkaller.appspotmail.com
> >> Reported-by: Liu Shixin <liushixin2@huawei.com>
> >> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> >> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> >> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> >> ---
> >> v1 -> v2:
> >> 1) Add lock protection as Ryusuke suggested and slightly fix commit
> >> message.
> >> 2) Fix and add tags.
> >> ---
> >>   fs/nilfs2/sufile.c | 8 ++++++++
> >>   1 file changed, 8 insertions(+)
> >>
> >> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> >> index 77ff8e95421f..dc359b56fdfa 100644
> >> --- a/fs/nilfs2/sufile.c
> >> +++ b/fs/nilfs2/sufile.c
> >> @@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
> >>   int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
> >>   {
> >>          struct buffer_head *bh;
> >> +       void *kaddr;
> >> +       struct nilfs_segment_usage *su;
> >>          int ret;
> >>
> >> +       down_write(&NILFS_MDT(sufile)->mi_sem);
> >>          ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
> >>          if (!ret) {
> >>                  mark_buffer_dirty(bh);
> >>                  nilfs_mdt_mark_dirty(sufile);
> >> +               kaddr = kmap_atomic(bh->b_page);
> >> +               su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
> >> +               nilfs_segment_usage_set_dirty(su);
> >> +               kunmap_atomic(kaddr);
> >>                  brelse(bh);
> >>          }
> >> +       up_write(&NILFS_MDT(sufile)->mi_sem);
> >>          return ret;
> >>   }
> >>
> >> --
> >> 2.17.1
> >>
