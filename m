Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFD54F5447
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377375AbiDFEpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584021AbiDEX5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 19:57:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A4C1FB525;
        Tue,  5 Apr 2022 15:10:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E59A61793;
        Tue,  5 Apr 2022 22:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4774BC385A1;
        Tue,  5 Apr 2022 22:10:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZxKwp451"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649196645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OOYm7XyUiyywa+ltOBORW4i/OyBtu6Tfp2IZLFrWre8=;
        b=ZxKwp451Ilh9HPCZJwq1SZiFBMZPAX92jMGZWyiZCln9HYHPJn6pRK4eNttF7GEewHR6oI
        FhbABoOpf8AMmYFXr2iUSDRZ3+dmLGAYtfDlaixUgAWiVEjS7KdCDCx4zLnMmM/os7wAXc
        svbUYkBFzkX3xkuzIBQe8SV3C5TutGE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 00dc344c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Apr 2022 22:10:44 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2eb888cf7e7so6683567b3.13;
        Tue, 05 Apr 2022 15:10:44 -0700 (PDT)
X-Gm-Message-State: AOAM532U3NuDM1zKiVSdHaAHdFQZUjDSA4pbzLXss9agVq3ueX8LANZh
        GAt5t7egxbIsQw56E264djBfKPbfaNlb3/ffWMw=
X-Google-Smtp-Source: ABdhPJwtFgaVts9HYTqyh7F5Fet5c+tDOHQtT9Rzu8KkvMz9vWKjzbefeOz+ZMEqjZ6GCgLyk0wLNd7L7BmWdbWY3mc=
X-Received: by 2002:a0d:e8c6:0:b0:2eb:1a8e:19c4 with SMTP id
 r189-20020a0de8c6000000b002eb1a8e19c4mr5145140ywe.404.1649196643486; Tue, 05
 Apr 2022 15:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220328111828.1554086-1-sashal@kernel.org> <20220328111828.1554086-16-sashal@kernel.org>
 <YkH5mhYokPB87FtE@google.com> <CAHmME9oTiJ5ZTtsecisOp7cLurm+r0gOtPSozgPvr+phDjiACQ@mail.gmail.com>
In-Reply-To: <CAHmME9oTiJ5ZTtsecisOp7cLurm+r0gOtPSozgPvr+phDjiACQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 6 Apr 2022 00:10:32 +0200
X-Gmail-Original-Message-ID: <CAHmME9rhwgUyhKG_JvcqAds4oZoYPwPGESo4PRq_oa=biO9RpQ@mail.gmail.com>
Message-ID: <CAHmME9rhwgUyhKG_JvcqAds4oZoYPwPGESo4PRq_oa=biO9RpQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

On Tue, Mar 29, 2022 at 7:31 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> I'm inclined to agree with Eric here that you might be a bit careful
> about autosel'ing 5.18, given how extensive the changes were. In
> theory they should all be properly sequenced so that nothing breaks,
> but I'd still be cautious. However, if you want, maybe we can work out
> some plan for backporting.

It's still way too early to backport these, but I'll maintain these
two branches for a little while:

https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/log/?h=stable/linux-5.15.y
https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/log/?h=stable/linux-5.17.y

So that when or if it does ever make sense to do that, it's been
maintained incrementally while the knowledge is fresh. I'm omitting
from those branches new feature development, such as vmgenid.

Jason
