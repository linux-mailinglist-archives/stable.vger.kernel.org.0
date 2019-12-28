Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B5A12BDF3
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 16:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfL1Pla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Dec 2019 10:41:30 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:21342 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfL1Pla (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Dec 2019 10:41:30 -0500
Received: from [192.168.1.91] (unknown [77.207.133.132])
        (Authenticated sender: marc.w.gonzalez)
        by smtp4-g21.free.fr (Postfix) with ESMTPSA id 6AC7119F5A8;
        Sat, 28 Dec 2019 16:41:08 +0100 (CET)
Subject: Re: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
To:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191227012717.78965-1-bjorn.andersson@linaro.org>
 <9e5ee7e8-aa63-e82c-8135-acc77b476c87@mm-sol.com>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
Message-ID: <38acf5fc-85aa-7090-e666-97a1281e9905@free.fr>
Date:   Sat, 28 Dec 2019 16:41:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9e5ee7e8-aa63-e82c-8135-acc77b476c87@mm-sol.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/12/2019 09:51, Stanimir Varbanov wrote:

> On 12/27/19 3:27 AM, Bjorn Andersson wrote:
>
>> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
>> the fixup to only affect the relevant PCIe bridges.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> ---
>>
>> Stan, I picked up all the suggested device id's from the previous thread and
>> added 0x1000 for QCS404. I looked at creating platform specific defines in
>> pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
>> prefer that I do this anyway.
> 
> Looks good,
> 
> Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
>>  drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
>> index 5ea527a6bd9f..138e1a2d21cc 100644
>> --- a/drivers/pci/controller/dwc/pcie-qcom.c
>> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
>> @@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
>>  {
>>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
>>  }
>> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);

Hrmmm... still not CCed on the patch, and still don't think the
fixup is required(?) for 0x106 and 0x107.

Regards.
