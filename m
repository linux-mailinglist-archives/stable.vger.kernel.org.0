Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE9C0887
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 17:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfI0P0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 11:26:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:28646 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0P0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 11:26:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 08:26:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="214866117"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.145])
  by fmsmga004.fm.intel.com with ESMTP; 27 Sep 2019 08:26:32 -0700
Date:   Fri, 27 Sep 2019 08:26:32 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>,
        linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v2] PCI: quirks: Fix register location for UPDCR
Message-ID: <20190927152632.GA4261@otc-nc-03>
References: <7a3505df-79ba-8a28-464c-88b83eefffa6@kernkonzept.com>
 <20190927125457.GA34765@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927125457.GA34765@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn



On Fri, Sep 27, 2019 at 07:54:57AM -0500, Bjorn Helgaas wrote:
> [+cc Andrew, Alex, Ashok]
> 
> Please cc people who commented on previous versions of a patch.  I
> added them for you here.
> 
> This is probably fine, but I'm waiting to see if Ashok gets a response
> from the chipset folks.  Hopefully he can ack this as a simple typo
> fix.
> 
> On Wed, Sep 18, 2019 at 03:16:52PM +0200, Steffen Liebergeld wrote:
> > According to documentation [0] the correct offset for the
> > Upstream Peer Decode Configuration Register (UPDCR) is 0x1014.
> > It was previously defined as 0x1114.

Finally someone in the HW team was able to lookup the documentation and 
it has stayed at 0x1014 per internal documentation. Apparently the genesis
is about 10 years ago :-)... so it took some time to hunt this from the team.

that's the final answer :-)

Cheers,
Ashok

> > 
> > Commit d99321b63b1f intends to enforce isolation between PCI
> > devices allowing them to be put into separate IOMMU groups.
> > Due to the wrong register offset the intended isolation was not
> > fully enforced. This is fixed with this patch.
> > 
> > Please note that I did not test this patch because I have
> > no hardware that implements this register.
> > 
> > [0]
> > https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/4th-gen-core-family-mobile-i-o-datasheet.pdf
> > (page 325)
> > 
> > Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
> > Reviewed-by: Andrew Murray <andrew.murray@arm.com>
> > Signed-off-by: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
> > ---
> >  drivers/pci/quirks.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 208aacf39329..7e184beb2aa4 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -4602,7 +4602,7 @@ int pci_dev_specific_acs_enabled(struct pci_dev
> > *dev, u16 acs_flags)
> >  #define INTEL_BSPR_REG_BPPD  (1 << 9)
> >   /* Upstream Peer Decode Configuration Register */
> > -#define INTEL_UPDCR_REG 0x1114
> > +#define INTEL_UPDCR_REG 0x1014
> >  /* 5:0 Peer Decode Enable bits */
> >  #define INTEL_UPDCR_REG_MASK 0x3f
> >  -- 2.11.0
> > 
> > 
