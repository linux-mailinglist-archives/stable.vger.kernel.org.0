Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254D02725F3
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 15:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIUNn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 09:43:59 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:45954 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgIUNn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 09:43:59 -0400
Received: by mail-lj1-f169.google.com with SMTP id c2so11122771ljj.12;
        Mon, 21 Sep 2020 06:43:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IzVwhgldFPdOEXwGOBAAemix127aGfC/miv2sGzrack=;
        b=Al1vR/dw6fEU2quolBrIiRM4Hz77L/9gyL7fzpWve7EkJWur1Qt3+mC734BHVLY0eJ
         ps7gOri/1lHlxl05nwkyzcWVo8q+rlYlB0n0vVWzfjAvP+aWdFFL84o5ePFsBeLiFkqF
         EHXKFVx4XLBPLjKIup7cOIzeiVIp9Uuq3uz7ZsZqynbDYMNLv+aVQTz4pbsQD8Sf857A
         fkwaZJObUQO9qfn9JSnDELL/8oAYpFy2yM2a9ZiSLVOBHohYELlKtAANeVsMcW+gInd0
         pggewagsc0guJUkQmfadjmSgeCv1HsxzLSZyIxTlQy/gI2laJOgxNHLwW0Ol8LD0gmP+
         Zzig==
X-Gm-Message-State: AOAM533wJXVnjCZWKX6WvVSsfWYkn4MLkMtjxeQO8y7xWrOLNvsZItn2
        NT5UTV3zIUlYJ/mzRIIUREo=
X-Google-Smtp-Source: ABdhPJxQEukLP7HMM4A3nGOgC0onRHZdWYTQrNkhsFLLdy5rPUK66/9QJK2P20IaZQxIMkh6G94GqQ==
X-Received: by 2002:a2e:88c4:: with SMTP id a4mr15268322ljk.393.1600695835522;
        Mon, 21 Sep 2020 06:43:55 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id r4sm2593718lfi.25.2020.09.21.06.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 06:43:54 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kKM6d-00068d-Ne; Mon, 21 Sep 2020 15:43:48 +0200
Date:   Mon, 21 Sep 2020 15:43:47 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
Message-ID: <20200921134347.GW24441@localhost>
References: <20200921081022.6881-1-johan@kernel.org>
 <1600677792.2424.61.camel@suse.com>
 <20200921093145.GS24441@localhost>
 <1600684156.2424.65.camel@suse.com>
 <20200921113601.GT24441@localhost>
 <1600688954.2424.76.camel@suse.com>
 <20200921120302.GU24441@localhost>
 <1600690627.2424.80.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600690627.2424.80.camel@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 02:17:07PM +0200, Oliver Neukum wrote:
> Am Montag, den 21.09.2020, 14:03 +0200 schrieb Johan Hovold:
> > On Mon, Sep 21, 2020 at 01:49:14PM +0200, Oliver Neukum wrote:
> > > Am Montag, den 21.09.2020, 13:36 +0200 schrieb Johan Hovold:
> > > > On Mon, Sep 21, 2020 at 12:29:16PM +0200, Oliver Neukum wrote:
> > > 
> > > Hi,
> > > 
> > > > I meant that instead of falling back to "combined-interface" probing we
> > > > could assume that all interfaces with three endpoints are "combined" and
> > > > simply ignore the union and call managementy. descriptors and all the ways
> > > > that devices may have gotten those wrong.
> > > 
> > > I am afraid we would break the spec. I cannot recall a prohibition on
> > > having more endpoints than necessary. Heuristics and ignoring invalid
> > > descriptors is one things. Ignoring valid descriptors is something
> > > else.
> > 
> > That depends on how you read the spec (see "3.3.1 Communication Class
> > Interface"). But sure, it's probably be better to err on the safe-side.
> 
> You mean 3.4.1?

It's 3.3.1 in Version 1.1 at least.

> > > > I was thinking more of the individual entries in the device-id table
> > > > whose control interfaces may not even be of the Communication class. But
> > > > hopefully that was verified when adding them.
> > > 
> > > Now you are confusing me. In case of a quirky device, why change
> > > the current logic?
> > 
> > Just because they have a quirk defined, doesn't mean they don't rely on
> > the generic probe algorithm (e.g. a USB_DEVICE entry which matches all
> > interface classes and only specifies SEND_ZERO_PACKET).
> 
> Right, so let me be more specific. It would probably be unwise to
> change the decision tree in probe() as far as devices whose quirks
> affect decisions in that already are concerned.

But we need to draw line somewhere to keep the code maintainable and
ourselves sane, especially since a lot of these devices where added
without any record of their descriptors.

I guess we could add another test for the device-id fields, but I'm
reluctant to add more special casing before we know it's needed.

Johan
