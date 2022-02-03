Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCACC4A8960
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352660AbiBCRKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:10:01 -0500
Received: from foss.arm.com ([217.140.110.172]:58168 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352539AbiBCRJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Feb 2022 12:09:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01A6C147A;
        Thu,  3 Feb 2022 09:09:48 -0800 (PST)
Received: from lpieralisi (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00B973F40C;
        Thu,  3 Feb 2022 09:09:46 -0800 (PST)
Date:   Thu, 3 Feb 2022 17:09:41 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Hongxing Zhu <hongxing.zhu@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] PCI: imx6: Allow to probe when
 dw_pcie_wait_for_link() fails
Message-ID: <20220203170941.GA26554@lpieralisi>
References: <20220106103645.2790803-1-festevam@gmail.com>
 <AS8PR04MB8676540C48042F8E71D45E098C4D9@AS8PR04MB8676.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8PR04MB8676540C48042F8E71D45E098C4D9@AS8PR04MB8676.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 07, 2022 at 03:12:45AM +0000, Hongxing Zhu wrote:
> > -----Original Message-----
> > From: Fabio Estevam <festevam@gmail.com>
> > Sent: Thursday, January 6, 2022 6:37 PM
> > To: bhelgaas@google.com
> > Cc: lorenzo.pieralisi@arm.com; robh@kernel.org;
> > l.stach@pengutronix.de; Hongxing Zhu <hongxing.zhu@nxp.com>;
> > linux-pci@vger.kernel.org; Fabio Estevam <festevam@gmail.com>;
> > stable@vger.kernel.org
> > Subject: [PATCH v2] PCI: imx6: Allow to probe when
> > dw_pcie_wait_for_link() fails
> > 
> > The intention of commit 886a9c134755 ("PCI: dwc: Move link handling
> > into common code") was to standardize the behavior of link down as
> > explained in its commit log:
> > 
> > "The behavior for a link down was inconsistent as some drivers would fail
> > probe in that case while others succeed. Let's standardize this to succeed
> > as there are usecases where devices (and the link) appear later even
> > without hotplug. For example, a reconfigured FPGA device."
> > 
> > The pci-imx6 still fails to probe when the link is not present, which causes
> > the following warning:
> > 
> > imx6q-pcie 8ffc000.pcie: Phy link never came up
> > imx6q-pcie: probe of 8ffc000.pcie failed with error -110 ------------[ cut
> > here ]------------
> > WARNING: CPU: 0 PID: 30 at drivers/regulator/core.c:2257
> > _regulator_put.part.0+0x1b8/0x1dc Modules linked in:
> > CPU: 0 PID: 30 Comm: kworker/u2:2 Not tainted 5.15.0-next-20211103
> > #1 Hardware name: Freescale i.MX6 SoloX (Device Tree)
> > Workqueue: events_unbound async_run_entry_fn [<c0111730>]
> > (unwind_backtrace) from [<c010bb74>] (show_stack+0x10/0x14)
> > [<c010bb74>] (show_stack) from [<c0f90290>]
> > (dump_stack_lvl+0x58/0x70) [<c0f90290>] (dump_stack_lvl) from
> > [<c012631c>] (__warn+0xd4/0x154) [<c012631c>] (__warn) from
> > [<c0f87b00>] (warn_slowpath_fmt+0x74/0xa8) [<c0f87b00>]
> > (warn_slowpath_fmt) from [<c076b4bc>]
> > (_regulator_put.part.0+0x1b8/0x1dc)
> > [<c076b4bc>] (_regulator_put.part.0) from [<c076b574>]
> > (regulator_put+0x2c/0x3c) [<c076b574>] (regulator_put) from
> > [<c08c3740>] (release_nodes+0x50/0x178)
> > 
> > Fix this problem by ignoring the dw_pcie_wait_for_link() error like it is
> > done on the other dwc drivers.
> > 
> > Tested on imx6sx-sdb and imx6q-sabresd boards.
> > 
> > Cc: <stable@vger.kernel.org>
> > Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
> > Signed-off-by: Fabio Estevam <festevam@gmail.com>
> [Richard Zhu] Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>

Please, there is no need to add [Richard Zhu] to let us understand
it is you, this breaks tools that pick up tags automatically so
refrain from using it, thanks.

Lorenzo

> > Changes since v1:
> > - Remove the printk timestamp from the kernel warning log (Richard).
> > 
> >  drivers/pci/controller/dwc/pci-imx6.c | 10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/pci/controller/dwc/pci-imx6.c
> > b/drivers/pci/controller/dwc/pci-imx6.c
> > index 2ac081510632..5e8a03061b31 100644
> > --- a/drivers/pci/controller/dwc/pci-imx6.c
> > +++ b/drivers/pci/controller/dwc/pci-imx6.c
> > @@ -807,9 +807,7 @@ static int imx6_pcie_start_link(struct dw_pcie
> > *pci)
> >  	/* Start LTSSM. */
> >  	imx6_pcie_ltssm_enable(dev);
> > 
> > -	ret = dw_pcie_wait_for_link(pci);
> > -	if (ret)
> > -		goto err_reset_phy;
> > +	dw_pcie_wait_for_link(pci);
> > 
> >  	if (pci->link_gen == 2) {
> >  		/* Allow Gen2 mode after the link is up. */ @@ -845,11 +843,7
> > @@ static int imx6_pcie_start_link(struct dw_pcie *pci)
> >  		}
> > 
> >  		/* Make sure link training is finished as well! */
> > -		ret = dw_pcie_wait_for_link(pci);
> > -		if (ret) {
> > -			dev_err(dev, "Failed to bring link up!\n");
> > -			goto err_reset_phy;
> > -		}
> > +		dw_pcie_wait_for_link(pci);
> >  	} else {
> >  		dev_info(dev, "Link: Gen2 disabled\n");
> >  	}
> > --
> > 2.25.1
> 
