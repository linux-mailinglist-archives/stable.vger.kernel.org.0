Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A9416FCEA
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 12:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgBZLF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 06:05:57 -0500
Received: from foss.arm.com ([217.140.110.172]:33972 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbgBZLF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 06:05:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40A841FB;
        Wed, 26 Feb 2020 03:05:56 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B7463FA00;
        Wed, 26 Feb 2020 03:05:54 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:05:49 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marc Gonzalez <marc.w.gonzalez@free.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
Message-ID: <20200226110549.GA16284@e121166-lin.cambridge.arm.com>
References: <20191227012717.78965-1-bjorn.andersson@linaro.org>
 <20200226102255.GA13830@e121166-lin.cambridge.arm.com>
 <4e1587e9-352c-a2de-d136-18506500641d@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e1587e9-352c-a2de-d136-18506500641d@mm-sol.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 12:56:23PM +0200, Stanimir Varbanov wrote:
> Hi Lorenzo,
> 
> On 2/26/20 12:22 PM, Lorenzo Pieralisi wrote:
> > On Thu, Dec 26, 2019 at 05:27:17PM -0800, Bjorn Andersson wrote:
> >> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
> >> the fixup to only affect the relevant PCIe bridges.
> >>
> >> Cc: stable@vger.kernel.org
> > 
> > Hi Bjorn,
> > 
> > to simplify stable's merging, would you mind helping me with
> > the stable releases you want this patch to apply to please ?
> > 
> 
> We've to have this in the patch:
> 
> Cc: stable@vger.kernel.org # v5.2+
> Fixes: 322f03436692 ("PCI: qcom: Use default config space read function")

Done, applied to pci/qcom for v5.7.

Thanks,
Lorenzo

> > I will apply it then.
> > 
> > Thanks,
> > Lorenzo
> > 
> >> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> >> ---
> >>
> >> Stan, I picked up all the suggested device id's from the previous thread and
> >> added 0x1000 for QCS404. I looked at creating platform specific defines in
> >> pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
> >> prefer that I do this anyway.
> >>
> >>  drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> >> index 5ea527a6bd9f..138e1a2d21cc 100644
> >> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> >> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> >> @@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
> >>  {
> >>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
> >>  }
> >> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
> >> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
> >> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
> >> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
> >> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
> >> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
> >> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
> >> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
> >>  
> >>  static struct platform_driver qcom_pcie_driver = {
> >>  	.probe = qcom_pcie_probe,
> >> -- 
> >> 2.24.0
> >>
> 
> -- 
> regards,
> Stan
