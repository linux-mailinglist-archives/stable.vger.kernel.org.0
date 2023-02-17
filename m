Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2AC69A8D6
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 11:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBQKFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 05:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjBQKFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 05:05:46 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4765DE0D
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 02:05:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id pt13-20020a17090b3d0d00b00233ba727724so603212pjb.1
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 02:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0uHfzgv2qkWN2QON21082yWHlyLvuVbZRGsDEiQa/4=;
        b=PG5Binl+dYtv2Cjcd7RqW/ODxroR2V/J6A0O08t3kCKUF8DqL8yLPUONQMUKQscNc3
         EQOKnQ1LZO+QtC2oIbLMYVKiKQ5ZZPxm6e7cVdvAoEdL0JmOjt2RbXSk8iN5tm8PVtjk
         drb9pAjO+9YmLFMNRCnS15J1CNjRPLu0CgLshdZQAhTbf22BJAq5Wyay1Ttu1b39GgDB
         cQIF+Na6tM2sQdzbEByGhcSp+ALgk/Bwujx0nQsjsC6pxexRv8fmTgEWTLNuqKhiYI1/
         p6vtD2eluVvz+onwnkvOmMEHCXBIvBlaB5Q03/j3l74tHt7lwP4hcj356MYV7Eme+5hh
         84og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0uHfzgv2qkWN2QON21082yWHlyLvuVbZRGsDEiQa/4=;
        b=goFi4Kxkbuhy8vl5hkDUbnNDNb0H0MxeQzW7izlRi48PLElFS1bTWJDDtZoGArKXvU
         kB+TIqBHB4vdvOqbVIFMZhUfmDwy/7r+U8y2fW+17K4aK1FHi10+KuH8NZGYCAMY8D4p
         kaBKjnhsxwXeL+vpm8Yp8ZVPYwcjskuUgXfm9+hJKaWIFx+Tf4r5BOaPe7bZktUWrVnJ
         SiCJSP8raZxbq6YnsVEpQVomn+w6GWYgFPjIRmbP9AVyPnzDKbAktDFgil/04EEXC4CZ
         XB2JqvzognO5z7uVM6Z2dtu33ZYcXCxVatHDhq5FP7PTJChyF6/36DVRfnwY+hfQACPG
         Dhpw==
X-Gm-Message-State: AO0yUKWFEAB8JgodsGjTPqG8nic3ol3g/KNLdFq2wJTdxGvzgNTsdyxA
        IIuoelmL+nr36tjP++X1WmgMR5g85BihYW/bbMw=
X-Google-Smtp-Source: AK7set+MJkoGKxQePTCKdXB2FoV2zsPtsTEyn2qp0w/jyI1frR8HQRwLH0Wl+vDAcweSTFzCmgnjz4WLhYSvR7RlX8E=
X-Received: by 2002:a17:90b:1f8f:b0:233:3c5a:b41b with SMTP id
 so15-20020a17090b1f8f00b002333c5ab41bmr1384023pjb.133.1676628344552; Fri, 17
 Feb 2023 02:05:44 -0800 (PST)
MIME-Version: 1.0
References: <20230215050911.1433132-1-pcc@google.com>
In-Reply-To: <20230215050911.1433132-1-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Fri, 17 Feb 2023 11:05:33 +0100
Message-ID: <CA+fCnZdvDY_15bL4zZ442snuq20K+HeAb+OFxGA7t--3e9Y0UQ@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: Reset KASAN tag in copy_highpage with HW tags only
To:     Peter Collingbourne <pcc@google.com>
Cc:     catalin.marinas@arm.com,
        =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= 
        <Qun-wei.Lin@mediatek.com>,
        =?UTF-8?B?R3Vhbmd5ZSBZYW5nICjmnajlhYnkuJop?= 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        =?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?= 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        =?UTF-8?B?S3Vhbi1ZaW5nIExlZSAo5p2O5Yag56mOKQ==?= 
        <Kuan-Ying.Lee@mediatek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 6:09 AM Peter Collingbourne <pcc@google.com> wrote:
>
> During page migration, the copy_highpage function is used to copy the
> page data to the target page. If the source page is a userspace page
> with MTE tags, the KASAN tag of the target page must have the match-all
> tag in order to avoid tag check faults during subsequent accesses to the
> page by the kernel. However, the target page may have been allocated in
> a number of ways, some of which will use the KASAN allocator and will
> therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
> update the target page's KASAN tag to match the source page.
>
> We ended up unintentionally fixing this issue as a result of a bad
> merge conflict resolution between commit e059853d14ca ("arm64: mte:
> Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64=
:
> kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
> preserved a tag reset for PG_mte_tagged pages which was considered to be
> unnecessary at the time. Because SW tags KASAN uses separate tag storage,
> update the code to only reset the tags when HW tags KASAN is enabled.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd85=
706505830f52e0c
> Reported-by: "Kuan-Ying Lee (=E6=9D=8E=E5=86=A0=E7=A9=8E)" <Kuan-Ying.Lee=
@mediatek.com>
> Cc: <stable@vger.kernel.org> # 6.1
> Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page ta=
g in page->flags"")
> ---
> v2:
> - added Fixes tag
>
> For the stable branch, e059853d14ca needs to be cherry-picked and the fol=
lowing
> merge conflict resolution is needed:
>
> -               page_kasan_tag_reset(to);
> +               if (kasan_hw_tags_enabled())
> +                       page_kasan_tag_reset(to);
>  -              /* It's a new page, shouldn't have been tagged yet */
>  -              WARN_ON_ONCE(!try_page_mte_tagging(to));
>
>  arch/arm64/mm/copypage.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index 8dd5a8fe64b4..4aadcfb01754 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -22,7 +22,8 @@ void copy_highpage(struct page *to, struct page *from)
>         copy_page(kto, kfrom);
>
>         if (system_supports_mte() && page_mte_tagged(from)) {
> -               page_kasan_tag_reset(to);
> +               if (kasan_hw_tags_enabled())
> +                       page_kasan_tag_reset(to);
>                 /* It's a new page, shouldn't have been tagged yet */
>                 WARN_ON_ONCE(!try_page_mte_tagging(to));
>                 mte_copy_page_tags(kto, kfrom);
> --
> 2.39.1.581.gbfd45094c4-goog
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thank you, Peter!
