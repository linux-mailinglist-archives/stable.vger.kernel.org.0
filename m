Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E701F9800
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgFONMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFONMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:12:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58783C061A0E;
        Mon, 15 Jun 2020 06:12:40 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o15so17359370ejm.12;
        Mon, 15 Jun 2020 06:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2h9e+eGSGjdU1mcqeHyapMumElVznZdYrWvaheMOzqI=;
        b=Q0ksf44c9R2gEIuPhfga4T8ZPy44bz9mmNtp5TrPqDt0zy3h3IYsdGw9dHQqxds82u
         GXvbnM1Xi0b4b2hnB+w0kK9TP2zzxgEd7aaKnL1apOKaxXSRP597wQvtvGUcshJe7eLf
         nQHKS0rsn3X77V3PpALQ4kbe3cu7P5+fJEn9QedYTiTcSfSltGufbwjelvjcFs7S3oHs
         S0YtSc/PKNDKe6x5BVXj3Moivdikrn7JLpMDmuv6sZibjsgcA8r5k/xU2rZxw4NblVx8
         xqf5YoHfv7Z8oDB/H8XE9qEmNCnG8Zl+hll1ZDQb8jnJ/sitZKyIYoYqp9pVF2kvz1wI
         abyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2h9e+eGSGjdU1mcqeHyapMumElVznZdYrWvaheMOzqI=;
        b=gOgEXX4r3nkT6+sXKRqOjceV1XZ8+RkJysFPzQiUF1sFaBFB5Uzjx2iPR8IJ4By2Ye
         XnXQ9Q5RPo8j0nP7ezROKAUfNnf0w7h3CFlGfidc40WIR9v1A32FY3Am5NI5U8iM/u3c
         /c2Uug7ngbJOAG3+RyckxqVnllSQgVqICdgWhQiyIQPv1RNtE9D2KxfN8BWPb4rBfCqf
         8p5gyEZRv9a0J6+OOCnbCfnTFYwLpVZw1YF5u4a26KBqB06sCqpSFyeNOKfEviPed9sx
         TMH5ArTKw+doES/rX6pQ1bftNuxRj6IcvU2CbR+bBfh2giwgFlD32WYtnnbRUsOuskeQ
         Jucg==
X-Gm-Message-State: AOAM530hFyaRwr7AeE1XQvNfsgxgdvFboHAOaqqVxsjT53GH0hoXYjjD
        0b18fV3gmAI38RD8Lzs8SaWlc/QUalvTnmpqGq4=
X-Google-Smtp-Source: ABdhPJzMRrPQPqIr3p2C+5xxpngruQQ43MqrZbGlhHVmMGkRJpRsikRWrtEymCTacC8UqFHrJ2gPifhqgc4PA0xb2OM=
X-Received: by 2002:a17:906:e47:: with SMTP id q7mr25487375eji.279.1592226759060;
 Mon, 15 Jun 2020 06:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de> <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com> <20200615131006.GR4447@sirena.org.uk>
In-Reply-To: <20200615131006.GR4447@sirena.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 16:12:28 +0300
Message-ID: <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
To:     Mark Brown <broonie@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
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

On Mon, 15 Jun 2020 at 16:10, Mark Brown <broonie@kernel.org> wrote:

>
> It's a bit unusual to need to actually free the IRQ over suspend -
> what's driving that requirement here?

clk_disable_unprepare(dspi->clk); is driving the requirement - same as
in dspi_remove case, the module will fault when its registers are
accessed without a clock.

-Vladimir
