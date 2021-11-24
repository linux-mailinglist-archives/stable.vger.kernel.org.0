Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612F245C9AE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbhKXQS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhKXQS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:18:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB9160D42;
        Wed, 24 Nov 2021 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637770549;
        bh=rxQy+0YJzHqbN0RjamP9WAcLYQRbfwKao/oNpuPtN90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BlMygx4O2526zjpcHMU/ytqiU9fqwqHPpU1Y2aCOgy0A28aR8+NPaRQ/EOfbxqZsx
         B6NuhOXGZBXc+iAJo5e5rpToPw0B1Vyu6f2SbBc1K2Ve7TsEPhr6EX8LTT9OCRSkYr
         CQ4f82QVrbOapD3h0O5D3nTB14agGbRQYT3Q0aQc=
Date:   Wed, 24 Nov 2021 17:15:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Stephen Boyd <swboyd@chromium.org>,
        lkft-triage@lists.linaro.org
Subject: Re: qcom :apq8016-sbc.dtsi:412.21-414.5: ERROR (duplicate_label):
 /soc/codec: Duplicate label 'lpass_codec' on /soc/codec and /soc@0/codec
Message-ID: <YZ5lMnv8rTEturEp@kroah.com>
References: <CA+G9fYv5fnntoa1vzXp52=TSxCK=U8fV8J-AbE+WmKH1w4ebwg@mail.gmail.com>
 <YZ4gjaTqE++yDAB/@kroah.com>
 <CA+G9fYsa=04=sKsxH2=5yh3NqGTZUpcD-4OiKcfiFGSH3DP+FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsa=04=sKsxH2=5yh3NqGTZUpcD-4OiKcfiFGSH3DP+FQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 05:48:14PM +0530, Naresh Kamboju wrote:
> Hi Greg,
> 
> On Wed, 24 Nov 2021 at 16:52, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Nov 24, 2021 at 03:30:09PM +0530, Naresh Kamboju wrote:
> > > Regression found on arm64 gcc-11 builds
> > > Following build warnings / errors reported on stable-rc 5.4.
> > >
> > > metadata:
> > >     git_describe: v5.4.161-99-g60345e6d23ca
> > >     git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >     git_short_log: 60345e6d23ca (\"Linux 5.4.162-rc1\")
> > >     target_arch: arm64
> > >     toolchain: gcc-11
> > >
> > > build error :
> > > --------------
> > > builds/linux/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5:
> > > ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on
> > > /soc/codec and /soc@0/codec
> > > ERROR: Input tree has errors, aborting (use -f to force output)
> > > make[3]: *** [scripts/Makefile.lib:285:
> > > arch/arm64/boot/dts/qcom/apq8016-sbc.dtb] Error 2
> 
> > I can not figure out what commit caused this problem.  Any pointers
> > would be appreciated...
> 
> The bisect tool pointed to,
> 
> b979ffa8bbd6e4c33df7f3e7ac3d63f2234c023c is the first bad commit
> commit b979ffa8bbd6e4c33df7f3e7ac3d63f2234c023c
> Author: Stephan Gerhold <stephan@gerhold.net>
> Date:   Tue Sep 21 17:21:18 2021 +0200
> 
>     arm64: dts: qcom: msm8916: Add unit name for /soc node
> 
>     [ Upstream commit 7a62bfebc8c94bdb6eb8f54f49889dc6b5b79601 ]
> 
>     This fixes the following warning when building with W=1:
>     Warning (unit_address_vs_reg): /soc: node has a reg or ranges property,
>     but no unit name
> 
>     Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
>     Reviewed-by: Stephen Boyd <swboyd@chromium.org>
>     Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>     Link: https://lore.kernel.org/r/20210921152120.6710-1-stephan@gerhold.net
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
>  arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now dropped from everywhere, thanks.

greg k-h
