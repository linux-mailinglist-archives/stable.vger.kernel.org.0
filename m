Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9080A2682A7
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 04:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgINCfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Sep 2020 22:35:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43264 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725969AbgINCfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Sep 2020 22:35:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600050944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JuEVqBIYofi1f+3PPcI8zQb71WljDFGGzBS/722/WcA=;
        b=gqqe6UqpQ/sz4oLJXYP0hqBweN81WHDS/KwReh3rSQnqmA7nt0XpOBQMOYdeqSiDZw9puZ
        wiC/PsW3Xrt8wAfXTSgqR92HaF4ieyS22fyc9K20ztAcrKi/Y/gj0AB+TJ+aKAxDG6x1af
        O76UUq/ut/U9+2dQodMpIm/CDnDpmrc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-pJ8OkG1_PI2ueqBXsrJlyw-1; Sun, 13 Sep 2020 22:35:39 -0400
X-MC-Unique: pJ8OkG1_PI2ueqBXsrJlyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7D8C1091063;
        Mon, 14 Sep 2020 02:35:37 +0000 (UTC)
Received: from [10.72.13.25] (ovpn-13-25.pek2.redhat.com [10.72.13.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1773819C4F;
        Mon, 14 Sep 2020 02:35:27 +0000 (UTC)
Subject: Re: [PATCH] intel-iommu: don't disable ATS for device without page
 aligned request
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     dwmw2@infradead.org, baolu lu <baolu.lu@linux.intel.com>,
        joro@8bytes.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, eperezma@redhat.com,
        peterx@redhat.com, mst@redhat.com, stable@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20200909083432.9464-1-jasowang@redhat.com>
 <20200909171056.GF104641@otc-nc-03>
 <491540137.16465450.1599704255365.JavaMail.zimbra@redhat.com>
 <20200910155303.GC97190@otc-nc-03>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ef925e93-5931-0c50-d154-9fd332b1e87d@redhat.com>
Date:   Mon, 14 Sep 2020 10:35:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200910155303.GC97190@otc-nc-03>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/9/10 下午11:53, Raj, Ashok wrote:
> On Wed, Sep 09, 2020 at 10:17:35PM -0400, Jason Wang wrote:
>>
>> ----- Original Message -----
>>> Hi Jason
>>>
>>> On Wed, Sep 09, 2020 at 04:34:32PM +0800, Jason Wang wrote:
>>>> Commit 61363c1474b1 ("iommu/vt-d: Enable ATS only if the device uses
>>>> page aligned address.") disables ATS for device that can do unaligned
>>>> page request.
>>> Did you take a look at the PCI specification?
>>> Page Aligned Request is in the ATS capability Register.
>>>
>>> ATS Capability Register (Offset 0x04h)
>>>
>>> bit (5):
>>> Page Aligned Request - If Set, indicates the Untranslated address is always
>>> aligned to 4096 byte boundary. Setting this field is recommended. This
>>> field permits software to distinguish between implemntations compatible
>>> with this specification and those compatible with an earlier version of
>>> this specification in which a Requester was permitted to supply anything in
>>> bits [11:2].
>> Yes, my understanding is that this is optional not mandatory.
> Correct, but optional on the device side. An IOMMU might *require* this for
> proper normal operation. Our IOMMU's do not get the low 12 bits. Which is
> why the spec gives SW a way to detect if the device is compatible for this
> IOMMU implementation.


I see, it's better to clarify this in the spec (or is there already had 
a section for this?)


>
>>>> This looks wrong, since the commit log said it's because the page
>>>> request descriptor doesn't support reporting unaligned request.
>>> I don't think you can change the definition from ATS to PRI. Both are
>>> orthogonal feature.
>> I may miss something, here's my understanding is that:
>>
>> - page request descriptor will only be used when PRS is enabled
>> - ATS spec allows unaligned request
>>
>> So any reason for disabling ATS for unaligned request even if PRS is
>> not enabled?
> I think you are getting confused between the 2 different PCIe features.
>
> ATS - Address Translation Services. Used by device to simply request the
> Host Physical Address for some DMA operation.
>
> When ATS response indicates failed, then the device can request a
> page-request (PRS this is like a device page-fault), and then IOMMU driver
> would work with the kernel to fault a page then respond with
> (Page-response) success/failure. Then the device will send a new ATS
> to get the new translation.


Yes, that's my understanding as well. I think what confuses me is the 
commit log of 61363c1474b1 which ties a PRI queue to ATS features ...


>
>
>>>> A victim is Qemu's virtio-pci which doesn't advertise the page aligned
>>>> address. Fixing by disable PRI instead of ATS if device doesn't have
>>>> page aligned request.
>>> This is a requirement for the Intel IOMMU's.
>>>
>>> You say virtio, so is it all emulated device or you talking about some
>>> hardware that implemented virtio-pci compliant hw? If you are sure the
>>> device actually does comply with the requirement, but just not enumerating
>>> the capability, you can maybe work a quirk to overcome that?
>> So far only emulated devices. But we are helping some vendor to
>> implement virtio hardware so  we need to understand the connection
>> between ATS alignment and page request descriptor.
> ATS and PRS are 2 separate orthogonal features.
> PRS requires ATS, but not the other way around.
>
>>> Now PRI also has an alignment requirement, and Intel IOMMU's requires that
>>> as well. If your device supports SRIOV as well, PASID and PRI are
>>> enumerated just on the PF and not the VF. You might want to pay attension
>>> to that. We are still working on a solution for that problem.
>> Thanks for the reminding, but it looks to me according to the ATS
>> spec, all PRI message is 4096 byte aligned? E.g lower bites were used
>> for group index etc.
> Right, I should have been clear. The issue with PRI is we require responses
> to have PASID field set. There is another capability on the device that
> exposes that. pci_prg_resp_pasid_required(). This is required to enable PRI
> for a device.


Right. Thanks for the clarification, I will withdraw this patch.


>
> Cheers,
> Ashok
>

