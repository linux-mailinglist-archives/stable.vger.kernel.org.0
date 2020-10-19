Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560C02922CF
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 09:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgJSHKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 03:10:38 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46986 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgJSHKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 03:10:38 -0400
Received: by mail-lf1-f66.google.com with SMTP id v6so12820876lfa.13;
        Mon, 19 Oct 2020 00:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ikfGLiawk4LAa9mmuiQJyjvU9DU+KHULB1EowMpanLg=;
        b=cMvRg+cQwJfgyd/u7eaHhyEFhkHqINQ5lLYyClI3PsmTCE8LhZIiZVDRB0Da4m6HHe
         c0Zpr27emsElttdq6uHqev3EvIL96uSsWI2xrfJEtt+MZhb3U8QkkrxWbXpTv1rGPtrb
         xCiupGkX1iW7Av9UjmdM8LT9xXSZGDa3v9tni/TCCHfbO/Jh+dfVUdkOO82L+1wO5/en
         mg0mAWPwsgwDgJ07EAzQacwc/yyAsEVINsKPJYtlmbBFk7/Fk3AYP1bw0ErriG5CI8gu
         CxlsV7LdkkDwzN5iDyJRBcPBweETAyNuMsOPlHWUxJUAjee+60dMBHkyAmKOSibXPpsC
         Ui9A==
X-Gm-Message-State: AOAM532hbBHNS/VppH6uz3tF97TEaDTsE0kJAVCKVTS0WMYbu4avYsNB
        z6eLl0UeBNk0CR+ij4oml5M=
X-Google-Smtp-Source: ABdhPJy8EM5pQmEMIslJHID50+RLzkBY759atuoK7g1AHSh5Hgttw0gI8CX7gLfJX76K3Wpx71j5pg==
X-Received: by 2002:a19:4c1:: with SMTP id 184mr5081180lfe.547.1603091435120;
        Mon, 19 Oct 2020 00:10:35 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id 131sm3108699lff.198.2020.10.19.00.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 00:10:34 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kUPJS-0000ID-Ui; Mon, 19 Oct 2020 09:10:35 +0200
Date:   Mon, 19 Oct 2020 09:10:34 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 5.9 054/111] USB: cdc-acm: handle broken union
 descriptors
Message-ID: <20201019071034.GP26280@localhost>
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-54-sashal@kernel.org>
 <20201019070218.GO26280@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019070218.GO26280@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 19, 2020 at 09:02:18AM +0200, Johan Hovold wrote:
> On Sun, Oct 18, 2020 at 03:17:10PM -0400, Sasha Levin wrote:
> > From: Johan Hovold <johan@kernel.org>
> > 
> > [ Upstream commit 960c7339de27c6d6fec13b54880501c3576bb08d ]
> > 
> > Handle broken union functional descriptors where the master-interface
> > doesn't exist or where its class is of neither Communication or Data
> > type (as required by the specification) by falling back to
> > "combined-interface" probing.
> > 
> > Note that this still allows for handling union descriptors with switched
> > interfaces.
> > 
> > This specifically makes the Whistler radio scanners TRX series devices
> > work with the driver without adding further quirks to the device-id
> > table.
> > 
> > Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > Acked-by: Oliver Neukum <oneukum@suse.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Link: https://lore.kernel.org/r/20200921135951.24045-3-johan@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I was surprised to see this picked up by AUTOSEL since I remember adding
> a stable tag to this patch (to v2, changed my mind since v1) -- and it's
> there in the lore link above.
> 
> Greg, just to make sure this wasn't due to a b4 bug; did you drop the
> stable tag on purpose when applying?
> 
> The tag-order has been reshuffled by b4 too it seems (I know, some
> people think that's ok) so maybe it fell out in the process.

Hmm. Apparently the Link-tag that I had added to keep a record of the
descriptors provided in the original report also fell out. Another b4
bug?

Adding Konstantin just in case.

Johan
