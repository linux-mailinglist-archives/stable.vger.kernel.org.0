Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1E14F75D4
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbiDGGUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236654AbiDGGUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:20:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4222D1A8C17;
        Wed,  6 Apr 2022 23:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE0A61D0D;
        Thu,  7 Apr 2022 06:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB1AC385A0;
        Thu,  7 Apr 2022 06:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649312320;
        bh=WNjt/W0EC5NHsxTNHptluiTrADyC31f+9oWaPnEp5d0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HYerDy/KYCFxq39gnJ4RAqvZZ3raYPvCXbukjYlfWMfdsehpkjbkcRJoWGFl8Qv/K
         Jc3iEUV7A/EAEiqc1uacaPN04am8D5R3JmocyWfL5fkyjLY/ShDRa8KeBmTGJYrhed
         GSvUer54e2rVTaXRQqVnoMl2kZifHYi6YCgYhJQY=
Date:   Thu, 7 Apr 2022 08:18:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laurent Vivier <laurent@vivier.eu>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-m68k@lists.linux-m68k.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-rtc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alessandro Zummo <a.zummo@towertech.it>, stable@vger.kernel.org
Subject: Re: [PATCH v16 1/4] tty: goldfish: introduce
 gf_ioread32()/gf_iowrite32()
Message-ID: <Yk6CO11wyo86ylee@kroah.com>
References: <20220406201523.243733-1-laurent@vivier.eu>
 <20220406201523.243733-2-laurent@vivier.eu>
 <Yk5tNOPE4b2QbHLG@kroah.com>
 <198be9ea-a8c2-0f9e-6ae5-a7358035def4@vivier.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <198be9ea-a8c2-0f9e-6ae5-a7358035def4@vivier.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 08:00:08AM +0200, Laurent Vivier wrote:
> Le 07/04/2022 à 06:48, Greg KH a écrit :
> > On Wed, Apr 06, 2022 at 10:15:20PM +0200, Laurent Vivier wrote:
> > > Revert
> > > commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> > > 
> > > and define gf_ioread32()/gf_iowrite32() to be able to use accessors
> > > defined by the architecture.
> > > 
> > > Cc: stable@vger.kernel.org # v5.11+
> > > Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> > > Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> > > Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > ---
> > >   drivers/tty/goldfish.c   | 20 ++++++++++----------
> > >   include/linux/goldfish.h | 15 +++++++++++----
> > >   2 files changed, 21 insertions(+), 14 deletions(-)
> > > 
> > 
> > Why is this a commit for the stable trees?  What bug does it fix?  You
> > did not describe the problem in the changelog text at all, this looks
> > like a housekeeping change only.
> 
> Arnd asked for that in:
> 
>   Re: [PATCH v11 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
>   https://lore.kernel.org/lkml/CAK8P3a1oN8NrUjkh2X8jHQbyz42Xo6GSa=5n0gD6vQcXRjmq1Q@mail.gmail.com/

You did not provide a reason in this changelog to explain any of that :(
