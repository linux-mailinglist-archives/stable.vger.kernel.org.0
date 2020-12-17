Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B236C2DCF6B
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 11:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgLQKUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 05:20:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgLQKUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 05:20:34 -0500
Date:   Thu, 17 Dec 2020 11:19:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608200393;
        bh=jY4ps8uCooV8u+Tl4ow1NrBJT3axma8765wOmVWvCms=;
        h=From:To:cc:Subject:In-Reply-To:References:From;
        b=bDzAOWdWkiylXciUAaXTaWJ++rWAkAoqv4JbnLXdT1Q2S3NQAPZSx2AR1UAdDQuKP
         plVmdqMipkq79AQxGlHyQrZ82ER/9coeZTqg9p5pWz4c53qaYYYkbLprnbiwZGyKna
         Urf5313gKOa2uE6rM1MmzTo3m4tkfq4ko3mpjm9mdxZ9grcSKL6gDbMoajBvs9zlmo
         1X6RE+vuche5ZWwgj2rGZJ9wZh77iZ7qZrW3MGzKBZN9XFr2x7XuOoa8wqZjNkPQsO
         Ip5vEm8C878kjvG6+Xkg5sehQ9vzuGdKMB4TcOmsbxpSlCVmTXgBzG0tdlvkCNB7T4
         Furjq/TRPR0gA==
From:   Jiri Kosina <jikos@kernel.org>
To:     Will McVicker <willmcvicker@google.com>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        security@kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Will Coster <willcoster@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] HID: make arrays usage and value to be the same
In-Reply-To: <X9e5vl+nw4GQNYEw@google.com>
Message-ID: <nycvar.YFH.7.76.2012171119240.25826@cbobk.fhfr.pm>
References: <20201205004848.2541215-1-willmcvicker@google.com> <X9e5vl+nw4GQNYEw@google.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Dec 2020, Will McVicker wrote:

> > The HID subsystem allows an "HID report field" to have a different
> > number of "values" and "usages" when it is allocated. When a field
> > struct is created, the size of the usage array is guaranteed to be at
> > least as large as the values array, but it may be larger. This leads to
> > a potential out-of-bounds write in
> > __hidinput_change_resolution_multipliers() and an out-of-bounds read in
> > hidinput_count_leds().
> > 
> > To fix this, let's make sure that both the usage and value arrays are
> > the same size.
> > 
> > Signed-off-by: Will McVicker <willmcvicker@google.com>
> > ---
> >  drivers/hid/hid-core.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 56172fe6995c..8a8b2b982f83 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
> >   * Register a new field for this report.
> >   */
> >  
> > -static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
> > +static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages)
> >  {
> >  	struct hid_field *field;
> >  
> > @@ -101,7 +101,7 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
> >  
> >  	field = kzalloc((sizeof(struct hid_field) +
> >  			 usages * sizeof(struct hid_usage) +
> > -			 values * sizeof(unsigned)), GFP_KERNEL);
> > +			 usages * sizeof(unsigned)), GFP_KERNEL);
> >  	if (!field)
> >  		return NULL;
> >  
> > @@ -300,7 +300,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
> >  	usages = max_t(unsigned, parser->local.usage_index,
> >  				 parser->global.report_count);
> >  
> > -	field = hid_register_field(report, usages, parser->global.report_count);
> > +	field = hid_register_field(report, usages);
> >  	if (!field)
> >  		return 0;
> >  
> > -- 
> > 2.29.2.576.ga3fc446d84-goog
> > 
> 
> Hi Jiri and Benjamin,
> 
> This is a friendly reminder in case this got lost in your inbox.

Hi Will,

I am planning to merge it once the merge window is over.

-- 
Jiri Kosina
SUSE Labs

