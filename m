Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6872457A44F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 18:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiGSQs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 12:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiGSQsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 12:48:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3070257268;
        Tue, 19 Jul 2022 09:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658249304; x=1689785304;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=Ycu7Ok4eSxy7/aEcgWkuiWqgpnoYSn46cWi0gpMnDZQ=;
  b=K5mGghYxu/UwfHq9XttsuChznZNKUOIdQfubGX5uPnbY+xQZE2BlYqdT
   SKxzEghbZPox7Cc3u/G5HWbK4j9KPEG84pVnacJY6po9bEaUdfuTwFkYt
   n98kNOA3oybSJjONDkfO/rdf/rP+V22LUiepQi1oAj8cvUi8X33Lkekvm
   f+n4cYu7QrG8E+B9j3cMeI75y+aJY8LebxZvgiRlKkWJLjqXpmpRShQSu
   mKBI+QB4F69/l6czNh9uZK1L8mego0HE51hrNilENmDw3WPNFGpu74Meu
   8tcd31gUG4uGJWbJ603gEpHfpLyUaqCdlo2mPPMupNNsSLvnVA3TvwkLv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="287694139"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="287694139"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 09:48:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="687179855"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jul 2022 09:48:16 -0700
Message-ID: <9d54d0e4-d2db-3896-301e-9d9048599092@linux.intel.com>
Date:   Tue, 19 Jul 2022 19:49:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Content-Language: en-US
To:     Joey Corleone <joey.corleone@mail.ru>, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
References: <20220623111945.1557702-1-mathias.nyman@linux.intel.com>
 <20220623111945.1557702-3-mathias.nyman@linux.intel.com>
 <fe4005ed-802a-d276-a6c8-87717d16c089@mail.ru>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH 2/4] xhci: turn off port power in shutdown
In-Reply-To: <fe4005ed-802a-d276-a6c8-87717d16c089@mail.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.7.2022 16.42, Joey Corleone wrote:
> On 23.06.22 13:19, Mathias Nyman wrote:
>> If ports are not turned off in shutdown then runtime suspended
>> self-powered USB devices may survive in U3 link state over S5.
>>
>> During subsequent boot, if firmware sends an IPC command to program
>> the port in DISCONNECT state, it will time out, causing significant
>> delay in the boot time.
>>
>> Turning off roothub port power is also recommended in xhci
>> specification 4.19.4 "Port Power" in the additional note.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>   drivers/usb/host/xhci-hub.c |  2 +-
>>   drivers/usb/host/xhci.c     | 15 +++++++++++++--
>>   drivers/usb/host/xhci.h     |  2 ++
>>   3 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
>> index c54f2bc23d3f..0fdc014c9401 100644
>> --- a/drivers/usb/host/xhci-hub.c
>> +++ b/drivers/usb/host/xhci-hub.c
>> @@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
>>    * It will release and re-aquire the lock while calling ACPI
>>    * method.
>>    */
>> -static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
>> +void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
>>                   u16 index, bool on, unsigned long *flags)
>>       __must_hold(&xhci->lock)
>>   {
>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>> index cb99bed5f755..65858f607437 100644
>> --- a/drivers/usb/host/xhci.c
>> +++ b/drivers/usb/host/xhci.c
>> @@ -791,6 +791,8 @@ static void xhci_stop(struct usb_hcd *hcd)
>>   void xhci_shutdown(struct usb_hcd *hcd)
>>   {
>>       struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>> +    unsigned long flags;
>> +    int i;
>>       if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
>>           usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
>> @@ -806,12 +808,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
>>           del_timer_sync(&xhci->shared_hcd->rh_timer);
>>       }
>> -    spin_lock_irq(&xhci->lock);
>> +    spin_lock_irqsave(&xhci->lock, flags);
>>       xhci_halt(xhci);
>> +
>> +    /* Power off USB2 ports*/
>> +    for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
>> +        xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
>> +
>> +    /* Power off USB3 ports*/
>> +    for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
>> +        xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
>> +
>>       /* Workaround for spurious wakeups at shutdown with HSW */
>>       if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
>>           xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
>> -    spin_unlock_irq(&xhci->lock);
>> +    spin_unlock_irqrestore(&xhci->lock, flags);
>>       xhci_cleanup_msix(xhci);
>> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
>> index 0bd76c94a4b1..28aaf031f9a8 100644
>> --- a/drivers/usb/host/xhci.h
>> +++ b/drivers/usb/host/xhci.h
>> @@ -2196,6 +2196,8 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
>>   int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
>>   int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
>>   struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
>> +void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
>> +             bool on, unsigned long *flags);
>>   void xhci_hc_died(struct xhci_hcd *xhci);
> 
> fyi: there is a report [1] about a regression introduced by this patch.
> 
> Joey
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=216243

Thanks for the notice, I'm away until August.
If it starts to cause more issues then this one incident then it should be reverted.

Will take a look at this when I return.
Meanwhile a log with xhci dynamic debug enabled could better show what is going on

mount -t debugfs none /sys/kernel/debug
echo 'module xhci_hcd =p' >/sys/kernel/debug/dynamic_debug/control

Thanks
Mathias





