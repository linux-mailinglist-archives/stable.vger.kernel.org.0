Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738091EE053
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 10:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgFDI5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 04:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbgFDI5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 04:57:36 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B980C03E96D
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 01:57:36 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g1so4043024edv.6
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 01:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=izvjeZntfmRt5pu1JX50kgxBnowsGSvfpbiC2Aiju08=;
        b=dZ+Mq7idopXp+hDzE7zFqBFyLUZ7EP9eaafDXK/AYtHuglQGqKnKfZcqf3skLKeuWi
         bt6Os/FC8ApoAMPYzZDQzJlNagYdue5brTxhUzcd8Co1CnwYoQm+m4WABrgSpcPnWIy8
         rHUdAg/mRcyHTGimvmyNjETWivcSuEfruD6iM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=izvjeZntfmRt5pu1JX50kgxBnowsGSvfpbiC2Aiju08=;
        b=OxJxacHAmlfUF6L/NbtafqD/zMn2iP2PYOES7UkCnG/bRhi4rngtiIBMH4urIr3m28
         zZ7us5nPWqrjCA6UmnHM27ToFknv70nS7kXiMS6xaCmFYoXo4K0nEnZ5JNtmYQWbDXm4
         dCSt3vEtX1kFZBzMDIUwyi3ngR0DGna9DDwqXdwS/+MtF08JksqlINFEaYNWWHUnxMY6
         eplB8y6ieZ8NgiStn6EAnMHMB/SY7rybR6a35pBRWQ1g16tYOBSTnK0z8RX7+Z/Ewi7l
         KgejZPTpDImU4k4I1GCCWSxItVpYpoXofO7LMYj+IaWH9xgLiLf8JwvnXCb8cRVTv4N6
         rZtA==
X-Gm-Message-State: AOAM532M1YxOSA2yC5aJoKbwvcrE7ukyuvE54g5dfFzOlIVs1VBWLeI0
        A1zp2NVM5E7XF8eIYBlZVqrLsMKUfNoOOAvK2jknew==
X-Google-Smtp-Source: ABdhPJySAb3O8tj5h0rTeAJ2JH2o5Myx7L0hVgX6ooQ3uBIE934EdnxSaB6pv3CUHsAuoMpiBU/GkWyLhWf1oQlohl8=
X-Received: by 2002:a05:6402:17f9:: with SMTP id t25mr3364060edy.134.1591261055268;
 Thu, 04 Jun 2020 01:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200604084245.161480-1-glider@google.com>
In-Reply-To: <20200604084245.161480-1-glider@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 4 Jun 2020 10:57:24 +0200
Message-ID: <CAJfpegv5W9BnCFGc2jWxCGS_RcqT0LFxw5ke2Z2XbCotokdUWw@mail.gmail.com>
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
To:     Alexander Potapenko <glider@google.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        royyang@google.com, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 4, 2020 at 10:43 AM <glider@google.com> wrote:
>
> Under certain circumstances (we found this out running Docker on a
> Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> return uninitialized value of |error| from ovl_copy_xattr().
> It is then returned by ovl_create() to lookup_open(), which casts it to
> an invalid dentry pointer, that can be further read or written by the
> lookup_open() callers.
>
> The uninitialized value is returned when all the xattr on the file
> are ovl_is_private_xattr(), which is actually a successful case,
> therefore we initialize |error| with 0.
>
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Roy Yang <royyang@google.com>
> Cc: <stable@vger.kernel.org> # 4.1
>
> ---
>
> The bug seem to date back to at least v4.1 where the annotation has been
> introduced (i.e. the compilers started noticing error could be used
> before being initialized). I hovever didn't try to prove that the
> problem is actually reproducible on such ancient kernels. We've seen it
> on a real machine running v4.4 as well.
>
> v2:
>  -- Per Vivek Goyal's suggestion, changed |error| to be 0

Thanks, applied patch posted here (with your signed-off as well, since
the patch is the same...):

https://lore.kernel.org/linux-unionfs/874ks212uj.fsf@m5Zedd9JOGzJrf0/

Miklos
