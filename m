Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E232262874
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 09:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIIHWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 03:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgIIHWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 03:22:33 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766ACC061573;
        Wed,  9 Sep 2020 00:22:32 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lo4so2030745ejb.8;
        Wed, 09 Sep 2020 00:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rO8zY4SOk/PyIA4prlUmHLVh2+ctXvivZUrMTHOdfHA=;
        b=MskrfZnZsX7Iuf32LZyCZNzbIGXaeW+mK14mUDqYgOSribmqAZDvmz6KL5ttLjqipX
         0HopvRMl/pbef4OquOPAaByTp17ipnjqwMBRTDF5vqky3Dq5MqT4nfy6qxe8qVvr8lQw
         NkfivOti0pWe4NwtLb/25Q40m9Yhaj4s3RJIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rO8zY4SOk/PyIA4prlUmHLVh2+ctXvivZUrMTHOdfHA=;
        b=D2Nbfm6vR2Ir+mJJqwOJLvL1aQKTl2wEL4P8bzatz3TTEOubwz7xwABpW7T467RHEQ
         V9Z2bTj1voh0f07uQjBWe2uq0HA0Awtt1rOPMfr+GLoiL25K3fIRVdlY/H3H9LSxY3RR
         e9y0+H1PLt8RBNq0obdvHDBCXy71+U5ob8CNUh77GddBg0gotZeMjM/v5Zkj4/p/BILQ
         XAdJQFylFN8s6UttWcOxv5NbA115MEcZDoN/e4yc4KV95IyoTHIryG8BkwCFzVL+5q+2
         DZW1y3K2qyestvjwyIuTEyxd+hIzjWuJpZl0roeSePgoLX5zYjrCf2JQecqYSmBEqQjP
         TX7w==
X-Gm-Message-State: AOAM532ZCdybSw4ccKP4NVLLlGSNZlahm2PuM0ms8a2i9j75tXaONwDY
        vuzfIg86Tc5AQ/zpKkpofie3lWYoA29MO1Ppb0NF487K
X-Google-Smtp-Source: ABdhPJzG8i0Ylu6Upc12ayDxcIwkT9Rb3MGN1wQb3dn2PS0s9yBulo2UK0UfKwHfUno3cr8owVw38kBJQrVRgFCbzL0=
X-Received: by 2002:a17:906:4c58:: with SMTP id d24mr2472778ejw.108.1599636151097;
 Wed, 09 Sep 2020 00:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200812112400.2406734-1-joel@jms.id.au> <1e56af7945b93a22e31ba6d81da82cbdb1b237b6.camel@ozlabs.org>
In-Reply-To: <1e56af7945b93a22e31ba6d81da82cbdb1b237b6.camel@ozlabs.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 9 Sep 2020 07:22:19 +0000
Message-ID: <CACPK8XfZ6hLv0Ls0g=b5wdr6A3ei3nzVKDgyOt5Su_Y8g8yQ7A@mail.gmail.com>
Subject: Re: [PATCH] ARM: aspeed: g5: Do not set sirq polarity
To:     Jeremy Kerr <jk@ozlabs.org>
Cc:     Oskar Senft <osk@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Aug 2020 at 06:27, Jeremy Kerr <jk@ozlabs.org> wrote:
>
> Hi Joel,
>
> > A feature was added to the aspeed vuart driver to configure the vuart
> > interrupt (sirq) polarity according to the LPC/eSPI strapping register.
> >
> > Systems that depend on a active low behaviour (sirq_polarity set to 0)
> > such as OpenPower boxes also use LPC, so this relationship does not
> > hold.
> >
> > The property was added for a Tyan S7106 system which is not supported
> > in the kernel tree. Should this or other systems wish to use this
> > feature of the driver they should add it to the machine specific device
> > tree.
> >
> > Fixes: c791fc76bc72 ("arm: dts: aspeed: Add vuart aspeed,sirq-polarity-sense...")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
>
> LGTM. I've tested this on the s2600st, which is strapped for eSPI. All
> good there too, as expected.
>
> Tested-by: Jeremy Kerr <jk@ozlabs.org>
>
> and/or:
>
> Reviewed-by: Jeremy Kerr <jk@ozlabs.org>

Thanks Jeremy. I have queued this for 5.10 and applied it to the openbmc tree.

We should also remove the code from the aspeed-vuart driver, as it is
not correct. Better would be a property that is set according to the
system's hardware design.

Cheers,

Joel
