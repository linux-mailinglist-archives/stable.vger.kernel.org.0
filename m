Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE581F98E6
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgFONeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730638AbgFONeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:34:07 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29051C061A0E;
        Mon, 15 Jun 2020 06:34:07 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id f7so17468338ejq.6;
        Mon, 15 Jun 2020 06:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2V1qAE11MNlrSXseMOlYDGmQZmq5VRcnjVpJmM7yzg=;
        b=GbIldhCdOCVrXEk+ONIEUVLgT0UsbDx8tLCIdwL2uVK0L8Ezi/vkURRR4WlfbiCfht
         x/F/qgWd21c9PhWl6xCe99JQ1RZw1/+2cxirrPJC9s7GybkalRLGVnHdkRSzOmNjCA1H
         /S1J7Qda5Y4rgJPjIGX2uum2NncaCTNtYaNmAjyKN4/w38uVr1F928XE8iRGv6cwzU22
         XXtrdgDqU9/rUGwnrmfy9sUjc66dfTbOEuh891oRPkDExQUNYjKl3Vj9IZCBBZsHDxi6
         8bSSEDrtNV704lENX5H5ZRAi8a1Z3ny7cUBzhsD/vhjZk4InSqYrSdrtbIvJeLezThfb
         3NHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D2V1qAE11MNlrSXseMOlYDGmQZmq5VRcnjVpJmM7yzg=;
        b=MQ9CP2FGBeVn8g5eyobuRrbU3aT1Vm4AJ3CTLjrzpG0DGwWJkONUR0xjq0ILIKMLeg
         G84QA+VHAy2nxfqopg8+1GXYeR/Lju42AScfJ0LLfloF3kCQglyO78PtCv7/l0wfcUaq
         SLuDilA+um+a1u0BpI67eMwT25LWiQ1R0XrzVRMCZDnQ7WKYKzDCxsda/Y4Fk91bd5RB
         PIsWaFcxyO6Xo1SUd3d7y250MBcWbA5J38TyZBU1JE7tbod5X7kGXZBuMq6+dHCxfeAk
         3kt3BdBw+KyjdNMVbSVbYUAL5DlVHVUvyrrVebdmxtpbUKGRcS2QVDNlBwWzLoezjhTN
         Cqzw==
X-Gm-Message-State: AOAM532N1migWf/LQ/CWOC57cyh5DQqQsC7UK6BSZvHu8t6e8A+O37lC
        KOcFcpsVBJUGVxkqUJVTx/qqtuze8Rhai6DXZFg=
X-Google-Smtp-Source: ABdhPJzeJ2Yrey1vBEGdZaJnJxSnmLJHNM8zVVXUFYwnfHr2tIRNLk8hVbekn0NLieVUa+bUfXOM0ywx4KZAvQxQROw=
X-Received: by 2002:a17:906:198d:: with SMTP id g13mr12938685ejd.281.1592228045820;
 Mon, 15 Jun 2020 06:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de> <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131012.GB2634@kozik-lap> <CA+h21hoCUC-UqHKLOsMhiEZdyTctUwNC6pqijpD9X96ZZq4M7w@mail.gmail.com>
 <20200615132842.GA3321@kozik-lap>
In-Reply-To: <20200615132842.GA3321@kozik-lap>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 16:33:54 +0300
Message-ID: <CA+h21hpagCDVbjzh_==B_m2HiVrZv1MsvEcY=fPmqSequ6jvJA@mail.gmail.com>
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

On Mon, 15 Jun 2020 at 16:28, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Jun 15, 2020 at 04:14:06PM +0300, Vladimir Oltean wrote:
> > On Mon, 15 Jun 2020 at 16:10, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> >
> > >
> > > It is a slightly different bug which so this patch should have a follow
> > > up.
> > >
> > > Best regards,
> > > Krzysztof
> > >
> >
> > Why is it a different bug? It's the same bug.
>
> One bug is using devm-interface for shared interrupts and second is not
> caring about suspend/resume.
>
> Best regards,
> Krzysztof
>

The problem is that you don't have a way to stop servicing a shared
interrupt safely and on demand, before clk_disable_unprepare.
So it's exactly the same problem on suspend and on remove.
Avoiding to think about the suspend problem now means that you'll end
up having an overall worse solution.
