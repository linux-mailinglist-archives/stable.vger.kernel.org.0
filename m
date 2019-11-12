Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C33F8B6C
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 10:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLJLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 04:11:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:33670 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLJLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 04:11:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 01:11:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,295,1569308400"; 
   d="scan'208";a="207048672"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003.jf.intel.com with ESMTP; 12 Nov 2019 01:11:34 -0800
Received: from andy by smile with local (Exim 4.93-RC1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iUSCz-0005w8-6J; Tue, 12 Nov 2019 11:11:33 +0200
Date:   Tue, 12 Nov 2019 11:11:33 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, malin.jonsson@ericsson.com,
        mika.westerberg@linux.intel.com, oliver.barta@aptiv.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: intel: Avoid potential glitches
 if pin is in GPIO" failed to apply to 4.19-stable tree
Message-ID: <20191112091133.GQ32742@smile.fi.intel.com>
References: <157345199314214@kroah.com>
 <20191111131907.GR4787@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111131907.GR4787@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 08:19:07AM -0500, Sasha Levin wrote:
> On Mon, Nov 11, 2019 at 06:59:53AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 29c2c6aa32405dfee4a29911a51ba133edcedb0f Mon Sep 17 00:00:00 2001
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Date: Mon, 14 Oct 2019 12:51:04 +0300
> > Subject: [PATCH] pinctrl: intel: Avoid potential glitches if pin is in GPIO
> > mode
> > 
> > When consumer requests a pin, in order to be on the safest side,
> > we switch it first to GPIO mode followed by immediate transition
> > to the input state. Due to posted writes it's luckily to be a single
> > I/O transaction.
> > 
> > However, if firmware or boot loader already configures the pin
> > to the GPIO mode, user expects no glitches for the requested pin.
> > We may check if the pin is pre-configured and leave it as is
> > till the actual consumer toggles its state to avoid glitches.
> 
> I've queued it up for 4.19, it was just a minor conflict with
> e58926e781d8 ("pinctrl: intel: Use GENMASK() consistently").

Thank you!

> However, for 4.14 and older:
> 
> > Fixes: 7981c0015af2 ("pinctrl: intel: Add Intel Sunrisepoint pin controller and GPIO support")
> > Depends-on: f5a26acf0162 ("pinctrl: intel: Initialize GPIO properly when used through irqchip")
> 
> We need to take this "Depends-on" commit, but in the past we have
> reverted it:
> 
> https://lore.kernel.org/lkml/20180427135732.999030511@linuxfoundation.org/

Yes, as the commit says that we have a lot of dependencies.

> So I didn't do anything with this patch for <=4.14.

So far so good, thanks!

P.S. In case we need it in the future, we will prepare a backport patch
ourselves.

-- 
With Best Regards,
Andy Shevchenko


