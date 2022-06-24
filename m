Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1AB559C0B
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiFXOiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 10:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiFXOht (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 10:37:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FB64FC7D;
        Fri, 24 Jun 2022 07:37:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EF4262081;
        Fri, 24 Jun 2022 14:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E64C385A5;
        Fri, 24 Jun 2022 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656081448;
        bh=CNBkSrLCaZGfawQUgSak+d02ko5fad5AVz/rJLSEs3U=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=u1hxhEbObejGel9t79BV/XwqoWz5imnrFY0iPN//c9MgONvFIMic89mLI2bdGFDcT
         FTMlW0y1eJFjPyNvQYvgHcz8+jAW+nf1zLoUP8x3afs6//woYRkXofQq2aaUabp2Nd
         ZPlIgDiNAc83gK3srvt+LEUSRvMbK1Lprsk/dr+uxFVok+GpQ0XZXSz6SuLNGMj0UP
         S48581ihx8iZeGuWVEvhHstN1tS2hIkTwAAB1IzViYHqD5R0EARapGuQh3pXChAyDb
         ED8nBsoY8f8x0X46cTzCxEuKv4qAxcyW+V+/WNk7LYhAdNfqofEyHuMrjmRr2K3y4O
         jGwRfq9yOTpbA==
Received: by mail-wm1-f49.google.com with SMTP id o16-20020a05600c379000b003a02eaea815so2415202wmr.0;
        Fri, 24 Jun 2022 07:37:28 -0700 (PDT)
X-Gm-Message-State: AJIora8xU/FbnJkE48PoeRZnFzkzXuqNIvlyu9lQdl1K1yD3ns4mmrlo
        33o3j3MCvEJh8hSudskpnUPtpu5N26kB+AHLyhU=
X-Google-Smtp-Source: AGRyM1toUIbPlNjeQV682apKJ2r7rupV5vchoSK9VTn7DESCMrOJKPYh0D/0cNa/9BwCGy8G4rV6ZJP6dP7UEjeL3O0=
X-Received: by 2002:a05:600c:4e0c:b0:39c:519f:9f35 with SMTP id
 b12-20020a05600c4e0c00b0039c519f9f35mr4276665wmq.153.1656081446878; Fri, 24
 Jun 2022 07:37:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f805:0:0:0:0:0 with HTTP; Fri, 24 Jun 2022 07:37:26
 -0700 (PDT)
In-Reply-To: <7FBC6FD2-5D60-4EB8-96D5-A6014D271950@tuxera.com>
References: <20220623033635.973929-1-xu.xin16@zte.com.cn> <20220623094956.977053-1-xu.xin16@zte.com.cn>
 <YrSeAGmk4GZndtdn@sol.localdomain> <CAKYAXd8qoLKbWGX7omYUfarSugRnose8X8o3Zhb1XctiUtamQg@mail.gmail.com>
 <7FBC6FD2-5D60-4EB8-96D5-A6014D271950@tuxera.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Jun 2022 23:37:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-cg5rvXo-MYZ29+wiE3BYbg4vqDHrOHtu77ox-+7dPBw@mail.gmail.com>
Message-ID: <CAKYAXd-cg5rvXo-MYZ29+wiE3BYbg4vqDHrOHtu77ox-+7dPBw@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ntfs: fix BUG_ON of ntfs_read_block()
To:     Anton Altaparmakov <anton@tuxera.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
        "cgel.zte@gmail.com" <cgel.zte@gmail.com>,
        "linux-ntfs-dev@lists.sourceforge.net" 
        <linux-ntfs-dev@lists.sourceforge.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>,
        "syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com" 
        <syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com>,
        Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-06-24 21:19 GMT+09:00, Anton Altaparmakov <anton@tuxera.com>:
> Hi,
>
> On 24 Jun 2022, at 03:33, Namjae Jeon
> <linkinjeon@kernel.org<mailto:linkinjeon@kernel.org>> wrote:
>
> 2022-06-24 2:08 GMT+09:00, Eric Biggers
> <ebiggers@kernel.org<mailto:ebiggers@kernel.org>>:
> On Thu, Jun 23, 2022 at 09:49:56AM +0000,
> cgel.zte@gmail.com<mailto:cgel.zte@gmail.com> wrote:
> From: xu xin <xu.xin16@zte.com.cn<mailto:xu.xin16@zte.com.cn>>
>
> As the bug description at
> https://lore.kernel.org/lkml/20220623033635.973929-1-xu.xin16@zte.com.cn/
> attckers can use this bug to crash the system.
>
> So to avoid panic, remove the BUG_ON, and use ntfs_warning to output a
> warning to the syslog and return instead until someone really solve
> the problem.
>
> Cc: stable@vger.kernel.org
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
> Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
> Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
> Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
> Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>
> Change for v2:
> - Use ntfs_warning instead of WARN().
> - Add the tag Cc: stable@vger.kernel.org.
> ---
> fs/ntfs/aops.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index 5f4fb6ca6f2e..84d68efb4ace 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -183,7 +183,12 @@ static int ntfs_read_block(struct page *page)
> vol =3D ni->vol;
>
> /* $MFT/$DATA must have its complete runlist in memory at all times. */
> - BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
> + if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
> + ntfs_warning(vi->i_sb, "Error because ni->runlist.rl, ni->mft_no, "
> + "and NInoAttr(ni) is null.");
> + unlock_page(page);
> + return -EINVAL;
> + }
>
> A better warning message that doesn't rely on implementation details
> (struct
> field and macro names) would be "Runlist of $MFT/$DATA is not cached".
> Also,
> why does this situation happen in the first place? Is there a way to
> prevent
> this situation in the first place?
>
> ntfs_mapping_pairs_decompress() should return error pointer instead of
> NULL.
>
> Callers is checking error value using IS_ERR(). and the mapping pairs
> array of @MFT entry is empty, I think it's corrupted, it should cause
> mount failure.
>
> NAK
>
> Sorry but this patch is incorrect.  It is perfectly valid to have an empt=
y
> non-resident attribute.  E.g. if you truncate a file to zero size this is
> exactly what you will get on-disk and when you then unmount and mount nex=
t
> time and try to access that file with your patch you will now get an -EIO
> error trying to access the file and you will not be able to write to the
> file nor truncate it as you will keep getting the i/o error.
Sorry, I can't reproduce the issue you described?

root@linkinjeon-Z10PA-D8-Series:/mnt/test# ls -al
total 5928
drwx------ 1 root root    4096  6=EC=9B=94 24 23:01  .
drwxr-xr-x 7 root root    4096  5=EC=9B=94 29 12:47  ..
-rw------- 1 root root 6059409  9=EC=9B=94 22  2020  foo
drwx------ 1 root root       0  6=EC=9B=94 24 22:30 'System Volume Informat=
ion'
root@linkinjeon-Z10PA-D8-Series:/mnt/test# truncate -s 0 foo
root@linkinjeon-Z10PA-D8-Series:/mnt/test# ls -al
total 8
drwx------ 1 root root 4096  6=EC=9B=94 24 23:01  .
drwxr-xr-x 7 root root 4096  5=EC=9B=94 29 12:47  ..
-rw------- 1 root root    0  6=EC=9B=94 24 23:11  foo
drwx------ 1 root root    0  6=EC=9B=94 24 22:30 'System Volume Information=
'
root@linkinjeon-Z10PA-D8-Series:/mnt/test# cd ..
root@linkinjeon-Z10PA-D8-Series:/mnt# sudo umount /mnt/test
root@linkinjeon-Z10PA-D8-Series:/mnt# sudo mount -t ntfs /dev/sde2 /mnt/tes=
t/
root@linkinjeon-Z10PA-D8-Series:/mnt# cd /mnt/test/
root@linkinjeon-Z10PA-D8-Series:/mnt/test# cat foo
root@linkinjeon-Z10PA-D8-Series:/mnt/test# truncate -s 1048576 foo
root@linkinjeon-Z10PA-D8-Series:/mnt/test# ls -al
total 1032
drwx------ 1 root root    4096  6=EC=9B=94 24 23:01  .
drwxr-xr-x 7 root root    4096  5=EC=9B=94 29 12:47  ..
-rw------- 1 root root 1048576  6=EC=9B=94 24 23:12  foo
drwx------ 1 root root       0  6=EC=9B=94 24 22:30 'System Volume Informat=
ion'
root@linkinjeon-Z10PA-D8-Series:/mnt/test# echo "hello world" > foo
root@linkinjeon-Z10PA-D8-Series:/mnt/test# cat foo
hello world

>
> The correct solution is to use IS_ERR_OR_NULL() in places where an empty
> attribute is not acceptable.  Such a case is for example when mounting th=
e
> $MFT::$DATA::unnamed attribute cannot be empty which should then be
> addressed inside in fs/ntfs/inode.c::ntfs_read_inode_mount().  There may =
be
> more call sites to ntfs_mapping_pairs_decompress() which require similar
> treatment.  Need to go through the code to see...
I think that it is needed everywhere that calls it. Am I missing something =
?

I can not understand why the below code is needed in
ntfs_mapping_pairs_decompress().

/* If the mapping pairs array is valid but empty, nothing to do. */
        if (!vcn && !*buf) {
                return old_rl;
        }

There is no description in patch. and this code is not in
ntfs_mapping_pairs_decompress() in ntfs-3g. Is there any case the
caller get NULL runlist pointer from ntfs_mapping_pairs_decompress()
in current ntfs code?

NTFS: Fix handling of valid but empty mapping pairs array in
      fs/ntfs/runlist.c::ntfs_mapping_pairs_decompress().

Signed-off-by: Anton Altaparmakov <aia21@cantab.net>

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/f=
s/ntfs/runlist.c?h=3Dv5.19-rc3&id=3D2b0ada2b8e086c267dd116a39ad41ff0a717b66=
5
>
> Best regards,
>
> Anton
>
>
> I haven't checked if this patch fix the problem. Xu, Can you check it ?
>
> diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
> index 97932fb5179c..31263fe0772f 100644
> --- a/fs/ntfs/runlist.c
> +++ b/fs/ntfs/runlist.c
> @@ -766,8 +766,11 @@ runlist_element
> *ntfs_mapping_pairs_decompress(const ntfs_volume *vol,
> return ERR_PTR(-EIO);
> }
> /* If the mapping pairs array is valid but empty, nothing to do. */
> - if (!vcn && !*buf)
> + if (!vcn && !*buf) {
> + if (!old_rl)
> + return ERR_PTR(-EIO);
> return old_rl;
> + }
> /* Current position in runlist array. */
> rlpos =3D 0;
> /* Allocate first page and set current runlist size to one page. */
>
>
> - Eric
>
>
