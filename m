Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E551368D8
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 09:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgAJIQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 03:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgAJIQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 03:16:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B502072A;
        Fri, 10 Jan 2020 08:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578644206;
        bh=vbOyzbvruv5chHSCn6AlK9BNbMsKVgBT5UGr2DJ7XGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JtX2cyZx85/NGjVLtkZ45ZsN0N5bMDyptPmYIErMh9hyy/ERhiGSRXWRTBh0a03e1
         aURSMBO5l5PrnygAnwiI5bI8A523R2DXlpLATa9QmFRx8iGZ+I9vxPduwP/As70Tiv
         D9xGaajzw1GxSnasUsRA1I0lCwEYL2IOH0ULWhgI=
Date:   Fri, 10 Jan 2020 09:16:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: ab8500: Remove AB8505 USB regulator
Message-ID: <20200110081643.GA363320@kroah.com>
References: <20191106173125.14496-1-stephan@gerhold.net>
 <CACRpkdaH8ahbVKTrBHh7NKVZVg-PZvyKDKNityEyv5rL8=Qdag@mail.gmail.com>
 <CA+G9fYvSQJ0BVAAMyTk0mViqCdNjtsZCrhhorRnrmcPg98yQVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvSQJ0BVAAMyTk0mViqCdNjtsZCrhhorRnrmcPg98yQVA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 01:32:57PM +0530, Naresh Kamboju wrote:
> On Thu, 7 Nov 2019 at 13:32, Linus Walleij <linus.walleij@linaro.org> wrote:
> >
> > On Wed, Nov 6, 2019 at 6:33 PM Stephan Gerhold <stephan@gerhold.net> wrote:
> >
> > > The USB regulator was removed for AB8500 in
> > > commit 41a06aa738ad ("regulator: ab8500: Remove USB regulator").
> > > It was then added for AB8505 in
> > > commit 547f384f33db ("regulator: ab8500: add support for ab8505").
> > >
> 
> Stable-rc 4.4 branch arm build failed due to this error.
> 
> arch/arm/mach-ux500/board-mop500-regulators.c:957:3: error:
> 'AB8505_LDO_USB' undeclared here (not in a function); did you mean
> 'AB9540_LDO_USB'?
>   [AB8505_LDO_USB] = {
>    ^~~~~~~~~~~~~~
>    AB9540_LDO_USB
> arch/arm/mach-ux500/board-mop500-regulators.c:957:3: error: array
> index in initializer not of integer type
> arch/arm/mach-ux500/board-mop500-regulators.c:957:3: note: (near
> initialization for 'ab8505_regulators')
> 
> Full build log,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.4/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/703/consoleText
> 

Good catch, I'll go drop this patch from the 4.4.y queue now, thanks.

greg k-h
