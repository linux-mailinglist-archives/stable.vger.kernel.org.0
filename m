Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC9563737
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiGAPvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 11:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGAPvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 11:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5903912765;
        Fri,  1 Jul 2022 08:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 073FAB83093;
        Fri,  1 Jul 2022 15:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D5AC3411E;
        Fri,  1 Jul 2022 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656690660;
        bh=8woPVNg8tQyFWVC6+tMkYOLruDZ7MnQ0cPcdpqT0y9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XVP5mmGdzP21sxkmF2vEZiL/P5HiQGDhYxvEapB4OyjjHyHO/VIuAEd2X8NpoLiE8
         tffWqcnywG9OxeUZen/P+tG+ynFLrs5sf89hj+02bFOiNRmFtNE1C/5xYtcTA9yipT
         OmyHvzr61hJbTzY8+INoUxQSYxmclJmobiP3uYco=
Date:   Fri, 1 Jul 2022 17:50:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5.15 02/28] clocksource/drivers/ixp4xx: remove __init
 from ixp4xx_timer_setup()
Message-ID: <Yr8X4VbSTMrP9HQ7@kroah.com>
References: <20220630133232.926711493@linuxfoundation.org>
 <20220630133233.000575254@linuxfoundation.org>
 <Yr8TSxroBaL3oRDV@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr8TSxroBaL3oRDV@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 01, 2022 at 08:31:23AM -0700, Nathan Chancellor wrote:
> Hi Greg,
> 
> On Thu, Jun 30, 2022 at 03:46:58PM +0200, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ixp4xx_timer_setup is exported, and so can not be an __init function.
> > Remove the __init marking as the build system is rightfully claiming
> > this is an error in older kernels.
> > 
> > This is fixed "properly" in commit 41929c9f628b
> > ("clocksource/drivers/ixp4xx: Drop boardfile probe path") but that can
> > not be backported to older kernels as the reworking of the IXP4xx
> > codebase is not suitable for stable releases.
> > 
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This patch causes the following warnings with clang when building
> ARCH=arm allmodconfig on 5.15, 5.10, and 5.4. I am surprised nobody else
> saw them.
> 
>   WARNING: modpost: vmlinux.o(.text+0x1219ccc): Section mismatch in reference from the function ixp4xx_timer_register() to the function .init.text:sched_clock_register()
>   The function ixp4xx_timer_register() references
>   the function __init sched_clock_register().
>   This is often because ixp4xx_timer_register lacks a __init
>   annotation or the annotation of sched_clock_register is wrong.
> 
>   WARNING: modpost: vmlinux.o(.text+0x1219cf4): Section mismatch in reference from the function ixp4xx_timer_register() to the function .init.text:register_current_timer_delay()
>   The function ixp4xx_timer_register() references
>   the function __init register_current_timer_delay().
>   This is often because ixp4xx_timer_register lacks a __init
>   annotation or the annotation of register_current_timer_delay is wrong.
> 
> I think it would just be better to remove the export of
> ixp4xx_timer_setup(), rather than removing __init, as it is only called
> in arch/arm/mach-ixp4xx/common.c, which has to be built into the kernel
> image as it is 'obj-y' in arch/arm/mach-ixp4xx/Makefile.

Ah it can?  That would have been much better/easier.  I'll drop this and
go do that for the next release after this one, thanks for letting me
know as this did not show up in my local testing either.

greg k-h
