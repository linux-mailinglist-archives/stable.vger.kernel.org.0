Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BE411FF02
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 08:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfLPH2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 02:28:32 -0500
Received: from mga18.intel.com ([134.134.136.126]:23635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfLPH2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 02:28:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Dec 2019 23:28:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,320,1571727600"; 
   d="scan'208";a="297607719"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by orsmga001.jf.intel.com with ESMTP; 15 Dec 2019 23:28:30 -0800
Subject: Re: FAILED: patch "[PATCH] xhci: make sure interrupts are restored to
 correct state" failed to apply to 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <15764020665465@kroah.com> <20191215180324.GH18043@sasha-vm>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <2c9ca886-f4d4-f478-c3bb-9247d59b6a3b@linux.intel.com>
Date:   Mon, 16 Dec 2019 09:30:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191215180324.GH18043@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.12.2019 20.03, Sasha Levin wrote:
> On Sun, Dec 15, 2019 at 10:27:46AM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From bd82873f23c9a6ad834348f8b83f3b6a5bca2c65 Mon Sep 17 00:00:00 2001
>> From: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Date: Wed, 11 Dec 2019 16:20:07 +0200
>> Subject: [PATCH] xhci: make sure interrupts are restored to correct state
>>
>> spin_unlock_irqrestore() might be called with stale flags after
>> reading port status, possibly restoring interrupts to a incorrect
>> state.
>>
>> If a usb2 port just finished resuming while the port status is read
>> the spin lock will be temporary released and re-acquired in a separate
>> function. The flags parameter is passed as value instead of a pointer,
>> not updating flags properly before the final spin_unlock_irqrestore()
>> is called.
>>
>> Cc: <stable@vger.kernel.org> # v3.12+
>> Fixes: 8b3d45705e54 ("usb: Fix xHCI host issues on remote wakeup.")
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Link: https://lore.kernel.org/r/20191211142007.8847-7-mathias.nyman@linux.intel.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> There were quite a few code movements around this:
> 
>      e67ebf1b3815 ("xhci: move usb2 get port status link resume handling to its own function")
>      5f78a54f8d31 ("xhci: move usb3 speficic bits to own function in get_port_status call")
>      70e9b53dfedc ("xhci: move usb2 speficic bits to own function in get_port_status call")
> 
> I've fixed up the original patch to work around that and queued for 4.19
> - 4.4.
> 

Thank you for backporting, there was a lot of code shuffled around in this area.

-Mathias
