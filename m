Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5239027620F
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 22:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIWU1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 16:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgIWU1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 16:27:42 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B694C0613CE;
        Wed, 23 Sep 2020 13:27:42 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id e22so1110644edq.6;
        Wed, 23 Sep 2020 13:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RLmDO0N9ccoJ8u92C25jHjrEVWeg8b6n7yD+xz6k+6Q=;
        b=R4uunmiDiELoVRTK827oOM2OMeXozrpPuXoZZcSF5pgIdW8NYAxGFzg3nSNbZrx45g
         pOMecXhBY11U3aILDB0bY+hGPhL13YUWLIaBRmvg9OX0KKgoY+wDsUI0MU+xQ1lFCI6T
         8+i3FtRwPhBuygoYwV24I/aeVyesVkyx4nOaci7WI/+TDBioBAU2a9HEbif38XHLpwxX
         uPcl7fsa+BR/7TZW/swADfQ9+JrZF2XFnxZBn57c31JfaWxnQGqdCSTVYTywws23bBap
         safe//+Lkqq/XJAsUq523v/LZl4HaQosc1H+oUsMhLGGh3Rw4IR7MPn4VymTBxTWvYX1
         OxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RLmDO0N9ccoJ8u92C25jHjrEVWeg8b6n7yD+xz6k+6Q=;
        b=o8XEF7uD8XFhYFld8Vj4Mry2bTUmntHconJuixoAYHStcHAfqwsrTOyjCDQ+FhrvZf
         YZxTiyBysH5HTxuyuUi38PltF1+TjS59uTkF5eNo0e/OGWx6otJJnoS9KPVVtizKE9/Z
         QBu8hNYI+jbC8Mp9+KBvuU5xDoiAqHWPhxQU3vlN+VnRBel4PsbKLYoLPq1qPucK8z74
         E5rCM4AmLTJbhRndVtGQFYFKuGouTDcqHXKcwwwgC7WtiTsrnln2gE0+leIR4k45xzbp
         kLjBKnZBTc6QWetpgBx2enP1LyoS7oq25Uz5SgH+W7MtBqe3Cza1rVwbRCffHPOl/UYV
         Y1WQ==
X-Gm-Message-State: AOAM532saLTy214ViI63eg5+bC2jJHr1U1Lr/0qrcAxaNP0ivgExuPCv
        uUkt5hP1YKe2+scRdzUj5tUmk2g79qE=
X-Google-Smtp-Source: ABdhPJzihFfmrxDThRVVULdh2IhBYV10mRR9tpYrkebJinnFPte5DuLo1wiPQv0HxGX0M2zxoLLi0A==
X-Received: by 2002:aa7:c61a:: with SMTP id h26mr1114145edq.254.1600892861107;
        Wed, 23 Sep 2020 13:27:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:9dd1:2d79:8cda:7fd2? (p200300ea8f2357009dd12d798cda7fd2.dip0.t-ipconnect.de. [2003:ea:8f23:5700:9dd1:2d79:8cda:7fd2])
        by smtp.googlemail.com with ESMTPSA id r9sm708481ejc.102.2020.09.23.13.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 13:27:40 -0700 (PDT)
Subject: Re: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        broonie@kernel.org, npiggin@gmail.com
Cc:     linux-spi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ec77cf82-5ef1-c650-3e8a-80be749c2214@gmail.com>
Date:   Wed, 23 Sep 2020 22:27:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.09.2020 02:28, Chris Packham wrote:
> The SPIE register contains counts for the TX FIFO so any time the irq
> handler was invoked we would attempt to process the RX/TX fifos. Use the
> SPIM value to mask the events so that we only process interrupts that
> were expected.
> 
> This was a latent issue exposed by commit 3282a3da25bd ("powerpc/64:
> Implement soft interrupt replay in C").
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Cc: stable@vger.kernel.org
> ---
> 
> Notes:
>     I've tested this on a T2080RDB and a custom board using the T2081 SoC. With
>     this change I don't see any spurious instances of the "Transfer done but
>     SPIE_DON isn't set!" or "Transfer done but rx/tx fifo's aren't empty!" messages
>     and the updates to spi flash are successful.
>     
>     I think this should go into the stable trees that contain 3282a3da25bd but I
>     haven't added a Fixes: tag because I think 3282a3da25bd exposed the issue as
>     opposed to causing it.
> 
>  drivers/spi/spi-fsl-espi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
> index 7e7c92cafdbb..cb120b68c0e2 100644
> --- a/drivers/spi/spi-fsl-espi.c
> +++ b/drivers/spi/spi-fsl-espi.c
> @@ -574,13 +574,14 @@ static void fsl_espi_cpu_irq(struct fsl_espi *espi, u32 events)
>  static irqreturn_t fsl_espi_irq(s32 irq, void *context_data)
>  {
>  	struct fsl_espi *espi = context_data;
> -	u32 events;
> +	u32 events, mask;
>  
>  	spin_lock(&espi->lock);
>  
>  	/* Get interrupt events(tx/rx) */
>  	events = fsl_espi_read_reg(espi, ESPI_SPIE);
> -	if (!events) {
> +	mask = fsl_espi_read_reg(espi, ESPI_SPIM);
> +	if (!(events & mask)) {
>  		spin_unlock(&espi->lock);
>  		return IRQ_NONE;

Sorry, I was on vacation and therefore couldn't comment earlier.
I'm fine with the change, just one thing could be improved IMO.
If we skip an unneeded interrupt now, then returning IRQ_NONE
causes reporting this interrupt as spurious. This isn't too nice
as spurious interrupts typically are seen as a problem indicator.
Therefore returning IRQ_HANDLED should be more appropriate.
This would just require a comment in the code explaining why we
do this, and why it can happen that we receive interrupts
we're not interested in.

>  	}
> 

