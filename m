Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636FC66DA7C
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 11:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbjAQKCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 05:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbjAQKBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 05:01:50 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63C72DE57;
        Tue, 17 Jan 2023 02:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673949706; x=1705485706;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=g3c6q4xrVsoepkNJvGfRFJLTApcNy3zIvRyFF7DCD5Y=;
  b=C7Cp9HrIFcSkwOauRvSoFMlXnLeRT38oUTB90oJrNtbXjk8ge4IAjcfD
   SiRpvsN+OCjTwch9ax7pEq98iN7FgRZF1IMkqEUfZbdT9SUye421YBi+x
   PNCOVI+miWBdlgS0ef0bWyfGTg1p8ts8LErNgDH/xw61ikzJ3OxPV/1n9
   U8r9QcFOq8e2LQDVTCuWc6LMuERWFpYJy1Oput6oxoQTYgSpBA+MX+4DC
   6o2+UmFQYJHtiQK1FDjAs7M+h2w3CtW2OUAGa4lx7H4QI9g1n8Un7v7EG
   GVGOfeKTFBmX5DxqWrj46BtHg7QN1n6tePMUgEIozWfbtSX82gsz+KioU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="312523018"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="312523018"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 02:01:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="833113665"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="833113665"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga005.jf.intel.com with ESMTP; 17 Jan 2023 02:01:44 -0800
Message-ID: <bd5ba5bb-4f1c-1ed9-8bd1-46fcd2eeac52@linux.intel.com>
Date:   Tue, 17 Jan 2023 12:02:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
To:     Ladislav Michl <oss-lists@triops.cz>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        Jimmy Hu <hhhuuu@google.com>, stable@vger.kernel.org
References: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
 <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
 <Y8WCdG5YSpX/Seit@lenoch>
Content-Language: en-US
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH 2/7] usb: xhci: Check endpoint is valid before
 dereferencing it
In-Reply-To: <Y8WCdG5YSpX/Seit@lenoch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.1.2023 18.59, Ladislav Michl wrote:
> Hi Mathias,
> 
> On Mon, Jan 16, 2023 at 04:22:11PM +0200, Mathias Nyman wrote:
>> From: Jimmy Hu <hhhuuu@google.com>
>>
>> When the host controller is not responding, all URBs queued to all
>> endpoints need to be killed. This can cause a kernel panic if we
>> dereference an invalid endpoint.
>>
>> Fix this by using xhci_get_virt_ep() helper to find the endpoint and
>> checking if the endpoint is valid before dereferencing it.
> 
> I'm a bit confused this goes in and even to stable. Let me quote your
> own analysis from
> Message-ID: <0fe978ed-8269-9774-1c40-f8a98c17e838@linux.intel.com>
> On Thu, Dec 22, 2022 at 03:18:53PM +0200, Mathias Nyman wrote:
>> I think root cause is that freeing xhci->devs[i] and including rings isn't
>> protected by the lock, this happens in xhci_free_virt_device() called by
>> xhci_free_dev(), which in turn may be called by usbcore at any time
>>
>> So xhci->devs[i] might just suddenly disappear
>>
>> Patch just checks more often if xhci->devs[i] is valid, between every endpoint.
>> So the race between xhci_free_virt_device() and xhci_kill_endpoint_urbs()
>> doesn't trigger null pointer deref as easily.> 
> I believe the above is correct and even Jimmy was unable to verify your
> later patch (3rd in this serie), which brings a question how could be this
> patch tested. It just burns a bug a bit deeper and I do not think it is the
> right approach.

As I said in a direct response to the original patch I think this is a valid fix
for older kernels where we used to unlock xhci->lock while giving back
URBs. Together with PATCH 3/7 the issue should be completely resolved.
For later kernels PATCH 3/7 should be enough by itself, but no harm in keeping this.

See Message-ID: <379b395f-b65c-96fe-7ecc-f18e3740b990@linux.intel.com>

Older kernels are all before v5.5 that lack commit
36dc01657b49 usb: host: xhci: Support running urb giveback in tasklet context.

I haven't been able to trigger this issue myself, but based on the report and finding in
the code I still think this the right approach. The internal testing this has been
through could only prove these patches (2/7 and 3/7) don't cause any additional issues.

If you think the analysis or solution is incorrect let me know, and we can come up with a
better one.

Thanks
Mathias

