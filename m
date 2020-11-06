Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E422A9E79
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 21:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgKFUMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 15:12:51 -0500
Received: from mail-ej1-f66.google.com ([209.85.218.66]:33427 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbgKFUMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 15:12:51 -0500
Received: by mail-ej1-f66.google.com with SMTP id 7so3640781ejm.0;
        Fri, 06 Nov 2020 12:12:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HknRaMwrIYdX/xZyUFtQWWgJWZ4ozlSDotxSubUVQAQ=;
        b=EhoHFzQmsDzZ1sWdFl6K6ugFVxJ5UlNi5ManfXN8J8XWJVGFo92AmXVD5U5QHcn1yB
         +rDMBqN7MZ5m2vmKHYLCE/EEg0GWvjolK09M/HyavJWJmAArJS6EvvY5Siztu8X8kwp6
         cgdW1dbtpAdSU55YTSnC23z666vCAYEwpYplNf2flPaCLuWj8nQY6tfZ98k759Up45mc
         EvmTWKHko/0jjlXtYrY+Zp2NdYtH6OV+xlzXGhm+uQjHrYvkp+LlM7B5ze31ilG44IHj
         sISFY4O3MGMxsIQetVP523N3yAEKh00qmcAh9NO5kEeF9Ssxh0EOYXMARUSRmKpLzsah
         U/Vw==
X-Gm-Message-State: AOAM5315cXbT80zKqcdOpxQAlOI6NsWucF+CGCn1NLDCqhOMbG13UjOL
        zQLIaWDAATnHDgcu0cv0Adg=
X-Google-Smtp-Source: ABdhPJyj+uHAR2eNBXDfygxkkR9riwjzCC6yUZZJXdcS5GkftYD/lz+U7/i5fO6GeHV3R9fbGIKbVw==
X-Received: by 2002:a17:906:3fc1:: with SMTP id k1mr3604375ejj.287.1604693567656;
        Fri, 06 Nov 2020 12:12:47 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id c4sm1661734ejx.9.2020.11.06.12.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 12:12:46 -0800 (PST)
Date:   Fri, 6 Nov 2020 21:12:45 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 107/191] ARM: dts: s5pv210: move PMU node out of
 clock controller
Message-ID: <20201106201245.GA332560@kozik-lap>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203243.594174920@linuxfoundation.org>
 <20201105114648.GB9009@duo.ucw.cz>
 <CAJKOXPeexYuH1_9HZUGn4Q80QBtKmqCKiEd=hNd46VKTM4kGgA@mail.gmail.com>
 <20201105195508.GB19957@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201105195508.GB19957@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 08:55:08PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > The Power Management Unit (PMU) is a separate device which has little
> > > > common with clock controller.  Moving it to one level up (from clock
> > > > controller child to SoC) allows to remove fake simple-bus compatible and
> > > > dtbs_check warnings like:
> > > >
> > > >   clock-controller@e0100000: $nodename:0:
> > > >     'clock-controller@e0100000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
> > >
> > > > +++ b/arch/arm/boot/dts/s5pv210.dtsi
> > > > @@ -98,19 +98,16 @@
> > > >               };
> > > >
> > > >               clocks: clock-controller@e0100000 {
> > > > -                     compatible = "samsung,s5pv210-clock", "simple-bus";
> > > > +                     compatible = "samsung,s5pv210-clock";
> > > >                       reg = <0xe0100000 0x10000>;
> > > ...
> > > > +             pmu_syscon: syscon@e0108000 {
> > > > +                     compatible = "samsung-s5pv210-pmu", "syscon";
> > > > +                     reg = <0xe0108000 0x8000>;
> > > >               };
> > >
> > > Should clock-controller@e0100000's reg be shortened to 0x8000 so that
> > > the ranges do not overlap?
> > >
> > > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> > 
> > I don't think this commit should be backported to stable. It is simple
> > dtbs_check - checking whether Devicetree source matches device tree
> > schema. Neither the schema nor the warning existed in v4.19. I think
> > dtbs_check fixes should not be backported, unless a real issue is
> > pointed out.
> 
> I agree with you about the backporting. Hopefully Greg drops the
> commit.
> 
> But the other issue is: should mainline be fixed so that ranges do not overlap?

Yes, it should be. This should fail on mapping resources...

I'll take a look, thanks for the report.

Best regards,
Krzysztof

