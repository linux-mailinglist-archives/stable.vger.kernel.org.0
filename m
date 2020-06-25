Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1E20A812
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 00:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407489AbgFYWNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 18:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407480AbgFYWNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 18:13:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A034C08C5C1
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 15:13:41 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x8so2527373plm.10
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 15:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=FMi8HIRU1bG/4UKbi/g8kAakUuymPAGSF1dal1jHofU=;
        b=Oko6Vl1ZWjGZjshO8+lPnQThRx9YYwShYnNUKrx7CUdQYx6IRY3ypg7+C+dedQ+0NZ
         VUXhc25D2S58HhvMLRC3+rkawPp2KXuMxhrgmV7wufv7y2JhgGr81olTVnO1H/rc1zxa
         1xS0taC1jUbnDdmjOl7lpOdMbdc9hedBmQUB0xIA0Hvf1DT1NEK2W0HEI1YdYN1e6Acx
         sIVcsQgH89aELyW3Dxb2xiEsfMUd0RQo91pEXnosZdcRt4Nk8rXd02a1lerGZnQ1tuVc
         ypD5+YyZvsUiNLIDZpc/kbKsGpSwPDorSDp662Pba97ZLUoa+ZVsuQrQBAOygiJXzz6h
         ijXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=FMi8HIRU1bG/4UKbi/g8kAakUuymPAGSF1dal1jHofU=;
        b=nLmEz3HCbf86hk3bQLwX5HXGjk+LqemCd5gzzziRs+Pu8siyk4BQ/g3NAkL1ZyKM2w
         vhCMueGovOBh3P8Gpr0CEg0hXUBiXva6PQVIXRbZ4e7eZIAHzdg92FvIKO8fa4+BkbqV
         s8TU2gxp5l8I7UDml36g/Ckiv7MqBoJ7WMDfb0Nud/Mb4/F5ldVhVKJq9yCQ6oTe4ysY
         KouelBcW7jzHUPxlM2z05BTWyKgpmSWZ3W6E7H+hXvM1OStaW+XcpfqT2jw1LChPKebk
         4VVzY9bKCdJY3lB9KaJPT5HwuRmgRwnSbbAbAAPR5r8auGJhrkJRnCNoh0Hpxk3HRKIv
         wvwg==
X-Gm-Message-State: AOAM532lKTT4R/nBh7axF0pksekHkCRgwsUfPPUX+rw4LkTMaRYqZZPr
        Q42BsaNa9SGG7sKjUvx8InAKJQ==
X-Google-Smtp-Source: ABdhPJwnNaFD1edXu6LP5kTdhLILkBE9maEiAmnp1ujt7nO01MXFGDOlI/t55tREGWqTqwAeK2XUwQ==
X-Received: by 2002:a17:902:8344:: with SMTP id z4mr28515512pln.280.1593123220342;
        Thu, 25 Jun 2020 15:13:40 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id s23sm19673299pfs.157.2020.06.25.15.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 15:13:39 -0700 (PDT)
Date:   Thu, 25 Jun 2020 15:13:39 -0700 (PDT)
X-Google-Original-Date: Thu, 25 Jun 2020 15:13:38 PDT (-0700)
Subject:     Re: [PATCH] clk: sifive: allocate sufficient memory for struct __prci_data
In-Reply-To: <1592875458-5887-1-git-send-email-vincent.chen@sifive.com>
CC:     mturquette@baylibre.com, sboyd@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        linux-riscv@lists.infradead.org, schwab@suse.de,
        vincent.chen@sifive.com, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     vincent.chen@sifive.com
Message-ID: <mhng-af462151-9be0-44c9-aeca-7777d4040d72@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Jun 2020 18:24:17 PDT (-0700), vincent.chen@sifive.com wrote:
> The (struct __prci_data).hw_clks.hws is an array with dynamic elements.
> Using struct_size(pd, hw_clks.hws, ARRAY_SIZE(__prci_init_clocks))
> instead of sizeof(*pd) to get the correct memory size of
> struct __prci_data for sifive/fu540-prci. After applying this
> modifications, the kernel runs smoothly with CONFIG_SLAB_FREELIST_RANDOM
> enabled on the HiFive unleashed board.
>
> Fixes: 30b8e27e3b58 ("clk: sifive: add a driver for the SiFive FU540 PRCI IP block")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> ---
>  drivers/clk/sifive/fu540-prci.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/sifive/fu540-prci.c b/drivers/clk/sifive/fu540-prci.c
> index 6282ee2f361c..a8901f90a61a 100644
> --- a/drivers/clk/sifive/fu540-prci.c
> +++ b/drivers/clk/sifive/fu540-prci.c
> @@ -586,7 +586,10 @@ static int sifive_fu540_prci_probe(struct platform_device *pdev)
>  	struct __prci_data *pd;
>  	int r;
>
> -	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> +	pd = devm_kzalloc(dev,
> +			  struct_size(pd, hw_clks.hws,
> +				      ARRAY_SIZE(__prci_init_clocks)),
> +			  GFP_KERNEL);
>  	if (!pd)
>  		return -ENOMEM;

This is on fixes, thanks!
