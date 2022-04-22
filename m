Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9853D50AFBF
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 07:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiDVF5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 01:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiDVF5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 01:57:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9586A2FB;
        Thu, 21 Apr 2022 22:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0B50B82974;
        Fri, 22 Apr 2022 05:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12B1C385AA;
        Fri, 22 Apr 2022 05:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650606893;
        bh=bUrwNa2jPgsgJxQkoG5r227zZatdq91cfQWCFa1pTUc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=IKKl4bekyTRerar8LEgfm2sWhYaTy65ntzCBXTmlkjSeXw0ig56ou0blltKZGah2U
         e/W8JJbrLQLv9DlVZnuSu6hsPUqYkIMuMxPNvJrEYL6j+Y7rS+k1Rrhgqj2xev5SuB
         +ICisZxzj8ogizJ5du1+3E6WmJisMkDRX/RBPc/SbSm8XDUbIjz0PRFkw52ftd1A2r
         XGSi5TwROwToDMOC/wMoRxiC/qenY0DLShpRnrygDA4JsKSGa04ez4+77I1ycl2QBT
         SabmEGL2/4YDRnU7dQ/p3YOcIFThShuI/8eRyQv9HBLW2nBTLWgiqisd15rhtiEHI/
         vIyxO71DPZz9w==
Received: by mail-wm1-f47.google.com with SMTP id q20so4456535wmq.1;
        Thu, 21 Apr 2022 22:54:53 -0700 (PDT)
X-Gm-Message-State: AOAM5339Y3SIUj57/2xC4xCGojiNZAqirmdB83SvswCDESJYsML/39Xz
        xEyeJSeXaTPvjwroBVDNfei3eiU+Hu1vvUcJDxE=
X-Google-Smtp-Source: ABdhPJzA5pKXGtSgCP8euSF4E86K804hiGfu+B7CoBJFdhlDoGVeeXI0gHS8+quTHu87bDT4vhNdS6R9/IaCxgzAPZQ=
X-Received: by 2002:a05:600c:3503:b0:38f:fbd7:1f0d with SMTP id
 h3-20020a05600c350300b0038ffbd71f0dmr2439802wmq.170.1650606891969; Thu, 21
 Apr 2022 22:54:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:6b8a:0:0:0:0:0 with HTTP; Thu, 21 Apr 2022 22:54:51
 -0700 (PDT)
In-Reply-To: <20220418173923.193173-1-tadeusz.struk@linaro.org>
References: <20220418173923.193173-1-tadeusz.struk@linaro.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 22 Apr 2022 14:54:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_9BT7je6-UHgDYCY-WD2maxYtam0_En8pgS_FiwRJP9Q@mail.gmail.com>
Message-ID: <CAKYAXd_9BT7je6-UHgDYCY-WD2maxYtam0_En8pgS_FiwRJP9Q@mail.gmail.com>
Subject: Re: [PATCH] exfat: check if cluster num is valid
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-04-19 2:39 GMT+09:00, Tadeusz Struk <tadeusz.struk@linaro.org>:
Hi Tadeusz,

> Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
> This was triggered by reproducer calling truncate with size 0,
> which causes the following trace:
>
> BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490
> fs/exfat/balloc.c:174
> Read of size 8 at addr ffff888115aa9508 by task syz-executor251/365
>
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
>  print_address_description+0x81/0x3c0 mm/kasan/report.c:233
>  __kasan_report mm/kasan/report.c:419 [inline]
>  kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
>  exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
>  exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
>  __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
>  exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
>  exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
>  notify_change+0xb76/0xe10 fs/attr.c:336
>  do_truncate+0x1ea/0x2d0 fs/open.c:65
Could you please share how to reproduce this ?

Thanks.
>
> Add checks to validate if cluster number is within valid range in
> exfat_clear_bitmap() and exfat_set_bitmap()
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sungjong Seo <sj1557.seo@samsung.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> Link:
> https://syzkaller.appspot.com/bug?id=50381fc73821ecae743b8cf24b4c9a04776f767c
> Reported-by: syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
> Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  fs/exfat/balloc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
> index 03f142307174..4ed81f86f993 100644
> --- a/fs/exfat/balloc.c
> +++ b/fs/exfat/balloc.c
> @@ -149,6 +149,9 @@ int exfat_set_bitmap(struct inode *inode, unsigned int
> clu, bool sync)
>  	struct exfat_sb_info *sbi = EXFAT_SB(sb);
>
>  	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
> +	if (clu > EXFAT_DATA_CLUSTER_COUNT(sbi))
> +		return -EINVAL;
> +
>  	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
>  	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
>  	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
> @@ -167,6 +170,9 @@ void exfat_clear_bitmap(struct inode *inode, unsigned
> int clu, bool sync)
>  	struct exfat_mount_options *opts = &sbi->options;
>
>  	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
> +	if (clu > EXFAT_DATA_CLUSTER_COUNT(sbi))
> +		return;
> +
>  	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
>  	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
>  	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
> --
> 2.35.1
>
>
