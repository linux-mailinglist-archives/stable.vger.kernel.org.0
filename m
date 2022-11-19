Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25CD630F18
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 15:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiKSOKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 09:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKSOKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 09:10:11 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B1D76169;
        Sat, 19 Nov 2022 06:10:09 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id q127so7321995vsa.7;
        Sat, 19 Nov 2022 06:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UK/36liefMYRPvX2jJzVryY7Hec6hcx+fUxOABXQRD0=;
        b=QmazCKaBq2I7kwQPa+4fGw/ON5iZ6OyfG3OTOqzGuyy37SMHqbOnCGXo4G8uA3deDa
         TZGnfnb6uDiCFUf2RrIBfw0nMZnoZlRN/Sgm5bZXUNEd4oEBTtyV0rJTkvV1giBiXhpy
         ZuNIrvtgWBaG4xVicub0YBxSorilQi8+ORLHBm9Vn6H9dI7QBRrGBLH02uoo0/6ACVEB
         Nhq5igTfhYANj/LuPeUNcPrE2j8O/wkFsezurH7Qt6+/n9F+wEfXg52tGloR7k7gV/Ka
         r3jqTabk/WxFdM90hudW4s9Y+X3+K8OPiWnBXFaVeJHAg6p0S/tqAdnQAAtjV9IQ8ZGU
         uIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UK/36liefMYRPvX2jJzVryY7Hec6hcx+fUxOABXQRD0=;
        b=om4vBc3y6i6x0UkKUnDHrGYjC2hJi331/7BbtO3HJN4FtBqBbc/ZfAVWltAbHYHymu
         P7s/BSKBEKJHK75jeJqdve/up8R2RWIoWWXhEBBRyI7j6C0a7OBEtnRHFhZoKQzxFHMn
         EZZSV6YFQqq/i0SoPVBg9zKMo0Sqx+sGZiw0iemwyXvNdHxnNhfkCyycKal+XSikjkqJ
         Uu7jW6vXhkqXbGgbOy1XHjIXUkAgDkNgdpHovfXb+jGGv/abpxSj6xKQuEby4y32XP1e
         F8xM/SQbkCVx08bHS+nKBKbGP44tmt3UUAfdvA1O5GkZJPKuSp7fAenqWF2Gy5l6PL+T
         Od7Q==
X-Gm-Message-State: ANoB5pk9bt09aRdEjQTfAzGqElWtSssDh13MDrd/0rKQ+JVkAcSfqvFr
        0hSAixRYwtqEkUvVhg4j8/epPQuFMKAoY2H7jew=
X-Google-Smtp-Source: AA0mqf6GnCr2UBEkczFji5nlgNspARpSk6VmFXmhduhpWzVfvJwUTyIS+ZN9SlEkA8TpgR9Ag9dOCNLgLuPzALmtvWs=
X-Received: by 2002:a67:e94e:0:b0:3a7:91c0:5915 with SMTP id
 p14-20020a67e94e000000b003a791c05915mr6473814vso.84.1668867008803; Sat, 19
 Nov 2022 06:10:08 -0800 (PST)
MIME-Version: 1.0
References: <20221119093424.193145-1-chenzhongjin@huawei.com>
In-Reply-To: <20221119093424.193145-1-chenzhongjin@huawei.com>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Sat, 19 Nov 2022 23:09:52 +0900
Message-ID: <CAKFNMokEHD4FfPRcuRB4GrVquiT_RkWkNGKgb+ZPLPSGwfbDHQ@mail.gmail.com>
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

On Sat, Nov 19, 2022 at 6:37 PM Chen Zhongjin wrote:
>
> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
> nilfs_segment_usage is not set dirty, which makes it can be found by
> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).

The body of the patch looks OK, but this part of the commit log is a
bit misleading.
Could you please modify the expression so that we can understand this
patch fixes the issue when the disk image is corrupted and the leak
wasn't always there ?

Originally, the assumption was that the current and next segments
pointed to by log headers had been made dirty, and in fact mkfs.nilfs2
and nilfs2 itself had created metadata that way, so it wasn't really a
problem.  Usually the segment usage that this patch tries to dirty is
already marked dirty and usually results in duplicate processing.
nilfs_sufile_mark_dirty() is really only supposed to dirty that buffer
and inode, and this patch changes the role.

However, that assumption was incomplete in the sense that it does not
assume broken metadata (whether intentionally or as a result of
device/media failure), and lacked checks or protection from it.  In
the meantime, you showed the simple and safe workaround even though it
duplicates in almost all cases and even changes the semantics of the
function.
In terms of the stability and safety, your patch is good that we can
ignore the inefficiency, so I am pushing for this change.

Thanks,
Ryusuke Konishi

>
> This will cause the problem reported by syzkaller:
> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
>
> It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
> nilfs_sufile_alloc() not called to allocate a new segment.
>
> The first time nilfs_segctor_extend_segments() allocated segment
> segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
> nextnextnum = 4 segment because its su is not set dirty.
> So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.
>
> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
> added to both buffer lists of two segbuf.
> It makes the list head of second list linked to the first one. When
> iterating the first one, it will access and deref the head of second,
> which causes NULL pointer dereference.
>
> Fix this by setting usage as dirty in nilfs_sufile_mark_dirty(),
> and add lock in it to protect the usage modification.
>
> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+77e4f005cb899d4268d1@syzkaller.appspotmail.com
> Reported-by: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> v1 -> v2:
> 1) Add lock protection as Ryusuke suggested and slightly fix commit
> message.
> 2) Fix and add tags.
> ---
>  fs/nilfs2/sufile.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 77ff8e95421f..dc359b56fdfa 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
>  int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
>  {
>         struct buffer_head *bh;
> +       void *kaddr;
> +       struct nilfs_segment_usage *su;
>         int ret;
>
> +       down_write(&NILFS_MDT(sufile)->mi_sem);
>         ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
>         if (!ret) {
>                 mark_buffer_dirty(bh);
>                 nilfs_mdt_mark_dirty(sufile);
> +               kaddr = kmap_atomic(bh->b_page);
> +               su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
> +               nilfs_segment_usage_set_dirty(su);
> +               kunmap_atomic(kaddr);
>                 brelse(bh);
>         }
> +       up_write(&NILFS_MDT(sufile)->mi_sem);
>         return ret;
>  }
>
> --
> 2.17.1
>
