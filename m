Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E6A54B9DD
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbiFNS7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358807AbiFNS7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:59:05 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF1F58E73
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 11:51:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x62so12914709ede.10
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 11:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MxzAGP0pIIN3YqlB0eCdWurjplEWqWQLhiwTRIU/o6M=;
        b=KQBXCmESvCN88CHPwxmcQJ5LvMrkM0MhhtAfAtIZ6Twv4RRxP1rOM/0FeZOxuBL/+j
         qL5KOBg0aTONuLHCwI6lIgPp7C4cADiugGhsgPfz2QAlssDmLVrMAHEO++IvAEZcP/F8
         U/BrtfJnGp5FKckPm8pCQFgb9kp0WGr5O7H40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MxzAGP0pIIN3YqlB0eCdWurjplEWqWQLhiwTRIU/o6M=;
        b=GgrnO2hQ9s0MvG8pTHmdVFGDq4KHNGvKEBRr95pZceyL6fp3W8XeClsN8492tZPMYW
         KHONzV2YR5RrhNBYClLHoP3Up6qjYShNMn0sSUlHYY2WYnr5UvDQrkzJvkWVE02Xhafb
         RIOk6ioWCZ/f/GSEjNyyn+0BaQhrCm6aD4lxshZMpRqZ0tfuquXOkx2AhJP1bAs9a2Hy
         ARtRRrxTLiOOa2UggIfbCOlN468tzwnZu4sUuWCJuyNPOVS94udmV6yYb9Rzi5faqPb/
         MrNcNQy73qQG2eGs9TqkTbHsqrEA5ZDAhYhK3H2h9OPpp10r0GfBBBD1iOKFG+9JZRpo
         Vo/w==
X-Gm-Message-State: AOAM5310T2BWLpdeR6ilLj+xsaO17Dl8hdgwrFBOpTD+uKNu4F5UjVLk
        LGaeX98W9HedPYSL7DsACkgxQPfsUH62t4N2
X-Google-Smtp-Source: ABdhPJyksXwY+9svAzeo1y6G1xbPRdudBUB2NoZAssK9YgjidwY3YDROVAbk42ppOs3FW1F4qOsG5w==
X-Received: by 2002:a05:6402:cab:b0:42d:c842:8369 with SMTP id cn11-20020a0564020cab00b0042dc8428369mr7811616edb.181.1655232713441;
        Tue, 14 Jun 2022 11:51:53 -0700 (PDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7d38f000000b0042dd1584e74sm7409736edq.90.2022.06.14.11.51.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 11:51:52 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id a15so12458573wrh.2
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 11:51:51 -0700 (PDT)
X-Received: by 2002:a05:6000:16c4:b0:20f:cd5d:4797 with SMTP id
 h4-20020a05600016c400b0020fcd5d4797mr6136973wrf.193.1655232711617; Tue, 14
 Jun 2022 11:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
In-Reply-To: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Jun 2022 11:51:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
Message-ID: <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
To:     Thomas Backlund <tmb@tmb.nu>, Jan Kara <jack@suse.cz>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 11:20 AM Thomas Backlund <tmb@tmb.nu> wrote:
>
> I "think" this is the suggested fix:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git/commit/?h=for_next&id=46b6418e26c7c26f98ff9c2c2310bce5ae2aa4dd

Ugh, this is just too ugly for words.

That's not a fix. That's a "hide the problem" patch.

Now, admittedly clearly the "hide the problem" code already existed,
and was just moved earlier, but I really think this whole "we're
calling __mark_inode_dirty() on an inode that isn't even *initialized*
yet" is a much deeper issue, and shouldn't have some hacky work-around
in __mark_inode_dirty() that just happens to make it work.

I don't mind that patch per se - moving the code is fine.

But I *do* mind the patch when the reason is to hide that wrong
ordering of operations.

Now, maybe a proper fix might be to say that new_inode_pseudo() should
always initialize i_state to I_DIRTY_ALL or something like that. The
comment already says that they cannot participate in writeback, so
maybe they should be disabled that way (ie a pseudo inode is always
dirty and marking it dirty does nothing).

And then you get rid of the noop_backing_dev_info entirely.

Or just make sure that noop_backing_dev_info is fully initialized
before it's used.

Because I think the real problem here is that things have a pointer to
an uninitialized backing_dev_info.

Hmm? Jan?

                   Linus
