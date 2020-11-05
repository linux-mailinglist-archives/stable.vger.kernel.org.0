Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40582A7EC4
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 13:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgKEMip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 07:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgKEMip (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 07:38:45 -0500
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959592083B;
        Thu,  5 Nov 2020 12:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604579924;
        bh=ukbI+aZOBvhM7nVW/2DbByvV7udCrwZsbR3bDwLTtWs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YzFK8xkmQEeSCBfXgoXWfsaKWnfA8QIpx9G0jJcC2XwaDU12hANQrx6Syc3xCeKA2
         mumwN/GyTI45eQgRrEAOzIcO+avDTENq+dBwvPEh5GZ6V70EyoBlbmov2VP4H1aruE
         TzAjyip53c+Gr1pF+u6NulLBUFTwVKTZdSd7hvf4=
Received: by mail-ed1-f52.google.com with SMTP id o20so1361661eds.3;
        Thu, 05 Nov 2020 04:38:44 -0800 (PST)
X-Gm-Message-State: AOAM531wG6bmlaCDFaZI8cnktHYlZbiKVbteZpURkWPeHwQiisFrQV2e
        3a9j6xoBn47/15TrXXh/OZEKKVW48bFWF4I833Q=
X-Google-Smtp-Source: ABdhPJyAjYvrQfP0xO6VsEfL8L8ctucLZXEOV/WXH2UFKRFGCW0kmD7cmPCzL8PKJsZd7qScN0RfQCDL5/Cwb8dfZaE=
X-Received: by 2002:a50:8b65:: with SMTP id l92mr2380277edl.132.1604579922958;
 Thu, 05 Nov 2020 04:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20201103203232.656475008@linuxfoundation.org> <20201103203243.594174920@linuxfoundation.org>
 <20201105114648.GB9009@duo.ucw.cz>
In-Reply-To: <20201105114648.GB9009@duo.ucw.cz>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 5 Nov 2020 13:38:31 +0100
X-Gmail-Original-Message-ID: <CAJKOXPeexYuH1_9HZUGn4Q80QBtKmqCKiEd=hNd46VKTM4kGgA@mail.gmail.com>
Message-ID: <CAJKOXPeexYuH1_9HZUGn4Q80QBtKmqCKiEd=hNd46VKTM4kGgA@mail.gmail.com>
Subject: Re: [PATCH 4.19 107/191] ARM: dts: s5pv210: move PMU node out of
 clock controller
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Nov 2020 at 12:46, Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> > The Power Management Unit (PMU) is a separate device which has little
> > common with clock controller.  Moving it to one level up (from clock
> > controller child to SoC) allows to remove fake simple-bus compatible and
> > dtbs_check warnings like:
> >
> >   clock-controller@e0100000: $nodename:0:
> >     'clock-controller@e0100000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
>
> > +++ b/arch/arm/boot/dts/s5pv210.dtsi
> > @@ -98,19 +98,16 @@
> >               };
> >
> >               clocks: clock-controller@e0100000 {
> > -                     compatible = "samsung,s5pv210-clock", "simple-bus";
> > +                     compatible = "samsung,s5pv210-clock";
> >                       reg = <0xe0100000 0x10000>;
> ...
> > +             pmu_syscon: syscon@e0108000 {
> > +                     compatible = "samsung-s5pv210-pmu", "syscon";
> > +                     reg = <0xe0108000 0x8000>;
> >               };
>
> Should clock-controller@e0100000's reg be shortened to 0x8000 so that
> the ranges do not overlap?
>
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

I don't think this commit should be backported to stable. It is simple
dtbs_check - checking whether Devicetree source matches device tree
schema. Neither the schema nor the warning existed in v4.19. I think
dtbs_check fixes should not be backported, unless a real issue is
pointed out.

Best regards,
Krzysztof
