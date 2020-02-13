Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7883715BF71
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgBMNdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 08:33:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7181 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgBMNdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 08:33:52 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4550230000>; Thu, 13 Feb 2020 05:33:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 13 Feb 2020 05:33:52 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 13 Feb 2020 05:33:52 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 13 Feb
 2020 13:33:49 +0000
Subject: Re: [RFT PATCH v2] xhci: Fix memory leak when caching protocol
 extended capability PSI tables
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <m.szyprowski@samsung.com>
CC:     <pmenzel@molgen.mpg.de>, <mika.westerberg@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <krzk@kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20d0559f-8d0f-42f5-5ebf-7f658a172161@linux.intel.com>
 <20200211150158.14475-1-mathias.nyman@linux.intel.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f42f7f73-48e7-74ad-2524-2514f29490cb@nvidia.com>
Date:   Thu, 13 Feb 2020 13:33:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211150158.14475-1-mathias.nyman@linux.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581600803; bh=Q/1g/+E1KxLXh/a5BE04ZQbja/0YRrFg7JgCT2PQy6g=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=IDJOQ47i/JoBb4NZDQO6MgrrTUF+1N6pMfcfklm8/ibMblWaIjTOSVjBOyl4zkY+f
         xPEAXXzEyUSQjnSf+sdtxp/wzkC0CBxN194RNiD8yKgxjwRnlx60E9znf0dznEavY2
         P0noIUPp3usvtUaVnXItReSRgC1MM0ij9KPlYExuyEUW7qx5aSRBVx084WC4Hi7/8S
         VZ/c464qrPvFg7WwdzzKcLZscrk8uM+27RMvd8o9kJkvKZwRA7VUEBVCVqyA6cDEjY
         h5mAVoBYdZUfvQQf+o/X0vBdAffWsWjRKS/fezaN4amef782Qs0rmj7Tp4XNl2vbj4
         zF5xVV+NAcQbQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/02/2020 15:01, Mathias Nyman wrote:
> xhci driver assumed that xHC controllers have at most one custom
> supported speed table (PSI) for all usb 3.x ports.
> Memory was allocated for one PSI table under the xhci hub structure.
> 
> Turns out this is not the case, some controllers have a separate
> "supported protocol capability" entry with a PSI table for each port.
> This means each usb3 roothub port can in theory support different custom
> speeds.
> 
> To solve this, cache all supported protocol capabilities with their PSI
> tables in an array, and add pointers to the xhci port structure so that
> every port points to its capability entry in the array.
> 
> When creating the SuperSpeedPlus USB Device Capability BOS descriptor
> for the xhci USB 3.1 roothub we for now will use only data from the
> first USB 3.1 capable protocol capability entry in the array.
> This could be improved later, this patch focuses resolving
> the memory leak.
> 
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Reported-by: Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>
> Fixes: 47189098f8be ("xhci: parse xhci protocol speed ID list for usb 3.1 usage")
> Cc: stable <stable@vger.kernel.org> # v4.4+
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>


Since next-20200211, we have been observing a regression exiting suspend
on our Tegra124 Jetson TK1 board. Bisect is pointing to this commit and
reverting on top of -next fixes the problem.

On exiting suspend, I am seeing the following ...

[   56.216793] tegra-xusb 70090000.usb: Firmware already loaded, Falcon state 0x20
[   56.216834] usb usb3: root hub lost power or was reset
[   56.216837] usb usb4: root hub lost power or was reset
[   56.217760] tegra-xusb 70090000.usb: No ports on the roothubs?
[   56.218257] tegra-xusb 70090000.usb: failed to resume XHCI: -12
[   56.218299] PM: dpm_run_callback(): platform_pm_resume+0x0/0x40 returns -12
[   56.218312] PM: Device 70090000.usb failed to resume: error -12
[   56.334366] hub 4-0:1.0: hub_ext_port_status failed (err = -32)
[   56.334368] hub 3-0:1.0: hub_ext_port_status failed (err = -32)

Let me know if you have any thoughts on this.

Cheers
Jon

-- 
nvpublic
