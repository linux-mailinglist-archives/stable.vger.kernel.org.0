Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA5C4EB9B3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 06:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbiC3EiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 00:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242667AbiC3EiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 00:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E9A22B24;
        Tue, 29 Mar 2022 21:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D60A061560;
        Wed, 30 Mar 2022 04:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE474C340F0;
        Wed, 30 Mar 2022 04:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648614993;
        bh=pYArpFbewAQPlyehfe9Ax847/durxWMKTHZCv43s+gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S7zLHVjEdfr3mUJkJ0tsFbL3eqz4As+/Xl9nN0DxlXf1d4VLODh/cirbPzlvT1+NU
         TxtDV0iL0j1Abe2LBh2Wx9RHVUgC4N/7eXGKl2PhBsWW6tZ+2J8tr/9MuBm0dGOZ6U
         75q6Fz5jFVmWdPKPkS5e5rEj6gNE+diJhI4Kh4C4=
Date:   Wed, 30 Mar 2022 06:36:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Stable release process proposal (Was: Linux 5.10.109)
Message-ID: <YkPeTkf0sG/ns+L4@kroah.com>
References: <164845571613863@kroah.com>
 <44e28591-873a-d873-e04a-78dda900a5de@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44e28591-873a-d873-e04a-78dda900a5de@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 02:49:00AM +0300, Alexey Khoroshilov wrote:
> Dear Greg,
> 
> First of all, thank you very much for keeping stable maintenance so well.
> 
> We (Linux Verification Center of ISPRAS (linuxtesting.org)) are going to
> join a team of regular testers for releases in 5.10 stable branch (and
> other branches later). We are deploying some test automation for that
> and have met an oddity that would to discuss.
> 
> Sometimes, like in 5.10.109 release, we have a situation when a
> released version (5.10.109) differs from the release candidate
> (5.10.109-rс1). In this case there was a patch "llc: only change
> llc->dev when bind()succeeds" added to fix a bug in another llc fix.
> Unfortunately, as Pavel noted, this patch does not fix a bug, but
> introduces a new one, because another commit b37a46683739 ("netdevice:
> add the case if dev is NULL") was missed in 5.10 branch.

This happens quite frequently due to issues found in testing.  It's not
a new thing.

> The problem will be fixed in 5.10.110, but we still have a couple oddities:
> - we have a release that should not be recommended for use
> - we have a commit message misleading users when says:
> 
>     Tested-by: Pavel Machek (CIP) <pavel@denx.de>
>     Tested-by: Fox Chen <foxhlchen@gmail.com>
>     Tested-by: Florian Fainelli <f.fainelli@gmail.com>
>     Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>     Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
>     Tested-by: Salvatore Bonaccorso <carnil@debian.org>
>     Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>     Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>     Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> but actually nobody tested that version.
> 
> There are potential modifications in stable release process that can
> prevent such problems:
> 
> (1) to always release rс2 when there are changes in rc1 introduced
> 
> (2) to avoid Tested-by: section from release commits in such situations.
> 
> Or may be it is overkill and it too complicates maintenance work to be
> worth. What do you think?

I think it's not worth the extra work on my side for this given the
already large workload.  What would benifit from this to justify it?

thanks,

greg k-h
