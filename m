Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0855E99C7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 08:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiIZGqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 02:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiIZGqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 02:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1921FCD7;
        Sun, 25 Sep 2022 23:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43045B818EA;
        Mon, 26 Sep 2022 06:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C403C433C1;
        Mon, 26 Sep 2022 06:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664174777;
        bh=t9ZFgSLybIz5CVVdKLuCZVxIGBv79vJKVx2moo8JR1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C0dkGikTdJwSIYsRsuPv58FTU0YiRGsTottgzQ3yQZpEjwfHcgXLHiSB2JnMrEiqW
         gNEUmxaZN/6znRWSMHxZrkXFAaFI6C0o8KG8A0UiIOpFO+W70cG6aqshqcH+5WLgnR
         bAUXSH0pL0lAw63ScLK3XQIZCcmM5OhOSBq6lxbc=
Date:   Mon, 26 Sep 2022 08:46:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yong w <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 stable-4.19 1/3] mm/page_alloc: use ac->high_zoneidx
 for classzone_idx
Message-ID: <YzFKtxt0iZODL211@kroah.com>
References: <Yyn7MoSmV43Gxog4@kroah.com>
 <20220925103529.13716-1-yongw.pur@gmail.com>
 <20220925103529.13716-2-yongw.pur@gmail.com>
 <YzA04ZZI/1OH8oRT@kroah.com>
 <CAOH5QeBiSEe03KNge9voJ-HjKbNLDoeY2PfKC7HE7F6z-92d7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOH5QeBiSEe03KNge9voJ-HjKbNLDoeY2PfKC7HE7F6z-92d7A@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 25, 2022 at 10:32:32PM +0800, yong w wrote:
> Greg KH <gregkh@linuxfoundation.org> 于2022年9月25日周日 19:00写道：
> >
> > On Sun, Sep 25, 2022 at 03:35:27AM -0700, wangyong wrote:
> > > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > >
> > > [ backport of commit 3334a45eb9e2bb040c880ef65e1d72357a0a008b ]
> >
> > This is from 5.8.  What about the 5.4.y kernel?  Why would someone
> > upgrading from 4.19.y to 5.4.y suffer a regression here?
> >
> I encountered this problem on 4.19, but I haven't encountered it on 5.4.
> However, this should be a common problem, so 5.4 may also need to be
> merged.
> 
> Hello, Joonsoo, what do you think?
> 
> > And why wouldn't someone who has this issue just not use 5.10.y instead?
> > What prevents someone from moving off of 4.19.y at this point in time?
> >
> This is a solution, but upgrading the kernel version requires time and overhead,
> so use the patch is the most effective way, if there is.

You will have to move off of 4.19 soon anyway, so why delay the change?

thanks,

greg k-h
