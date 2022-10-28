Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010E7610F43
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 13:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJ1LBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 07:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJ1LBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 07:01:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7BE1C8400;
        Fri, 28 Oct 2022 04:01:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 190DAB8294D;
        Fri, 28 Oct 2022 11:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DC4C433D6;
        Fri, 28 Oct 2022 11:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666954896;
        bh=Sbj94qyOysjZJE+ackYXXNKl168AQnZBHbwv9gdbaps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ya9OWcXiNBemxAcmFdTmRCg7T8N5KQVO5LeCTzcTeDZhZuwGGAXd63KnPPS8IkaZi
         PeMwW9aIr40qpk3kjcKWev8dLzv4yze7SgIBsIl9pmvD1pjL96ZB8tcxO92VMrIsti
         klFUTv9kBsf15SH7/W6K01tCzILhZR3MYN9oQm5Y=
Date:   Fri, 28 Oct 2022 13:01:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Machek <pavel@denx.de>, Guenter Roeck <linux@roeck-us.net>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Message-ID: <Y1u2jq+blROrB8IC@kroah.com>
References: <20221027165054.270676357@linuxfoundation.org>
 <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
 <Y1rbQqkdeliRrQPF@kroah.com>
 <20221027192744.GC11819@duo.ucw.cz>
 <CAHk-=wgweH9GibJBzuEZNBGKbYPrs4NchT0YLuyxk1=N7gsWog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgweH9GibJBzuEZNBGKbYPrs4NchT0YLuyxk1=N7gsWog@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 12:49:22PM -0700, Linus Torvalds wrote:
> On Thu, Oct 27, 2022 at 12:27 PM Pavel Machek <pavel@denx.de> wrote:
> >
> > Alternatively you can modify the caller to do /bin/sh /scripts/... so
> > it does not need a +x bit...
> 
> Generally we should be doing both.
> 
> Make it have the proper +x bit to show clearly that it's an executable
> script and have 'ls' and friends show it that way when people enable
> colorization or whatever.
> 
> *And* make any Makefiles and tooling use an explicit "sh" or whatever
> thing, because we've traditionally let people use tar-files and patch
> to generate their trees, and various stupid tools exist and get it
> wrong even when we get it right in our git tree.
> 
> So belt and suspenders.
> 
> But in this case, I think our tools already do the "run shell" part:
> 
>   Makefile:PAHOLE_FLAGS   = $(shell PAHOLE=$(PAHOLE)
> $(srctree)/scripts/pahole-flags.sh)
> 
> no? And at least in my -git tree, it's already executable.

In your tree, yes.

And when I export the patch, we get the proper:
	create mode 100755 scripts/pahole-flags.sh
line added to the patch.

But then when importing the patch using:
	git quilt-import
that line is totally ignored and the permissions are set to normal.

It's a long-running issue, and I think I'm about the only one that uses
git quilt-import outside of the debian build system, so it's low on my
list of things to fix up with that shell script (speed is my biggest
issue, it's just slow on large amounts of patches and needs to be
rewritten in C).

I'll go fix this up by hand...

thanks,

greg k-h
