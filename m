Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAE31A6BE9
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 20:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbgDMSH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 14:07:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:12741 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387625AbgDMSHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 14:07:55 -0400
IronPort-SDR: sKboh4/Y7aTpmZiguA/viJDnB/Onuj2n1w6U3PO1VU5GE8HWnYalFkRM+5E3XHzqUC7kTrN83K
 VzOFal+Sriyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 11:07:55 -0700
IronPort-SDR: XnU/oKghhk93OP1z9CxvGAh0ddFLpKhKu5c6Whx6OH+EaCzbI5w/dNdxxkWxgeRao2LJ6cH+9Z
 drasZ0jwu20g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,378,1580803200"; 
   d="scan'208";a="256250288"
Received: from sarsteda-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.40.211])
  by orsmga006.jf.intel.com with ESMTP; 13 Apr 2020 11:07:34 -0700
Date:   Mon, 13 Apr 2020 21:07:32 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm/tpm_tis: Free IRQ if probing fails
Message-ID: <20200413180732.GA11147@linux.intel.com>
References: <20200412170412.324200-1-jarkko.sakkinen@linux.intel.com>
 <b909aaee-3fff-4dca-40f4-4c5348474426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b909aaee-3fff-4dca-40f4-4c5348474426@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 12:04:25PM +0200, Hans de Goede wrote:
> Hi Jarkko,
> 
> On 4/12/20 7:04 PM, Jarkko Sakkinen wrote:
> > Call devm_free_irq() if we have to revert to polling in order not to
> > unnecessarily reserve the IRQ for the life-cycle of the driver.
> > 
> > Cc: stable@vger.kernel.org # 4.5.x
> > Reported-by: Hans de Goede <hdegoede@redhat.com>
> > Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >   drivers/char/tpm/tpm_tis_core.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index 27c6ca031e23..ae6868e7b696 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -1062,9 +1062,12 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
> >   		if (irq) {
> >   			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
> >   						 irq);
> > -			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
> > +			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
> >   				dev_err(&chip->dev, FW_BUG
> >   					"TPM interrupt not working, polling instead\n");
> > +				devm_free_irq(chip->dev.parent, priv->irq,
> > +					      chip);
> > +			}
> 
> My initial plan was actually to do something similar, but if the probe code
> is actually ever fixed to work as intended again then this will lead to a
> double free as then the IRQ-test path of tpm_tis_send() will have called
> disable_interrupts() which already calls devm_free_irq().
> 
> You could check for chip->irq != 0 here to avoid that.
> 
> But it all is rather messy, which is why I went with the "#if 0" approach
> in my patch.

I think it is right way to fix it. It is a bug independent of the issue
we are experiencing.

However, what you are suggesting should be done in addition. Do you have
a patch in place or do you want me to refine mine?

/Jarkko
