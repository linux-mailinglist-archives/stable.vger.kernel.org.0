Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608E541952F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 15:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhI0Nio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 09:38:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:29474 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhI0Nik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 09:38:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10119"; a="222585651"
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="222585651"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 06:37:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="615770247"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 27 Sep 2021 06:37:00 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 27 Sep 2021 16:36:59 +0300
Date:   Mon, 27 Sep 2021 16:36:59 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, jon@solid-run.com,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] software node: balance refcount for managed sw nodes
Message-ID: <YVHI+wNKXLktzW2Q@kuha.fi.intel.com>
References: <20210927102249.12939-1-laurentiu.tudor@nxp.com>
 <YVG2XCK1nF4vVYP0@kroah.com>
 <97a611be-3deb-111e-5619-f0f015393e24@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a611be-3deb-111e-5619-f0f015393e24@nxp.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 03:42:42PM +0300, Laurentiu Tudor wrote:
> 
> On 9/27/2021 3:17 PM, Greg KH wrote:
> > On Mon, Sep 27, 2021 at 01:22:49PM +0300, Laurentiu Tudor wrote:
> >> software_node_notify(), on KOBJ_REMOVE drops the refcount twice on managed
> >> software nodes, thus leading to underflow errors. Balance the refcount by
> >> bumping it in the device_create_managed_software_node() function.
> >>
> >> The error [1] was encountered after adding a .shutdown() op to our
> >> fsl-mc-bus driver.
> >>
> >> [Backported to stable from mainline commit
> >> 5aeb05b27f81 ("software node: balance refcount for managed software nodes")]
> 
> But ...
> 
> >> [1]
> >> pc : refcount_warn_saturate+0xf8/0x150
> >> lr : refcount_warn_saturate+0xf8/0x150
> >> sp : ffff80001009b920
> >> x29: ffff80001009b920 x28: ffff1a2420318000 x27: 0000000000000000
> >> x26: ffffccac15e7a038 x25: 0000000000000008 x24: ffffccac168e0030
> >> x23: ffff1a2428a82000 x22: 0000000000080000 x21: ffff1a24287b5000
> >> x20: 0000000000000001 x19: ffff1a24261f4400 x18: ffffffffffffffff
> >> x17: 6f72645f726f7272 x16: 0000000000000000 x15: ffff80009009b607
> >> x14: 0000000000000000 x13: ffffccac16602670 x12: 0000000000000a17
> >> x11: 000000000000035d x10: ffffccac16602670 x9 : ffffccac16602670
> >> x8 : 00000000ffffefff x7 : ffffccac1665a670 x6 : ffffccac1665a670
> >> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
> >> x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff1a2420318000
> >> Call trace:
> >>  refcount_warn_saturate+0xf8/0x150
> >>  kobject_put+0x10c/0x120
> >>  software_node_notify+0xd8/0x140
> >>  device_platform_notify+0x4c/0xb4
> >>  device_del+0x188/0x424
> >>  fsl_mc_device_remove+0x2c/0x4c
> >>  rebofind sp.c__fsl_mc_device_remove+0x14/0x2c
> >>  device_for_each_child+0x5c/0xac
> >>  dprc_remove+0x9c/0xc0
> >>  fsl_mc_driver_remove+0x28/0x64
> >>  __device_release_driver+0x188/0x22c
> >>  device_release_driver+0x30/0x50
> >>  bus_remove_device+0x128/0x134
> >>  device_del+0x16c/0x424
> >>  fsl_mc_bus_remove+0x8c/0x114
> >>  fsl_mc_bus_shutdown+0x14/0x20
> >>  platform_shutdown+0x28/0x40
> >>  device_shutdown+0x15c/0x330
> >>  __do_sys_reboot+0x218/0x2a0
> >>  __arm64_sys_reboot+0x28/0x34
> >>  invoke_syscall+0x48/0x114
> >>  el0_svc_common+0x40/0xdc
> >>  do_el0_svc+0x2c/0x94
> >>  el0_svc+0x2c/0x54
> >>  el0t_64_sync_handler+0xa8/0x12c
> >>  el0t_64_sync+0x198/0x19c
> >> ---[ end trace 32eb1c71c7d86821 ]---
> >>
> >> Fixes: 151f6ff78cdf ("software node: Provide replacement for device_add_properties()")
> >> Reported-by: Jon Nettleton <jon@solid-run.com>
> >> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> >> Cc: <stable@vger.kernel.org> # 5.12+
> >> ---
> >>  drivers/base/swnode.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> > 
> > Next time, please include the git commit id of this patch that is
> > already in Linus's tree so that I don't have to go and manually look it
> > up...
> > 
> 
> ... i did mention the mainline commit in the description. Maybe there's
> a mix up with the previous submission, or i should have used a special
> syntax that i'm not aware of...

The syntax is defined in the documentation:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

> Anyway, thanks for picking this up.

thanks,

-- 
heikki
