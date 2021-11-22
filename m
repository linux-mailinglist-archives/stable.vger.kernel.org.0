Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1937F458C85
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 11:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhKVKqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 05:46:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:62187 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhKVKqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 05:46:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10175"; a="234587802"
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="234587802"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 02:42:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="649417612"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 22 Nov 2021 02:42:57 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kishon@ti.com
Cc:     hdegoede@redhat.com, chris.chiu@canonical.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
References: <20211115221630.871204-1-mathias.nyman@linux.intel.com>
 <CGME20211118111915eucas1p2cf4a502442e7259c6c347daf0d87259e@eucas1p2.samsung.com>
 <f3bfcbc7-f701-c74a-09bd-6491d4c8d863@samsung.com>
 <c6e720fc-03a3-f6d2-e486-b81e5a3c5e89@linux.intel.com>
Subject: Re: [PATCH] usb: hub: Fix usb enumeration issue due to address0 race
Message-ID: <1d6ef5ff-e5e2-b81e-42be-7876b5bcfd05@linux.intel.com>
Date:   Mon, 22 Nov 2021 12:44:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c6e720fc-03a3-f6d2-e486-b81e5a3c5e89@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.11.2021 15.50, Mathias Nyman wrote:
> On 18.11.2021 13.19, Marek Szyprowski wrote:
>> Hi,
>>
>> On 15.11.2021 23:16, Mathias Nyman wrote:
>>> xHC hardware can only have one slot in default state with address 0
>>> waiting for a unique address at a time, otherwise "undefined behavior
>>> may occur" according to xhci spec 5.4.3.4
>>>
>>> The address0_mutex exists to prevent this across both xhci roothubs.
>>>
>>> If hub_port_init() fails, it may unlock the mutex and exit with a xhci
>>> slot in default state. If the other xhci roothub calls hub_port_init()
>>> at this point we end up with two slots in default state.
>>>
>>> Make sure the address0_mutex protects the slot default state across
>>> hub_port_init() retries, until slot is addressed or disabled.
>>>
>>> Note, one known minor case is not fixed by this patch.
>>> If device needs to be reset during resume, but fails all hub_port_init()
>>> retries in usb_reset_and_verify_device(), then it's possible the slot is
>>> still left in default state when address0_mutex is unlocked.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>
>> This patch landed in linux next-20211118 as commit 6ae6dc22d2d1 ("usb: 
>> hub: Fix usb enumeration issue due to address0 race"). On my test 
>> systems it triggers the following deplock warning during system 
>> suspend/resume cycle:
>>
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> 5.16.0-rc1-00014-g6ae6dc22d2d1 #4126 Not tainted
>> ------------------------------------------------------
>> kworker/u16:8/738 is trying to acquire lock:
>> cf81f738 (hcd->address0_mutex){+.+.}-{3:3}, at: 
>> usb_reset_and_verify_device+0xe8/0x3e4
>>
>> but task is already holding lock:
>> cf80ab3c (&port_dev->status_lock){+.+.}-{3:3}, at: 
>> usb_port_resume+0xa0/0x7e8
>>
> 
> Thanks, I see it now.
> 
> Lock order is:
>   mutex_lock(&port_dev->status_lock)
>     mutex_lock(hcd->address0_mutex)
>     mutex_unlock(hcd->address0_mutex)
>   mutex_unlock(&port_dev->status_lock)
> in hub_port_connect(), usb_port_resume() and usb_reset_device()
> 
> But patch changed the status_lock and address0_mutex lock order in hub_port_connect().
> Lets see if we can take the status_lock a bit earlier in hub_port_connect() to
> solve this.
> 

I can easily reproduce this myself now.
I'll send a patch on top of this one to fix it.
Lockdep warnings are gone for me after applying it,
Also fixes an unbalanced address0_mutex unlock in error codepath.

Grateful if someone else could try it out as well.

Thanks 
-Mathias





