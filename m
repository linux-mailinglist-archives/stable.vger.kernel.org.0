Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C48E6C0D39
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCTJ0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjCTJZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:25:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D300626AA;
        Mon, 20 Mar 2023 02:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679304322; x=1710840322;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=1n1sqvKcWHzt2G9CtunMYx7nMZdFJxTREqFACQxM9Hg=;
  b=B2m0YG9h9WnJq42k9rOqdlCsc7gc2Nglxz1wh+fjfCD/hnijiMEVdTdc
   2G/ZAZAVVbZO526BHk9ATdrD9HqsPMc3g1p2NvR/H1+MH1agKQce1KBWZ
   dqFKicH0TyTdZ6e1FKy5aHHGT5gt30pYf0u4gISo2DKyckVtaL45Yxcov
   kSN/8W7BXkBMJ1D4jj0vgrZ7hACgf22yH8RaaqaRY6+gVAT9kvNMZ+sPp
   bD+USiGzZ56hP52mApN8bEa3JAK0QwvcTF+qYANVkq47aBGGP/Lz/+Ftp
   eZ2/IjUJDhY2MehTzxxBpDP/U0vLttgxWo1lilqkx1BhV77n2s+4OEwhU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="340973914"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="340973914"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 02:25:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="824418925"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="824418925"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 20 Mar 2023 02:25:20 -0700
Message-ID: <d14a6e71-d7da-db8d-f901-52d6cdf1fa1d@linux.intel.com>
Date:   Mon, 20 Mar 2023 11:26:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
To:     Erhard Furtner <erhard_f@mailbox.org>, linux-usb@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Chris Snook <chris.snook@gmail.com>, stable@vger.kernel.org
References: <20230319013706.016d96b2@yea>
Content-Language: en-US
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: When VIA VL805/806 xHCI USB 3.0 Controller is present Atheros
 E2400 (alx) ethernet does not work: NETDEV WATCHDOG: enp5s0 (alx): transmit
 queue 2 timed out
In-Reply-To: <20230319013706.016d96b2@yea>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.3.2023 2.37, Erhard Furtner wrote:
> Greetings!
> 
> On my GIGABYTE GA-970-Gaming board (AM3+ board + AMD FX8370 CPU) I got this very annoying problem that onboard ethernet Atheros E2400 (alx) ceases to work when the USB 3.0 controller (VIA VL805/806 chipset) is enabled in BIOS.
> 
>   # lspci
> 02:00.0 USB controller: ASMedia Technology Inc. ASM2142/ASM3142 USB 3.1 Host Controller
> 06:00.0 USB controller: VIA Technologies, Inc. VL805/806 xHCI USB 3.0 Controller (rev 01)

dmesg shows usb bus numbers are not ordered, xhci driver registers two usb buses per host.

xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 1
xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:06:00.0: can't setup: -110

> 
> With the VIA VL805/806 USB-Controller disabled in BIOS I don't get this problem, everything works fine. But this way I loose front USB 3 ports... The other ASMedia USB 3.1 controller works fine without hampering the system.
> 
> Don't know whether this is a regression - the problem shows up on current kernel 6.2.x or 6.1.x TLS too. Kernel dmesg + .config attached.
> 
> Regards,
> Erhard

This could be related to another case with two xHC controllers, but different vendors.
Bus numbers were interleaved there as well. Removing the asynch probe helped:

https://lore.kernel.org/linux-usb/d5ff9480-57bd-2c39-8b10-988ad0d14a7e@linux.intel.com/

Does reverting:
4c2604a9a689 usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS
help for you?

Thanks
Mathias
