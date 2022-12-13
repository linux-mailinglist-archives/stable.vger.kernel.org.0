Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52E64B73B
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 15:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbiLMOWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 09:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiLMOVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 09:21:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4811EC77
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 06:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 030566154F
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 14:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C60C433D2;
        Tue, 13 Dec 2022 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670941305;
        bh=xYmEQLyCE/ZYrA4m2lckNTlC0yxTMzsg760vvvhjo4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AaFvwtsABYnTKvUAJcKYcxw0HVl8JrL+vbQowCHqHhGo0LRnrOiDui5eF6PYCBM3R
         aN68N6tiqwwv5a57DEiOUrM5dQdHI+m2obwSGhLKc+INZp5y06lg/MwohlBrS07qgd
         JTkoToFx/Q0rRBeXvn7SLd6XXhkGUcIvkKE3FIY4=
Date:   Tue, 13 Dec 2022 15:21:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 072/106] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL
 dependency for BCMGENET under ARCH_BCM2835
Message-ID: <Y5iKcV2zfolkeDYu@kroah.com>
References: <20221212130924.863767275@linuxfoundation.org>
 <20221212130928.024498741@linuxfoundation.org>
 <b478e4a3-aa37-771d-eac9-dc30a9d3a508@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b478e4a3-aa37-771d-eac9-dc30a9d3a508@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 03:24:50PM +0800, YueHaibing wrote:
> On 2022/12/12 21:10, Greg Kroah-Hartman wrote:
> 
> > From: YueHaibing <yuehaibing@huawei.com>
> >
> > [ Upstream commit 421f8663b3a775c32f724f793264097c60028f2e ]
> >
> > commit 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig") fixes the build
> > that contain 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> > and enable BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
> > leads to a link failure. However this may trigger a runtime failure.
> >
> > Fix the original issue by propagating the PTP_1588_CLOCK_OPTIONAL dependency
> > of BROADCOM_PHY down to BCMGENET.
> >
> > Fixes: 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
> > Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Link: https://lore.kernel.org/r/20221125115003.30308-1-yuehaibing@huawei.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/ethernet/broadcom/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> > index 7b79528d6eed..06aaeaadf2e9 100644
> > --- a/drivers/net/ethernet/broadcom/Kconfig
> > +++ b/drivers/net/ethernet/broadcom/Kconfig
> > @@ -63,6 +63,7 @@ config BCM63XX_ENET
> >  config BCMGENET
> >  	tristate "Broadcom GENET internal MAC support"
> >  	depends on HAS_IOMEM
> > +	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
> 
> This commit is not needed by 5.10,  see
> 
> commit 7be134eb691f6a54b267dbc321530ce0221a76b1
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Fri Nov 25 15:51:06 2022 +0100
> 
>     Revert "net: broadcom: Fix BCMGENET Kconfig"
> 
>     This reverts commit fbb4e8e6dc7b38b3007354700f03c8ad2d9a2118 which is
>     commit 8d820bc9d12b8beebca836cceaf2bbe68216c2f8 upstream.
> 
>     It causes runtime failures as reported by Naresh and Arnd writes:
> 
>             Greg, please just revert fbb4e8e6dc7b ("net: broadcom: Fix BCMGENET Kconfig")
>             in stable/linux-5.10.y: it depends on e5f31552674e ("ethernet: fix
>             PTP_1588_CLOCK dependencies"), which we probably don't want backported
>             from 5.15 to 5.10.

Now dropped, thanks.

greg k-h
