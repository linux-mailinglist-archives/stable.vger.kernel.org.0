Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECCE1F8891
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 13:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgFNLSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 07:18:37 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:34814 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgFNLSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 07:18:34 -0400
Received: by mail-ej1-f68.google.com with SMTP id l27so14445899ejc.1;
        Sun, 14 Jun 2020 04:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RIFF4j/xVkbSoEupEMJWQwCtcJ6Ciw3Gx6G2a1v2FLM=;
        b=shy0jRs5tmAcLvIyiCLYDNY6Z0HEmNQ1dGoXyGIgIsefAidlFNa0Z6GrnBGYJVYNRv
         11BRi45GHV8ofTFw/TqB8/hJP+xFLBkYYHqd9270U0xBTKO31ejgt8wHPImKcOk1MgGN
         Ffit0Hs/tT2XsYJMeIbKt0sAVaW9slQ7Z1utoQ+K4QbO40K+E6/5TmdfAizt8izSLxOM
         DQ1isV7czYk8samvcdP+DDBzQzIgdLVXPu9hjkcQX9ikUX3+Nu9DdvElkZ2hwEtvi/3d
         r7E+oqit4z9lIU3vmLvIN/6DCLrtp1H5Ua23K/vkLushzjDxx3g6W7+vdcvi9ZEO4viW
         QiPg==
X-Gm-Message-State: AOAM530dGmgt6A+e5Nj5WoLNSfKzTuvXT3+264VsGSZq8GT8FdeWtr3y
        oQZ2br39MdkjHzj6AqsBo4Q=
X-Google-Smtp-Source: ABdhPJyx2PziyboNC1/CM1nmSMa2PZwolIctqdqrNergoKfwIqM/V2WZ9SSMfxwS3HDj1MTJwBzEZg==
X-Received: by 2002:a17:906:6d19:: with SMTP id m25mr20751602ejr.524.1592133512468;
        Sun, 14 Jun 2020 04:18:32 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id y62sm6397943edy.61.2020.06.14.04.18.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Jun 2020 04:18:31 -0700 (PDT)
Date:   Sun, 14 Jun 2020 13:18:29 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
Message-ID: <20200614111829.GA9694@kozik-lap>
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org>
 <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 02:14:15PM +0300, Vladimir Oltean wrote:
> On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > If interrupt fires early, the dspi_interrupt() could complete
> > (dspi->xfer_done) before its initialization happens.
> >
> > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > ---
> 
> Why would an interrupt fire before spi_register_controller, therefore
> before dspi_transfer_one_message could get called?
> Is this master or slave mode?

I guess practically it won't fire.  It's more of a matter of logical
order and:
1. Someone might fix the CONFIG_DEBUG_SHIRQ_FIXME one day,
2. The hardware is actually initialized before and someone could attach
   to SPI bus some weird device.

Best regards,
Krzysztof

