Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3FE6CB8CC
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 09:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjC1H4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 03:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjC1H4J (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 03:56:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011333C3D;
        Tue, 28 Mar 2023 00:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679990168; x=1711526168;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=vAiH/S0RUQmNTQntq0xo+aCAtjnA1nAOevVXhchtR14=;
  b=H5XOQB3lGvnwuJTs8tAaD5KkF6I1HE8gdVhw/LdVsOU34TzN6wgyEcHf
   y13o35OPEjsuUwt+RjCuZ/ygVpcE9sLrQtWiqBWPpqjeZbljeJzELy7E+
   zr0nJAGmC0jgiEkmytuasEOxWfw+jj4LA1DGY5bneGMlnoTnWZSXArYkk
   LLKAiBTpXMsIlz02WW89A7N7qzuvXWt/c1vbrKn+qaEqSKWUOJ8oOyVvr
   LiiccGy43xoFLdYBNn95rVGRxrv3PPae8Rw1HWKSiIRaoIQY+a3Ig1z1X
   h9okSDYM4QF9aH074VH+M89ml2xbxzZ69eFYeo7N0L250rfx1TvMhVOlY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="405435126"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="405435126"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 00:56:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="827381167"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="827381167"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 28 Mar 2023 00:56:04 -0700
Message-ID: <46a9abc1-6121-032f-4416-261af73ac05c@linux.intel.com>
Date:   Tue, 28 Mar 2023 10:57:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Content-Language: en-US
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, ubuntu-devel-discuss@lists.ubuntu.com,
        stern@rowland.harvard.edu, arnd@arndb.de, Stable@vger.kernel.org
References: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
 <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
 <d84fe574-e6cc-ad77-a44c-1eb8df3f2b6b@alu.unizg.hr>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] xhci: Free the command allocated for setting LPM if we
 return early
In-Reply-To: <d84fe574-e6cc-ad77-a44c-1eb8df3f2b6b@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.3.2023 1.25, Mirsad Goran Todorovac wrote:
> On 27. 03. 2023. 11:50, Mathias Nyman wrote:
>> The command allocated to set exit latency LPM values need to be freed in
>> case the command is never queued. This would be the case if there is no
>> change in exit latency values, or device is missing.
>>
>> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>> Cc: <Stable@vger.kernel.org>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>   drivers/usb/host/xhci.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>> index bdb6dd819a3b..6307bae9cddf 100644
>> --- a/drivers/usb/host/xhci.c
>> +++ b/drivers/usb/host/xhci.c
>> @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>>   
>>   	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
>>   		spin_unlock_irqrestore(&xhci->lock, flags);
>> +		xhci_free_command(xhci, command);
>>   		return 0;
>>   	}
>>   
> 
> After more testing, I can confirm that your patch fixes the leak in the original
> environment.

Thanks for testing.
Can I add the tags below to the patch?
  
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>

Thanks
Mathias


