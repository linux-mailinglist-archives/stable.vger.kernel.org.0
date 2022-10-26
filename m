Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365EF60E77A
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 20:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiJZSdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 14:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiJZScv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 14:32:51 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76673BCA1
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 11:32:13 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id kt23so18232848ejc.7
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 11:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m0iuel/bwanr0F35kqo/iiFIUgLGxYmOV2Z3DDNfjKU=;
        b=kcWexajE0RetXYSRh7/phh7Xpm4jPXreN682urffe/jOF/DwXv5P809I50+u+LKrbK
         2zHcPeHW9a61KwRvHZyUiNX+/3u2y/RKdCbK1FggilmIBFBUtkB2z5GDg1DiD0ZaIilQ
         MM3Q7WO+XJmhfKy41QZulgGLyBiPVvYmu9WLFXMv1hLFbnbdbkwaY5r7y00SNq9nC9rd
         A/wALr6gFp8Ds75oduHkwjj6TUC2BQe0nO6XUsMY/RuxDjI+0NsUaty31tNQLULOYnt7
         NZC+TI6L77/Ngifx3fFem1V5ZjN04N7GMt/yCwFhHTuVnpQHMFi2oSwr1dgsnCJ2b7OZ
         wM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m0iuel/bwanr0F35kqo/iiFIUgLGxYmOV2Z3DDNfjKU=;
        b=pBhIhqjJwy+yAvbEOcphwDKZ1x8HbcHaBdITTs6uNQNX5CSP1GofLVSGNgPDjyr91I
         U/hrtg5gyzmYY3mwbn0YxKcALYpGzY1h0aMQALEn+a/YLy5+XCt9124FRFL9vQg5UWGo
         V+cVjMhIEwUwUCd3BCGw3FiaUG3LLgvykLnT7apqZ2lzHGGeF6M/prUZ9QWkj1srYwmX
         UR//gambgvAT2CNQp3Eew1RfNVI2clvnxjtDQSM75DbRVkGzYGrEZRhWLWsvniVKL3Zb
         nFtZ+7WjkOvljaowCuaPHxQuiHbvRSfW2eeLW7iBa7gXnbv2tWU4p6E6MiEx+fxAJvj+
         mFlQ==
X-Gm-Message-State: ACrzQf381xJ1pPChi0dyac9AGqXdBLlwGByedG+hlmQzpin9r+9P47H/
        e7arC7j9Q/4d3BRsncsnO1yti5gxTDly7HX8SsygwCL2YQTChg==
X-Google-Smtp-Source: AMsMyM7SAsGoH8Gf3FDbemeR5sFFvoWNx3EI5Xu6RQbn8jc9y/LeyrTF+i6Z+yuhwuJ1b04cQeAHWZIIOUWinJoMt5w=
X-Received: by 2002:a17:907:94c1:b0:792:56d7:2879 with SMTP id
 dn1-20020a17090794c100b0079256d72879mr34270575ejc.144.1666809131974; Wed, 26
 Oct 2022 11:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221026162438.711738-1-sethjenkins@google.com> <Y1ljQBkfcCoLYTx+@kroah.com>
In-Reply-To: <Y1ljQBkfcCoLYTx+@kroah.com>
From:   Seth Jenkins <sethjenkins@google.com>
Date:   Wed, 26 Oct 2022 14:32:00 -0400
Message-ID: <CALxfFW6a_Fe1rwbXf6LnG-1PvjtwLwGLHYYPr8c-Wda3NNJD8g@mail.gmail.com>
Subject: Re: [PATCH stable 4.19-5.19] mm: /proc/pid/smaps_rollup: fix no vma's null-deref
To:     Greg KH <gregkh@linuxfoundation.org>, willy@infradead.org,
        Liam.Howlett@oracle.com
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
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

Hi Greg,

The upstream commit that fixed the issue was not an intentional fix
AFAIK, but a refactor to switch to maple tree VMA lookups. I was under
the impression that there were no plans to backport maple trees back
to stable trees but do let me know if that presumption is incorrect.
Assuming they're not getting backported, what do you think of this
instead:
c4c84f06285e on upstream resolves this issue as part of the switch to
using maple trees for VMA lookups, but a fix must still be applied to
stable trees 4.19-5.19.

On Wed, Oct 26, 2022 at 12:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 26, 2022 at 12:24:38PM -0400, Seth Jenkins wrote:
> > Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
> > seq_file") introduced a null-deref if there are no vma's in the task in
> > show_smaps_rollup.
> >
> > Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
> > Signed-off-by: Seth Jenkins <sethjenkins@google.com>
> > Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> > Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > c4c84f06285e on upstream resolves this issue, but a fix must still be applied to stable trees 4.19-5.19.
>
> And you need to document really really really well why we can not take
> that upstream commit please.
>
> Also note that 5.19.y is end-of-life.
>
> Please fix up and resend.
>
> thanks,
>
> greg k-h
