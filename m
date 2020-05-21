Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A781DC6B0
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 07:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgEUFt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 01:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgEUFtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 01:49:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0EE42070A;
        Thu, 21 May 2020 05:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590040165;
        bh=AVDNECx4JPHg3PcuDTfFyXh8gJ763HJou+70/OjZo8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FxeIPuI7gstDyVzdUQAQrcy7sKvWQU1Ul6FxWTe22TnsNMQSpxL+0dKT6YPj09Mot
         DThrdl4tbZ40OOy6oCgPVCXEVSDiJ1Xl3SvgtdipxoLEBWOnidYRmJbzprqBJz6nTk
         B59En0+qduFUNwYZeCXmVklhGZRC5rjPFptow3OU=
Date:   Thu, 21 May 2020 07:49:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.9-stable] watchdog: Fix the race between the release of
 watchdog_core_data and cdev
Message-ID: <20200521054923.GC2295294@kroah.com>
References: <df70afba3439e4573a8e2b61f751577ff67ab36d.camel@codethink.co.uk>
 <21124d783a72aa3292502100b1558ddf8f873b97.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21124d783a72aa3292502100b1558ddf8f873b97.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 09:15:57PM +0100, Ben Hutchings wrote:
> On Wed, 2020-05-20 at 21:10 +0100, Ben Hutchings wrote:
> > Please queue up the attached backport of commit 2351c88f8296 "watchdog:
> > Fix the race between the release of watchdog_core_data and cdev" for
> > 4.14.
> 
> And here's the corresponding version for 4.9.
> 
> Ben.
> 
> -- 
> Ben Hutchings, Software Developer                         Codethink Ltd
> https://www.codethink.co.uk/                 Dale House, 35 Dale Street
>                                      Manchester, M1 2HF, United Kingdom

> From 1cf1b24c844a037da38e6096a865bcab75aa05eb Mon Sep 17 00:00:00 2001
> From: Kevin Hao <haokexin@gmail.com>
> Date: Tue, 8 Oct 2019 19:29:34 +0800
> Subject: watchdog: Fix the race between the release of watchdog_core_data and
>  cdev
> 
> commit 72139dfa2464e43957d330266994740bb7be2535 upstream.
> 
> The struct cdev is embedded in the struct watchdog_core_data. In the
> current code, we manage the watchdog_core_data with a kref, but the
> cdev is manged by a kobject. There is no any relationship between
> this kref and kobject. So it is possible that the watchdog_core_data is
> freed before the cdev is entirely released. We can easily get the
> following call trace with CONFIG_DEBUG_KOBJECT_RELEASE and
> CONFIG_DEBUG_OBJECTS_TIMERS enabled.
>   ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x38
>   WARNING: CPU: 23 PID: 1028 at lib/debugobjects.c:481 debug_print_object+0xb0/0xf0
>   Modules linked in: softdog(-) deflate ctr twofish_generic twofish_common camellia_generic serpent_generic blowfish_generic blowfish_common cast5_generic cast_common cmac xcbc af_key sch_fq_codel openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
>   CPU: 23 PID: 1028 Comm: modprobe Not tainted 5.3.0-next-20190924-yoctodev-standard+ #180
>   Hardware name: Marvell OcteonTX CN96XX board (DT)
>   pstate: 00400009 (nzcv daif +PAN -UAO)
>   pc : debug_print_object+0xb0/0xf0
>   lr : debug_print_object+0xb0/0xf0
>   sp : ffff80001cbcfc70
>   x29: ffff80001cbcfc70 x28: ffff800010ea2128
>   x27: ffff800010bad000 x26: 0000000000000000
>   x25: ffff80001103c640 x24: ffff80001107b268
>   x23: ffff800010bad9e8 x22: ffff800010ea2128
>   x21: ffff000bc2c62af8 x20: ffff80001103c600
>   x19: ffff800010e867d8 x18: 0000000000000060
>   x17: 0000000000000000 x16: 0000000000000000
>   x15: ffff000bd7240470 x14: 6e6968207473696c
>   x13: 5f72656d6974203a x12: 6570797420746365
>   x11: 6a626f2029302065 x10: 7461747320657669
>   x9 : 7463612820657669 x8 : 3378302f3078302b
>   x7 : 0000000000001d7a x6 : ffff800010fd5889
>   x5 : 0000000000000000 x4 : 0000000000000000
>   x3 : 0000000000000000 x2 : ffff000bff948548
>   x1 : 276a1c9e1edc2300 x0 : 0000000000000000
>   Call trace:
>    debug_print_object+0xb0/0xf0
>    debug_check_no_obj_freed+0x1e8/0x210
>    kfree+0x1b8/0x368
>    watchdog_cdev_unregister+0x88/0xc8
>    watchdog_dev_unregister+0x38/0x48
>    watchdog_unregister_device+0xa8/0x100
>    softdog_exit+0x18/0xfec4 [softdog]
>    __arm64_sys_delete_module+0x174/0x200
>    el0_svc_handler+0xd0/0x1c8
>    el0_svc+0x8/0xc
> 
> This is a common issue when using cdev embedded in a struct.
> Fortunately, we already have a mechanism to solve this kind of issue.
> Please see commit 233ed09d7fda ("chardev: add helper function to
> register char devs with a struct device") for more detail.

Wait, 233ed09d7fda ("chardev: add helper function to register char devs
with a struct device") only showed up in 4.12, it's not in 4.9, so how
is this needed for 4.9?

thanks,

greg k-h
