Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7650324D613
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 15:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgHUN3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 09:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbgHUN3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 09:29:53 -0400
X-Greylist: delayed 523 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Aug 2020 06:29:52 PDT
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F8C061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 06:29:52 -0700 (PDT)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 449775C0160;
        Fri, 21 Aug 2020 15:21:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1598016060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAmn351OrHHZYEgU6zTRjzq0M49ckKbBSek16/Foebc=;
        b=mKcMiFnbPzsC8l9AFLdkncUV9EmSxcMITYQK9r8Mbook20kfNTEZhAmXrE/rB2GmTuYNog
        4opHaOqUBdcKd5HT9d65OES7IknI6F77qRH604l5v04B6LM8tDr9Jedh5GgCk7i1F6n9Mn
        eXKlbEnYBy2ozI6ebEvEx28pmLwTem4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date:   Fri, 21 Aug 2020 15:20:59 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        robh+dt@kernel.org, andrew.smirnov@gmail.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, festevam@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: vfxxx: Add syscon compatible with ocotp
In-Reply-To: <20200820041055.75848-1-cphealy@gmail.com>
References: <20200820041055.75848-1-cphealy@gmail.com>
User-Agent: Roundcube Webmail/1.4.1
Message-ID: <1bf1c9664d8c376c87dc55aeb27da6e4@agner.ch>
X-Sender: stefan@agner.ch
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-20 06:10, Chris Healy wrote:
> From: Chris Healy <cphealy@gmail.com>
> 
> Add syscon compatibility with Vybrid ocotp node. This is required to
> access the UID.

Hm, it seems today the SoC driver uses the specific compatible. It also
should expose the UID as soc_id, see drivers/soc/imx/soc-imx.c.

Maybe it does make sense exposing it as syscon, but then we should
probably also adjust
Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt.

--
Stefan

> 
> Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Healy <cphealy@gmail.com>
> ---
> Changes in v2:
>  - Add Fixes line to commit message
> 
>  arch/arm/boot/dts/vfxxx.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
> index 0fe03aa0367f..2259d11af721 100644
> --- a/arch/arm/boot/dts/vfxxx.dtsi
> +++ b/arch/arm/boot/dts/vfxxx.dtsi
> @@ -495,7 +495,7 @@ edma1: dma-controller@40098000 {
>  			};
>  
>  			ocotp: ocotp@400a5000 {
> -				compatible = "fsl,vf610-ocotp";
> +				compatible = "fsl,vf610-ocotp", "syscon";
>  				reg = <0x400a5000 0x1000>;
>  				clocks = <&clks VF610_CLK_OCOTP>;
>  			};
