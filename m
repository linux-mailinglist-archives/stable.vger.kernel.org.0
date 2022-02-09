Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EA34AF04E
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 12:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiBIL5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 06:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiBIL4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 06:56:06 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AAEE03E231;
        Wed,  9 Feb 2022 02:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644404201; x=1675940201;
  h=to:cc:references:from:subject:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=W/ACr337dCWxZ64atnDXrvUA4xLsoa1IEFVrCd8GQkg=;
  b=Gzx/SQzb6dbXgj88lUo6DajTK4slC/uXScqj3biG0Vge3JEzC98lC3uk
   RM2GYo5571PRBN9RwVtx0VD/Zu7WiRloIPkNoFeRlN8JtljFAx198I6VW
   ltHWBkLe0aK2sufNjV0tqLSV4rcvQfcRWdNOG1tf+kfBSLuwSeORYeEem
   87bOw3zvNE9OKWgM8SCJ6Ucw/ssvF98WbuN4qrkfgHBRC6xTGvuWBULcq
   rDqZBigRTrB4jItnlnqMfnOkjgi6co1gMqefMDPQKoIdVkle1ce2CkT3m
   MhOtr35XzYIpObiBcynOqcF/wtnighFDJA4JVEk9D3mAVo0raJ425kCUd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229135463"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="229135463"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 01:27:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568178958"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 01:27:47 -0800
To:     Hongyu Xie <xy521521@gmail.com>, gregkh@linuxfoundation.org,
        mathias.nyman@intel.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org
References: <20220209025234.25230-1-xy521521@gmail.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -next v2] xhci: fix two places when dealing with return
 value of function xhci_check_args
Message-ID: <89d59749-8ca3-b30b-4da6-a6e567528d1b@linux.intel.com>
Date:   Wed, 9 Feb 2022 11:29:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220209025234.25230-1-xy521521@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9.2.2022 4.52, Hongyu Xie wrote:
> From: Hongyu Xie <xiehongyu1@kylinos.cn>
> 
> xhci_check_args returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
> xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
> the return value of xhci_check_args <= 0.
> This will cause a problem.
> For example, r8152_submit_rx calling usb_submit_urb in
> drivers/net/usb/r8152.c.
> r8152_submit_rx will never get -ENODEV after submiting an urb
> when xHC is halted,
> because xhci_urb_enqueue returns -EINVAL in the very beginning.
> 
> Fixes: 203a86613fb3 ("xhci: Avoid NULL pointer deref when host dies.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
> ---

Thanks, added to queue.
Changed the commit message and header a bit:

"xhci: Prevent futile URB re-submissions due to incorrect return value.
    
The -ENODEV return value from xhci_check_args() is incorrectly changed
to -EINVAL in a couple places before propagated further.
    
xhci_check_args() returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
the return value of xhci_check_args <= 0.
This causes problems for example r8152_submit_rx, calling usb_submit_urb
in drivers/net/usb/r8152.c.
r8152_submit_rx will never get -ENODEV after submiting an urb when xHC
is halted because xhci_urb_enqueue returns -EINVAL in the very beginning."

Let me know if you disagree with this.

Thanks
-Mathias
