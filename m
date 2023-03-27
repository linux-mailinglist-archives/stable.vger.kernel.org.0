Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D846A6CA851
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 16:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbjC0O45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 10:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbjC0O4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 10:56:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B14130F8;
        Mon, 27 Mar 2023 07:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679929003; x=1711465003;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=BRqQ/P0VMt4c6LS9SziOR7bbAmyIDfw7eWqlAV9D8cc=;
  b=L55txLuimMA25e4m5A0LQeof3omTRmqYC5ffh7duKOIX3X34QGx2SyYR
   KucuknSSDQypflfrO8aw9DbvMU/b8vZfeyZEKECRm2sUU+t96XHJEtlN3
   dlSoRMfMGxnoMZpz5qOZgO84fzwk4qflPRR+zGCJBSejQv2gwPH+PEvLK
   XwfNGV7kAuMVeza+zGhMMkVQhcw1SCK7mgkiscYRxDHOqDDFcTSe7ObJ5
   A6GtisK+zRu7vUcetroxFS31cq5Ken3DLO0cBp+siCyC9ulBjGSXYXt8m
   ZnZ7fXtDAZiR9J/YrcAsHn4Mo/sXa6oHrhz9xHG6qu3Z1jBVoktRGtDOw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="426547735"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="426547735"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 07:56:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="794368272"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="794368272"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga002.fm.intel.com with ESMTP; 27 Mar 2023 07:56:40 -0700
Message-ID: <086a7af9-0a33-1a37-2bf3-1338adf96b12@linux.intel.com>
Date:   Mon, 27 Mar 2023 17:58:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Content-Language: en-US
To:     Hongyu Xie <xiehongyu1@kylinos.cn>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sunke <sunke@kylinos.cn>
References: <20230327011117.33953-1-xiehongyu1@kylinos.cn>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -next v2] usb: xhci: do not free an empty cmd ring
In-Reply-To: <20230327011117.33953-1-xiehongyu1@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.3.2023 4.11, Hongyu Xie wrote:
> It was first found on HUAWEI Kirin 9006C platform with a builtin xhci
> controller during stress cycle test(stress-ng, glmark2, x11perf, S4...).
> 
> phase one:
> [26788.706878] PM: dpm_run_callback(): platform_pm_thaw+0x0/0x68 returns -12
> [26788.706878] PM: Device xhci-hcd.1.auto failed to thaw async: error -12
> ...
> phase two:
> [28650.583496] [2023:01:19 04:43:29]Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
> ...
> [28650.583526] user pgtable: 4k pages, 39-bit VAs, pgdp=000000027862a000
> [28650.583557] [0000000000000028] pgd=0000000000000000
> ...
> [28650.583587] pc : xhci_suspend+0x154/0x5b0
> [28650.583618] lr : xhci_suspend+0x148/0x5b0
> [28650.583618] sp : ffffffc01c7ebbd0
> [28650.583618] x29: ffffffc01c7ebbd0 x28: ffffffec834d0000
> [28650.583618] x27: ffffffc0106a3cc8 x26: ffffffb2c540c848
> [28650.583618] x25: 0000000000000000 x24: ffffffec82ee30b0
> [28650.583618] x23: ffffffb43b31c2f8 x22: 0000000000000000
> [28650.583618] x21: 0000000000000000 x20: ffffffb43b31c000
> [28650.583648] x19: ffffffb43b31c2a8 x18: 0000000000000001
> [28650.583648] x17: 0000000000000803 x16: 00000000fffffffe
> [28650.583648] x15: 0000000000001000 x14: ffffffb150b67e00
> [28650.583648] x13: 00000000f0000000 x12: 0000000000000001
> [28650.583648] x11: 0000000000000000 x10: 0000000000000a80
> [28650.583648] x9 : ffffffc01c7eba00 x8 : ffffffb43ad10ae0
> [28650.583648] x7 : ffffffb84cd98dc0 x6 : 0000000cceb6a101
> [28650.583679] x5 : 00ffffffffffffff x4 : 0000000000000001
> [28650.583679] x3 : 0000000000000011 x2 : 0000000000e2cfa8
> [28650.583679] x1 : 00000000823535e1 x0 : 0000000000000000
> 
> gdb:
> (gdb) l *(xhci_suspend+0x154)
> 0xffffffc010b6cd44 is in xhci_suspend (/.../drivers/usb/host/xhci.c:854).
> 849	{
> 850		struct xhci_ring *ring;
> 851		struct xhci_segment *seg;
> 852
> 853		ring = xhci->cmd_ring;
> 854		seg = ring->deq_seg;
> (gdb) disassemble 0xffffffc010b6cd44
> ...
> 0xffffffc010b6cd40 <+336>:	ldr	x22, [x19, #160]
> 0xffffffc010b6cd44 <+340>:	ldr	x20, [x22, #40]
> 0xffffffc010b6cd48 <+344>:	mov	w1, #0x0                   	// #0
> 
> During phase one, platform_pm_thaw called xhci_plat_resume which called
> xhci_resume. The rest possible calling routine might be
> xhci_resume->xhci_init->xhci_mem_init, and xhci->cmd_ring was cleaned in
> xhci_mem_cleanup before xhci_mem_init returned -ENOMEM.
> 
> During phase two, systemd was tring to hibernate again and called
> xhci_suspend, then xhci_clear_command_ring dereferenced xhci->cmd_ring
> which was already NULL.
> 

Any comments on the questions I had on the first version of the patch?

xhci_mem_init() failing with -ENOMEM looks like the real problem here.

Are we really running out of memory? does kmemleak say anything?

Any chance you could look into where exactly xhci_mem_init() fails as
xhci_mem_init() always returns -ENOMEM on failure?

> So if xhci->cmd_ring is NULL, xhci_clear_command_ring just return.

This hides the problem more than solves it. Root cause is still unknown

Thanks
Mathias

