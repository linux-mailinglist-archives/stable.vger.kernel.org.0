Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC20EE3BCF
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 21:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392877AbfJXTJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 15:09:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:41001 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390450AbfJXTJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 15:09:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 12:09:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="399870716"
Received: from nesterov-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.8.153])
  by fmsmga006.fm.intel.com with ESMTP; 24 Oct 2019 12:09:43 -0700
Date:   Thu, 24 Oct 2019 22:09:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Switch to platform_get_irq_optional()
Message-ID: <20191024190942.GA12038@linux.intel.com>
References: <20191019094528.27850-1-hdegoede@redhat.com>
 <20191021154942.GB4525@linux.intel.com>
 <80409d36-53fa-d159-d864-51b8495dc306@redhat.com>
 <20191023113733.GB21973@linux.intel.com>
 <d6adeb21-f7b3-5c64-fa32-03a8ee21cc53@redhat.com>
 <20191024142519.GA3881@linux.intel.com>
 <c6a0c3e3-c5c8-80d9-b6b6-bf45d66f4b32@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6a0c3e3-c5c8-80d9-b6b6-bf45d66f4b32@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 04:27:24PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 24-10-2019 16:25, Jarkko Sakkinen wrote:
> > On Wed, Oct 23, 2019 at 04:32:57PM +0200, Hans de Goede wrote:
> > > Hi,
> > > 
> > > On 23-10-2019 13:37, Jarkko Sakkinen wrote:
> > > > On Mon, Oct 21, 2019 at 05:56:56PM +0200, Hans de Goede wrote:
> > > > > Hi,
> > > > > 
> > > > > On 21-10-2019 17:49, Jarkko Sakkinen wrote:
> > > > > > On Sat, Oct 19, 2019 at 11:45:28AM +0200, Hans de Goede wrote:
> > > > > > > Since commit 7723f4c5ecdb ("driver core: platform: Add an error message to
> > > > > > > platform_get_irq*()"), platform_get_irq() will call dev_err() on an error,
> > > > > > > as the IRQ usage in the tpm_tis driver is optional, this is undesirable.
> > > > > > > 
> > > > > > > Specifically this leads to this new false-positive error being logged:
> > > > > > > [    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found
> > > > > > > 
> > > > > > > This commit switches to platform_get_irq_optional(), which does not log
> > > > > > > an error, fixing this.
> > > > > > > 
> > > > > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > > > 
> > > > > > Incorrect format (should be wo '<' and '>').
> > > > > 
> > > > > According to:
> > > > > 
> > > > > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > > > > 
> > > > > the '<' and '>' should be added when adding a # <kerner>
> > > > 
> > > > OK, right so it was. This first patch that I'm reviewing with such
> > > > commit.
> > > > 
> > > > > > Also, not sure why this should be backported to stable kernel anyway.
> > > > > 
> > > > > Because false-positive error messages are bad and cause users to
> > > > > file false-positive bug-reports.
> > > > 
> > > > Neither categorizes into a regression albeit being unfortunate
> > > > glitches.
> > > 
> > > The stable series also does other small fixes, such as adding new
> > > pci/usb-ids, etc. This clearly falls within this. IMHO ideally this
> > > should go to a 5.4-rc# making the whole discussion moot, but since
> > > I was afraid it would not make 5.4, I added the Cc: stable.
> > 
> > I get adding PCI/USB id as it extends the hardware support for the
> > stable kernel without risking its stability. This patch is factors
> > less useful.
> 
> It also has about 0% chance of causing regressions and it does
> help to avoid false--positive bug reports.
> 
> TBH I'm quite surprised we are even having this discussion...
> 
> Regards,
> 
> Hans

Why do you think that way?

I mean the commit does not even have a fixes line. It already obviously
implies that this kind of discussion is mandatory. Your reasoning in
this discussion does make sense. The problem is really the commit
message supplied.

I'd guess something like this would be more appropriate:

"
platform_get_irq() calls dev_err() on an error. As the IRQ usage in the
tpm_tis driver is optional, this is undesirable.

Specifically this leads to this new false-positive error being logged:
[    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found

This commit switches to platform_get_irq_optional(), which does not log
an error, fixing this.

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()"
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
"

You should confirm this by sending v2 either what I proposed unmodified
or with the changes that you see appropriate.

/Jarkko
