Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7756416FACF
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 10:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgBZJf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 04:35:26 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:34387 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgBZJfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 04:35:25 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2020 04:35:24 EST
Received: from [192.168.27.209] (unknown [37.157.136.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by extserv.mm-sol.com (Postfix) with ESMTPSA id 296ADCF89;
        Wed, 26 Feb 2020 11:27:26 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mm-sol.com; s=201706;
        t=1582709246; bh=9MPQJJaQlLFtjkVxyv5S5xHtxbzX1vQNXtMjE8xkyQo=;
        h=From:Subject:To:Cc:Date:From;
        b=mUk101MkKZlI/CTWli1Fy0qEor3s6M5jdtemHsXgKXmQKvEPEkzpIYklH+p3Mlahb
         oRv7eAMsfDxKA9dU3cZfmVLTRCZwC4fwOArA0KRJHivsKpDNMK9wP6yQqAdF8Uii6g
         OrXk8GwPryJOgOdFg1zUIq0aZc6SnLXQ94JUUxqOuwXm6vbHHN8KtPN01fqCX1OXXt
         pFj6peWM5gmFEMCLcrycAR0V43gbuhpbLPsc1Ss87LJNp9nLUXHhkpbzV4/xtuXyYn
         6OSAopjYtL/Z/VSfNN6igAhDt0PVrRNNOpO8zz33rWhyT4OO6fZEVtPEHA3xiqq2YJ
         VwJWj09wIvItQ==
From:   Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191227012717.78965-1-bjorn.andersson@linaro.org>
 <9e5ee7e8-aa63-e82c-8135-acc77b476c87@mm-sol.com>
 <38acf5fc-85aa-7090-e666-97a1281e9905@free.fr>
 <20191229024547.GH3755841@builder>
 <9c7d69cc-29e7-07c5-1e93-e9fdadf370a6@free.fr>
 <20200221143525.GC15440@e121166-lin.cambridge.arm.com>
Message-ID: <d9282b27-63ea-b1d6-1e43-9c7359f5f8d4@mm-sol.com>
Date:   Wed, 26 Feb 2020 11:27:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221143525.GC15440@e121166-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lorenzo,

On 2/21/20 4:35 PM, Lorenzo Pieralisi wrote:
> On Mon, Dec 30, 2019 at 09:25:28PM +0100, Marc Gonzalez wrote:
>> On 29/12/2019 03:45, Bjorn Andersson wrote:
>>
>>> On Sat 28 Dec 07:41 PST 2019, Marc Gonzalez wrote:
>>>
>>>> On 27/12/2019 09:51, Stanimir Varbanov wrote:
>>>>
>>>>> On 12/27/19 3:27 AM, Bjorn Andersson wrote:
>>>>>
>>>>>> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
>>>>>> the fixup to only affect the relevant PCIe bridges.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>>>>>> ---
>>>>>>
>>>>>> Stan, I picked up all the suggested device id's from the previous thread and
>>>>>> added 0x1000 for QCS404. I looked at creating platform specific defines in
>>>>>> pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
>>>>>> prefer that I do this anyway.
>>>>>
>>>>> Looks good,
>>>>>
>>>>> Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>>>>>
>>>>>>  drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
>>>>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
>>>>>> index 5ea527a6bd9f..138e1a2d21cc 100644
>>>>>> --- a/drivers/pci/controller/dwc/pcie-qcom.c
>>>>>> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
>>>>>> @@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
>>>>>>  {
>>>>>>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
>>>>>>  }
>>>>>> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
>>>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
>>>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
>>>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
>>>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
>>>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
>>>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
>>>>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
>>>>
>>>> Hrmmm... still not CCed on the patch,
>>>
>>> You are Cc'ed on the patch, but as usual your mail server responds "451
>>> too many errors from your ip" and throw my emails away.
>>>
>>>> and still don't think the fixup is required(?) for 0x106 and 0x107.
>>>>
>>>
>>> I re-read your reply in my v1 thread. So we know that 0x104 doesn't need
>>> the fixup, so presumably only 0x101 needs the fixup?
>>
>> I apologize for the tone of my reply. I did not mean to sound
>> so snarky.
>>
>> All I can say is that, if I remember correctly, the fixup was
>> not necessary on apq8098 (0x0105) and it was probably not
>> required on msm8996 and sdm845. For older platforms, all bets
>> are off.
> 
> How are we proceeding with this patch then ?

It took too much time, please take it as-is in v2 with my Ack.

We can drop the not-affected SoCs with follow-up patches once we are
sure that we do not break the supported SoCs.

-- 
regards,
Stan
