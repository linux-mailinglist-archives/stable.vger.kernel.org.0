Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8912E192B
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 13:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390623AbfJWLhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 07:37:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:48005 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732149AbfJWLhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 07:37:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 04:37:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="399362767"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.121])
  by fmsmga006.fm.intel.com with ESMTP; 23 Oct 2019 04:37:33 -0700
Date:   Wed, 23 Oct 2019 14:37:33 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Switch to platform_get_irq_optional()
Message-ID: <20191023113733.GB21973@linux.intel.com>
References: <20191019094528.27850-1-hdegoede@redhat.com>
 <20191021154942.GB4525@linux.intel.com>
 <80409d36-53fa-d159-d864-51b8495dc306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80409d36-53fa-d159-d864-51b8495dc306@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 05:56:56PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 21-10-2019 17:49, Jarkko Sakkinen wrote:
> > On Sat, Oct 19, 2019 at 11:45:28AM +0200, Hans de Goede wrote:
> > > Since commit 7723f4c5ecdb ("driver core: platform: Add an error message to
> > > platform_get_irq*()"), platform_get_irq() will call dev_err() on an error,
> > > as the IRQ usage in the tpm_tis driver is optional, this is undesirable.
> > > 
> > > Specifically this leads to this new false-positive error being logged:
> > > [    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found
> > > 
> > > This commit switches to platform_get_irq_optional(), which does not log
> > > an error, fixing this.
> > > 
> > > Cc: <stable@vger.kernel.org> # 5.4.x
> > 
> > Incorrect format (should be wo '<' and '>').
> 
> According to:
> 
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 
> the '<' and '>' should be added when adding a # <kerner>

OK, right so it was. This first patch that I'm reviewing with such
commit.

> > Also, not sure why this should be backported to stable kernel anyway.
> 
> Because false-positive error messages are bad and cause users to
> file false-positive bug-reports.

Neither categorizes into a regression albeit being unfortunate
glitches.

/Jarkko
