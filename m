Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18492155353
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 08:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgBGH5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 02:57:00 -0500
Received: from mga17.intel.com ([192.55.52.151]:22018 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgBGH5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 02:57:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 23:56:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,412,1574150400"; 
   d="scan'208";a="345684049"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 06 Feb 2020 23:56:55 -0800
Received: by lahna (sSMTP sendmail emulation); Fri, 07 Feb 2020 09:56:54 +0200
Date:   Fri, 7 Feb 2020 09:56:54 +0200
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
Message-ID: <20200207075654.GB2667@lahna.fi.intel.com>
References: <20200205194804.1647-1-mst@semihalf.com>
 <20200206083149.GK2667@lahna.fi.intel.com>
 <CAMiGqYi2rVAc=hepkY-4S1U_3dJdbR4pOoB0f8tbBL4pzWLdxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMiGqYi2rVAc=hepkY-4S1U_3dJdbR4pOoB0f8tbBL4pzWLdxA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 11:26:54PM +0100, Michał Stanek wrote:
> On Thu, Feb 6, 2020 at 9:31 AM Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> >
> > On Wed, Feb 05, 2020 at 08:48:04PM +0100, Michal Stanek wrote:
> > > Dropping custom Linux GPIO translation caused some Intel_Strago based Chromebooks
> > > with old firmware to detect GPIOs incorrectly. Add quirk which restores some code removed by
> > > commit 03c4749dd6c7ff94 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation").
> >
> > Hi,
> >
> > Can you elaborate this? I was under the impression that all the
> > different Strago systems have been already worked around by patches from
> > Dmitry (Cc'd).
> 
> Hi Mika,
> 
> The previous patches from Dmitry handled IRQ numbering, here we have a
> similar issue with GPIO to pin translation - hardcoded values in FW
> which do not agree with the (non-consecutive) numbering in newer
> kernels.

Hmm, so instead of passing GpioIo/GpioInt resources to devices the
firmware uses some hard-coded Linux GPIO numbering scheme? Would you
able to share the exact firmware description where this happens?

> > What GPIO(s) we are talking about and how does it show up to the user?
> 
> As an example, the issue manifests itself when you run 'crossystem
> wpsw_cur'. On my Kefka it incorrectly reports the value as 1 instead
> of 0 when the write protect screw is removed.

Is it poking GPIOs directly through sysfs relying the Linux GPIO
numbering (which can change and is fragile anyway)?
