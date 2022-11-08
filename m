Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1258D620AF9
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 09:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiKHIMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 03:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiKHIMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 03:12:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6024019C12;
        Tue,  8 Nov 2022 00:12:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AE99B8171B;
        Tue,  8 Nov 2022 08:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F748C433D6;
        Tue,  8 Nov 2022 08:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667895160;
        bh=tr4utLTvbJI5QC87X+bDHvLjs/lH810Iljf8WOasF2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cdvmm3GJkral4rJEg2r6UXPxaz+Of9dPDkDwtTvSEFtexQbjRKECP00SnTv0Zit2/
         s7vw3BHKA/16Mq25TGa1Fw2eL0y2gAmdmGneepskVp3Mz6Yll4H27QDDKyjfMo7Tuk
         yaXncfy/GnepuZMK1/1iHzWWHN38SQvnfS/CyPYI=
Date:   Tue, 8 Nov 2022 09:12:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.14.297
Message-ID: <Y2oPdQVmMDWCTZ8q@kroah.com>
References: <166732705422181@kroah.com>
 <20221104181745.ahtjvjvk5qk7vu37@google.com>
 <Y2YzeruPdM2y327C@kroah.com>
 <CAKwvOdk378tUkqXzS8_NvWZRfayQjJAtJX81PdemuBVZ16i4Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdk378tUkqXzS8_NvWZRfayQjJAtJX81PdemuBVZ16i4Dg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 10:38:51AM -0800, Nick Desaulniers wrote:
> On Sat, Nov 5, 2022 at 2:57 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Nov 04, 2022 at 11:17:45AM -0700, Nick Desaulniers wrote:
> > > On Tue, Nov 01, 2022 at 07:24:13PM +0100, Greg Kroah-Hartman wrote:
> > > > I'm announcing the release of the 4.14.297 kernel.
> > > >
> > > > All users of the 4.14 kernel series must upgrade.
> > > >
> > > > The updated 4.14.y git tree can be found at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
> > > > and can be browsed at the normal kernel.org git web browser:
> > > >     https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > >
> > > Hi Greg and stable tree maintainers,
> > > Please consider cherry-picking
> > > commit 95b980d62d52 ("linux/bits.h: make BIT(), GENMASK(), and friends available in assembly")
> > > back to 4.19.y and 4.14.y. It first landed in v5.3-rc1 and applies
> > > cleanly to both branches. I did not find any fixups to 95b980d62d52,
> > > FWIW.
> > >
> > > Otherwise users upgrading to this point release of linux-4.14.y still on
> > > versions of the GNU assembler older than v1.28 will observe assembler
> > > errors when building this series. See the link below for the error
> > > messages.
> > >
> > > Please see
> > > https://lore.kernel.org/llvm/20221103210748.1343090-1-ndesaulniers@google.com/
> > > for more info.
> >
> > Did you try building with that commit applied?  I get the following
> 
> I built 4.19 but not 4.14. Sorry! It looks like for 4.14 95b980d62d52
> will additionally depend on
> 
> commit 2dd8a62c6476 ("linux/const.h: move UL() macro to include/linux/const.h")
> 
> which first landed in v4.17-rc1.
> 
> That commit will depend on
> 
> commit 2a6cc8a6c0cb ("linux/const.h: prefix include guard of
> uapi/linux/const.h with _UAPI")
> 
> which first landed in v4.17-rc1 as well. Looks like they were part of
> the same series.
> 
> So 4.14.y will need the following 3 patches:
> 1. commit 2a6cc8a6c0cb ("linux/const.h: prefix include guard of
> uapi/linux/const.h with _UAPI")
> 2. commit 2dd8a62c6476 ("linux/const.h: move UL() macro to
> include/linux/const.h")
> 3. commit 95b980d62d52 ("linux/bits.h: make BIT(), GENMASK(), and
> friends available in assembly")
> 
> 2a6cc8a6c0cb will have a minor conflict in include/uapi/linux/const.h because
> commit a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
> <linux/const.h>")
> was backported before 2a6cc8a6c0cb as b732e14e6218b (in 4.14).
> Attached is a compile tested (x86 make CC=clang) mbox for 4.14.y.
> Please let me know if that works for you.

Thanks, I've queued these up now and will test them later today on the
Android build system as well.

greg k-h
