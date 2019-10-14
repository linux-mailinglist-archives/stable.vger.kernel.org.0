Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A649D6395
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbfJNNQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 09:16:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:57917 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbfJNNQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 09:16:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 06:16:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,295,1566889200"; 
   d="scan'208";a="220100314"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by fmsmga004.fm.intel.com with ESMTP; 14 Oct 2019 06:16:44 -0700
Subject: Re: [RFT PATCH] xhci: Fix use-after-free regression in xhci clear hub
 TT implementation
To:     Johan Hovold <johan@kernel.org>
Cc:     gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, "# v5 . 3" <stable@vger.kernel.org>
References: <1c4b7107-f5e1-4a69-2a73-0e339c7e1072@linux.intel.com>
 <1570798722-31594-1-git-send-email-mathias.nyman@linux.intel.com>
 <20191014101611.GN13531@localhost>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <7e88dd63-9cd6-1149-10a0-960e944ef31f@linux.intel.com>
Date:   Mon, 14 Oct 2019 16:18:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191014101611.GN13531@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.10.2019 13.16, Johan Hovold wrote:
> On Fri, Oct 11, 2019 at 03:58:42PM +0300, Mathias Nyman wrote:
>> commit ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer") schedules work
>> to clear TT buffer, but causes a use-after-free regression at the same time
>>
>> Make sure hub_tt_work finishes before endpoint is disabled, otherwise
>> the work will dereference already freed endpoint and device related
>> pointers.
>>
>> This was triggered when usb core failed to read the configuration
>> descriptor of a FS/LS device during enumeration.
>> xhci driver queued clear_tt_work while usb core freed and reallocated
>> a new device for the next enumeration attempt.
>>
>> EHCI driver implents ehci_endpoint_disable() that makes sure
>> clear_tt_work has finished before it returns, but xhci lacks this support.
>> usb core will call hcd->driver->endpoint_disable() callback before
>> disabling endpoints, so we want this in xhci as well.
>>
>> The added xhci_endpoint_disable() is based on ehci_endpoint_disable()
>>
> 
> I used essentially the same reproducer as you did for debugging this
> after I first hit it with an actually stalled control endpoint, and this
> patch works also with my fault-injection hack.
> 
> I've reviewed the code and it looks good to me except for one mostly
> theoretical issue. You need to check ep->hc_priv while holding the
> xhci->lock in xhci_clear_tt_buffer_complete() or you could end up having
> xhci_endpoint_disable() reschedule indefinitely while waiting for
> EP_CLEARING_TT to be cleared on a sufficiently weakly ordered
> system.

Good point, I'll change that

> 
> Since cfbb8a84c2d2 ("xhci: Fix NULL pointer dereference in
> xhci_clear_tt_buffer_complete()") isn't needed anymore and is slightly
> misleading, I suggest amending the patch with the following:
> 

I'll add those changes and your tags to the patch

Thanks
Mathias
