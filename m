Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C8B2453A6
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgHOWEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbgHOVvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:51:04 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A21C061349
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 17:53:41 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id bo3so11680701ejb.11
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 17:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cE/B8jLj1zvXZ+mvl87f60vua1FqTOB1sidvPP/WOgw=;
        b=opWbEJLAX5qZbFpaKKZsvc/e8RNL/4tGU/5+gViPNL//IDiQoQtBlTLSzzmrl1XfSN
         7gIxERT+8ExdXmKG1LZPDzPWMkzQTReXKx0ITYiliKFUjkIt6i85mEChVWopekn4wAGj
         gfiBKSUqnKRTjekrpQOpCDJwSnJi5XmbQtbdar7ObT4lW8YvuI/aTPsZkMlLbGps1t2p
         bO2tf5mNlVMAsRothforYyk+YoS5Z+5q/+DAG+Dh+tT6ki+L/aTkg+EW8W9a1CJKuB4A
         g8ceSac41Bcdsa2UCT/3ODU+9pbD/lXNdVzCH3EyG+f9Sd7/CsWbnqwKtbPqC1BPyPJ+
         xgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cE/B8jLj1zvXZ+mvl87f60vua1FqTOB1sidvPP/WOgw=;
        b=d9Z+tlHPLsBFG2EeNTQSyPXzVR6ihpLNiUWbDZFhkZGkWLt8/QXGqk4jW+Sn6n8hCJ
         Yho52QuVKHuEOQgCOzJUDc44/VUfMsEOyCGl+Zd16hKgsVWP8SHF4WUY+jT/LBFRbT9E
         JMQp0A6Y8yOqbr2C08pwXIf27zUiyhsILSQIgOCgAJGG9bez/JcpPNdioO1K+i2cVBda
         Zoh0X67hts8+6pyylWwLBXgANU+zCt40rqUZfmlkxJIczUY1OEQeM6m3xEM8GAfFjuit
         zF0cvuS5JvaEpis1q0x5/IWYPWnqtPmergRbxA19ml/fdE88t06Rc7pRtQBiJsrQ56G9
         KB4A==
X-Gm-Message-State: AOAM532zIYRG2z02XLw2bj+qIvf76pbGbDuyjWUHuioj+lRVMjg4ploW
        iFHenZ/bBKgok4X8b2CdupNHufLTH66qFqGulyIodg==
X-Google-Smtp-Source: ABdhPJzVdWTzcJE2teGLvr5U2+nBzfXqIXCSwMxtlViqGl33Ab6EWKq2Qh8BYAtrIE7u/XqSAtchMB3OFImFW3GdQCQ=
X-Received: by 2002:a17:906:2356:: with SMTP id m22mr4835600eja.124.1597452819358;
 Fri, 14 Aug 2020 17:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200815002417.1512973-1-ndesaulniers@google.com>
In-Reply-To: <20200815002417.1512973-1-ndesaulniers@google.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Fri, 14 Aug 2020 17:53:28 -0700
Message-ID: <CABCJKue4ikLs9NuxkhwxZUMZzgD10mVXnwt4=_8euXer8gzOQQ@mail.gmail.com>
Subject: Re: [PATCH] lib/string.c: implement stpcpy
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Joe Perches <joe@perches.com>, Tony Luck <tony.luck@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nick,

On Fri, Aug 14, 2020 at 5:24 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings.
>
> `stpcpy` is just like `strcpy` except:
> 1. it returns the pointer to the new tail of `dest`. This allows you to
>    chain multiple calls to `stpcpy` in one statement.
> 2. it requires the parameters not to overlap.  Calling `sprintf` with
>    overlapping arguments was clarified in ISO C99 and POSIX.1-2001 to be
>    undefined behavior.
>
> `stpcpy` was first standardized in POSIX.1-2008.
>
> Implement this so that we don't observe linkage failures due to missing
> symbol definitions for `stpcpy`.
>
> Similar to last year's fire drill with:
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
>
> This optimization was introduced into clang-12.
>
> Cc: stable@vger.kernel.org
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
> Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
> Link: https://reviews.llvm.org/D85963
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/linux/string.h |  3 +++
>  lib/string.c           | 23 +++++++++++++++++++++++
>  2 files changed, 26 insertions(+)

Thank you for the patch! I can confirm that this fixes the build for
me with ToT Clang.

Tested-by: Sami Tolvanen <samitolvanen@google.com>

Sami
