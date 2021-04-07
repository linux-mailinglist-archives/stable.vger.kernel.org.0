Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784923576CC
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 23:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhDGV2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 17:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbhDGV2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 17:28:44 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE46C061761
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 14:28:34 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id d12so371878lfv.11
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 14:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XWjUyKOaiYaHrSNGRAQMkzTl2/6YP/Jxn5feXfPwJPw=;
        b=tGiprS0/uJqpTbO30TJ0/ozd1LkH6KmtujjdAQUy46IQqWHCA+K9jJ49/vtQK9xk6u
         vGCaxYm3MoIn+oDobegiMeH5CB/hqskfLAp8nQ7C17k4KWv7LpeRAOC5oOf175SEecYC
         77SzaNqu9ig81iYfZUrSiEY6vFIrTY3t7zrXpxcG8k8SwyWfyYAk3KTvV9rcmYXI6raW
         majb+BZW0GXU0zq1dtMd4gHpPKNtEWEyMmtNJGwXkbMPMhDzl6u2jioESWOJOobEsgXU
         JijAIUg2KBFyJvUKpb0rd9ZHBeZIkT4Efk4Q57bGyByyH+3pz6Glh2pyJzopeV0XqfPJ
         rDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XWjUyKOaiYaHrSNGRAQMkzTl2/6YP/Jxn5feXfPwJPw=;
        b=qDDp8LwP9GL9s1vmDnnu6m7huytUyZ/nHjRDKq1FGzOdyMt/BMIJ64xO5Wvz1jHnqH
         nAhbo5rCvIVk9cqs+k8JrAa/JHwTai+nXlwWtukUknWjfbtvnfdSyVI7jO1Q4VkMZx+w
         O0XIzcmOrfa2kuCrQ6uPVJMf6HkGxbzHkl1C8P6xghMcjajhIqGA3/uxF9QknXba9Mua
         oAmmq2i5JtDVz0RDm01bauPD4HxorpPIIGRQ64sZ4lImkoBs72A+aY6ZlPFR+6ULc0Ms
         y8k2VW2ivb2yY5K82NETGGP4jEyZyMfPt4H7TTf+IBBWqLR87JqEqLLrZuFofZRnaVO5
         +JWA==
X-Gm-Message-State: AOAM532w2SOo7/Df1kyVo1YuNx+G0RGk3vk2+Iu1vBC62t3xSjDA8G6r
        od5oHkVnZT2aTGDXYWZkPM4sB5gMpJ0XTrY5UIHgpA==
X-Google-Smtp-Source: ABdhPJzCUyjDCWCmMBQXNZk2FyD0UTwuI5OnSxCg2fPf4EgssQww/AdlL/SgELOZfVFRjhKLhGGkjQnH92LgDVMQCoM=
X-Received: by 2002:a19:430e:: with SMTP id q14mr3981418lfa.374.1617830912545;
 Wed, 07 Apr 2021 14:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210407185456.41943-1-ndesaulniers@google.com>
 <20210407185456.41943-2-ndesaulniers@google.com> <20210407142121.677e971e9e5dc85643441811@linux-foundation.org>
In-Reply-To: <20210407142121.677e971e9e5dc85643441811@linux-foundation.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 7 Apr 2021 14:28:21 -0700
Message-ID: <CAKwvOdnSRsUj9dvKP_1Dd9+WwLJwaK0mC-T9mL+jsQvRfwLZmg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gcov: re-fix clang-11+ support
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 7, 2021 at 2:21 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed,  7 Apr 2021 11:54:55 -0700 Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> > LLVM changed the expected function signature for
> > llvm_gcda_emit_function() in the clang-11 release.  Users of clang-11 or
> > newer may have noticed their kernels producing invalid coverage
> > information:
> >
> > $ llvm-cov gcov -a -c -u -f -b <input>.gcda -- gcno=<input>.gcno
> > 1 <func>: checksum mismatch, \
> >   (<lineno chksum A>, <cfg chksum B>) != (<lineno chksum A>, <cfg chksum C>)
> > 2 Invalid .gcda File!
> > ...
> >
> > Fix up the function signatures so calling this function interprets its
> > parameters correctly and computes the correct cfg checksum. In
> > particular, in clang-11, the additional checksum is no longer optional.
>
> Which tree is this against?  I'm seeing quite a lot of rejects against
> Linus's current.

Today's linux-next; the only recent changes to this single source file
since my last patches were:

commit b3c4e66c908b ("gcov: combine common code")
commit 17d0508a080d ("gcov: use kvmalloc()")

both have your sign off, so I assume those are in your tree?

-- 
Thanks,
~Nick Desaulniers
