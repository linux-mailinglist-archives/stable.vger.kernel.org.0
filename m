Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C9355A8C
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhDFRlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 13:41:01 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:44771 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhDFRlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 13:41:00 -0400
Received: by mail-oi1-f179.google.com with SMTP id a8so15935268oic.11;
        Tue, 06 Apr 2021 10:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6QPhKZsquLIEpX7e3NC/9vIpJz8EUh2fOFvHLn8Y5pw=;
        b=S3wCtFSocVFiEJY5W0pFVjU3fELWkZGaczm9mnJMOcQ+jPjYVURLkpHEmxdw7HbTf7
         MI+IkIMml2pWoJhzn3kNVP5KUUazFJb1FueZwSF0cJjZ+pddDWSiDsbZ0jAN7m9Mjw/g
         LpSVpqmgvl8ckCfd+/pcCJXnbJEWwdGke3tg3bWGIx6k4nkctl+8+TkyidhnmTPTOGs8
         C+fsMTCxue30HtTbzVderSMcL6K+kTPyR6G3bZkaeGHMcbSXOmLedwRZcJdYURT6MULL
         8m4WCJ+zkWhzPhPnbuFDCzmhKbOuYI+0RfrGK9SZvD9LS4IgmTlYEz8n2jHmz85o1Oha
         0giw==
X-Gm-Message-State: AOAM533JKtNpOCBIJo0Rhx6KiYwUrzw3ehfH2DAiuGsF/KIsoqmavB0h
        1xsnFauBpasuN92N3et24A==
X-Google-Smtp-Source: ABdhPJz/exfIBW4WbDS+BnoTA5dhoXS7ju34vF4fJxbKbpRTNFrZPUs0M/kXJrc3/t6EM5pgq00sOA==
X-Received: by 2002:aca:4187:: with SMTP id o129mr4173846oia.10.1617730852367;
        Tue, 06 Apr 2021 10:40:52 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l81sm3876263oif.31.2021.04.06.10.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 10:40:51 -0700 (PDT)
Received: (nullmailer pid 2016914 invoked by uid 1000);
        Tue, 06 Apr 2021 17:40:50 -0000
Date:   Tue, 6 Apr 2021 12:40:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] of: property: do not create device links from *nr-gpios
Message-ID: <20210406174050.GA1963300@robh.at.kernel.org>
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
 <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com>
 <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 01:18:56PM -0700, Saravana Kannan wrote:
> On Mon, Apr 5, 2021 at 1:10 PM Ilya Lipnitskiy
> <ilya.lipnitskiy@gmail.com> wrote:
> >
> > Hi Saravana,
> >
> > On Mon, Apr 5, 2021 at 1:01 PM Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
> > > <ilya.lipnitskiy@gmail.com> wrote:
> > > >
> > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > not configured by #gpio-cells and can't be parsed along with other
> > > > "*-gpios" properties.
> > > >
> > > > scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> > > > nr-gpio is not really special, so we only need to fix nr-gpios suffix
> > > > here.
> > >
> > > The only example of this that I see is "snps,nr-gpios".
> > arch/arm64/boot/dts/apm/apm-shadowcat.dtsi uses "apm,nr-gpios", with
> > parsing code in drivers/gpio/gpio-xgene-sb.c. There is also code in
> > drivers/gpio/gpio-adnp.c and drivers/gpio/gpio-mockup.c using
> > "nr-gpios" without any vendor prefix.
> 
> Ah ok. I just grepped the DT files. I'm not sure what Rob's position
> is on supporting DT files not in upstream. Thanks for the
> clarification.

If it's something we had documented, then we have to support it (also 
conditioned on someone noticing). I'm hoping we can just delete APM and 
other defunct ARM server DTs soon, but we could update them to use 
'ngpios' instead.

gpio-mockup doesn't have a binding, so no DT ABI. Hard to tell if 
gpio-adnp.c has any users.

Rob
