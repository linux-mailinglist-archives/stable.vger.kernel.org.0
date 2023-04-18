Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27796E5BC5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 10:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDRINS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 04:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjDRINQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 04:13:16 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF6365B5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 01:13:15 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4ec8133c59eso1939588e87.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 01:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681805593; x=1684397593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fuQkHKWI/lgpNcFt6ZdMNne2pX3w0YtDWS0YTqJBCI=;
        b=bKYT1lQF+ceywACbQRsaGEYOk9yAX3tfN/xOqXX9bhvZZf6j6UTjmGixXbFHfp4+YE
         zdw4u3y0ZPeZCUBFWtiwbwtX7p8OTfU3e1abCNbqqoa+GS8vK9GT6INbvWfqdfHipeNn
         YSi24AcgUJfX86Cu9UFpPw+PyjT/J/ZYJ1Fh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681805593; x=1684397593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fuQkHKWI/lgpNcFt6ZdMNne2pX3w0YtDWS0YTqJBCI=;
        b=kjK5Iq7TugPYPgOiaHH14h840++JFLK4q/86YLErosOWYKRb5qvLdCAWhn8/TEp0/K
         4qclSzq1+s10ALU8nZ2lb7fG8thNslweKrFHV3nb991XpK3FgDsJRwIQeY5ucE4dUeNq
         83a+hvv7/9k0F0gv8yfzITq7KKDxeleOJVXT2zgsYC705WUmE5ixFfYQiRkusca5EOlQ
         RHPmB0bSYraqh8DKPQhLho+lxzzsnrOfHqA4BEPEgH/DnpkE9LalCAOlrf6InBYQsEYs
         ebh8GHseE3B9nhGbZP1uoVPty1v3ScG6GDAEeiVA958gLu43WdmQbCZ8KkgtW4pu+RgW
         mp9Q==
X-Gm-Message-State: AAQBX9fAqzo/r0yp9vpZ5Wn5NiSMPyF0wEkaelSFxTR+lAlovMn+kUHt
        05AJe3noyw7FSI3RxwOSoGZ6yM6JFB+1Wb729PZcsADRXNbH712DI+8=
X-Google-Smtp-Source: AKy350b6SrZ1TIvMFfizitLoXeV1f9MlUcZAN/8+gQQrtYTkDshwXQBWP3COlcIoKs6VFaiig0JHBR7o/686hWK9VRY=
X-Received: by 2002:a19:f60d:0:b0:4ec:8ca6:65ad with SMTP id
 x13-20020a19f60d000000b004ec8ca665admr2961873lfe.11.1681805593322; Tue, 18
 Apr 2023 01:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230418061933.3282785-1-stevensd@google.com>
In-Reply-To: <20230418061933.3282785-1-stevensd@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Tue, 18 Apr 2023 17:13:02 +0900
Message-ID: <CAD=HUj5fhD3kcav5mbJ8Zegin-Bpb1cYChNzTUDLzUE5kbv9Ew@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem: Fix race in shmem_undo_range w/THP
To:     linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 3:22=E2=80=AFPM David Stevens <stevensd@chromium.or=
g> wrote:
>
> From: David Stevens <stevensd@chromium.org>
>
> Split folios during the second loop of shmem_undo_range. It's not
> sufficient to only split folios when dealing with partial pages, since
> it's possible for a THP to be faulted in after that point. Calling
> truncate_inode_folio in that situation can result in throwing away data
> outside of the range being targeted.
>
> Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large f=
olios")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  mm/shmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 9218c955f482..317cbeb0fb6b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1033,7 +1033,7 @@ static void shmem_undo_range(struct inode *inode, l=
off_t lstart, loff_t lend,
>                                 }
>                                 VM_BUG_ON_FOLIO(folio_test_writeback(foli=
o),
>                                                 folio);
> -                               truncate_inode_folio(mapping, folio);
> +                               truncate_inode_partial_folio(folio, lstar=
t, lend);

It was pointed out to me that truncate_inode_partial_folio only
sometimes frees the target pages. So this patch does fix the data
loss, but it ends up making partial hole punches on a THP not actually
free memory. I'll send out a v2 that properly calls
truncate_inode_folio after splitting a THP.

-David

>                         }
>                         folio_unlock(folio);
>                 }
> --
> 2.40.0.634.g4ca3ef3211-goog
>
