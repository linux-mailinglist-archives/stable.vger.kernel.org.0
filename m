Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E413CED58
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 22:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348387AbhGSSWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 14:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344450AbhGSSBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 14:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF4C861003;
        Mon, 19 Jul 2021 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626720141;
        bh=eMk/xrm0cjxlIUp+UO3LLo3l6/4xD2rOx7ZWLE5vwZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jvCzbu/+vA9vA6touRHcEoO3U2eYvDZxT8Qkm/20fkEY6lon6t3a5IvHnzpNB9CbS
         E6DXC6CicFL8LiUIiA0sGfg4yX8LdlvLQHxjPKEFjZZqge0W5HgGJG2D4QZnnsjyHO
         q+quieF27mGWufM1AezMxxXtaT6oD7nDT8Cj6Vxc=
Date:   Mon, 19 Jul 2021 20:42:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.14 305/315] arm64: dts: qcom: msm8994-angler: Fix
 gpio-reserved-ranges 85-88
Message-ID: <YPXHioXEfwU6NzTf@kroah.com>
References: <20210719144942.861561397@linuxfoundation.org>
 <20210719144953.504491331@linuxfoundation.org>
 <CA+G9fYvqW9ZG8PFMyUobaiT2a_nAYyuJeWvRr0AuwB6eWMa+cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvqW9ZG8PFMyUobaiT2a_nAYyuJeWvRr0AuwB6eWMa+cQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 09:17:17PM +0530, Naresh Kamboju wrote:
> On Mon, 19 Jul 2021 at 21:01, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Petr Vorel <petr.vorel@gmail.com>
> >
> > [ Upstream commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 ]
> >
> > Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
> > application CPUs (causes reboot). Yet another fix similar to
> > 9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
> > 3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").
> >
> > Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")
> >
> > Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> > Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > index dfa08f513dc4..e5850c4d3334 100644
> > --- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > +++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > @@ -38,3 +38,7 @@
> >                 };
> >         };
> >  };
> > +
> > +&tlmm {
> > +       gpio-reserved-ranges = <85 4>;
> > +};
> 
> Following build errors noticed on arm64 architecture on on
> stable-rc linux-4.19.y
> stable-rc linux-4.14.y
> 
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> Error: /builds/linux/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts:42.1-6
> Label or path tlmm not found
> FATAL ERROR: Syntax error parsing input tree
> make[3]: *** [scripts/Makefile.lib:294:
> arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dtb] Error 1
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [/builds/linux/scripts/Makefile.build:544:
> arch/arm64/boot/dts/qcom] Error 2
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> reference build link,
> build: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/
> config: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config
> 
> 
> steps to reproduce:
> ---------------------
> # TuxMake is a command line tool and Python library that provides
> # portable and repeatable Linux kernel builds across a variety of
> # architectures, toolchains, kernel configurations, and make targets.
> #
> # TuxMake supports the concept of runtimes.
> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> # that you install podman or docker on your system.
> #
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
> 
> 
> tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
> --kconfig defconfig --kconfig-add
> https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config
> 

Now dropped from everywhere, thanks.

greg k-h
