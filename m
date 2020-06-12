Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E1B1F76D1
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 12:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgFLKjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 06:39:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33692 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgFLKjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 06:39:55 -0400
Received: by mail-ed1-f67.google.com with SMTP id o26so6078351edq.0;
        Fri, 12 Jun 2020 03:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bBguARwUO/wHNwoTqDLDR0r7qkZEicJBKW50tLs1qxM=;
        b=UhNlcgq/malkxkd41EAeM1MkRhuRc06clbbn7cYVHpHeOfVZzsIE4wVo3r2DE/mPc1
         fPLiWgifElVOQHere7aocDzDhKCEXMeSctOxHlRmZgH5TS5NXltQd/mi20n5hGw0oiDL
         atbIgq82i4Z+frLkKHTtOm75k2YnFsseTXxsvcTYXegH6g6nHAu+O70lWa9LkVdAIfXZ
         drOW1ZqNFhRDJW3Swk6bqY7Qah/P9LHu7UdJp9k9ucvyiiUgbEeMPjjzL9eWGRdcHnzQ
         3hNmAoReaX55XC8ZKHKgMvW91FHx+/Kq8243RoUhES0ge0vIMzwvZ8YJbFwK5Tr36g6V
         jGPg==
X-Gm-Message-State: AOAM533LUtvyxeJ3V89fcWnTMKF8/56LTCC8JczzwT1yPIoYL7Zk4g6q
        XvN745p7gM3wDJa3kl7Eqs4=
X-Google-Smtp-Source: ABdhPJxUutltGtDoTvlpjvOa5B+zbRtPHYPgbVfuqRWP8igjMXRPh0MsA09sbMQFUVf8LtHUBKErmw==
X-Received: by 2002:a50:fd19:: with SMTP id i25mr10916965eds.248.1591958392580;
        Fri, 12 Jun 2020 03:39:52 -0700 (PDT)
Received: from pi3 ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id qp15sm3379298ejb.69.2020.06.12.03.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 03:39:51 -0700 (PDT)
Date:   Fri, 12 Jun 2020 12:39:49 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Wolfram Sang <wsa@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612103949.GB26056@pi3>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato>
 <20200612102113.GA26056@pi3>
 <20200612103149.2onoflu5qgwaooli@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200612103149.2onoflu5qgwaooli@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 12:31:49PM +0200, Oleksij Rempel wrote:
> On Fri, Jun 12, 2020 at 12:21:13PM +0200, Krzysztof Kozlowski wrote:
> > On Fri, Jun 12, 2020 at 11:56:04AM +0200, Wolfram Sang wrote:
> > > On Fri, Jun 12, 2020 at 11:29:41AM +0200, Krzysztof Kozlowski wrote:
> > > > On Fri, Jun 12, 2020 at 11:05:17AM +0200, Wolfram Sang wrote:
> > > > > On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> > > > > > If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
> > > > > 
> > > > > That code is disabled since 2011 (6d83f94db95c ("genirq: Disable the
> > > > > SHIRQ_DEBUG call in request_threaded_irq for now"))? So, you had this
> > > > > without fake injection, I assume?
> > > > 
> > > > No, I observed it only after enabling DEBUG_SHIRQ (to a kernel with
> > > > some debugging options already).
> > > 
> > > Interesting. Maybe probe was deferred and you got the extra irq when
> > > deregistering?
> > 
> > Yes, good catch. The abort happens right after deferred probe exit.  It
> > could be then different reason than I thought - the interrupt is freed
> > through devm infrastructure quite late.  At this time, the clock might
> > be indeed disabled (error path of probe()).
> 
> This line looks suspicious to me:
>  Unhandled fault: external abort on non-linefetch (0x1008) at 0x8882d003
> 
> 0x8882d003 looks like not initialized pointer.
> The only not initialized value at devm_request_irq stage is i2c_imx->queue.

The queue should be good at this time because it is part of i2c_imx
which is allocated before interrupt (so freed after interrupt).

Like Wolfram suggested, the interrupt comes because of deferred probe.
The only solution would be to free the IRQ in error path... and in
driver remove.

This basically kills the concept of devm for interrupts. Some other
drivers experience exactly the same pattern. I now reproduced it on
unbind of dspi driver of VF5xx:

echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
[  218.391867] Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
...
[  218.754493] [<806185c4>] (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
[  218.820049] [<80678c64>] (dspi_interrupt) from [<8017acec>] (free_irq+0x26c/0x3cc)
[  218.827853]  r5:86312200 r4:85a71d40
[  218.831602] [<8017aa80>] (free_irq) from [<8017dcec>] (devm_irq_release+0x1c/0x20)
[  218.839420]  r10:805f91fc r9:8630dac8 r8:8630dac8 r7:805f9214 r6:8630d810 r5:85a54780
[  218.847468]  r4:85a54800
[  218.850152] [<8017dcd0>] (devm_irq_release) from [<805f98ec>] (release_nodes+0x1e4/0x298)

Best regards,
Krzysztof

