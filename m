Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A77360F478
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiJ0KJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbiJ0KJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:09:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D11115;
        Thu, 27 Oct 2022 03:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C245B8252C;
        Thu, 27 Oct 2022 10:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEC2C433C1;
        Thu, 27 Oct 2022 10:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666865372;
        bh=tZ4B9hZpoBmF5BYQ8cjVqZIOcWnSZnmapQKKtNNTNrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VIT/SQh60NIG4GGLfFtLxmVxlOZfjm3ecQKgwYvLutGKfSVsxs2T7dDuK4oDjmQEw
         pcH4Adch2iPY/qSJ4VEiGQOFIpJFXgtNCwBMdF9GtKxreyJo2h1x7jWIpkc0x3ygN2
         sN8Zp1sMnP2coidZDy0FiVf3XKMoOGETdF9cPJtI=
Date:   Thu, 27 Oct 2022 12:09:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Michele Jr De Candia <mdecandia@gmail.com>,
        akpm@linux-foundation.org, bsegall@google.com, edumazet@google.com,
        jbaron@akamai.com, khazhy@google.com, linux-kernel@vger.kernel.org,
        r@hev.cc, rpenyaev@suse.de, stable@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 5.4 051/389] epoll: autoremove wakers even more
 aggressively
Message-ID: <Y1pY2n6E1Xa58MXv@kroah.com>
References: <20220823080117.738248512@linuxfoundation.org>
 <20221026160051.5340-1-mdecandia@gmail.com>
 <Y1ljluiq8Ojp4vdL@kroah.com>
 <CAAPDZK9Oz2Hs9wofW9820gM=SeWgycCEWN=Xsjmy-YY_iFBcfQ@mail.gmail.com>
 <CALvZod5My-JaXBSm1iuVSFMiarB2YuE=O0AxD=6ZG0BfmJZ1AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod5My-JaXBSm1iuVSFMiarB2YuE=O0AxD=6ZG0BfmJZ1AQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 11:48:01AM -0700, Shakeel Butt wrote:
> On Wed, Oct 26, 2022 at 11:44 AM Michele Jr De Candia
> <mdecandia@gmail.com> wrote:
> >
> > Hi Greg,
> > sorry for the confusion.
> >
> > I'm running a container-based app on top of Ubuntu Linux 20.04 and linux kernel 5.4 always updated with latest patches.
> >
> > Updating from 5.4.210 to 5.4.211 we faced the hang up issue and searching for the cause we have tested that
> > hangup occurs only with this patch
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=cf2db24ec4b8e9d399005ececd6f6336916ab6fc
> >
> > While understanding root cause, wt the moment we reverted it and hang up does not occurs (actually we are running 5.4.219 without that patch).
> >
> > Michele
> >
> 
> Hi Michele, can you try the latest upstream kernel and see if the
> issue repro ther? Also is it possible to provide a simplified repro of
> the issue?

Also is this issue on 5.10.y and 5.15.y?

thanks,

greg k-h
