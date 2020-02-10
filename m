Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5829D1572A2
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgBJKOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 05:14:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:44766 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgBJKOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 05:14:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 02:14:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,424,1574150400"; 
   d="scan'208";a="347020341"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 10 Feb 2020 02:14:15 -0800
Received: by lahna (sSMTP sendmail emulation); Mon, 10 Feb 2020 12:14:14 +0200
Date:   Mon, 10 Feb 2020 12:14:14 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     =?utf-8?Q?Micha=C5=82?= Stanek <mst@semihalf.com>
Cc:     linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stanekm@google.com,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        levinale@chromium.org, andriy.shevchenko@linux.intel.com,
        Linus Walleij <linus.walleij@linaro.org>,
        bgolaszewski@baylibre.com, rafael.j.wysocki@intel.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation
 of ACPI GPIO numbers
Message-ID: <20200210101414.GN2667@lahna.fi.intel.com>
References: <20200205194804.1647-1-mst@semihalf.com>
 <20200206083149.GK2667@lahna.fi.intel.com>
 <CAMiGqYi2rVAc=hepkY-4S1U_3dJdbR4pOoB0f8tbBL4pzWLdxA@mail.gmail.com>
 <20200207075654.GB2667@lahna.fi.intel.com>
 <CAMiGqYjmd2edUezEXsX4JBSyOozzks1Pu8miPEviGsx=x59nZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMiGqYjmd2edUezEXsX4JBSyOozzks1Pu8miPEviGsx=x59nZQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 08, 2020 at 07:43:24PM +0100, Michał Stanek wrote:
> > >
> > > Hi Mika,
> > >
> > > The previous patches from Dmitry handled IRQ numbering, here we have a
> > > similar issue with GPIO to pin translation - hardcoded values in FW
> > > which do not agree with the (non-consecutive) numbering in newer
> > > kernels.
> >
> > Hmm, so instead of passing GpioIo/GpioInt resources to devices the
> > firmware uses some hard-coded Linux GPIO numbering scheme? Would you
> > able to share the exact firmware description where this happens?
> 
> Actually it is a GPIO offset in ACPI tables for Braswell that was
> hardcoded in the old firmware to match the previous (consecutive)
> Linux GPIO numbering.

Can you share the ACPI tables and point me to the GPIO that is using
Linux number?

> > > > What GPIO(s) we are talking about and how does it show up to the user?
> > >
> > > As an example, the issue manifests itself when you run 'crossystem
> > > wpsw_cur'. On my Kefka it incorrectly reports the value as 1 instead
> > > of 0 when the write protect screw is removed.
> >
> > Is it poking GPIOs directly through sysfs relying the Linux GPIO
> > numbering (which can change and is fragile anyway)?
> 
> I believe so, yes.

This is something that should be fixed in userspace. Using global Linux
GPIO or IRQ numbers is fragile and source of issues like this. There are
correct ways of using GPIOs from userspace: in case of sysfs, you can
find the base of the chip and then user relative numbering against it or
switch to use libgpiod that does the same but uses the newer char
device. Both cases the GPIO number are relative against the GPIO chip so
they work even if global Linux GPIO numbering changes.
