Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439F76A225C
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 20:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBXTcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 14:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBXTcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 14:32:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75E71BE6;
        Fri, 24 Feb 2023 11:32:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3631861924;
        Fri, 24 Feb 2023 19:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F67C433D2;
        Fri, 24 Feb 2023 19:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677267168;
        bh=SWkLnlr1tyAWXgS02hR1wX6dMdkFNZ2D757/FbtNjTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bDflmbhfe6Y+Y0BvHe5JrIppNwxZqwpaF/ivu5jD6/VF4crFi5YO0EB/nYK3DjW72
         8Ro0F7aQ3ycdqlqPOneOJX8Ftsj4fIxQkbzsRU289o0jB4VVoLHBM5iwdddRaUO4UK
         SIaoEH5sBei0t86oHfQ9qs7jBhATK4/am3yzl4Wg=
Date:   Fri, 24 Feb 2023 11:32:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Jim Meyering <meyering@fb.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>, patches@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2
 review)
Message-Id: <20230224113247.07a660eb44198499314a9e96@linux-foundation.org>
In-Reply-To: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Feb 2023 11:16:52 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But as far as I can tell, GNU diffutils have never actually grown the
> ability to generate those extensions, even though at least the mode
> bit one should be fairly simple (the file rename/copy ones are rather
> more complicated, but those are just a "make diffs more legible and
> compact" convenience thing, unlike the executable bit thing that
> allows for scripts to remain executable).

yeah, irritating.

Can we use git instead of diff?  I tried once, but it didn't work -
perhaps because it didn't like doing stuff outside a git repo.

However, trying it now...

hp2:/home/akpm> mkdir foo
hp2:/home/akpm> cd foo
hp2:/home/akpm/foo> date > a
hp2:/home/akpm/foo> cp a b
hp2:/home/akpm/foo> chmod +x a
hp2:/home/akpm/foo> git diff a b
diff --git a/a b/b              
old mode 100755
new mode 100644
