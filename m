Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6659A27234B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgIUMDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:03:11 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:39172 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIUMDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 08:03:11 -0400
Received: by mail-lf1-f44.google.com with SMTP id q8so13692245lfb.6;
        Mon, 21 Sep 2020 05:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+QI8mTIy0Eft8z2TjdteLwGuaZdvxggWE9Qg6IcauVw=;
        b=fTTEuQpRQiYen3wlgkU38kPA3n4KBCjf/9KVJ9ocl8kj3UoSfimhsYdYVqCMMR64Vo
         PXwkoiX6KrvRUCfwOGeufZQGWwbX/nC2VoKvx47DMRalTijpeaR0i0YoP4scoByUqj73
         ITcMeTFfpZlV7shY5IL99XOXx2DRXSe4Uh0KPqdfIDFR+pZLTPQq99nszGYH9B5cDI6Z
         +p7rV28zbuH1LtZHQL8voSSGmOKqsqf2jUM/1PcpaHqy8eLbsotw2YldbJtsgLoKDRdR
         d8nm0G4fhPvtlv5IaHTpok/vq3vY+/I6OBISy+zgE90vaPvTXOKELXt/xegIX4q7i7op
         g3DA==
X-Gm-Message-State: AOAM531GubAorwxQDLz0bGfklVsXYm5jprlpEFhRGZOKONTimubunuI0
        OjYCIwxMoW8KyFvV8bgD5Jw=
X-Google-Smtp-Source: ABdhPJxdjtM6vpjl17ORbFrP8CgY69mUCFUTz49xDT59p6xw6fjC7zTUkILj4y0C1vObC+RLgxP+4A==
X-Received: by 2002:a19:4e:: with SMTP id 75mr14633741lfa.159.1600689789491;
        Mon, 21 Sep 2020 05:03:09 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id n2sm2667943lji.97.2020.09.21.05.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:03:08 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kKKX8-0000WD-Av; Mon, 21 Sep 2020 14:03:02 +0200
Date:   Mon, 21 Sep 2020 14:03:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
Message-ID: <20200921120302.GU24441@localhost>
References: <20200921081022.6881-1-johan@kernel.org>
 <1600677792.2424.61.camel@suse.com>
 <20200921093145.GS24441@localhost>
 <1600684156.2424.65.camel@suse.com>
 <20200921113601.GT24441@localhost>
 <1600688954.2424.76.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600688954.2424.76.camel@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 01:49:14PM +0200, Oliver Neukum wrote:
> Am Montag, den 21.09.2020, 13:36 +0200 schrieb Johan Hovold:
> > On Mon, Sep 21, 2020 at 12:29:16PM +0200, Oliver Neukum wrote:
> 
> Hi,
> 
> > I meant that instead of falling back to "combined-interface" probing we
> > could assume that all interfaces with three endpoints are "combined" and
> > simply ignore the union and call managementy. descriptors and all the ways
> > that devices may have gotten those wrong.
> 
> I am afraid we would break the spec. I cannot recall a prohibition on
> having more endpoints than necessary. Heuristics and ignoring invalid
> descriptors is one things. Ignoring valid descriptors is something
> else.

That depends on how you read the spec (see "3.3.1 Communication Class
Interface"). But sure, it's probably be better to err on the safe-side.

> > I was thinking more of the individual entries in the device-id table
> > whose control interfaces may not even be of the Communication class. But
> > hopefully that was verified when adding them.
> 
> Now you are confusing me. In case of a quirky device, why change
> the current logic?

Just because they have a quirk defined, doesn't mean they don't rely on
the generic probe algorithm (e.g. a USB_DEVICE entry which matches all
interface classes and only specifies SEND_ZERO_PACKET).

Johan
