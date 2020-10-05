Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6E12831B7
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgJEIQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 04:16:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55265 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 04:16:45 -0400
Received: by mail-wm1-f65.google.com with SMTP id p15so3132612wmi.4;
        Mon, 05 Oct 2020 01:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=so3Q2iStLANQzUsWPJtNOkoc+zx5z4LsFtN/g7RdwuA=;
        b=Yb1QZxxkooLudEnk8XN6HPSfmEsrM9EL59bf2/392ELo2GDinoakbX9PgcBJjbI5st
         xxr3lcdNiWhjHtghgEAjwQmyfe3aCWtaJM+mMO4K3BX3d6Z5eaU5jx0W8ZR8/jvSffEd
         XnjVHyd0XkQ6BUR6kMQvm394XVa1oQbQCWldRigxltOR4n5chjMbPaFzW3poN+YQpiaJ
         qU4j9kmCxMjyaz0O4K/i0PK9lNDkjHuVRackFUekA/AQ2oiGGdHe1dAI+vWkIFpy0FZR
         /Z97mF9MMchmOqxVu0nsqhsnao2HzD+O/X+RlxAnuBman4qgU7I0qp0nadjm2MSRR6r6
         J8+A==
X-Gm-Message-State: AOAM533YN76uQDYP+/GNqwOsIgQGnJlbpTONyxXdszuZTbsU6iH3/uBT
        /ajAyb3efunjvk5Se8ndjTw=
X-Google-Smtp-Source: ABdhPJy1FDIel9WhtFJmJd9CyAQEOlK6fIY5XuLZ0pflqjU2ZvCyXQDazBGV4roSAtjoCmXu+DoPFw==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr16442283wma.165.1601885803104;
        Mon, 05 Oct 2020 01:16:43 -0700 (PDT)
Received: from kozik-lap ([194.230.155.194])
        by smtp.googlemail.com with ESMTPSA id c130sm873401wma.17.2020.10.05.01.16.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Oct 2020 01:16:41 -0700 (PDT)
Date:   Mon, 5 Oct 2020 10:16:39 +0200
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
Subject: Re: [PATCH v2 3/3] i2c: imx: Don't generate STOP condition if
 arbitration has been lost
Message-ID: <20201005081639.GA7431@kozik-lap>
References: <20201002152305.4963-1-ceggers@arri.de>
 <20201002152305.4963-4-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201002152305.4963-4-ceggers@arri.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 02, 2020 at 05:23:05PM +0200, Christian Eggers wrote:
> If arbitration is lost, the master automatically changes to slave mode.
> I2SR_IBB may or may not be reset by hardware. Raising a STOP condition
> by resetting I2CR_MSTA has no effect and will not clear I2SR_IBB.
> 
> So calling i2c_imx_bus_busy() is not required and would busy-wait until
> timeout.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org # Requires trivial backporting, simple remove
>                            # the 3rd argument from the calls to
>                            # i2c_imx_bus_busy().
> ---
>  drivers/i2c/busses/i2c-imx.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 

Tested (not extensively) on Vybrid VF500 (Toradex VF50):
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>

The I2C on Vybrid VF500 still works fine (also bigger transfers). I did
not test this actual condition (arbitration) but only a regular I2C
driver (BQ27xxx fuel gauge). Obviously this only proves that regular
operation is not broken...

Best regards,
Krzysztof
