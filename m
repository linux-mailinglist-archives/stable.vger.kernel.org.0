Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FFD55A851
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 11:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbiFYIuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 04:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiFYIuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 04:50:10 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5550E419A4
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 01:50:09 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id q132so8301944ybg.10
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 01:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lv+FkxyjS/NQutVt+wfhAcydFycem3hgLi5V9K9eRHk=;
        b=GGomJks9se9aRiZPrnkaj+MkjtDXB1AjbcDjtd3FmKDbYRq4vLEPEOhYeF5hQEnjgh
         gA8G8WYzomc85KEh/80ZbS7xExwFawZI7RKx86EBTuGP4dfRxZGX55DPn6ddeZK01JjK
         N4FFpMLT9gYc9+D1Q5KPkgLzWIReIzC5Qbk1AKzvaozPtSn/CSX5v1gkp0dsyDh5QTEd
         BXkfqoh9+ehFJbtK9qB3lELaUT7wo38zRYzEoNWNgEsYNJHyxf40uUPa7ej4nWExmxa0
         /cZ2DXgUtW/HfuBs84ZXI3cagF2y95zgzu+rjIEJp0pCsoO4LByk6BdZ9yP6zbjYuHJd
         nqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lv+FkxyjS/NQutVt+wfhAcydFycem3hgLi5V9K9eRHk=;
        b=SZQgpMQ5ltQEMRHClPn2PdMACgDT7irvvK3jzYjKVYbZT+gf1qdTbdzKE6hG4zDORN
         ZDpzWeRO7xxIJ3wXVdOO641Y8gCd8Zlal+lxayMxhM1wAQE0HJ6qR94JNecGevTAn/jc
         ZhFSNTFHD0T1jx2H/W8kdwaWxCTOX/UWKSYQiHpTBhsGk5AFmjBu34ixJaGLNOr72AIq
         e53KrVKUZ7LzPDJlXVY2uv+R1a3Mrgk14uynbJfCJLqD+aonxjpNlyzWlhMXW7bKXFjV
         GgeUGMRor6z7jpSNgnaUa31C07ED+lE+CROkm+hXEl/Hb+TkgrOx/DMAhY0F6+6bnKYo
         82SQ==
X-Gm-Message-State: AJIora8pSZ1J5ZgchrzfF7Hn6sx0B3GixiVqlxJFKA1Jw8dvSBfxp1v2
        MqzMnNPi1M+ApDYFt3or0gmAvSuuBFk9zKZ7NDZeIRhTyPt92Q==
X-Google-Smtp-Source: AGRyM1t8TNJw3d/FU1nQTEhu7gjwWTgPUcz4RF4GIPzinVn8gHVuDfr/lmPi+A18Q8e4Qqw7s9zc1LBos/hD2hoGkeU=
X-Received: by 2002:a25:3288:0:b0:66c:8a91:74bb with SMTP id
 y130-20020a253288000000b0066c8a9174bbmr2096560yby.89.1656147008595; Sat, 25
 Jun 2022 01:50:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220625080423.2797-1-chenfeiyang@loongson.cn>
In-Reply-To: <20220625080423.2797-1-chenfeiyang@loongson.cn>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Sat, 25 Jun 2022 16:49:32 +0800
Message-ID: <CAMZfGtWT7oPq6bD_fRn2gVNX8Lj3=ev21EAoaCCPeq-P_NYF0g@mail.gmail.com>
Subject: Re: [PATCH] page-flags.h: Fix a missing header include of static_keys.h
To:     Feiyang Chen <chris.chenfeiyang@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Feiyang Chen <chenfeiyang@loongson.cn>, chenhuacai@kernel.org,
        loongarch@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 25, 2022 at 4:04 PM Feiyang Chen
<chris.chenfeiyang@gmail.com> wrote:
>
> The page-flags.h header relies on static keys since commit
> a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled
> with a static_key"), so make sure to include the header to avoid
> compilation errors.
>
> Fixes: a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
> Cc: stable@vger.kernel.org
> Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> ---
>  include/linux/page-flags.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index e66f7aa3191d..147b336c7a35 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -11,6 +11,7 @@
>  #include <linux/mmdebug.h>
>  #ifndef __GENERATING_BOUNDS_H
>  #include <linux/mm_types.h>
> +#include <linux/static_key.h>

I did not include this. The change makes sense to me. But I am
curious what configs cause the compiling error. Would you mind
sharing the config with us?

Thanks.

>  #include <generated/bounds.h>
>  #endif /* !__GENERATING_BOUNDS_H */
>
> --
> 2.27.0
>
