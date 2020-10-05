Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64BC283176
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 10:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgJEIFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 04:05:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53618 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgJEIFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 04:05:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id f21so2311520wml.3;
        Mon, 05 Oct 2020 01:05:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=epaOtiR7tFx4/XOOg9iXSMt8xfS4r3yEvrrCUOibwn8=;
        b=bWmcQTR/zFK58sPVE+7DRSXnwxmbYrCde8z3owfsnE+yPmVm84mw2e9hdu0Yw0oXne
         dIaMu6FQf2c1x0sT4ZD4H/k/5YBoThbAdJbIjQRPXH4Q/eEnM98rMIeCD4otYztt3k6G
         /77hH/UQ37wsD4P3UA2zLmEXbtZtGBM2Jxv/Rf2hFRVEFA5O5nC99i0nx1/PldIDWHX6
         nMACE1zC65axOUvHtuW7YZ3W6PnwGJGvp5YfTA6Fkf2h9ZUt1K2QyE/An+nSF23bmUKS
         CuOSG+52nwBBeBkM5V8RGn/MZV9qaQmuhWgGhs3sSx4NHJBYlkN66VPFAVtipp8IIx3z
         EwgQ==
X-Gm-Message-State: AOAM531/4v2XnJwkfm1tzhbN3yW+ZpYcAfo+LOwF8CJ0fGtc5Y+kjgN+
        Q4HNYB+ZrGbZ0irpEWir3V4=
X-Google-Smtp-Source: ABdhPJxQiC77o6IdaUGbmW18uKR5W+lznFvVF0rPnHifJ2GCzGskfXFyZq/guojTAJI0eU35JbvMoA==
X-Received: by 2002:a7b:cf04:: with SMTP id l4mr6794958wmg.137.1601885144602;
        Mon, 05 Oct 2020 01:05:44 -0700 (PDT)
Received: from kozik-lap ([194.230.155.194])
        by smtp.googlemail.com with ESMTPSA id u188sm7538987wmu.0.2020.10.05.01.05.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Oct 2020 01:05:43 -0700 (PDT)
Date:   Mon, 5 Oct 2020 10:05:41 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201005080541.GA7135@kozik-lap>
References: <20201002152305.4963-1-ceggers@arri.de>
 <20201002152305.4963-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201002152305.4963-2-ceggers@arri.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 02, 2020 at 05:23:03PM +0200, Christian Eggers wrote:
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/i2c/busses/i2c-imx.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)


Tested (not extensively) on Vybrid VF500 (Toradex VF50):
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>

The I2C on Vybrid VF500 still works fine. I did not test this actual
condition (arbitration) but only a regular I2C driver (BQ27xxx fuel
gauge).

Best regards,
Krzysztof

