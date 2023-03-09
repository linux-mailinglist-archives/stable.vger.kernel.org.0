Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414606B2FB3
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 22:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCIVgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 16:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCIVgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 16:36:31 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F30F6939
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 13:36:14 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-536c02eea4dso60593157b3.4
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 13:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678397773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFnIpAyFi7KEE0nQFD6hvfwa5ttoKe86kwhnOw55/ZU=;
        b=VnZTCI1OG2ybp+DVQPhYDlJZxoHrTSn1SGD+EKOSP+tiVtsriqGK3Wu6ruHYY1pY/q
         34eKL/jlCcUpMBncmj5tu3hzBHiIWsAnMVmMrQJfq6J04pISSiUxcu+jVVcO5U/uR7mk
         n3MKJ9JiXwHUXxPRGCbXYcEJt2U2D8NpoJ/KlsfSDuKSsj4naDLtvrFhicMEeb+0eiZl
         EDL8JJFGYt8jYxadX+tMn+Nidyew06w65UP5VLTThiEbV037I0/6ZFx8/NnePvpQRBBh
         eGJt+oNEi88TM1zrDt5T/STfcj9LlZqHxCWpSriEXOWH5vCPUBOS1zvek1N7aGEvjlI3
         7vpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678397773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFnIpAyFi7KEE0nQFD6hvfwa5ttoKe86kwhnOw55/ZU=;
        b=oW6WiiAy8PK3FjkgTVEXp0ToLJsDLnmV4R+wXJFWhoHA6IRPPfJ2XUUhnJ+aWR2brq
         XKWJAuXbvsYlTRo8WiPRdxmCl5+gdQLV8B2KPvQRTsg8tCnfj69c3TsZ4eCs3mVZ9tiI
         r5CnL+btHDPBjuaO6Sw9YiaWd8OGk/hjE8yVaXpYqnUkNzxFXiv2hAt0hA/8KxlSTpo7
         Hclrcj2wRo9b4ERnRsgEA367AsBdg0X/eeFlaCgcy5h25xmbUclwfyIY5XXAZ5MjcGF8
         WL8cGKC3m/qsJZPEIA7zWirRN6e8AI3Lfho5YWeYQJbPI1Cc1NO53Wx73mRhOLTuWaSH
         kp5A==
X-Gm-Message-State: AO0yUKV9W/Z3b/Mqd3eRZmGORC+KVAQieYQCmeiDNY7e6pQQrmx3l1pM
        kyVDhVMHu3SazDD5gkeZeIt/AesGdYuAzAQYcJXd/A==
X-Google-Smtp-Source: AK7set81cPx++J8MDz2wFdv3aePYvK3Oo6i+9UbDfeOXLVptbDo7DEqL78MNnpcuOPV+QL+R/7pmNH+t2iq/nwNa3I0=
X-Received: by 2002:a81:af46:0:b0:53c:70c5:45d9 with SMTP id
 x6-20020a81af46000000b0053c70c545d9mr14455374ywj.2.1678397773576; Thu, 09 Mar
 2023 13:36:13 -0800 (PST)
MIME-Version: 1.0
References: <20230301003545.282859-1-pcc@google.com> <20230301003545.282859-2-pcc@google.com>
 <20230308174608.e66ed98c97ea29934d99c596@linux-foundation.org>
In-Reply-To: <20230308174608.e66ed98c97ea29934d99c596@linux-foundation.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 9 Mar 2023 13:36:02 -0800
Message-ID: <CAMn1gO4jne3JyXgP9fufDYVoF4-xfL7H_38syJDaUBYCzmRETw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     catalin.marinas@arm.com, andreyknvl@gmail.com, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, eugenis@google.com, stable@vger.kernel.org
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

On Wed, Mar 8, 2023 at 5:46=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Tue, 28 Feb 2023 16:35:44 -0800 Peter Collingbourne <pcc@google.com> w=
rote:
>
> > This reverts commit 487a32ec24be819e747af8c2ab0d5c515508086a.
> >
> > The should_skip_kasan_poison() function reads the PG_skip_kasan_poison
> > flag from page->flags. However, this line of code in free_pages_prepare=
():
> >
> > page->flags &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> >
> > clears most of page->flags, including PG_skip_kasan_poison, before call=
ing
> > should_skip_kasan_poison(), which meant that it would never return true
> > as a result of the page flag being set. Therefore, fix the code to call
> > should_skip_kasan_poison() before clearing the flags, as we were doing
> > before the reverted patch.
>
> What are the user visible effects of this change?
>
> > Cc: <stable@vger.kernel.org> # 6.1
>
> Especially if it's cc:stable.

This fixes a measurable performance regression introduced in the
reverted commit, where munmap() takes longer than intended if HW tags
KASAN is supported and enabled at runtime. Without this patch, we see
a single-digit percentage performance regression in a particular
mmap()-heavy benchmark when enabling HW tags KASAN, and with the
patch, there is no statistically significant performance impact when
enabling HW tags KASAN.

That can be added as a paragraph to the end of my commit message, or I
can send a v4 if you prefer.

Peter
