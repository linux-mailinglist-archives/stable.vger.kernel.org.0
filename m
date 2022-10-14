Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CAC5FEEC4
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJNNjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJNNje (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:39:34 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBDB1CEC26
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 06:39:33 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id g1so7223847lfu.12
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 06:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFbzLBe9AfP7vamYvVIzj2UjVP0fVKxnfJpMQrpApvA=;
        b=WTdB/wjc8j00xI0SIDnU1S49AxbVLonWAjGprNp/ElfIr4tAZ7hufGhQsROMb4jAf8
         +katokk/DSN3hPlXPCl9DHsKs3jKpCCNBKuUgDdUToGpOM3ZuK3pPTRPoPS4CzwBslOL
         q1S9NH1LGrEi9eYpLvKRES9EJsdT1OSRE4iangqtJUOcdNIggaccMuLjZ5Y4n+iP7tVb
         V5NCUltYhOipQ59lKwkyZChGQSo+ao6Hezjpt0gKs1DsJm7U1dwTSJUP3uDwXG/oYwuK
         xJxKYWi8S3hSfxikppxDmds8zE31pLV4AvV9rpx3ykxICb0BlBxl8veKaBYx8Hgp7Ma7
         nQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nFbzLBe9AfP7vamYvVIzj2UjVP0fVKxnfJpMQrpApvA=;
        b=0nCHV13QpxBzxVtGOsOeCxQar57/xuzOygFWQInNLJ7L+HKoT2IPB+2YkOoemkbjke
         vn90IYl1fQSJi+yXC7M7uqobzdhm68/+bWwhnMUUJJHhYsG4pe0mRSw9p+L0N91yHB60
         2f7J1coU3CGpyDDWf/HnD/5ZzlRDDN98i1uyTdaP8suJySAVGS2MWjX3usAsu7Fo3eHG
         K1pwpB6Mh/4UDdDVh2V2VN62QpO4HmTH4fs9HqLxvlZxfd2QYZpx8goakaaYggZmW/bX
         4gXAmQo/Gt63DthAUQe1ahmRF8K2Sqlj3C1c8YKxVlDX2b1uDzTlg10vSORhFi+qVyrw
         qUEg==
X-Gm-Message-State: ACrzQf2+D0GBah23/vApNeOG78lWmmwx6kIuzM9DbIklNUGI3oD4zqft
        VBiaFIk/Tc18jU0eJNPvlTpkzF4pjR/IT9sBy/JfSA==
X-Google-Smtp-Source: AMsMyM5gkNQ5yYERXc0Eyb0ajg8XzMBGXpaYLDr61DyNzuHgK9k0K+nntxSZQJlpwQ2XhVGCc908Q6b6KKfOiYZ9Yio=
X-Received: by 2002:a05:6512:31c4:b0:4a2:696e:4302 with SMTP id
 j4-20020a05651231c400b004a2696e4302mr1962516lfe.478.1665754771639; Fri, 14
 Oct 2022 06:39:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221014122032.47784-1-jinpu.wang@ionos.com> <8bd2e447-54b0-8a6a-9020-7453a7353dd3@molgen.mpg.de>
In-Reply-To: <8bd2e447-54b0-8a6a-9020-7453a7353dd3@molgen.mpg.de>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 14 Oct 2022 15:39:20 +0200
Message-ID: <CAMGffEkiWcHFdupfPFaHKp6G-_OQx5D6um2aO0cvYtSk7C9NWQ@mail.gmail.com>
Subject: Re: [PATCH] md/bitmap: Fix bitmap chunk size overflow issues.
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        song@kernel.org, linux-raid@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 3:23 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Jack, dear Florian-Ewald,
>
>
> Thank you for the patch.
>
> Am 14.10.22 um 14:20 schrieb Jack Wang:
> > From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> >
> > - limit bitmap chunk size internal u64 variable to values not overflowi=
ng
> >    the u32 bitmap superblock structure variable stored on persistent me=
dia.
> > - assign bitmap chunk size internal u64 variable from unsigned values t=
o
> >    avoid possible sign extension artifacts when assigning from a s32 va=
lue.
> >
> > The bug has been there since at least kernel 4.0.
>
> Did you find this during code review or hit actual problems? If so, a
> reproducer would be nice to have. (A small nit, should you resend, if
> you removed the dot/period from the end of the commit message
> summary/title, that=E2=80=99d be great.)


Yes, we can reproduce it.
steps:
1: mdadm -C /dev/mdx -l 1 --bitmap=3Dinternal --bitmap-chunk=3D256M -e 1.2
-n2 /dev/rnbd1 /dev/rnbd2
2 resize member device rnbd1 and rnbd2 to 8 TB
3 mdadm --grow /dev/mdx --size=3Dmax

the bitmap_chunk will overflow.

Sure we can improve the commit message.
>
> Kind regards,
>
> Paul
Thanks for checking!

>
>
> > Cc: stable@vger.kernel.org
> >
> > Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> >   drivers/md/md-bitmap.c | 20 ++++++++++++--------
> >   1 file changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index bf6dffadbe6f..b266711485a8 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
> >       sb =3D kmap_atomic(bitmap->storage.sb_page);
> >       pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
> >       pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
> > -     pr_debug("       version: %d\n", le32_to_cpu(sb->version));
> > +     pr_debug("       version: %u\n", le32_to_cpu(sb->version));
> >       pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
> >                le32_to_cpu(*(__le32 *)(sb->uuid+0)),
> >                le32_to_cpu(*(__le32 *)(sb->uuid+4)),
> > @@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
> >       pr_debug("events cleared: %llu\n",
> >                (unsigned long long) le64_to_cpu(sb->events_cleared));
> >       pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
> > -     pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
> > -     pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
> > +     pr_debug("     chunksize: %u B\n", le32_to_cpu(sb->chunksize));
> > +     pr_debug("  daemon sleep: %us\n", le32_to_cpu(sb->daemon_sleep));
> >       pr_debug("     sync size: %llu KB\n",
> >                (unsigned long long)le64_to_cpu(sb->sync_size)/2);
> > -     pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind))=
;
> > +     pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind))=
;
> >       kunmap_atomic(sb);
> >   }
> >
> > @@ -2105,7 +2105,8 @@ int md_bitmap_resize(struct bitmap *bitmap, secto=
r_t blocks,
> >                       bytes =3D DIV_ROUND_UP(chunks, 8);
> >                       if (!bitmap->mddev->bitmap_info.external)
> >                               bytes +=3D sizeof(bitmap_super_t);
> > -             } while (bytes > (space << 9));
> > +             } while (bytes > (space << 9) && (chunkshift + BITMAP_BLO=
CK_SHIFT) <
> > +                     (BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->ch=
unksize) - 1));
> >       } else
> >               chunkshift =3D ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
> >
> > @@ -2150,7 +2151,7 @@ int md_bitmap_resize(struct bitmap *bitmap, secto=
r_t blocks,
> >       bitmap->counts.missing_pages =3D pages;
> >       bitmap->counts.chunkshift =3D chunkshift;
> >       bitmap->counts.chunks =3D chunks;
> > -     bitmap->mddev->bitmap_info.chunksize =3D 1 << (chunkshift +
> > +     bitmap->mddev->bitmap_info.chunksize =3D 1UL << (chunkshift +
> >                                                    BITMAP_BLOCK_SHIFT);
> >
> >       blocks =3D min(old_counts.chunks << old_counts.chunkshift,
> > @@ -2176,8 +2177,8 @@ int md_bitmap_resize(struct bitmap *bitmap, secto=
r_t blocks,
> >                               bitmap->counts.missing_pages =3D old_coun=
ts.pages;
> >                               bitmap->counts.chunkshift =3D old_counts.=
chunkshift;
> >                               bitmap->counts.chunks =3D old_counts.chun=
ks;
> > -                             bitmap->mddev->bitmap_info.chunksize =3D =
1 << (old_counts.chunkshift +
> > -                                                                      =
    BITMAP_BLOCK_SHIFT);
> > +                             bitmap->mddev->bitmap_info.chunksize =3D
> > +                                     1UL << (old_counts.chunkshift + B=
ITMAP_BLOCK_SHIFT);
> >                               blocks =3D old_counts.chunks << old_count=
s.chunkshift;
> >                               pr_warn("Could not pre-allocate in-memory=
 bitmap for cluster raid\n");
> >                               break;
> > @@ -2534,6 +2535,9 @@ chunksize_store(struct mddev *mddev, const char *=
buf, size_t len)
> >       if (csize < 512 ||
> >           !is_power_of_2(csize))
> >               return -EINVAL;
> > +     if (csize >=3D (1UL << (BITS_PER_BYTE *
> > +             sizeof(((bitmap_super_t *)0)->chunksize))))
> > +             return -EOVERFLOW;
> >       mddev->bitmap_info.chunksize =3D csize;
> >       return len;
> >   }
