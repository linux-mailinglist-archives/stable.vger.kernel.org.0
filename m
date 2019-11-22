Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36011074AB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 16:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKVPQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 10:16:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfKVPQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 10:16:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 890BD2071B;
        Fri, 22 Nov 2019 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574435794;
        bh=ZxQM3k879r7/0GkBs4EcysLfK42eCa9E+tvIZX1nAqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1pN1bLDycLvfU0mrNnHJcEJMrU/uYukBOti9fu3snFNR5ACLgx3Wu7zZieU0CTPYQ
         o3M/aTr9mz3aTqvWuEEucq51s+5yQl79t+MR7wHEWEJ3uvcvOd0rJuCh+39w4lebEq
         gG9XBXXm0eJjJEjT0RZudmuh/xu5tO3QjNSQDkxQ=
Date:   Fri, 22 Nov 2019 16:16:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/220] 4.19.86-stable review
Message-ID: <20191122151631.GA2083451@kroah.com>
References: <20191122100912.732983531@linuxfoundation.org>
 <ae3d804f-594b-80f9-048b-7da45806278c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae3d804f-594b-80f9-048b-7da45806278c@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 06:47:05AM -0800, Guenter Roeck wrote:
> On 11/22/19 2:26 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.86 release.
> > There are 220 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> > Anything received after that time might be too late.
> > 
> 
> I see the following warning (at least for arm64, ppc64, and x86_64).
> This seems to be caused by "idr: Fix idr_get_next race with idr_remove".
> v4.14.y is also affected. Mainline and v5.3.y are not affected.
> 
> Guenter
> 
> ---
> [    3.897800] NetLabel: Initializing
> [    3.897944] NetLabel:  domain hash size = 128
> [    3.898044] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> [    3.898995]
> [    3.899135] =============================
> [    3.899235] WARNING: suspicious RCU usage
> [    3.899479] 4.19.86-rc1+ #1 Not tainted
> [    3.899595] -----------------------------
> [    3.899772] include/linux/radix-tree.h:241 suspicious rcu_dereference_check() usage!
> [    3.899939]
> [    3.899939] other info that might help us debug this:
> [    3.899939]
> [    3.900159]
> [    3.900159] rcu_scheduler_active = 2, debug_locks = 1
> [    3.900347] 2 locks held by swapper/0/1:
> [    3.900479]  #0: (____ptrval____) (cb_lock){+.+.}, at: genl_register_family+0xab/0x717
> [    3.901498]  #1: (____ptrval____) (genl_mutex){+.+.}, at: genl_register_family+0xb9/0x717
> [    3.901860]
> [    3.901860] stack backtrace:
> [    3.902136] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.19.86-rc1+ #1
> [    3.902295] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> [    3.902633] Call Trace:
> [    3.902633]  dump_stack+0x71/0xa0
> [    3.902633]  idr_get_next+0x133/0x160
> [    3.902633]  ? genl_register_family+0xab/0x717
> [    3.902633]  ? do_early_param+0x89/0x89
> [    3.902633]  genl_family_find_byname+0x4e/0x80
> [    3.902633]  genl_register_family+0xc1/0x717
> [    3.902633]  ? do_early_param+0x89/0x89
> [    3.902633]  ? netlbl_netlink_init+0x21/0x21
> [    3.902633]  netlbl_netlink_init+0x5/0x21
> [    3.902633]  netlbl_init+0x4a/0x74
> [    3.902633]  do_one_initcall+0x58/0x2ae
> [    3.902633]  ? do_early_param+0x89/0x89
> [    3.902633]  ? rcu_read_lock_sched_held+0x6f/0x80
> [    3.902633]  ? do_early_param+0x89/0x89
> [    3.902633]  kernel_init_freeable+0x1bc/0x24b
> [    3.902633]  ? rest_init+0x176/0x176
> [    3.902633]  kernel_init+0x5/0x101
> [    3.902633]  ret_from_fork+0x3a/0x50
> 

Willy, this looks like something from your patch, is it to be expected?

thanks,

greg k-h
