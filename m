Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27794FAF39
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 12:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfKMLCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 06:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKMLCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 06:02:16 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A71982245D;
        Wed, 13 Nov 2019 11:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573642936;
        bh=2sFyRcCYHdBNrqaRNSf8B+NvRP5DzhSpWcrT3BMDuV0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=iw74jyK2NRY22Dg4VFYqkRLGJAzdn7UE5JbKQXEF8fwh8IEIGYEmi/9PFH1b6t6/X
         4znRXwGJaAoAeKZZrfx/cPBjUTBnPdqBwHjF76DAemk2Mhl//5tCFlRqCMxYOpNN0Q
         9eoOvTfoyuxynN/Ugf+ra69umleegJNyuGuStuDY=
Date:   Wed, 13 Nov 2019 12:02:11 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Pavel Machek <pavel@denx.de>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: Re: [PATCH 4.19 027/125] HID: wacom: generic: Treat serial number
 and related fields as unsigned
In-Reply-To: <20191113104724.GD32553@amd>
Message-ID: <nycvar.YFH.7.76.1911131201010.1799@cbobk.fhfr.pm>
References: <20191111181438.945353076@linuxfoundation.org> <20191111181444.186103315@linuxfoundation.org> <20191113104724.GD32553@amd>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 Nov 2019, Pavel Machek wrote:

> > From: Jason Gerecke <killertofu@gmail.com>
> > 
> > commit ff479731c3859609530416a18ddb3db5db019b66 upstream.
> > 
> > The HID descriptors for most Wacom devices oddly declare the serial
> > number and other related fields as signed integers. When these numbers
> > are ingested by the HID subsystem, they are automatically sign-extended
> > into 32-bit integers. We treat the fields as unsigned elsewhere in the
> > kernel and userspace, however, so this sign-extension causes problems.
> > In particular, the sign-extended tool ID sent to userspace as ABS_MISC
> > does not properly match unsigned IDs used by xf86-input-wacom and libwacom.
> > 
> > We introduce a function 'wacom_s32tou' that can undo the automatic sign
> > extension performed by 'hid_snto32'. We call this function when processing
> > the serial number and related fields to ensure that we are dealing with
> > and reporting the unsigned form. We opt to use this method rather than
> > adding a descriptor fixup in 'wacom_hid_usage_quirk' since it should be
> > more robust in the face of future devices.
> 
> > +++ b/drivers/hid/wacom.h
> > @@ -205,6 +205,21 @@ static inline void wacom_schedule_work(s
> >  	}
> >  }
> >  
> > +/*
> > + * Convert a signed 32-bit integer to an unsigned n-bit integer. Undoes
> > + * the normally-helpful work of 'hid_snto32' for fields that use signed
> > + * ranges for questionable reasons.
> > + */
> > +static inline __u32 wacom_s32tou(s32 value, __u8 n)
> > +{
> > +	switch (n) {
> > +	case 8:  return ((__u8)value);
> > +	case 16: return ((__u16)value);
> > +	case 32: return ((__u32)value);
> > +	}
> > +	return value & (1 << (n - 1)) ? value & (~(~0U << n)) : value;
> > +}
> 
> Can we do something like:
> 
>     BUG_ON(n>32);

Please no BUG_ON()s in bitop helpers.

Thanks,

-- 
Jiri Kosina
SUSE Labs

