Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDFD2722A1
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 13:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgIULgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 07:36:13 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40199 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgIULgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 07:36:12 -0400
Received: by mail-lj1-f196.google.com with SMTP id s205so10751413lja.7;
        Mon, 21 Sep 2020 04:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kd3iMKnixtZzfCsALrdkM+rA5qkShZbR4dY98v7k9JI=;
        b=qp4n7gj72VH5om8bC3n6he3nAoHnOQDM8lTXIck/wPHaveSzEC1jKt3QOqysdTLA3b
         xpRQ9bAcf/Glp0H4GGTsInBfZ2KIAIhV03+U8lfs3sIcPCH7bDaCvRxCBdH/vWUHEEAz
         e+sqMLbLmaf5hrdKRJXMeHMGp+PeC1BGW3L0PtP8sqh/cO/Hgs6pq2ZEczMw8r3w2Pkk
         5S40tOwm0Mqhd+R+dIWNzSl2hb/5hDszv+xeMm5alb3WDnNYMWGJ4jUnN1gPKjWRziMM
         kKFnzGfqGIEBBOwQwaZf8kTBnkEoqABtd2WITsOPVzfbDSVghc+NQ5j1gEAtrmn90WtQ
         NlOQ==
X-Gm-Message-State: AOAM5331qgSXHT9Zs77TcIOpoBAIMGqzhzapP+0Cfoj+KBH7fKyi880I
        QPgg53ML+BaP9TBxXyRqD84=
X-Google-Smtp-Source: ABdhPJwdk6FBblDCoPl9mOit9wQxOLYXq/8FPmzqGRPHLy/OW+Z1gPPsZH0K02YBkq7HfneJihxwWg==
X-Received: by 2002:a2e:3215:: with SMTP id y21mr14853686ljy.52.1600688170047;
        Mon, 21 Sep 2020 04:36:10 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id m20sm2633088ljp.132.2020.09.21.04.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 04:36:09 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kKK6z-0008O2-Py; Mon, 21 Sep 2020 13:36:02 +0200
Date:   Mon, 21 Sep 2020 13:36:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
Message-ID: <20200921113601.GT24441@localhost>
References: <20200921081022.6881-1-johan@kernel.org>
 <1600677792.2424.61.camel@suse.com>
 <20200921093145.GS24441@localhost>
 <1600684156.2424.65.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600684156.2424.65.camel@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 12:29:16PM +0200, Oliver Neukum wrote:
> Am Montag, den 21.09.2020, 11:31 +0200 schrieb Johan Hovold:
> > On Mon, Sep 21, 2020 at 10:43:12AM +0200, Oliver Neukum wrote:
> > > Am Montag, den 21.09.2020, 10:10 +0200 schrieb Johan Hovold:
> > > > Add support for Whistler radio scanners TRX series, which have a union
> > > > descriptor that designates a mass-storage interface as master. Handle
> > > > that by generalising the NO_DATA_INTERFACE quirk to allow us to fall
> > > > back to using the combined-interface detection.
> > > 
> > > Hi,
> 
> Hi,
> 
> > > 
> > > it amazes me what solutions people can come up with. Yet in this case
> > > using a quirk looks like an inferior solution. If your master
> > > is a storage interface, you will have a condition on the device you
> > > can test for without the need for a quirk.
> > 
> > Sure, and I mentioned that as an alternative, another would be checking
> > for a control interface with three endpoints directly.
> 
> These tests are not mutually exclusive. You can check for both
> conditions being met. In fact you have to, it seems to me.

I meant that instead of falling back to "combined-interface" probing we
could assume that all interfaces with three endpoints are "combined" and
simply ignore the union and call management descriptors and all the ways
that devices may have gotten those wrong.

I'll include that as an RFC.

> > My fear is that any change in this direction risk introducing regression
> > if there are devices out there with broken descriptors that we currently
> > happen to support by chance. Then again, probably better to try to
> > handle any such breakage if/when reported.
> 
> Well, I guess the chance that we break devices which claim to be
> storage devices we will simply have to take. Those devices are
> quite broken in any case.

I was thinking more of the individual entries in the device-id table
whose control interfaces may not even be of the Communication class. But
hopefully that was verified when adding them.

Johan
