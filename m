Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429D42A9EDE
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 22:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgKFVKo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 6 Nov 2020 16:10:44 -0500
Received: from mail-ej1-f67.google.com ([209.85.218.67]:46354 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFVKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 16:10:43 -0500
Received: by mail-ej1-f67.google.com with SMTP id w13so3788478eju.13;
        Fri, 06 Nov 2020 13:10:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eiZHqrS2vIdOh+bg/DLjfX4/blxwd3aT047goVvJGNY=;
        b=NyuHs/xmG/4hSr0l5mjwf5waw5BuoK5Mwd5NRx5GX9W18PKQk7+wAnrf4r3mBwS9kY
         ikFC9X2YMEPqVpsHyN6coNcqIdtwkL84lg5MGetS6w0RfgDcjdpxswX/oTiSD16rVyxj
         Zq3yNzi9EIxLxiYvdraqz6aSwn8aVnAlDgUVQ1HlwTx1Xrc5P8YhyCAtpBGs6DhUAGkw
         FolUbDh+TZLCN+Zlne+GVs0zA9zgTPSP/pM6a6gUeTXMvqnu3j1lZ4ZSzYZ15I+m4vg/
         qL0UruWCMu1Eu4NNVUyofCU1rH9ctZHOxJRIgOKjiDmnCQJfuYSBIXmHr6KRc2QbLpNs
         OmPA==
X-Gm-Message-State: AOAM532NpT73dokHbmL9uK6iajFFt0Tt2Ksysd6/yIVTVAAbrA6XvXXz
        rEerpfUsqK2IzEzFq+/KLa0=
X-Google-Smtp-Source: ABdhPJxQN4FDTjfZ6IhFz4o1c2N+k57l0Ao8qrl2+/TRNku7RGnVgsej4wIE055vscPuAtAWgc8knQ==
X-Received: by 2002:a17:906:c1ce:: with SMTP id bw14mr3953266ejb.302.1604697041377;
        Fri, 06 Nov 2020 13:10:41 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id z18sm1701282ejf.41.2020.11.06.13.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 13:10:40 -0800 (PST)
Date:   Fri, 6 Nov 2020 22:10:38 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>,
        =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 4.19 107/191] ARM: dts: s5pv210: move PMU node out of
 clock controller
Message-ID: <20201106211038.GA400980@kozik-lap>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203243.594174920@linuxfoundation.org>
 <20201105114648.GB9009@duo.ucw.cz>
 <CAJKOXPeexYuH1_9HZUGn4Q80QBtKmqCKiEd=hNd46VKTM4kGgA@mail.gmail.com>
 <20201105195508.GB19957@duo.ucw.cz>
 <20201106201245.GA332560@kozik-lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201106201245.GA332560@kozik-lap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 06, 2020 at 09:12:45PM +0100, Krzysztof Kozlowski wrote:
> On Thu, Nov 05, 2020 at 08:55:08PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > > The Power Management Unit (PMU) is a separate device which has little
> > > > > common with clock controller.  Moving it to one level up (from clock
> > > > > controller child to SoC) allows to remove fake simple-bus compatible and
> > > > > dtbs_check warnings like:
> > > > >
> > > > >   clock-controller@e0100000: $nodename:0:
> > > > >     'clock-controller@e0100000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
> > > >
> > > > > +++ b/arch/arm/boot/dts/s5pv210.dtsi
> > > > > @@ -98,19 +98,16 @@
> > > > >               };
> > > > >
> > > > >               clocks: clock-controller@e0100000 {
> > > > > -                     compatible = "samsung,s5pv210-clock", "simple-bus";
> > > > > +                     compatible = "samsung,s5pv210-clock";
> > > > >                       reg = <0xe0100000 0x10000>;
> > > > ...
> > > > > +             pmu_syscon: syscon@e0108000 {
> > > > > +                     compatible = "samsung-s5pv210-pmu", "syscon";
> > > > > +                     reg = <0xe0108000 0x8000>;
> > > > >               };
> > > >
> > > > Should clock-controller@e0100000's reg be shortened to 0x8000 so that
> > > > the ranges do not overlap?
> > > >
> > > > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> > > 
> > > I don't think this commit should be backported to stable. It is simple
> > > dtbs_check - checking whether Devicetree source matches device tree
> > > schema. Neither the schema nor the warning existed in v4.19. I think
> > > dtbs_check fixes should not be backported, unless a real issue is
> > > pointed out.
> > 
> > I agree with you about the backporting. Hopefully Greg drops the
> > commit.
> > 
> > But the other issue is: should mainline be fixed so that ranges do not overlap?
> 
> Yes, it should be. This should fail on mapping resources...
> 
> I'll take a look, thanks for the report.

+Cc Paweł and Marek,

The IO memory mappings overlap unfortunately on purpose. Most of the
clock driver registers are in the first range of 0x3000 but it also uses
two registers at offset 0xe000.

The samsung-s5pv210-pmu is used only as a syscon by phy-s5pv210-usb2.c
which wants to play with 0x680c.

The solution could be to split the mapping into two parts but I don't
want to do this. I don't have the hardware so there is a chance I will
break things.

However if Paweł, Jonathan or Marek want to improve it - patches are
welcomed. :)

Best regards,
Krzysztof

