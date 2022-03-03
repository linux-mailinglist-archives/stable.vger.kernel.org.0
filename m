Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9BC4CBBE0
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 11:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiCCK62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 05:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiCCK62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 05:58:28 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A203FBD0;
        Thu,  3 Mar 2022 02:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646305062; x=1677841062;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=sKoPepeMFBcySRf8nl4k0PsCl3jVayZFcUg8BBK5zUQ=;
  b=djnCCRsGV0M7r9rOAEaAZmJE/1ynmInWo5C+X6oLKv1Pn0X/uRhn/quB
   gCYbBdjObU7lc0eHsdK8lO376tw9p4tmhlNjHx3W5rOzTsj1awti0rVhu
   SeuLVvf8fT2AQfzcU9PUUkvHCCCLeUmK/QSWxYAuxaLl8Nvit5FnDexBZ
   hCljo08OFr+ow9Tx/oE9uPc+0s1jI1UiUOK1S1xYFoyaDUe/PkKSMc87g
   S8lAN5N+asY/eyD32u+7ykrn4tJX4wjzIkMbrYSkRf8j4hwBguCtiEJrw
   jP+lnYEmjsPpvyKmA4r5NOn5c5zJOwmS8icX3t7/bQolmqazTI43kESLB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="252468984"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="252468984"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 02:57:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="576449577"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 03 Mar 2022 02:57:40 -0800
Subject: Re: [PATCH 3/9] xhci: fix uninitialized string returned by
 xhci_decode_ctrl_ctx()
To:     Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
References: <20220303102656.1661407-1-mathias.nyman@linux.intel.com>
 <20220303102656.1661407-4-mathias.nyman@linux.intel.com>
 <4343c187-e40e-2804-5444-4a45c22e3781@bitwise.fi>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <51430531-b9f5-3da3-07da-d9c9b4562e14@linux.intel.com>
Date:   Thu, 3 Mar 2022 12:59:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4343c187-e40e-2804-5444-4a45c22e3781@bitwise.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3.3.2022 12.43, Anssi Hannula wrote:
> Hi,
> 
> On 3.3.2022 12.26, Mathias Nyman wrote:
>> From: Anssi Hannula <anssi.hannula@bitwise.fi>
>>
>> xhci_decode_ctrl_ctx() returns the untouched buffer as-is if both "drop"
>> and "add" parameters are zero.
>>
>> Fix the function to return an empty string in that case.
>>
>> It was not immediately clear from the possible call chains whether this
>> issue is currently actually triggerable or not.
>>
>> Note that before commit 4843b4b5ec64 ("xhci: fix even more unsafe memory
>> Cc: stable@vger.kernel.org
>> usage in xhci tracing") the result effect in the failure case was different
>> as a static buffer was used here, but the code still worked incorrectly.
> 
> You added the Cc-stable line a few lines too early above :)

Oops, copypaste accident. 

I'll resubmit 

Thanks
-Mathias
