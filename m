Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1DB278B4C
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgIYOxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:53:40 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33867 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbgIYOxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 10:53:39 -0400
Received: by mail-lf1-f67.google.com with SMTP id u8so3147312lff.1;
        Fri, 25 Sep 2020 07:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8BoxUeVizmKKAcaUi8Yfb1uh4zDY+60H994gLNpA+fw=;
        b=IQGncygq8g50OwobV8mkm8fAIF7/ll3n9TTxHnzr5GGrzvWV6xS/pa/M4eCj9ljOoS
         T3Ug4ist4W8WpRjbTLsKEM8k1WG2u7ZUTOcfdCIUw2mzSVrtiNKn1K2r+Tavn4P32F+j
         8/KtGjVdmGKb/d2hPG4mQucW4dAiw9Sgk8MRrHPZM6Ue48DNP2N+pn/TS/1pILr8TWZ7
         XTEl151eNdPnifcOw/rxqaBehWXJS1OGVdornG1RY1CtBTPaOE/eTPtZPKjP+81Ziy3Z
         SpJbimM4GuP+I4JcB+SJVCeOSWdArDGCxHwtEGovYm4sdqQe2g+eEHWM3L291Puzs9Md
         B0xQ==
X-Gm-Message-State: AOAM530OznCHTZxwvKABZ8oeQ1Y5wYiS49F55ZyRodgkmuny3oof/929
        IykrVkYYCzdyoSTxPNJ7KbZS3AOYqlo=
X-Google-Smtp-Source: ABdhPJyg+NvzLlKqClkaVwuYwH/4wfM3vQ1nlz0aaBEntmegb0lhchoSCA6o1TXM/djzwD/9gaYMJw==
X-Received: by 2002:ac2:4c31:: with SMTP id u17mr1426191lfq.1.1601045618089;
        Fri, 25 Sep 2020 07:53:38 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id d24sm2457068lfn.140.2020.09.25.07.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 07:53:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kLp6J-0003kn-7A; Fri, 25 Sep 2020 16:53:31 +0200
Date:   Fri, 25 Sep 2020 16:53:31 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, Oliver Neukum <oneukum@suse.com>,
        linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
Message-ID: <20200925145331.GL24441@localhost>
References: <20200921081022.6881-1-johan@kernel.org>
 <20200925144922.GA3113925@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925144922.GA3113925@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 04:49:22PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Sep 21, 2020 at 10:10:22AM +0200, Johan Hovold wrote:
> > Add support for Whistler radio scanners TRX series, which have a union
> > descriptor that designates a mass-storage interface as master. Handle
> > that by generalising the NO_DATA_INTERFACE quirk to allow us to fall
> > back to using the combined-interface detection.
> > 
> > Note that the NO_DATA_INTERFACE quirk was added by commit fd5054c169d2
> > ("USB: cdc_acm: Fix oops when Droids MuIn LCD is connected") to handle a
> > combined-interface-type device with a broken call-management descriptor
> > by hardcoding the "data" interface number.
> > 
> > Link: https://lore.kernel.org/r/5f4ca4f8.1c69fb81.a4487.0f5f@mx.google.com
> > Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> > 
> > v2
> >  - use the right class define in the device-id table (not subclass with
> >    same value)
> 
> Is this independant of your other patch series for cdc-acm?

This one is superseded by the series, so please drop this patch. Sorry
for not making that clear.

Johan
