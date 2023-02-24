Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8AF6A1A4E
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 11:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBXKaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 05:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBXK3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 05:29:49 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F071235BD;
        Fri, 24 Feb 2023 02:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677234554; x=1708770554;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=NjAq8aloKH/Ryx9xBqNFOzO8waT0+/lqrEQ5XsZxs/c=;
  b=M/Z9khgljqdEWMvYEl9fQQEuBWiZW6G9ycJaWRZblr3b3iHGnGGlM0MB
   6y/20JVebA+cv6E3KPSa63xFMTe1IyN1hF2EAeabhzN4XspMNlXoFVHtG
   Ctj6n+8eRXwFiN+Wg3lMPfqzAeRRj1gPmACQCnq4RuoidJyw9al1c2wPx
   AKHFDyNr5EpEYQrUYiDWsEhQLf/rE+pLLRo4Z2f8Boehi8SAVNxPxDdwY
   v71asKnXNPMwpR5z2vZbhXdJN2SpxXHm7BuyjwiFE4yNz/b7R0JVVa/5r
   QnTECIkyVA0BAZF2znY0SyQeAcfT9D9xAUTJDfinb0HrjKtS5ddlqX0yh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="333450052"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="333450052"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 02:27:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="782313164"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="782313164"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga002.fm.intel.com with ESMTP; 24 Feb 2023 02:27:52 -0800
Message-ID: <b924a240-e03a-af6c-29ea-390c84cde5d5@linux.intel.com>
Date:   Fri, 24 Feb 2023 12:29:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
To:     youling257 <youling257@gmail.com>
Cc:     gregkh@linuxfoundation.org, hhhuuu@google.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
References: <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
 <20230223162617.31845-1-youling257@gmail.com>
Content-Language: en-US
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH 2/7] usb: xhci: Check endpoint is valid before
 dereferencing it
In-Reply-To: <20230223162617.31845-1-youling257@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.2.2023 18.26, youling257 wrote:
> I used type-c 20Gbps USB3.2 GEN2x2 PCIe Expansion Card, may be this patch cause USB3.2 GEN2x2 PCIe Expansion Card not work.
> 
> [    0.285088] xhci_hcd 0000:09:00.0: hcc params 0x0200ef80 hci version 0x110 quirks 0x0000000000800010
> [    0.285334] usb usb7: We don't know the algorithms for LPM for this host, disabling LPM.
> [    0.285347] xhci_hcd 0000:09:00.0: xHCI Host Controller
> [    0.285407] hub 7-0:1.0: USB hub found
> [    0.285415] hub 7-0:1.0: 4 ports detected
> [    0.285783] xhci_hcd 0000:09:00.0: new USB bus registered, assigned bus number 8
> [    0.285787] xhci_hcd 0000:09:00.0: Host supports USB 3.2 Enhanced SuperSpeed
> [    0.285889] hub 4-0:1.0: USB hub found
> [    0.285901] hub 4-0:1.0: 1 port detected
> [    0.285988] usb usb8: We don't know the algorithms for LPM for this host, disabling LPM.
> [ 3277.156054] xhci_hcd 0000:09:00.0: Abort failed to stop command ring: -110
> [ 3277.156091] xhci_hcd 0000:09:00.0: xHCI host controller not responding, assume dead
> [ 3277.156103] xhci_hcd 0000:09:00.0: HC died; cleaning up
> 
> may be this patch cause "xhci_hcd 0000:09:00.0: HC died; cleaning up" problem.

Unlikely, this patch only touches code called after HC already died.

Does reverting this patch fix the issue?

Thanks
Mathias
