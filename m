Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AA569757F
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 05:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbjBOEo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 23:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjBOEoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 23:44:55 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A5623D85
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 20:44:49 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id v6so2155826ilc.10
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 20:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNl+bTrdiuBtPF/dZkoqbIPBqUd172UM9PQytiAg0FU=;
        b=D2G98lGOMTBRIJ1x4dBdUgWK3SxCQ6sbqqGxh2DD6N68ZaAWWSIt9/4mLjXsykZ6Ob
         Ii2D0xnzmp90+mjiQV+iNeRXVGivW94q58EhZhrLXYYECTm36G+oSQhPfmkesgRN9YFS
         0RKOiLDbSZYKz2uPpIsuUzPCrPOb96rmSG0bz4/37H1byEBDQ6EoY46cVwkDrRIvtgfe
         142s7zCy5eW2fILmcrSsiWxsHOKRx1kOibGKDhKXi8+MKpx2EKE1Si/vP3G/IYzwwsUR
         8Bm4imKesxjpouqksDJnhHn1y3R6HICkXHEhYOFkiJg1dz5/HIlOZBL281VnI2yA63he
         1leA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aNl+bTrdiuBtPF/dZkoqbIPBqUd172UM9PQytiAg0FU=;
        b=1Qx6XWBGS5EzeQYxOksLoo9lrhYL+Px0zmKa6liymnzYDTLxLFK3C7rrLRCQcfVStF
         zutAxNdBHQFpRDby4rIThEnnz7adbiuQxGaq40uPLlMbZPQ8WsfENzUnlqq2/717exI+
         Hr+/ljeP1BNZjUoBMlNnHmDDdfVcbv07aF5Ldk7PJ1s1+WpLzJPz4uhhxNi2989oVLrs
         edP4yM8C8O0Mdos4pSPozhvkVHNRk9V9SD4AvUDAyc20h7xAHTAPldtDARnz8O4MYD34
         C+R/WAJStLv08xt4itTBz8hnjdHHhmqkOIrQUqky/rVMEJj6BK6f+tB5bTOb6MSHo1ZM
         vqfw==
X-Gm-Message-State: AO0yUKVEcRvwENeTjbhD0V1/k4l/n9eFav+hEXKylvAbFkwMMxeQc6pV
        pHovhjWPmUE2kciW9mavkNsLNRqxdBLOtmwCSTJi7w==
X-Google-Smtp-Source: AK7set+p76YrnWaluJsyhx7p7Xy30z77TI6rE4c6cpC9xEItMkP2M5yNYdFMFp9zT1lFbOQP62+MsZyqfG85hQMkcTI=
X-Received: by 2002:a92:8e04:0:b0:310:9d77:6063 with SMTP id
 c4-20020a928e04000000b003109d776063mr318042ild.5.1676436288254; Tue, 14 Feb
 2023 20:44:48 -0800 (PST)
MIME-Version: 1.0
References: <20230214015214.747873-1-pcc@google.com> <Y+vKyZQVeofdcX4V@arm.com>
In-Reply-To: <Y+vKyZQVeofdcX4V@arm.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Tue, 14 Feb 2023 20:44:36 -0800
Message-ID: <CAMn1gO4mKL4od8_4+RH9T2C+6+-7=rsdLrSNpghsbMyoVExCjA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Reset KASAN tag in copy_highpage with HW tags only
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     andreyknvl@gmail.com,
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 9:54 AM Catalin Marinas <catalin.marinas@arm.com> w=
rote:
>
> On Mon, Feb 13, 2023 at 05:52:14PM -0800, Peter Collingbourne wrote:
> > During page migration, the copy_highpage function is used to copy the
> > page data to the target page. If the source page is a userspace page
> > with MTE tags, the KASAN tag of the target page must have the match-all
> > tag in order to avoid tag check faults during subsequent accesses to th=
e
> > page by the kernel. However, the target page may have been allocated in
> > a number of ways, some of which will use the KASAN allocator and will
> > therefore end up setting the KASAN tag to a non-match-all tag. Therefor=
e,
> > update the target page's KASAN tag to match the source page.
> >
> > We ended up unintentionally fixing this issue as a result of a bad
> > merge conflict resolution between commit e059853d14ca ("arm64: mte:
> > Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm=
64:
> > kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
> > preserved a tag reset for PG_mte_tagged pages which was considered to b=
e
> > unnecessary at the time. Because SW tags KASAN uses separate tag storag=
e,
> > update the code to only reset the tags when HW tags KASAN is enabled.
>
> Does KASAN_SW_TAGS work together with MTE?

Yes, it works fine. One of my usual kernel patch tests runs an
MTE-utilizing userspace program under a kernel with KASAN_SW_TAGS.

> In theory they should but I
> wonder whether we have other places calling page_kasan_tag_reset()
> without the kasan_hw_tags_enabled() check.

It's unclear to me whether any of the other references are
specifically related to KASAN_HW_TAGS or not. Because KASAN_SW_TAGS
also uses all-ones as a match-all tag, I wouldn't expect calling
page_kasan_tag_reset() to cause any problems aside from false
negatives.

> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd=
85706505830f52e0c
> > Reported-by: "Kuan-Ying Lee (=E6=9D=8E=E5=86=A0=E7=A9=8E)" <Kuan-Ying.L=
ee@mediatek.com>
> > Cc: <stable@vger.kernel.org> # 6.1
>
> What are we trying to fix? The removal of page_kasan_tag_reset() in
> copy_highpage()?

Yes.

> If yes, I think we should use:
>
> Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page ta=
g in page->flags"")
> Cc: <stable@vger.kernel.org> # 6.0.x

I agree with the Fixes tag, but are you sure that 6.0.y is still
supported as a stable kernel release? kernel.org only lists 6.1, and I
don't see any updates to Greg's linux-6.0.y branch since January 12.

I'm having some email trouble at the moment so I can't send a v2, so
please feel free to add the Fixes tag yourself.

Peter
