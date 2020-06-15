Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A641B1F9A06
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgFOOXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729733AbgFOOXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:23:41 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19887C061A0E;
        Mon, 15 Jun 2020 07:23:41 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id mb16so17659210ejb.4;
        Mon, 15 Jun 2020 07:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H9r0/sULFGsJQ0VS718x6ZAIaeQpzmxSr4ry5tlo8dA=;
        b=iTGuFP6o46kqSb7OX7uzryGWmBxBXqSo1GjexOIOIdYAkPEkR6ag3kHRccJgj51job
         IneqsherdA5JHsGp9gCUnITzRDzNGpHHUreaVA/swlF0+Z97dVzqwtpCZoLSPT21Ex+B
         oWOA3pkQ48zu3NtCgeg+0KkRHjQJYQtb7OqLkQwds3xGr5pGQNI20mRCIruFkZGFtHyg
         jJ77Ug1sfREkx0oD6ykfBDtCAIIIksvI16gYrJd0A+AZ022JH5wj6l+riUyZQTC6h+1b
         aS25R0XwLX8ltDveG25Y5DTzfdyxB8qo7hgE1p/5YjszAmaI7fDcewFKnXXKhfjTs8Hw
         k3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H9r0/sULFGsJQ0VS718x6ZAIaeQpzmxSr4ry5tlo8dA=;
        b=ZQG0CnDlsf7Bkw9No2ZQT2MNUfzu+WvyYqxErP/4APq6eR+ziyiJOwhuhwy3OOPC5Z
         Tzyh5VP630t5sGAae2JWweEEMGjzCW/qWT5cppPF2RurKA7qp0m+Fvv7KteIi9lmP4E2
         DU6vYlOQrxOvXSRRbEmZ7MkpS2+Vb2elWzH451+yfG8WGVrtMDLR+qiLOP/w4u9Ibrau
         RD1lcCer7UsCt/niTKT3uW1rms9jvvb9e9AKniCsPPNiRR4jCZ+nybG6pDHsD2YnEDE/
         0WOOjZJJk+xigzNJdT8SQIr9ih+foVdK92ouBwRbJ21WAlzC209dj7liHxYMMZ573D2M
         uHcg==
X-Gm-Message-State: AOAM532mnKr4H5YAQsA3vGa2e92Dlynsk6oXTxWUnCY5ECZSF02ARErZ
        K3w7UL9hjv1HKo9BNUfNtfoQp6VvZqD597hDVaQ=
X-Google-Smtp-Source: ABdhPJzYgleQ7Vn71c+CU11+ki0tmdv62jr2mfK0iQcj82yKU7B8iZmt/xGz58Y/kQv8GDe9O5ngIdCHH2iTvTZVjC8=
X-Received: by 2002:a17:906:198d:: with SMTP id g13mr13150059ejd.281.1592231019420;
 Mon, 15 Jun 2020 07:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de> <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131006.GR4447@sirena.org.uk> <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
 <20200615134119.GB3321@kozik-lap>
In-Reply-To: <20200615134119.GB3321@kozik-lap>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 17:23:28 +0300
Message-ID: <CA+h21hp29i=AdZB_fBQ4mwAh=3Oovopwz3ruzzJqiKpRpZYzhg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 at 16:41, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Jun 15, 2020 at 04:12:28PM +0300, Vladimir Oltean wrote:
> > On Mon, 15 Jun 2020 at 16:10, Mark Brown <broonie@kernel.org> wrote:
> >
> > >
> > > It's a bit unusual to need to actually free the IRQ over suspend -
> > > what's driving that requirement here?
> >
> > clk_disable_unprepare(dspi->clk); is driving the requirement - same as
> > in dspi_remove case, the module will fault when its registers are
> > accessed without a clock.
>
> In few cases when I have shared interrupt in different drivers, they
> were just disabling it during suspend. Why it has to be freed?
>
> Best regards,
> Krzysztof
>

Not saying it _has_ to be freed, just to be prevented from running
concurrently with us disabling the clock.
But if we can get away in dspi_suspend with just disable_irq, can't we
also get away in dspi_remove with just devm_free_irq?

-Vladimir
