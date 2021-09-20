Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6B7412AEC
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241862AbhIUCD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbhIUB4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 21:56:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAFEC03540A
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 16:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T1RFrzW21kzIZQqFZGBJPCEJ/CKQj6Iu6zOBR9y+v5E=; b=THjIGHzjDrIzSm/bUtJUWEeEdr
        MNq5lx3y2edGfzaG3NE0heLwtT/BfV98nK3DfAkMbPYN0tFtl/jgSoFUW95GbPb/F/YkuKM/enXip
        hLZDKrkRi3xy6Ed7bpnmIR8R03tkwOikzWoy/GkDVKbOCTXVy1kOwolEVX1ftvlLo9eUtvuEi+O4h
        PG8C9Vd6LHOthQDruKxeBbBcS+SD7LXWIPIlZbXvMGx8f+4TRI95SAVZ+zyIyXzTw07VNnP1Cf6QF
        fqoUa3AihZ/QNZlajuqwR3akH3yov+yKBhqYuDiAYyPva17OTFHGG8R2sLjhY9Epxf+tyA2VAI7RS
        uJjLM18w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54692)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mST1N-000286-Vy; Tue, 21 Sep 2021 00:48:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mST1N-0002ib-CW; Tue, 21 Sep 2021 00:48:25 +0100
Date:   Tue, 21 Sep 2021 00:48:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     shawnguo@kernel.org, linux-arm-kernel@lists.infradead.org,
        m.felsch@pengutronix.de, tharvey@gateworks.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ARM: imx6q: drop of_platform_default_populate()
 from init_machine"
Message-ID: <YUkdybUJZY+/5UO2@shell.armlinux.org.uk>
References: <20210920234311.682163-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920234311.682163-1-festevam@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 08:43:11PM -0300, Fabio Estevam wrote:
> This reverts commit cc8870bf4c3ab0af385538460500a9d342ed945f.
>  
> Since commit cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate()
> from init_machine") the following errors are seen on boot:
> 
> [    0.123372] imx6q_suspend_init: failed to find ocram device!
> [    0.123537] imx6_pm_common_init: No DDR LPM support with suspend -19! 
> 
> , which break suspend/resume on imx6q/dl.
> 
> Revert the offeding commit to avoid the regression.
> 
> Thanks to Tim Harvey for bisecting this problem.
> 
> Cc: stable@vger.kernel.org

Thanks Fabio.

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> Fixes: cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate() from  init_machine")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  arch/arm/mach-imx/mach-imx6q.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> index 11dcc369ec14..c9d7c29d95e1 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -172,6 +172,9 @@ static void __init imx6q_init_machine(void)
>  				imx_get_soc_revision());
>  
>  	imx6q_enet_phy_init();
> +
> +	of_platform_default_populate(NULL, NULL, NULL);
> +
>  	imx_anatop_init();
>  	cpu_is_imx6q() ?  imx6q_pm_init() : imx6dl_pm_init();
>  	imx6q_1588_init();
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
