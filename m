Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C65A5151BD
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 19:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbiD2R0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 13:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbiD2R0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 13:26:24 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC8B53710
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:23:05 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id t11so6239473qto.11
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H1BjCLAB4JlCx/4xRTOtPSo16Pw72DMxOKp15RmuoSg=;
        b=esuLwrF1US+Op8zYIuYSKJzFSzC/Smvuwj6VcsmWqgnAP/kdk3reg29dFoqzboHl8W
         HNA5A+LvQW6I6M88Ub/3vOu+5+nHS4WyEzg7CQlV/02DhSxKadfIwcVcIAksB9rDlHrW
         9V4usT0onacOJAYvbT1LTejhU10fPczPlJJWlB+WAyUTZ9J4iyAD6qaxRVSprV1hoM3W
         C/l35EHtpiugMNxBPwXWsqZOKODCGbGjNan6HjBYnOzSwr3UNYs+RAzZRxZM59Ubcfsz
         c3Z3qNV8ASZ37JsuYsgM+KjOy9NQlH+KWr+0JAivenIrrE7SlJuQ8ZL0pMkXSRaGRX1V
         ab1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H1BjCLAB4JlCx/4xRTOtPSo16Pw72DMxOKp15RmuoSg=;
        b=gzehvLtDO9cS3rhLszAqHXORi3/HuK7IgLKY5PWTD4ndUuAO8geZ3X3Im4s0KWOLIs
         je/KPGIVMDChPU1Xo/gAJHEbIQu4YXOPlcAcvPnuIWk8Op6m+HG05r8tJ/v6APLD99Uc
         vXg2RDwca5LQv1bbAtDs+4Rqw3jydxWled0gorCqIH8prNe8Y3dL6fx1+ama4nLd3sUH
         l1Z+ZvCRn2fMlgot1B7rtHEj3qCGBjv9LUQ64c1DWMXd6BmG/3qn/sjjkep/hbWc+5lB
         Hp9YeriFx0DlyfttPOC4mx65Op4mPOXM7QKWB8eyVf9Ea0dxc2QToxtCN8pilZIHAnim
         bUTA==
X-Gm-Message-State: AOAM530ELDvbOesCvS8gq4V4s7jOzlm70DJWGp4y7uejoWVVBUiHnDR0
        EETM7qdHbz9h4gl548S7SrWhaez6IMmhwZvFRw+c0w==
X-Google-Smtp-Source: ABdhPJysdgaouIVKJTM76g6ZF3g2vpTSZCBSTupqZhdpeYsekutawMKvYWlvRtGxgA6HFdS1GPGVcF7UHoVyt/EybVY=
X-Received: by 2002:ac8:5896:0:b0:2f3:88b4:f029 with SMTP id
 t22-20020ac85896000000b002f388b4f029mr383609qta.565.1651252984406; Fri, 29
 Apr 2022 10:23:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com> <Ymupcl2JshcWjmMD@kroah.com>
In-Reply-To: <Ymupcl2JshcWjmMD@kroah.com>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 29 Apr 2022 10:22:52 -0700
Message-ID: <CA+khW7jHKYVnv=R1k8560fLodpdy6rXcE3BWdhkbjXC99=q5dA@mail.gmail.com>
Subject: Re: [PATCH stable linux-5.15.y 00/10] Fix bpf mem read/write vulnerability.
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Apr 29, 2022 at 2:01 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 28, 2022 at 04:57:41PM -0700, Hao Luo wrote:
> > Hi Greg,
> >
> > Please cherry-pick this patch series into 5.15.y stable. It
> > includes a feature that fixes CVE-2022-0500 which allows a user with
> > cap_bpf privileges to get root privileges. The patch that fixes
> > the bug is
> >
> >  patch 7/10: bpf: Make per_cpu_ptr return rdonly
> >
> > The rest are the depedences required by the fix patch. Note that v5.10 and
> > below are not affected by this bug.
> >
> > This patchset has been merged in mainline v5.17 and backported to v5.16[1],
> > except patch 10/10 ("bpf: Fix crash due to out of bounds access into reg2btf_ids."),
> > which fixes an out-of-bound access in the main feature in this series and
> > hasn't been backported to v5.16 yet. If it's convenient, could you
> > apply patch 10/10 to 5.16? I can send a separate patch for v5.16, if you
> > prefer.
>
> 5.16 is long end-of-life, sorry, I can't add any more patches to that
> tree and no one should be using it anymore.
>
> I'll go queue these up now for 5.15, thanks for the backports!
>
> greg k-h

Thank you Greg! I double checked and found that patch 10/10 is already
in v5.16. So we're good.

Hao
