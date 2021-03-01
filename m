Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91609329241
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbhCAUmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238067AbhCAUfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:35:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6543C600EF;
        Mon,  1 Mar 2021 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614625278;
        bh=QWZtnweGPWYZkhAwe5FxTufhd7t9UsgPKsmw7AfGVtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d3qhqVHPqO9m8rLfNa0asgf3jI5azXANTsye1WGxzdfQOMEnDco8xh1pocXyFZu3J
         8hFjFN/Ov2X3zdozrN6Ab+3Ux1SgaBGc3BW3MM5Q20q/TjPiWejGVvSQ0QNSxoE+Y+
         IXJKf1zmSovcN3wnAAwBuNiSao0SuxhvH43uzto0=
Date:   Mon, 1 Mar 2021 20:01:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sun4i-ss-cipher.c:139:4: error: implicit declaration of function
 'kfree_sensitive'; did you mean 'kvfree_sensitive'?
Message-ID: <YD05+67Bo+YYkg0o@kroah.com>
References: <CA+G9fYufUB394TpDuO5-m2GEi=1LDZvsVcHmp-HyWbWV1tYjkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYufUB394TpDuO5-m2GEi=1LDZvsVcHmp-HyWbWV1tYjkA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:54:52PM +0530, Naresh Kamboju wrote:
> On stable rc 4.19 arm build failed due to below error.
> the config file link provided.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_opti_poll':
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:139:4: error: implicit
> declaration of function 'kfree_sensitive'; did you mean
> 'kvfree_sensitive'? [-Werror=implicit-function-declaration]
>   139 |    kfree_sensitive(backup_iv);
>       |    ^~~~~~~~~~~~~~~
>       |    kvfree_sensitive
> cc1: some warnings being treated as errors
> make[4]: *** [scripts/Makefile.build:304:
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.o] Error 1
> make[4]: Target '__build' not remade because of errors.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> ref:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064179234#L462
> 
> confg:
> https://builds.tuxbuild.com/1pAEVBwRxCDBXf85dL6Kki6o8Yf/config
> 
> 
> steps to reproduce:
> 
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
> tuxmake --runtime podman --target-arch arm --toolchain gcc-9 --kconfig
> defconfig --kconfig-add
> https://builds.tuxbuild.com/1pAEVBwRxCDBXf85dL6Kki6o8Yf/config

Also broken on 4.14, I'll fix that there too, thanks!

greg k-h
