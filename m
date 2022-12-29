Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816BC658C60
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 12:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiL2LtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 06:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiL2LtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 06:49:16 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01258EE10;
        Thu, 29 Dec 2022 03:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672314554; x=1703850554;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n4tX9uVtsaVSzOHfp9IJXLazRHHzOs74y/0kur3sE+w=;
  b=Hthtop+475nRJ2AfgDYzLPwA2LK833tvnnl6NTcTFtyaMC73rE4AVCRh
   tRylGufYNCylh3v65dGB2N7cbgutzFiAF3xyZGc9KB0GdyrnMQWB/HubA
   COqXjBzDG5OaTuY4Md+5idrlFdmTuI2EUW5sSmfbKTQ1qiCZDLewq/xe6
   Mdf0BVUi2rx0IUdCrEYEWiuaX70ejTd78z0S+65HXeaE3H7jtILAVGo9u
   C5RRTniYfX1CKcSEqPGvPD4T4dHx/0wwZ9JhkiMQq+eWBsPdh9FBspGMB
   CRntA1pdPevmBPK8qgiblbttjrCTMDzIVIoiF7JeFIQet38ANQPW2V6a2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="318714321"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="318714321"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 03:49:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="716898232"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="716898232"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga008.fm.intel.com with ESMTP; 29 Dec 2022 03:49:12 -0800
Message-ID: <1bf75820-dcb1-e6f3-d01b-6dd246fa3666@linux.intel.com>
Date:   Thu, 29 Dec 2022 13:50:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v2] usb: xhci: Check endpoint is valid before
 dereferencing it
To:     Ladislav Michl <oss-lists@triops.cz>, Jimmy Hu <hhhuuu@google.com>
Cc:     mathias.nyman@intel.com, gregkh@linuxfoundation.org,
        badhri@google.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221222072912.1843384-1-hhhuuu@google.com>
 <Y6Qc1p4saGFTdh9n@lenoch>
 <23fe0fe3-f330-b58e-c366-3ac5bd80fe22@linux.intel.com>
 <Y6RFCjbMswOBoKdV@lenoch>
 <0fe978ed-8269-9774-1c40-f8a98c17e838@linux.intel.com>
Content-Language: en-US
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
In-Reply-To: <0fe978ed-8269-9774-1c40-f8a98c17e838@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.12.2022 15.18, Mathias Nyman wrote:
> On 22.12.2022 13.52, Ladislav Michl wrote:
>> On Thu, Dec 22, 2022 at 01:08:47PM +0200, Mathias Nyman wrote:
>>> On 22.12.2022 11.01, Ladislav Michl wrote:
>>>> On Thu, Dec 22, 2022 at 07:29:12AM +0000, Jimmy Hu wrote:
>>>>> When the host controller is not responding, all URBs queued to all
>>>>> endpoints need to be killed. This can cause a kernel panic if we
>>>>> dereference an invalid endpoint.
>>>>>
>>>>> Fix this by using xhci_get_virt_ep() helper to find the endpoint and
>>>>> checking if the endpoint is valid before dereferencing it.
>>>>>
>>>>> [233311.853271] xhci-hcd xhci-hcd.1.auto: xHCI host controller not responding, assume dead
>>>>> [233311.853393] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8
>>>>>
>>>>> [233311.853964] pc : xhci_hc_died+0x10c/0x270
>>>>> [233311.853971] lr : xhci_hc_died+0x1ac/0x270
>>>>>
>>>>> [233311.854077] Call trace:
>>>>> [233311.854085]  xhci_hc_died+0x10c/0x270
>>>>> [233311.854093]  xhci_stop_endpoint_command_watchdog+0x100/0x1a4
>>>>> [233311.854105]  call_timer_fn+0x50/0x2d4
>>>>> [233311.854112]  expire_timers+0xac/0x2e4
>>>>> [233311.854118]  run_timer_softirq+0x300/0xabc
>>>>> [233311.854127]  __do_softirq+0x148/0x528
>>>>> [233311.854135]  irq_exit+0x194/0x1a8
>>>>> [233311.854143]  __handle_domain_irq+0x164/0x1d0
>>>>> [233311.854149]  gic_handle_irq.22273+0x10c/0x188
>>>>> [233311.854156]  el1_irq+0xfc/0x1a8
>>>>> [233311.854175]  lpm_cpuidle_enter+0x25c/0x418 [msm_pm]
>>>>> [233311.854185]  cpuidle_enter_state+0x1f0/0x764
>>>>> [233311.854194]  do_idle+0x594/0x6ac
>>>>> [233311.854201]  cpu_startup_entry+0x7c/0x80
>>>>> [233311.854209]  secondary_start_kernel+0x170/0x198
>>>>>
>>>>> Fixes: 50e8725e7c42 ("xhci: Refactor command watchdog and fix split string.")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Jimmy Hu <hhhuuu@google.com>
>>>>> ---
>>>>>    drivers/usb/host/xhci-ring.c | 5 ++++-
>>>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
>>>>> index ddc30037f9ce..f5b0e1ce22af 100644
>>>>> --- a/drivers/usb/host/xhci-ring.c
>>>>> +++ b/drivers/usb/host/xhci-ring.c
>>>>> @@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
>>>>>        struct xhci_virt_ep *ep;
>>>>>        struct xhci_ring *ring;
>>>>> -    ep = &xhci->devs[slot_id]->eps[ep_index];
>>>>> +    ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
>>>>> +    if (!ep)
>>>>> +        return;
>>>>> +
>>>>
>>>> xhci_get_virt_ep also adds check for slot_id == 0. It changes behaviour,
>>>> do we really want to skip that slot? Original code went from 0 to
>>>> MAX_HC_SLOTS-1.
>>>>
>>>> It seems to be off by one to me. Am I missing anything?
>>>
>>> slot_id 0 is always invalid, so this is a good change.
>>
>> I see. Now reading more carefully:
>> #define HCS_MAX_SLOTS(p)    (((p) >> 0) & 0xff)
>> #define MAX_HC_SLOTS        256
>> So the loop should go:
>>     for (i = 1; i <= HCS_MAX_SLOTS(xhci->hcs_params1); i++)
> 
> yes
> 
>>
>>>> Also, what about passing ep directly to xhci_kill_endpoint_urbs
>>>> and do the check in xhci_hc_died? Not even compile tested:
>>>
>>> passing ep to a function named kill_endpoint_urbs() sound like the
>>> right thing to do, but as a generic change.
>>>
>>> I think its a good idea to first do a targeted fix for this null pointer
>>> issue that we can send to stable fist.
>>
>> Agree. But I still do not understand the root cause. There is a check
>> for NULL xhci->devs[i] already, so patch does not add much more, except
>> for test for slot_id == 0. And the eps array is just array of
>> struct xhci_virt_ep, not a pointers to them, so &xhci->devs[i]->eps[j]
>> should be always valid pointer. However struct xhci_ring in each eps
>> is allocated and not protected by any lock here. Is that correct?
> 
> I think root cause is that freeing xhci->devs[i] and including rings isn't
> protected by the lock, this happens in xhci_free_virt_device() called by
> xhci_free_dev(), which in turn may be called by usbcore at any time
> 
> So xhci->devs[i] might just suddenly disappear
> 
> Patch just checks more often if xhci->devs[i] is valid, between every endpoint.
> So the race between xhci_free_virt_device() and xhci_kill_endpoint_urbs()
> doesn't trigger null pointer deref as easily.

Jimmy Hu,

Any chance you could try if the change below works for you instead of
using xhci_get_virt_ep().
I don't have a easy way to trigger the issue-


diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 79d7931c048a..50b41213e827 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3974,6 +3974,7 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
  	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
  	struct xhci_virt_device *virt_dev;
  	struct xhci_slot_ctx *slot_ctx;
+	unsigned long flags;
  	int i, ret;
  
  	/*
@@ -4000,7 +4001,11 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
  		virt_dev->eps[i].ep_state &= ~EP_STOP_CMD_PENDING;
  	virt_dev->udev = NULL;
  	xhci_disable_slot(xhci, udev->slot_id);
+
+	spin_lock_irqsave(&xhci->lock, flags);
  	xhci_free_virt_device(xhci, udev->slot_id);
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
  }
  

Thanks
Mathias
