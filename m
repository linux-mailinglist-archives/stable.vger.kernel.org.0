Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C165B271EF3
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 11:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIUJbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 05:31:55 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38135 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgIUJbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 05:31:55 -0400
Received: by mail-lf1-f67.google.com with SMTP id y11so13231794lfl.5;
        Mon, 21 Sep 2020 02:31:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=55QioiSplUcE4qCeCvoYiw01/9Vs+h44i8mvhWegEas=;
        b=JsyDOPZccLmUkMFnQQmvHqAHGZ8dtZI5dedzK7sRb5tWYM5zFbTDfaACe3qfb0kNOZ
         Gs5X514HenL8wYarmxa0KvPXkKR33EOikhfKOoP6wu64/csU/UGo5lk+ax95v/j/rxIp
         i2fTz8WBc6wnkFrOxHMq2mhxT1XU6UR2P6uLZnd2QoI3R/LcID2Cq/fofNOQ24+iNIlJ
         4f3B1KD4gJ15dNVy/tOOyTdIoW1B5pTFG0MlwHl2YajWMttzpJ31l6rqAM+IRTLRfcYc
         orl28kOXfYltIxSv8LBl0R/BvgkF5XbmcfvvmH3KyUtgR6yxpfCmmVzxdAqUFoqhdTYZ
         RhCg==
X-Gm-Message-State: AOAM532tkF+p6GtNatgv/qBtHWeyneJtuKAay3U44EuUhOIllWWEfgb+
        XVNxmF6jrkEQuDd7Cobbn2I=
X-Google-Smtp-Source: ABdhPJzm04IFIPfQsaNJgA7AhzyTz0+o1ulYaqtG0KWB006xZTul99XLmVE0Qpkb3IbOiz4bhMcYBA==
X-Received: by 2002:ac2:5217:: with SMTP id a23mr14224631lfl.509.1600680713449;
        Mon, 21 Sep 2020 02:31:53 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id a14sm2411104lfi.136.2020.09.21.02.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 02:31:52 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kKIAj-0001r1-UK; Mon, 21 Sep 2020 11:31:45 +0200
Date:   Mon, 21 Sep 2020 11:31:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
Message-ID: <20200921093145.GS24441@localhost>
References: <20200921081022.6881-1-johan@kernel.org>
 <1600677792.2424.61.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600677792.2424.61.camel@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 10:43:12AM +0200, Oliver Neukum wrote:
> Am Montag, den 21.09.2020, 10:10 +0200 schrieb Johan Hovold:
> > Add support for Whistler radio scanners TRX series, which have a union
> > descriptor that designates a mass-storage interface as master. Handle
> > that by generalising the NO_DATA_INTERFACE quirk to allow us to fall
> > back to using the combined-interface detection.
> 
> Hi,
> 
> it amazes me what solutions people can come up with. Yet in this case
> using a quirk looks like an inferior solution. If your master
> is a storage interface, you will have a condition on the device you
> can test for without the need for a quirk.

Sure, and I mentioned that as an alternative, another would be checking
for a control interface with three endpoints directly.

My fear is that any change in this direction risk introducing regression
if there are devices out there with broken descriptors that we currently
happen to support by chance. Then again, probably better to try to
handle any such breakage if/when reported.

I'll respin.

Johan
