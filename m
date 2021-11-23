Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F37459F34
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 10:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhKWJcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 04:32:43 -0500
Received: from mga06.intel.com ([134.134.136.31]:6466 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235178AbhKWJcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 04:32:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="295797038"
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="295797038"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 01:29:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="650013487"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2021 01:29:32 -0800
To:     Hans de Goede <hdegoede@redhat.com>, m.szyprowski@samsung.com,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kishon@ti.com
Cc:     chris.chiu@canonical.com, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <1d6ef5ff-e5e2-b81e-42be-7876b5bcfd05@linux.intel.com>
 <20211122105003.1089218-1-mathias.nyman@linux.intel.com>
 <132b6778-91e7-d758-2636-9561e5aa347f@redhat.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [RFT PATCH] usb: hub: Fix locking issues with address0_mutex
Message-ID: <29620153-d829-d31e-6f2b-a4093f040b84@linux.intel.com>
Date:   Tue, 23 Nov 2021 11:31:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <132b6778-91e7-d758-2636-9561e5aa347f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.11.2021 17.41, Hans de Goede wrote:
> Hi,
> 
> On 11/22/21 11:50, Mathias Nyman wrote:
>> Fix the circular lock dependency and unbalanced unlock of addess0_mutex
>> introduced when fixing an address0_mutex enumeration retry race in commit
>> ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
>>
>> Make sure locking order between port_dev->status_lock and address0_mutex
>> is correct, and that address0_mutex is not unlocked in hub_port_connect
>> "done:" codepath which may be reached without locking address0_mutex
>>
>> Fixes: 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> Oh, this is great, with this patch I can finally hot-plug my
> thunderbolt dock (and thus a XHCI controller) without the XHCI
> controller given a whole bunch of weird errors (and some USB
> devices not working), which it does not when already connected at boot.
> 
> I also tried the hotplug thingy with the previous fix without
> this locking fix and then I actually hit the deadlock and things
> like lsusb would hang.
> 
> If we can get these 2 fixes together merged soon and also backported
> to the stable series that would be great:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Hans de Goede <hdegoede@redhat.com>
> 
> Regards,
> 
> Hans
> 

Thanks for testing, I'll add your tags and submit this.

-Mathias
