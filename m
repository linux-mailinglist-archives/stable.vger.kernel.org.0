Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C99C2946
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 00:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfI3WFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 18:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfI3WFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 18:05:43 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC84215EA;
        Mon, 30 Sep 2019 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569881143;
        bh=9ivt8JrwB0PoO0cTjmVjhM38nkKnJ9SjG9vrPakQX/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=FfOqq1QAS6m+LeJVl0uWQek2A80OQTNMQ9OHaeYpDSITloQtAzu8WLZNxfjBAWsWo
         Kv2fD9Aof7Md0SG+Cb9nzUVGA+MxDlDEDYm32H4XxV5SPy/R3NXzj2VXGECB7/APn7
         dtIFJ5v+GvJeqKOIx6++CaO6HnB+pVK9WFog0tmA=
Date:   Mon, 30 Sep 2019 17:05:41 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>,
        linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2] PCI: quirks: Fix register location for UPDCR
Message-ID: <20190930220541.GA209848@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927152632.GA4261@otc-nc-03>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 27, 2019 at 08:26:32AM -0700, Raj, Ashok wrote:
> On Fri, Sep 27, 2019 at 07:54:57AM -0500, Bjorn Helgaas wrote:
> > [+cc Andrew, Alex, Ashok]
> > 
> > Please cc people who commented on previous versions of a patch.  I
> > added them for you here.
> > 
> > This is probably fine, but I'm waiting to see if Ashok gets a response
> > from the chipset folks.  Hopefully he can ack this as a simple typo
> > fix.
> > 
> > On Wed, Sep 18, 2019 at 03:16:52PM +0200, Steffen Liebergeld wrote:
> > > According to documentation [0] the correct offset for the
> > > Upstream Peer Decode Configuration Register (UPDCR) is 0x1014.
> > > It was previously defined as 0x1114.
> 
> Finally someone in the HW team was able to lookup the documentation and 
> it has stayed at 0x1014 per internal documentation. Apparently the genesis
> is about 10 years ago :-)... so it took some time to hunt this from the team.
> 
> that's the final answer :-)

So I *think* that's an ack for this patch, right?

> > > Commit d99321b63b1f intends to enforce isolation between PCI
> > > devices allowing them to be put into separate IOMMU groups.
> > > Due to the wrong register offset the intended isolation was not
> > > fully enforced. This is fixed with this patch.
> > > 
> > > Please note that I did not test this patch because I have
> > > no hardware that implements this register.
> > > 
> > > [0]
> > > https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/4th-gen-core-family-mobile-i-o-datasheet.pdf
> > > (page 325)
> > > 
> > > Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
> > > Reviewed-by: Andrew Murray <andrew.murray@arm.com>
> > > Signed-off-by: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>

And I suppose this should have a stable tag.  d99321b63b1f appeared in
v3.15.

I applied this as below to pci/virtualization for v5.5, thanks!

commit e50992e80279
Author: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
Date:   Wed Sep 18 15:16:52 2019 +0200

    PCI: Fix Intel ACS quirk UPDCR register address
    
    According to documentation [0] the correct offset for the Upstream Peer
    Decode Configuration Register (UPDCR) is 0x1014.  It was previously defined
    as 0x1114.
    
    d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
    intended to enforce isolation between PCI devices allowing them to be put
    into separate IOMMU groups.  Due to the wrong register offset the intended
    isolation was not fully enforced.  This is fixed with this patch.
    
    Please note that I did not test this patch because I have no hardware that
    implements this register.
    
    [0] https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/4th-gen-core-family-mobile-i-o-datasheet.pdf (page 325)
    Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
    Link: https://lore.kernel.org/r/7a3505df-79ba-8a28-464c-88b83eefffa6@kernkonzept.com
    Signed-off-by: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Reviewed-by: Andrew Murray <andrew.murray@arm.com>
    Acked-by: Ashok Raj <ashok.raj@intel.com>
    Cc: stable@vger.kernel.org      # v3.15+

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4e5048cb5ec6..23508c359296 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4713,7 +4713,7 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
 #define INTEL_BSPR_REG_BPPD  (1 << 9)
 
 /* Upstream Peer Decode Configuration Register */
-#define INTEL_UPDCR_REG 0x1114
+#define INTEL_UPDCR_REG 0x1014
 /* 5:0 Peer Decode Enable bits */
 #define INTEL_UPDCR_REG_MASK 0x3f
 
