Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506F5122AE9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 13:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfLQMGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 07:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbfLQMGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 07:06:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63D320733;
        Tue, 17 Dec 2019 12:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576584392;
        bh=RjgUGBgUy2NtgHKCHL8YjSlU/UigZOy/kWLUuA6Wlvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1yJ8sG97LN0NIiNu9Hk8z3/RMqM+OlEITld/tX3epwroZWk4DUSpp5MiyjUvq49ri
         kg7MNf0XhB5pxm6XKqNcDyy7yWHWircN4HSzyl04vUk24Mh+noQ56QYOWHxDdSK0WS
         lLzCS5dNj3ZD0EvMurad/ivvDDVfuj7fU0nBXrcw=
Date:   Tue, 17 Dec 2019 13:06:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>, stable@vger.kernel.org
Subject: Re: [GIT PULL 4/4] intel_th: msu: Fix window switching without
 windows
Message-ID: <20191217120629.GB3156341@kroah.com>
References: <20191217115527.74383-1-alexander.shishkin@linux.intel.com>
 <20191217115527.74383-5-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217115527.74383-5-alexander.shishkin@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 01:55:27PM +0200, Alexander Shishkin wrote:
> Commit 6cac7866c2741 ("intel_th: msu: Add a sysfs attribute to trigger
> window switch") adds a NULL pointer dereference in the case when there are
> no windows allocated:

Commit ids should only be specified in 12 digits, not 13 :)


> 
> > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 0 P4D 0
> > Oops: 0000 1 SMP
> > CPU: 5 PID: 1110 Comm: bash Not tainted 5.5.0-rc1+ #1
> > RIP: 0010:msc_win_switch+0xa/0x80 [intel_th_msu]
> > Call Trace:
> > ? win_switch_store+0x9b/0xc0 [intel_th_msu]
> > dev_attr_store+0x17/0x30
> > sysfs_kf_write+0x3e/0x50
> > kernfs_fop_write+0xda/0x1b0
> > __vfs_write+0x1b/0x40
> > vfs_write+0xb9/0x1a0
> > ksys_write+0x67/0xe0
> > __x64_sys_write+0x1a/0x20
> > do_syscall_64+0x57/0x1d0
> > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fix that by disallowing window switching with multiwindow buffers without
> windows.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Fixes: 6cac7866c2741 ("intel_th: msu: Add a sysfs attribute to trigger window switch")

Same here.

I can go edit it by hand...

