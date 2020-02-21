Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5135168065
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 15:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgBUOf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 09:35:29 -0500
Received: from foss.arm.com ([217.140.110.172]:40708 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgBUOf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 09:35:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DFE81FB;
        Fri, 21 Feb 2020 06:35:28 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 553413F703;
        Fri, 21 Feb 2020 06:35:27 -0800 (PST)
Date:   Fri, 21 Feb 2020 14:35:25 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
Message-ID: <20200221143525.GC15440@e121166-lin.cambridge.arm.com>
References: <20191227012717.78965-1-bjorn.andersson@linaro.org>
 <9e5ee7e8-aa63-e82c-8135-acc77b476c87@mm-sol.com>
 <38acf5fc-85aa-7090-e666-97a1281e9905@free.fr>
 <20191229024547.GH3755841@builder>
 <9c7d69cc-29e7-07c5-1e93-e9fdadf370a6@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c7d69cc-29e7-07c5-1e93-e9fdadf370a6@free.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 09:25:28PM +0100, Marc Gonzalez wrote:
> On 29/12/2019 03:45, Bjorn Andersson wrote:
> 
> > On Sat 28 Dec 07:41 PST 2019, Marc Gonzalez wrote:
> > 
> >> On 27/12/2019 09:51, Stanimir Varbanov wrote:
> >>
> >>> On 12/27/19 3:27 AM, Bjorn Andersson wrote:
> >>>
> >>>> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
> >>>> the fixup to only affect the relevant PCIe bridges.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> >>>> ---
> >>>>
> >>>> Stan, I picked up all the suggested device id's from the previous thread and
> >>>> added 0x1000 for QCS404. I looked at creating platform specific defines in
> >>>> pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
> >>>> prefer that I do this anyway.
> >>>
> >>> Looks good,
> >>>
> >>> Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> >>>
> >>>>  drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
> >>>>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> >>>> index 5ea527a6bd9f..138e1a2d21cc 100644
> >>>> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> >>>> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> >>>> @@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
> >>>>  {
> >>>>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
> >>>>  }
> >>>> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
> >>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
> >>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
> >>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
> >>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
> >>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
> >>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
> >>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
> >>
> >> Hrmmm... still not CCed on the patch,
> > 
> > You are Cc'ed on the patch, but as usual your mail server responds "451
> > too many errors from your ip" and throw my emails away.
> > 
> >> and still don't think the fixup is required(?) for 0x106 and 0x107.
> >>
> > 
> > I re-read your reply in my v1 thread. So we know that 0x104 doesn't need
> > the fixup, so presumably only 0x101 needs the fixup?
> 
> I apologize for the tone of my reply. I did not mean to sound
> so snarky.
> 
> All I can say is that, if I remember correctly, the fixup was
> not necessary on apq8098 (0x0105) and it was probably not
> required on msm8996 and sdm845. For older platforms, all bets
> are off.

How are we proceeding with this patch then ?

Thanks,
Lorenzo
