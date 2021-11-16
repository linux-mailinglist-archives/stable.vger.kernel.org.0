Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA28452CFF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 09:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhKPIks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 03:40:48 -0500
Received: from mga04.intel.com ([192.55.52.120]:20502 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231863AbhKPIks (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 03:40:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="232371497"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="232371497"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 00:37:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="645391943"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 16 Nov 2021 00:37:49 -0800
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stern@rowland.harvard.edu, kishon@ti.com, hdegoede@redhat.com,
        chris.chiu@canonical.com, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <20211115221630.871204-1-mathias.nyman@linux.intel.com>
 <YZNqQBd+pcXBQuAp@kroah.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] usb: hub: Fix usb enumeration issue due to address0 race
Message-ID: <dd32d4ab-dff9-0080-7911-5e1931af5c3e@linux.intel.com>
Date:   Tue, 16 Nov 2021 10:39:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YZNqQBd+pcXBQuAp@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.11.2021 10.22, Greg KH wrote:
> On Tue, Nov 16, 2021 at 12:16:30AM +0200, Mathias Nyman wrote:
>> xHC hardware can only have one slot in default state with address 0
>> waiting for a unique address at a time, otherwise "undefined behavior
>> may occur" according to xhci spec 5.4.3.4
>>
>> The address0_mutex exists to prevent this across both xhci roothubs.
>>
>> If hub_port_init() fails, it may unlock the mutex and exit with a xhci
>> slot in default state. If the other xhci roothub calls hub_port_init()
>> at this point we end up with two slots in default state.
>>
>> Make sure the address0_mutex protects the slot default state across
>> hub_port_init() retries, until slot is addressed or disabled.
>>
>> Note, one known minor case is not fixed by this patch.
>> If device needs to be reset during resume, but fails all hub_port_init()
>> retries in usb_reset_and_verify_device(), then it's possible the slot is
>> still left in default state when address0_mutex is unlocked.
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> What commit id does this "fix"?
> 

Looks like original cause could be:
638139eb95d2 ("usb: hub: allow to process more usb hub events in parallel")

which was partially fixed in 4.7 by:
feb26ac31a2a ("usb: core: hub: hub_port_init lock controller instead of bus")

And now improved by this patch 

-Mathias
