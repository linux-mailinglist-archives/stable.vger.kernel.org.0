Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430C56CD6E6
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 11:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjC2JuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 05:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjC2JuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 05:50:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3660526BB;
        Wed, 29 Mar 2023 02:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680083417; x=1711619417;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=X+OkkDVlkwjrlknylZVCGqMD7bLN8Zrws1CaiVDPC1Y=;
  b=Xlc6SuELq/HrshVe913uPOxLvv4g/H4Mi9sLUKj0Cc5dGb4/5zxE/reo
   fgNYmS4d8nZtLpCcppe5ij6vmf1yZ8ImNZ7atQ0XCDAlXR7vJWcXR+wkS
   GLpIByhAw4lat1Mx8O0pLJbvpuE6GDdXrpxSn5gX+uXwGAwF7F6LJkVA1
   KFJwrE/Jsb3BGaIRb50fNBiBef7ck4tZPFW5mpiipXJgWfCAIf9YxGgP2
   xouAGihnQ2z76MgIYGDUW5Cd59/PHdAsj9EXdAd9zY+sRuOYIJ8tdMBhS
   ifAfrA8PLrdP81sfCS0R6HqHsR2bqUvdMuDOv+oo3LIUZxbEtuF+Dx7tm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="324736636"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="324736636"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 02:50:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="827828779"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="827828779"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 29 Mar 2023 02:50:15 -0700
Message-ID: <29514574-295a-3144-4779-396293d50964@linux.intel.com>
Date:   Wed, 29 Mar 2023 12:51:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Content-Language: en-US
To:     Erhard Furtner <erhard_f@mailbox.org>
Cc:     linux-usb@vger.kernel.org, Chris Snook <chris.snook@gmail.com>,
        stable@vger.kernel.org
References: <20230319013706.016d96b2@yea>
 <d14a6e71-d7da-db8d-f901-52d6cdf1fa1d@linux.intel.com>
 <20230326175851.6d1c7000@yea>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: When VIA VL805/806 xHCI USB 3.0 Controller is present Atheros
 E2400 (alx) ethernet does not work: NETDEV WATCHDOG: enp5s0 (alx): transmit
 queue 2 timed out
In-Reply-To: <20230326175851.6d1c7000@yea>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.3.2023 18.58, Erhard Furtner wrote:
> On Mon, 20 Mar 2023 11:26:39 +0200
> Mathias Nyman <mathias.nyman@linux.intel.com> wrote:
> 
>> This could be related to another case with two xHC controllers, but different vendors.
>> Bus numbers were interleaved there as well. Removing the asynch probe helped:
>>
>> https://lore.kernel.org/linux-usb/d5ff9480-57bd-2c39-8b10-988ad0d14a7e@linux.intel.com/
>>
>> Does reverting:
>> 4c2604a9a689 usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS
>> help for you?
> 
> Ok, reverted 4c2604a9a689 usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS now but unfortunately didn't work out. New dmesg with the reverted commit attached.
> 
> Regards,
> Erhard

Closer look at dmesg shows we are stuck while trying to rest the VIA xHC during probe.
Driver times out after 10 seconds.

[    8.306783] xhci_hcd 0000:07:00.0: xHCI Host Controller
[    8.306791] xhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 10
[    8.311622] xhci_hcd 0000:07:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000e address=0xce210880 flags=0x0000]
...
[   18.306812] xhci_hcd 0000:07:00.0: can't setup: -110
[   18.306830] xhci_hcd 0000:07:00.0: USB bus 10 deregistered
[   18.307005] xhci_hcd 0000:07:00.0: init 0000:07:00.0 fail, -110

There is also a IOMMU entry in the log at the same time driver starts resetting the xHC.
There have been some other hosts that triggered IOMMU issues when host tried to access a partial
64 bit DMA address immediately after driver wrote first 32 bits.

Did this VIA xHC work with any older kernel, if yes, any chance you could bisect this?

Also possible that this host would work with a 32 bit DMA mask, hack:

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6183ce8574b1..e5b7700a807f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5408,7 +5408,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
  
         /* Set dma_mask and coherent_dma_mask to 64-bits,
          * if xHC supports 64-bit addressing */
-       if (HCC_64BIT_ADDR(xhci->hcc_params) &&
+       if (0 && HCC_64BIT_ADDR(xhci->hcc_params) &&
                         !dma_set_mask(dev, DMA_BIT_MASK(64))) {
                 xhci_dbg(xhci, "Enabling 64-bit DMA addresses.\n");
                 dma_set_coherent_mask(dev, DMA_BIT_MASK(64));

Thanks
Mathias

