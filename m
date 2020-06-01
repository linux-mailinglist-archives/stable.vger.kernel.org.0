Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D951EA824
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFARIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFARIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 13:08:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3779C05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 10:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Z3FEOtZpIi0moXNCjaI+EI5GtoYPAHRaQUcW992MeI4=; b=j6CQr8E8783Reb1oZcdYMj9Fn
        T7+k5uISoC8/aKpuGbmRQVPThv31a3nOB6Zqll+uGrQGfWwTDB3t0/tniLP2q8KnAAZTro4RLzQBz
        tSdeFTyVx2ZVhEQrW3CxynWqDDQ4JSF+j1RMV8JDv9E+hebKXAot+uWFclSQ7fYpJmemWRA0zgAkx
        Jwy91ZsuOj+n84EooVxvf0NGfYoPK8c+U1BYC1muGhU5HNyerNbgix+10E8mvqCeglG1dl83vr6Ih
        ZUrksyjdgDtXJOwwB2RwMNLe5dXP2eszit1LotFyCqa8zkskGeN7ACrZNfHEeKxyELGaR9XTUmCJu
        OTtWKCKOw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40034)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jfnuj-0000pg-T6; Mon, 01 Jun 2020 18:07:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jfnui-0003Tr-0Y; Mon, 01 Jun 2020 18:07:52 +0100
Date:   Mon, 1 Jun 2020 18:07:51 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
Message-ID: <20200601170751.GO1551@shell.armlinux.org.uk>
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601170248.GA1105493@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 07:02:48PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 01, 2020 at 09:18:34PM +0530, Naresh Kamboju wrote:
> > stable-rc 4.9 arm architecture build failed due to
> > following errors,
> > 
> > # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> > arm-linux-gnueabihf-gcc" O=build zImage
> > #
> > ../arch/arm/vfp/vfphw.S: Assembler messages:
> > ../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
> > ../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
> > make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
> > make[2]: Target '__build' not remade because of errors.
> > make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
> > ../arch/arm/lib/changebit.S: Assembler messages:
> > ../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

It looks like Naresh's toolchain doesn't like the new format
instructions.  Which toolchain (and versions of the individual
tools) are you (Naresh) using?

> Odd, I'll drop it from 4.9, but it's also in the 4.14 and 4.19 queues as
> well, is it causing issues there too?

What if it turns out that Naresh is using an ancient toolchain
that isn't supported by these kernels?  Does that still count as
a reason to drop the patch?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
