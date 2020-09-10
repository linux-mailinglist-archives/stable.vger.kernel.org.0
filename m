Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ACE263E22
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 09:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgIJHKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 03:10:34 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44777 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730408AbgIJHIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 03:08:44 -0400
Received: by mail-lj1-f195.google.com with SMTP id b19so6743653lji.11;
        Thu, 10 Sep 2020 00:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rLyVaAJAglFySSpr2MGhrCSvoIYdsTOte9p/4jLkzmo=;
        b=ivrn1aIWEFXz+cMgUi7eGCFI6kl+Ow9i96etPX4Q1XzYqtOQ98ky6EyJd9pEX/cCUL
         4vj0Vw20W1nBBCGrVojg/uVfHTjXFVWDqr/r5rjbn6KEw1DvR6F9wfl1NIPG8stp3+cQ
         jVhy/b5Jwan+SGnBG9fmyHoGM0AlohDibqxnfHthsu2ZfEU9pdcsRwNHgqwJovIn2Wb8
         Miyohu57hsdIIpxa7K1XlcdayUNfSDPLh1TpU7B27kop6S813mu/N1/TrS51COHYa7eJ
         cN4LtsVieqT2SSyqrGWSD96EqN3k9Vwo3NDo8seMsxY4Mq5hQ1y5A2drG0FefXBaI0yR
         Blnw==
X-Gm-Message-State: AOAM533FM88CY1FcUR84h+obTP730R95HOmKVzR1anllSXA+kIQICPSL
        KCPT+21HaCsVQRv7spCFMDU=
X-Google-Smtp-Source: ABdhPJzcLGO0skLg/9MNKQOq2gGlzisRR/xiOYj/piuMfbP3jScnhymaPvFW15ZJ6AgBtqBeh2jeFA==
X-Received: by 2002:a2e:b8d1:: with SMTP id s17mr602390ljp.222.1599721721980;
        Thu, 10 Sep 2020 00:08:41 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id z8sm1349606ljh.19.2020.09.10.00.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:08:41 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kGGhA-0005SA-Rw; Thu, 10 Sep 2020 09:08:37 +0200
Date:   Thu, 10 Sep 2020 09:08:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] serial: core: fix port-lock initialisation
Message-ID: <20200910070836.GB24441@localhost>
References: <20200909143101.15389-1-johan@kernel.org>
 <20200909143101.15389-2-johan@kernel.org>
 <20200909152158.GC1891694@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909152158.GC1891694@smile.fi.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 06:21:58PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 09, 2020 at 04:31:00PM +0200, Johan Hovold wrote:
> > Commit f743061a85f5 ("serial: core: Initialise spin lock before use in
> > uart_configure_port()") tried to work around a breakage introduced by
> > commit a3cb39d258ef ("serial: core: Allow detach and attach serial
> > device for console") by adding a second initialisation of the port lock
> > when registering the port.
> > 
> > As reported by the build robots [1], this doesn't really solve the
> > regression introduced by the console-detach changes and also adds a
> > second redundant initialisation of the lock for normal ports.
> 
> I thought, though doubtfully, it was a regression made by
> 679193b7baf8 ("serial: 8250: Let serial core initialise spin lock")
> and then I completely forgot about [1].

Yes, that driver has had an explicit early initialisation of the lock
and it was indeed the removal of that which triggered the robot's
report. With the initialisation again done during console setup (patch
2/2), that should no longer be an issue (at least not for the console
port...).

> > Start cleaning up this mess by removing the redundant initialisation and
> > making sure that the port lock is again initialised once-only for ports
> > that aren't already in use as a console.
> 
> Thanks for looking into this!
> 
> I agree this is better place for lock initialization.
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks for reviewing.

Johan
