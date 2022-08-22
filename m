Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDFC59BEB5
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 13:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiHVLmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiHVLmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216E533A3A;
        Mon, 22 Aug 2022 04:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96CD561088;
        Mon, 22 Aug 2022 11:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFE0C433C1;
        Mon, 22 Aug 2022 11:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661168566;
        bh=lbbILzmry447oKuhb/hZwxnsfNg8BIhdhI9lzTnZoUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYO2M83CBeDdxP1BPaupjh5secrT7l864gCmFkZZEaHqT5WMMMZEqzreYl6nx7p62
         kiG1RiiGvCqHxUB2jUiL2Jd/yXlVnua40NfEKC+x3xch7jyKd2ZK8zZ7b1LLGq5oca
         GRQjOonXUjMNDpWUe2BGILQ+Mcv+Rn1zdkXN0SxE=
Date:   Mon, 22 Aug 2022 13:42:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Willy Tarreau <w@1wt.eu>, stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Message-ID: <YwNrshpVAweaODMR@kroah.com>
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com>
 <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com>
 <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
 <20220822080456.GB17080@1wt.eu>
 <4c42af33-dc05-315a-87d9-be0747a74df4@gmx.com>
 <20220822083044.GC17080@1wt.eu>
 <9aa83875-0a05-6b28-b4df-4071ba8ee343@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aa83875-0a05-6b28-b4df-4071ba8ee343@gmx.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 07:07:19PM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/8/22 16:30, Willy Tarreau wrote:
> > On Mon, Aug 22, 2022 at 04:19:49PM +0800, Qu Wenruo wrote:
> > > > Regardless, if you need an older compiler, just use these ones:
> > > > 
> > > >      https://mirrors.edge.kernel.org/pub/tools/crosstool/
> > > > 
> > > > They go back to 4.9.4 for x86, you'll surely find the right one for your
> > > > usage. I've long used 4.7.4 for kernels up to 4.9 and 6.5 for 4.19 and
> > > > above, so something within that area will surely match your needs.
> > > 
> > > BTW, it would be way more awesome if the page can provide some hint on
> > > the initial release date of the compilers.
> > > 
> > > It would help a lot of choose the toolchain then.
> > 
> > It wouldn't help, if you look closely, you'll notice that in the "other
> > releases" section you have the most recent version of each of them. That
> > does not preclude the existence of the branch earlier. For example gcc-9
> > was released in 2019 and 9.5 was emitted 3 years later. That's quite an
> > amplitude that doesn't help.
> 
> Maybe I'm totally wrong, but if GCC10.1 is released May 2020, and even
> 10.4 is released 2022, then shouldn't we expect the kernel releases
> around 2020 can be compiled for all GCC 10.x releases?
> 
> Thus the initial release date should be a good enough hint for most cases.
> 
> If go this method, for v4.14 I guess I should go gcc 7.x, as gcc 7.1 is
> released May 2017, even the latest 7.5 is released 2019.
> 
> Or is my uneducated guess completely wrong?

Try it and see!
