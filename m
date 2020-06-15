Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45861F9926
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgFONl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:41:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39964 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730144AbgFONl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:41:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id h5so17211889wrc.7;
        Mon, 15 Jun 2020 06:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ldZ3qHesEPGPxRDy2PP+eNgQCVg0OujHEQewstkBEeU=;
        b=jA5k23mlbwIzkQE4LMtlQnpaoBh53mSiTfiId1dOw8Mf2cErvL1nzI+UjNswKEwgO6
         FPV4SF85jTtX3Cl31PQz++97s2ouDRvaGms2ThOWd5DBG4baTMwDrsk/oVkjpddxLyth
         npGk2RY+ieASVplZEd0bTOx91lUDX/xvlmJqOSYFD9iZXuXs7pssjnhI80lWkJ0d0Eky
         E7ZlnXxy1jpy4XhZ6Nv4cFzWdZAStzxBD1tLDgUU1GT95hdXMFFeBOIbeXp0dSk243W4
         i+fty3zoSFWv/7JDB0vtlcLIlX2LUFFknQgXw8KUQ311LADnL6rcV3//idIk9zD+tDyp
         xeRw==
X-Gm-Message-State: AOAM531lBy6rLnL+wEUfwVqa5MvRtTsvB8uOWaYuwyI7ZDL0azv9+MMG
        tmef1QIui/lAPZgdo+q3MFk=
X-Google-Smtp-Source: ABdhPJxEQoPl9fMwozzagAz4U4ysT/MZSAaF26yHkz0oVX6eTwy/fgnKn3eGxjmHAf/0JWCAxrTRGw==
X-Received: by 2002:adf:9205:: with SMTP id 5mr27655753wrj.232.1592228485925;
        Mon, 15 Jun 2020 06:41:25 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id 104sm25964040wrl.25.2020.06.15.06.41.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 06:41:25 -0700 (PDT)
Date:   Mon, 15 Jun 2020 15:41:19 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on
 interrupt in exit paths
Message-ID: <20200615134119.GB3321@kozik-lap>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
 <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131006.GR4447@sirena.org.uk>
 <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 04:12:28PM +0300, Vladimir Oltean wrote:
> On Mon, 15 Jun 2020 at 16:10, Mark Brown <broonie@kernel.org> wrote:
> 
> >
> > It's a bit unusual to need to actually free the IRQ over suspend -
> > what's driving that requirement here?
> 
> clk_disable_unprepare(dspi->clk); is driving the requirement - same as
> in dspi_remove case, the module will fault when its registers are
> accessed without a clock.

In few cases when I have shared interrupt in different drivers, they
were just disabling it during suspend. Why it has to be freed?

Best regards,
Krzysztof

