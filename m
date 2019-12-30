Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88412D47A
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 21:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfL3U3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 15:29:51 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:18254 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbfL3U3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 15:29:51 -0500
Received: from [192.168.1.91] (unknown [77.207.133.132])
        (Authenticated sender: marc.w.gonzalez)
        by smtp4-g21.free.fr (Postfix) with ESMTPSA id 4F4BA19F5E6;
        Mon, 30 Dec 2019 21:25:39 +0100 (CET)
Subject: Re: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191227012717.78965-1-bjorn.andersson@linaro.org>
 <9e5ee7e8-aa63-e82c-8135-acc77b476c87@mm-sol.com>
 <38acf5fc-85aa-7090-e666-97a1281e9905@free.fr>
 <20191229024547.GH3755841@builder>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
Message-ID: <9c7d69cc-29e7-07c5-1e93-e9fdadf370a6@free.fr>
Date:   Mon, 30 Dec 2019 21:25:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191229024547.GH3755841@builder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/12/2019 03:45, Bjorn Andersson wrote:

> On Sat 28 Dec 07:41 PST 2019, Marc Gonzalez wrote:
> 
>> On 27/12/2019 09:51, Stanimir Varbanov wrote:
>>
>>> On 12/27/19 3:27 AM, Bjorn Andersson wrote:
>>>
>>>> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
>>>> the fixup to only affect the relevant PCIe bridges.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>>>> ---
>>>>
>>>> Stan, I picked up all the suggested device id's from the previous thread and
>>>> added 0x1000 for QCS404. I looked at creating platform specific defines in
>>>> pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
>>>> prefer that I do this anyway.
>>>
>>> Looks good,
>>>
>>> Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>>>
>>>>  drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
>>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
>>>> index 5ea527a6bd9f..138e1a2d21cc 100644
>>>> --- a/drivers/pci/controller/dwc/pcie-qcom.c
>>>> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
>>>> @@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
>>>>  {
>>>>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
>>>>  }
>>>> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
>>
>> Hrmmm... still not CCed on the patch,
> 
> You are Cc'ed on the patch, but as usual your mail server responds "451
> too many errors from your ip" and throw my emails away.
> 
>> and still don't think the fixup is required(?) for 0x106 and 0x107.
>>
> 
> I re-read your reply in my v1 thread. So we know that 0x104 doesn't need
> the fixup, so presumably only 0x101 needs the fixup?

I apologize for the tone of my reply. I did not mean to sound
so snarky.

All I can say is that, if I remember correctly, the fixup was
not necessary on apq8098 (0x0105) and it was probably not
required on msm8996 and sdm845. For older platforms, all bets
are off.

Regards.
