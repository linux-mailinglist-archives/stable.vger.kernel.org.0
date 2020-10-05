Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F808283184
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 10:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgJEIHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 04:07:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35327 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEIHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 04:07:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id y15so7776155wmi.0;
        Mon, 05 Oct 2020 01:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AG8hP+MezQ849TpBpF7ybR9g9DALSYRtEfvkXe75nk4=;
        b=QJGY3LZLY9zQXuAlWKsB7H1/qG2t+waEBRcRWCRSdVjZtmXucyn0Zs3j2IJFDCYkRg
         Evj0qm6T6tmd5Fq3tw2IgpwSNS7IXn8+PCW0a3Z+8vWzDRBBqr15zYBzlebYt4aQ/fmy
         OEw4cwmS0dJHu5DcoNQTdKTWvgsrNQizQ/J3T7pEAr/zy59kGpTEQFuk9ertgPCAi8oT
         hGsifJQTo4nFGc1nnyJlKe16axSvwO4520A55ynnrPs0KGJ7sG6Y4ur7Xh/HOcfAg+Ka
         YqNdK6z1iMN5pL1Znxwo5QeJvVPMe8kndFb6CHO8xaVqTa0aBAahR40uB39t2JU4SnEC
         3CuQ==
X-Gm-Message-State: AOAM531Da2ueSRyZNwsSVgnveiO4virsnlBvSB2lqJ6cizJXFjgLZEvs
        ZCjOWHcsa1FGZKQDrB9VAqk=
X-Google-Smtp-Source: ABdhPJz0EMxPP196puOZzbWz1QWSvH4Y5YFa5lgdP6kVwE0lTzseA0j+Dt236zq0xwzGSLA9GVLNtA==
X-Received: by 2002:a05:600c:230a:: with SMTP id 10mr5056204wmo.151.1601885248796;
        Mon, 05 Oct 2020 01:07:28 -0700 (PDT)
Received: from kozik-lap ([194.230.155.194])
        by smtp.googlemail.com with ESMTPSA id c16sm12558625wrx.31.2020.10.05.01.07.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Oct 2020 01:07:27 -0700 (PDT)
Date:   Mon, 5 Oct 2020 10:07:25 +0200
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
Subject: Re: [PATCH v2 2/3] i2c: imx: Check for I2SR_IAL after every byte
Message-ID: <20201005080725.GB7135@kozik-lap>
References: <20201002152305.4963-1-ceggers@arri.de>
 <20201002152305.4963-3-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201002152305.4963-3-ceggers@arri.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 02, 2020 at 05:23:04PM +0200, Christian Eggers wrote:
> Arbitration Lost (IAL) can happen after every single byte transfer. If
> arbitration is lost, the I2C hardware will autonomously switch from
> master mode to slave. If a transfer is not aborted in this state,
> consecutive transfers will not be executed by the hardware and will
> timeout.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/i2c/busses/i2c-imx.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 

Tested (not extensively) on Vybrid VF500 (Toradex VF50):
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>

The I2C on Vybrid VF500 still works fine. I did not test this actual
condition (arbitration) but only a regular I2C driver (BQ27xxx fuel
gauge). Obviously this only proves that regular operation is not
broken...

Alternatively if you have a specific testing procedure (reproduction of
a problem), please share.

Best regards,
Krzysztof
