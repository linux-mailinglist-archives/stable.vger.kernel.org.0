Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0401A8589
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438788AbgDNQpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 12:45:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:24750 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437673AbgDNQpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 12:45:46 -0400
IronPort-SDR: UEx0Wz/tcgCqqc+75yEB8UooHTd3KJopeDo88nLZyCZcz9hcQaOvbR1VGrKbIXjIQ/FeeaLvFc
 HiXXgX9imGUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 09:45:43 -0700
IronPort-SDR: z7JprYkC0W+GU1lzE/oFAicDp7GOQzPHqlDgEhs7DAGPt7JLtYBPuj0y15Sz0nc6otbpAXgcNr
 add1aAMJskLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,383,1580803200"; 
   d="scan'208";a="454616261"
Received: from shiyaowa-mobl.ger.corp.intel.com (HELO localhost) ([10.249.43.105])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2020 09:45:42 -0700
Date:   Tue, 14 Apr 2020 19:45:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm/tpm_tis: Free IRQ if probing fails
Message-ID: <20200414164542.GC32775@linux.intel.com>
References: <20200412170412.324200-1-jarkko.sakkinen@linux.intel.com>
 <b909aaee-3fff-4dca-40f4-4c5348474426@redhat.com>
 <20200413180732.GA11147@linux.intel.com>
 <7df7f8bd-c65e-1435-7e82-b9f4ecd729de@redhat.com>
 <20200414071349.GA8403@linux.intel.com>
 <d6684575-ce91-fe72-6035-11834a05cd54@redhat.com>
 <20200414160404.GA32775@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414160404.GA32775@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 07:04:07PM +0300, Jarkko Sakkinen wrote:
> On Tue, Apr 14, 2020 at 10:26:32AM +0200, Hans de Goede wrote:
> > Hi,
> > 
> > On 4/14/20 9:13 AM, Jarkko Sakkinen wrote:
> > > On Mon, Apr 13, 2020 at 08:11:15PM +0200, Hans de Goede wrote:
> > > > Hi,
> > > > 
> > > > On 4/13/20 8:07 PM, Jarkko Sakkinen wrote:
> > > > > On Mon, Apr 13, 2020 at 12:04:25PM +0200, Hans de Goede wrote:
> > > > > > Hi Jarkko,
> > > > > > 
> > > > > > On 4/12/20 7:04 PM, Jarkko Sakkinen wrote:
> > > > > > > Call devm_free_irq() if we have to revert to polling in order not to
> > > > > > > unnecessarily reserve the IRQ for the life-cycle of the driver.
> > > > > > > 
> > > > > > > Cc: stable@vger.kernel.org # 4.5.x
> > > > > > > Reported-by: Hans de Goede <hdegoede@redhat.com>
> > > > > > > Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
> > > > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > > > ---
> > > > > > >     drivers/char/tpm/tpm_tis_core.c | 5 ++++-
> > > > > > >     1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > > > > > > index 27c6ca031e23..ae6868e7b696 100644
> > > > > > > --- a/drivers/char/tpm/tpm_tis_core.c
> > > > > > > +++ b/drivers/char/tpm/tpm_tis_core.c
> > > > > > > @@ -1062,9 +1062,12 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
> > > > > > >     		if (irq) {
> > > > > > >     			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
> > > > > > >     						 irq);
> > > > > > > -			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
> > > > > > > +			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
> > > > > > >     				dev_err(&chip->dev, FW_BUG
> > > > > > >     					"TPM interrupt not working, polling instead\n");
> > > > > > > +				devm_free_irq(chip->dev.parent, priv->irq,
> > > > > > > +					      chip);
> > > > > > > +			}
> > > > > > 
> > > > > > My initial plan was actually to do something similar, but if the probe code
> > > > > > is actually ever fixed to work as intended again then this will lead to a
> > > > > > double free as then the IRQ-test path of tpm_tis_send() will have called
> > > > > > disable_interrupts() which already calls devm_free_irq().
> > > > > > 
> > > > > > You could check for chip->irq != 0 here to avoid that.
> > 
> > Erm in case you haven't figured it out yet this should be priv->irq != 0, sorry.
> 
> Yup.
> 
> > > > > > 
> > > > > > But it all is rather messy, which is why I went with the "#if 0" approach
> > > > > > in my patch.
> > > > > 
> > > > > I think it is right way to fix it. It is a bug independent of the issue
> > > > > we are experiencing.
> > > > > 
> > > > > However, what you are suggesting should be done in addition. Do you have
> > > > > a patch in place or do you want me to refine mine?
> > > > 
> > > > I do not have a patch ready for this, if you can refine yours that would
> > > > be great.
> > > 
> > > Thanks! Just wanted to confirm.
> > 
> > And thank you for working on a (temporary?) fix for this.
> 
> As far as I see it, it is orthogonal fix that needs to be backported
> to stable kernels. This bug predates the issue we're seeing now.

Hey, I came to other thoughts on "how". Would probably make sense
to always call disable_interrupts() aka no sense to add two separate
code paths. What do you think?

/Jarkko
