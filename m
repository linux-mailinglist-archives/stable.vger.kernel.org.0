Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365CE5AA87D
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 09:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiIBHES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 03:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIBHER (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 03:04:17 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C012FBC101;
        Fri,  2 Sep 2022 00:04:16 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id x5so508220uaf.0;
        Fri, 02 Sep 2022 00:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=D5mNJYlN1uS8OgKjt0YRjR63MZ/emfhtzN8JpVQFkdY=;
        b=TyoSedZlNm0kRQmcISzVC8xkaZYDUns1VRhaL5OtQa16w7buPs/aCoCXyFwF9mxtuK
         L1jbMOxlf/bU3NFrhZ/6+UVMWokdVo/MYS4gmJGpZh14aPkWhGNEYd4lUgI82v4NbB5Q
         N99v50L/2Zid65zgdPvHp9QsN+OUWyAQ+wiwQKBK+yrxLbb8j61iR6DzNZb2mf26QiRV
         /9bOhVdkvmRP7uJeIDqwWTslZsUyUN98pHW4FHi8D3qZEsU1Px8BAYZ9uROyLG14UKfb
         tSogGmL2tYlI9CiLBqDJcJEXBxnC+fixEYEk1giMGMxqtTpP90vOt9Rf7hIUO5LEvC7D
         2sng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=D5mNJYlN1uS8OgKjt0YRjR63MZ/emfhtzN8JpVQFkdY=;
        b=qHutcoIU4EV52nn2pI4uK1lDrRpCUngI3nz8NXV0iFSwDmP3/3lvmB7WXd1N2067YC
         HcZURPfx6foZbbbdOz7Fmbpp7ZV4N3NggNRuDkB56PcergGq+Z1FtHsaohHhTQ4KxsPX
         ZGq+fry8cS60vGXK8hmlPQN0McY9dbQ9XSFJEwLoelUTFaBRnJ/jdrBkakr6mNMeTyNn
         /3Hzi7akxAtKv3m7p+KTjYmiQMw+XXK1DzD5+6r9gTnR5cu03FR2WYCz6F4AaPZ1Nj8i
         zSU0yF+igeeoHfGcB6/kRQFPa2DR+Zhobd9C1BiWkxKcnXhTjVr4ToLHbx1f02zJLhB8
         1Ohw==
X-Gm-Message-State: ACgBeo0zEgloaVuShYcooD2Fizci+Zno43wcggaKxpLCHAjp/u30a+jv
        PoqaNJpZqGMw2k4nvcS53okoYA19EwWfbgrXHZY=
X-Google-Smtp-Source: AA6agR7wlzsvRio8NikTh1qfXvXSSvbH4+yU6cAsVJmWRLwsa2E+u+QpgUCDsB22SSwvuFn7kilLOlNAqC/c5/aAgCk=
X-Received: by 2002:a9f:2067:0:b0:387:984d:4a8e with SMTP id
 94-20020a9f2067000000b00387984d4a8emr10527013uam.60.1662102255887; Fri, 02
 Sep 2022 00:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220901133356.2473299-1-amir73il@gmail.com> <20220901133356.2473299-2-amir73il@gmail.com>
 <YxGfxaCrKW9NUxYZ@kroah.com>
In-Reply-To: <YxGfxaCrKW9NUxYZ@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 2 Sep 2022 10:04:04 +0300
Message-ID: <CAOQ4uxgL82GpXdGhKH7YxwCT6wm-5HobQpeuAYARUFzPRvXu9Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 v3 1/5] xfs: remove infinite loop when reserving free
 block pool
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 2, 2022 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 01, 2022 at 04:33:52PM +0300, Amir Goldstein wrote:
> > commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc upstream.
> >
> > [Added wrapper xfs_fdblocks_unavailable() for 5.10.y backport]
>
> You forgot the correct Author/From: information here :(
>
> Please be more careful next time.
>

Sorry.
I noticed that happens from time to time and sometimes
I catch that.
I wonder why/when git has done that. during cherry-pick? rebase?
I certainly did not do --reset-author at any point.

I might have added an original commit adding the Accessor
and then squashed it in rebase. That may be the reason.

I'll remember to add the From: check to my pre-post eyeballing.

Thanks,
Amir.
