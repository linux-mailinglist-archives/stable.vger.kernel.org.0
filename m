Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7554FC376
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 19:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348913AbiDKRdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 13:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348972AbiDKRcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 13:32:23 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1243F2ED76
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 10:30:08 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e1so11958031ile.2
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 10:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wx78erCIL7oR7fuzQUCoSTa4jxpH/qON65mW2OiVq+c=;
        b=LPanMdQ5FPo2cPnX36yeIHEw4gCGnVmExm6OVTI5WFTvQshN4lGKZ5aKhJDkiAa0Zj
         wOii7DiFGFk2iv8cYIz7BdZJY6twaKl426mPUsr8zFY5GtMXVCs41LDbSdrFaZs8dKdn
         Jb3J+iaqiyPERuzYCu8fAtS/F2DUIag8H2UDdPcvCSc2AiNGJSIUk4czNg+pVJvI0XQB
         dslMuI2IckQmpy/XIYQkrRkcg+Ja4tZdfpCs26ciQFpL/QzM76FvHdt+TjQguNX6JtPI
         PNZzniafk84EwaNOE0Emy89fmlAvLb6KfI34WRKm8peF9BmQcEtzW9DbjFYZyj5I3MTi
         q3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wx78erCIL7oR7fuzQUCoSTa4jxpH/qON65mW2OiVq+c=;
        b=oKW0P3XM5baZzloMNf9abcO5a4SxNFPp0nJ24mkkh3Ei3TQx+ZiglV1+L1bjK8UQ4W
         jyb2X8RLViEUd9YFXH/se5xz5SijPmJXWWAQkkOEft6bR3+c6g8DYPKi/C92RT1beMli
         72ZQ4dgwzenUpAyQ52xj9cuhLD4BNLVWTgK9vBhrV6Un50+d65Vn8n9rOB9bhSF3qcwH
         dTG0D4RjAK9Bm38frYinGHx2o9aQg9mzqh0+AVoReA5jsmY8FJV7L5RpFI9kVnOnYRy+
         RfwCAwdvGQ94TzLoE+M8tB4NBKiP0gOB3h5OS+DaRkeylZc6MiLPoJl9CXSuICwowRJ0
         dirw==
X-Gm-Message-State: AOAM533VIxPOCFibgwQ1Qh71o5SajTz6hOR7wrwtTTyHTtnYo1jdePXa
        QW3anBAbaquJMUSNeD7f8m4+8HjE4ODKSQkTqkeYlw==
X-Google-Smtp-Source: ABdhPJzbLEEKY75FBQhIUb7lp8Fu0HXkOSUBQ/JrbGUsnUssoVrba+/xdKUk7Bry+5ZA368bu8sr4/jaXoR5GVpWa08=
X-Received: by 2002:a92:7d02:0:b0:2ca:4447:c1fb with SMTP id
 y2-20020a927d02000000b002ca4447c1fbmr13996595ilc.275.1649698207064; Mon, 11
 Apr 2022 10:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220324210909.1843814-1-axelrasmussen@google.com>
 <YjzjiDFBgigPqEO9@casper.infradead.org> <CAJHvVcj90ROLGWGZi_f5b4VCugD4o7v3quCv-6A6jPUdMbqi6A@mail.gmail.com>
 <CAJHvVchqPygpw9DGYuab+2ymFtF41E7RUyUUOiRHh1wicRgqCA@mail.gmail.com> <20220407135053.6652bdad545fe98fc9babfbc@linux-foundation.org>
In-Reply-To: <20220407135053.6652bdad545fe98fc9babfbc@linux-foundation.org>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Mon, 11 Apr 2022 10:29:31 -0700
Message-ID: <CAJHvVci6w6aUbXzz9fU=9NA10o30As4CZeyW0_GQH74j-ziH3Q@mail.gmail.com>
Subject: Re: [PATCH] mm/secretmem: fix panic when growing a memfd_secret
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Mike Rapoport <rppt@kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's a reasonable option.

Worth noting though that today when it says "larger than the maximum
file size", it refers to the global MAX_NON_LFS (2^31), not
necessarily growing in general. So, we're extending the meaning a bit.

But, I'm happy to send a v2 with EINVAL instead.


On Thu, Apr 7, 2022 at 1:50 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 31 Mar 2022 10:42:12 -0700 Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> > Any strong opinions on which error code is used? I think overall I
> > would still pick EOPNOTSUPP, but happy to change it if anyone feels
> > strongly.
> >
> > - I think ENOSYS is specific to syscall nr not defined
> > - I think ENOTTY is specific to ioctls
> > - The kernel (sort of mistakenly) defines ENOTSUPP instead of ENOTSUP,
> > but it's marked deprecated and it's recommended to use EOPNOTSUPP
> > instead (despite POSIX saying these should be distinct and for
> > different uses).
>
> `man ftruncate' sayeth
>
>        EINVAL The argument length is negative or larger than the maximum  file
>               size.
>
> which reasonably accurately describes what we're doing here?
>
> +       if ((ia_valid & ATTR_SIZE) && inode->i_size)
> +               return -EOPNOTSUPP;
>
>
