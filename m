Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27416861BC
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403786AbfHHMb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 08:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389951AbfHHMb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 08:31:27 -0400
Received: from localhost (173-25-83-245.client.mchsi.com [173.25.83.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E4221881;
        Thu,  8 Aug 2019 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565267486;
        bh=jPRA8WwVIBP3PqkfhSy/TiRINN02YI/sp1jGz5LU1/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E3/gFSiVht9KFJplSMpjko42etxgYXQisDrbuN818/Pn67cENeQhcfvA0qJjCyNnb
         4xvPZDFxFGNMVYPAGBi7FP301evhJWdbGR94yX6FjfW8h+/Ims0jgaeSvm1o/uh7mp
         A6i5AwHZqhucwkbw9Jy8kehJvnkZ7EhxuJHokVTw=
Date:   Thu, 8 Aug 2019 07:31:24 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Koenig, Christian" <Christian.Koenig@amd.com>
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] PCI: set BAR size bits correctly in Resize BAR
 control register
Message-ID: <20190808123124.GD151852@google.com>
References: <20190725192552.24295-1-sumit.saxena@broadcom.com>
 <20190807230149.GA151852@google.com>
 <ed70bffc-eed8-c3c5-ee9b-22e1cad1ae06@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed70bffc-eed8-c3c5-ee9b-22e1cad1ae06@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 08, 2019 at 07:01:03AM +0000, Koenig, Christian wrote:
> Am 08.08.19 um 01:01 schrieb Bjorn Helgaas:
> > On Fri, Jul 26, 2019 at 12:55:52AM +0530, Sumit Saxena wrote:
> >> In Resize BAR control register, bits[8:12] represents size of BAR.
> >> As per PCIe specification, below is encoded values in register bits
> >> to actual BAR size table:
> >>
> >> Bits  BAR size
> >> 0     1 MB
> >> 1     2 MB
> >> 2     4 MB
> >> 3     8 MB
> >> --
> >>
> >> For 1 MB BAR size, BAR size bits should be set to 0 but incorrectly
> >> these bits are set to "1f". Latest megaraid_sas and mpt3sas adapters
> >> which support Resizable BAR with 1 MB BAR size fails to initialize
> >> during system resume from S3 sleep.
> >>
> >> Fix: Correctly calculate BAR size bits for Resize BAR control register.
> >>
> >> V2:
> >> -Simplified calculation of BAR size bits as suggested by Christian Koenig.
> >>
> >> CC: stable@vger.kernel.org # v4.16+
> >> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203939
> >> Fixes: d3252ace0bc652a1a244455556b6a549f969bf99 ("PCI: Restore resized BAR state on resume")
> >> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> >> ---
> >>   drivers/pci/pci.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >> index 29ed5ec1ac27..e59921296125 100644
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -1438,7 +1438,7 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
> >>   		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
> >>   		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
> >>   		res = pdev->resource + bar_idx;
> >> -		size = order_base_2((resource_size(res) >> 20) | 1) - 1;
> >> +		size = order_base_2(resource_size(res) >> 20);
> > Since BAR sizes are always powers of 2, wouldn't this be simpler as:
> >
> > 		size = ilog2(resource_size(res)) - 20;
> >
> > which nicely matches the table in PCIe r5.0, sec 7.8.6.3?
> 
> Yeah, that should obviously work as well.
> 
> We would have a serious problem in the resource management if the 
> resource size is smaller than 1MB or not a power of two.

Yes, definitely.  Resizable BARs are required by spec to be 1MB or
larger, but this does niggle at me a little bit, too.  It probably
saves a few bits in pci_dev to recompute this at restore-time, but
honestly, I think it would be more obviously correct to just do the
simple-minded thing of saving and restoring the entire register.

> Feel free to add my r-b.

Done, thanks!

> Regards,
> Christian.
> 
> >
> >>   		ctrl &= ~PCI_REBAR_CTRL_BAR_SIZE;
> >>   		ctrl |= size << PCI_REBAR_CTRL_BAR_SHIFT;
> >>   		pci_write_config_dword(pdev, pos + PCI_REBAR_CTRL, ctrl);
> >> -- 
> >> 2.18.1
> >>
> 
