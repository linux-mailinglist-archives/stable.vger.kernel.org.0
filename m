Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E146B6CA5F0
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 15:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjC0Nap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 09:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjC0Nao (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 09:30:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373F65FF2;
        Mon, 27 Mar 2023 06:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679923808; x=1711459808;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yyb51LByAX16MGbX4ZdRUMDN22yNkVuq56AERr10ryQ=;
  b=Fw7rpaE7bZzKms5/901VW8DR1LUN7pRGMc92QqTS0rdoJOMkUOk/6hMq
   3rn/pyOBwE7yXrv/mIeefgJmkRsXzjjt/Jx+1uaMvQLFZt4IRq13P0pUj
   cWRmVgTNBGyZ9FN0dgITE2KypKn29QTu1zIenD2dtNmIUrIHLv4U+2h2H
   rLeVkIqouF+h60zmUPqUYSE57agDvIrLCR6MV8BMPMWEIVh9Qg/7h9VJq
   6a64qYttx2aU+X3ZGd37SHMSRsh6ZxqtmXBhYqjkOdZUuYxlC+ptg/lDH
   yq3DV2MRKKg8GRnsn8Wn1Mqw3fkM1JToalcxRJB8PoIzvi6vAd5P8mky2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="405185261"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="405185261"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 06:30:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="685966791"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="685966791"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 06:30:00 -0700
Message-ID: <70474413-fcb0-7527-d7a3-67c3e55d0f1b@linux.intel.com>
Date:   Mon, 27 Mar 2023 16:31:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Subject: Re: [PATCH] xhci: Free the command allocated for setting LPM if we
 return early
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mirsad.todorovac@alu.unizg.hr, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ubuntu-devel-discuss@lists.ubuntu.com, stern@rowland.harvard.edu,
        arnd@arndb.de, Stable@vger.kernel.org
References: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
 <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
 <ZCGDRrT4Bo3-UYOZ@kroah.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
In-Reply-To: <ZCGDRrT4Bo3-UYOZ@kroah.com>
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

On 27.3.2023 14.51, Greg KH wrote:
> On Mon, Mar 27, 2023 at 12:50:19PM +0300, Mathias Nyman wrote:
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
> 
> Do you want me to take this now, or will you be sending this to me in a
> separate series of xhci fixes?  Either is fine with me.

I can send a separate series this week, there are some other fixes as well.

Thanks
Mathias

