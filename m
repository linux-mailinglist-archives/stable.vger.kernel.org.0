Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CB31C79BF
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 20:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgEFS6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 14:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbgEFS6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 14:58:07 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18942C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 11:58:07 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id a9so2266507lfb.8
        for <stable@vger.kernel.org>; Wed, 06 May 2020 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hhU7YC1mHWJXOQCa9/YtvMX0AvTF/51BQ11Lkp2if0=;
        b=ENs11Z2E6PTphR/O7XEptV9DrkitQZwLiWGfUE3J1NThoeRLPWDK4tDps5BoTcWit1
         zxwc6iaDbar5hppPTNmyGg+DQIeMEcKomHQdFBhyU8VETMfHL8W2a1Jd5FtPT4MSFPlx
         pW5uAwDfiblCrXtvPdUyMV5XllzXhrrMlu3/oW6uuJTz36qgimok4gbXBH4xnjVurcCX
         lcUe+U7g7T87tsCxaKgUy1ztqhvZkOlPI1dRGORUz42KQ/uPPuoOll0V3+DBw/rjO1OW
         I1Q/zUwoATalGf6bzwzmulWBAfKNsUBbxb1ZM1A5ACSkMtfwmtHD9gRLESdsOugAfng+
         xmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2hhU7YC1mHWJXOQCa9/YtvMX0AvTF/51BQ11Lkp2if0=;
        b=mO1uYDaVG8gMSfnFdjBwZTIIUXSWHUU/PV0fguBdbgbx0h798qodWnQVeRMiyxShOn
         una9B+JLYjZCHR4D7mNLddCkbt9/GwbV+a4UK0IvrO2AOLlVY9lK/w+m7i3QQpuivTyL
         xFaHdJRfNbYa2oBCo4OtHU/CLqxRTD250RSW6cB5nCKS5J1YxjVCV2WnFi6ItRcaDkcK
         4tO2EBDshyR2PuWxXgCOpj2WIdrw3x16FnQPEIyzhWsSLGdperoOw21K8G/pfFgcuw+c
         do/87ERHB6ZUVR/zmL5Q8d8mxWeqrUIBWsGk59Ldi97plSXIXviOlFj4T1BWvJaWUYSX
         aoCQ==
X-Gm-Message-State: AGi0Pubyjfnq61DnfUf/PBZh2bPl6Uw7H+Tpfkr2z1cjTYcPhBmcvVLy
        iaBSfh7Rufw/A0NMWIp9zbZt74qG/BJ8SL+vjNJKmw==
X-Google-Smtp-Source: APiQypK2/BS9DNLQgUdve0DnZIP+ggCdF8l9P6mtknH7uy4q8+KLPietCh0cyMKc+/gJFltqkIhzsPf/UxXxP4Q5v8I=
X-Received: by 2002:a19:40d2:: with SMTP id n201mr6168784lfa.82.1588791485423;
 Wed, 06 May 2020 11:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <1480357509-28074-1-git-send-email-johan@kernel.org> <1480357509-28074-12-git-send-email-johan@kernel.org>
In-Reply-To: <1480357509-28074-12-git-send-email-johan@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 May 2020 00:27:53 +0530
Message-ID: <CA+G9fYvBjUVkVhtRHVm6xXcKe2+tZN4rGdB9FzmpcfpaLhY1+g@mail.gmail.com>
Subject: Re: [PATCH net 11/16] net: ethernet: marvell: mvneta: fix fixed-link
 phydev leaks
To:     Johan Hovold <johan@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vince Bridgers <vbridger@opensource.altera.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        Li Yang <leoli@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <blogic@openwrt.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars Persson <lars.persson@axis.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Netdev <netdev@vger.kernel.org>,
        nios2-dev@lists.rocketboards.org,
        open list <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Nov 2016 at 00:00, Johan Hovold <johan@kernel.org> wrote:
>
> Make sure to deregister and free any fixed-link PHY registered using
> of_phy_register_fixed_link() on probe errors and on driver unbind.
>
> Fixes: 83895bedeee6 ("net: mvneta: add support for fixed links")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 0c0a45af950f..707bc4680b9b 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -4191,6 +4191,8 @@ static int mvneta_probe(struct platform_device *pdev)
>         clk_disable_unprepare(pp->clk);
>  err_put_phy_node:
>         of_node_put(phy_node);
> +       if (of_phy_is_fixed_link(dn))
> +               of_phy_deregister_fixed_link(dn);

While building kernel Image for arm architecture on stable-rc 4.4 branch
the following build error found.

drivers/net/ethernet/marvell/mvneta.c:3442:3: error: implicit
declaration of function 'of_phy_deregister_fixed_link'; did you mean
'of_phy_register_fixed_link'? [-Werror=implicit-function-declaration]
|    of_phy_deregister_fixed_link(dn);
|    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
|    of_phy_register_fixed_link

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/541374729

- Naresh
