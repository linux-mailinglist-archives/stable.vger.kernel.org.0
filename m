Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C57727238F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIUMRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:17:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:35922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgIUMRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:17:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600690642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2WOB/LsKGVOS4/FNcum1bDPrDTePrSfKOmWeegawm6M=;
        b=Zt+26VaPHHDeVljzZ848AbXPE+5uUM9ujyWMbRVIYVh/V4seFQ39TxODBCL3KsFpb6ZmEl
        tVIM687xwkr1mL12xR/xGbANIL0LnGddPLq0WK8SHdmWISWiRnYqpmDw6oho9umGwOgTED
        a8F0Yra4bNZ+HPVr12q7B+YszKuPaps=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D44CAC4D;
        Mon, 21 Sep 2020 12:17:58 +0000 (UTC)
Message-ID: <1600690627.2424.80.camel@suse.com>
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
From:   Oliver Neukum <oneukum@suse.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Date:   Mon, 21 Sep 2020 14:17:07 +0200
In-Reply-To: <20200921120302.GU24441@localhost>
References: <20200921081022.6881-1-johan@kernel.org>
         <1600677792.2424.61.camel@suse.com> <20200921093145.GS24441@localhost>
         <1600684156.2424.65.camel@suse.com> <20200921113601.GT24441@localhost>
         <1600688954.2424.76.camel@suse.com> <20200921120302.GU24441@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Montag, den 21.09.2020, 14:03 +0200 schrieb Johan Hovold:
> On Mon, Sep 21, 2020 at 01:49:14PM +0200, Oliver Neukum wrote:
> > Am Montag, den 21.09.2020, 13:36 +0200 schrieb Johan Hovold:
> > > On Mon, Sep 21, 2020 at 12:29:16PM +0200, Oliver Neukum wrote:
> > 
> > Hi,
> > 
> > > I meant that instead of falling back to "combined-interface" probing we
> > > could assume that all interfaces with three endpoints are "combined" and
> > > simply ignore the union and call managementy. descriptors and all the ways
> > > that devices may have gotten those wrong.
> > 
> > I am afraid we would break the spec. I cannot recall a prohibition on
> > having more endpoints than necessary. Heuristics and ignoring invalid
> > descriptors is one things. Ignoring valid descriptors is something
> > else.
> 
> That depends on how you read the spec (see "3.3.1 Communication Class
> Interface"). But sure, it's probably be better to err on the safe-side.

You mean 3.4.1?

> > > I was thinking more of the individual entries in the device-id table
> > > whose control interfaces may not even be of the Communication class. But
> > > hopefully that was verified when adding them.
> > 
> > Now you are confusing me. In case of a quirky device, why change
> > the current logic?
> 
> Just because they have a quirk defined, doesn't mean they don't rely on
> the generic probe algorithm (e.g. a USB_DEVICE entry which matches all
> interface classes and only specifies SEND_ZERO_PACKET).

Right, so let me be more specific. It would probably be unwise to
change the decision tree in probe() as far as devices whose quirks
affect decisions in that already are concerned.

	Regards
		Oliver

