Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B02243971
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 13:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHMLld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 07:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgHMLl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 07:41:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5328220771;
        Thu, 13 Aug 2020 11:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597318888;
        bh=fp5rvaq7NPsTUTrz3k3eLOHmPNbOzxflP+aP/tMnI8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KYj7rXs19Lz6LH2TFh6PXdj7TqS4MstDRdvp0d0TGAc3vpZcsYajEQrthDRsHBuyP
         NFeSg6VzPIr1KthHuXcB37fCPC/wslqBgQkZHM+IlhJKsxONjztCYDYdTz/SDNZGFs
         oytpTvC6KNesg+zoic/2U0HkUP6A6wj2dYHXxaXo=
Date:   Thu, 13 Aug 2020 13:41:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 016/133] cgroup: fix cgroup_sk_alloc() for
 sk_clone_lock()
Message-ID: <20200813114138.GA3754843@kroah.com>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152804.513188610@linuxfoundation.org>
 <e6d703e7-2cbb-f77e-413f-523aa0706542@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e6d703e7-2cbb-f77e-413f-523aa0706542@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 13, 2020 at 07:30:55PM +0800, Yang Yingliang wrote:
> Hi,
> 
> On 2020/7/20 23:36, Greg Kroah-Hartman wrote:
> > From: Cong Wang <xiyou.wangcong@gmail.com>
> > 
> > [ Upstream commit ad0f75e5f57ccbceec13274e1e242f2b5a6397ed ]
> > 
> > When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> > copied, so the cgroup refcnt must be taken too. And, unlike the
> > sk_alloc() path, sock_update_netprioidx() is not called here.
> > Therefore, it is safe and necessary to grab the cgroup refcnt
> > even when cgroup_sk_alloc is disabled.
> > 
> > sk_clone_lock() is in BH context anyway, the in_interrupt()
> > would terminate this function if called there. And for sk_alloc()
> > skcd->val is always zero. So it's safe to factor out the code
> > to make it more readable.
> > 
> > The global variable 'cgroup_sk_alloc_disabled' is used to determine
> > whether to take these reference counts. It is impossible to make
> > the reference counting correct unless we save this bit of information
> > in skcd->val. So, add a new bit there to record whether the socket
> > has already taken the reference counts. This obviously relies on
> > kmalloc() to align cgroup pointers to at least 4 bytes,
> > ARCH_KMALLOC_MINALIGN is certainly larger than that.
> > 
> > This bug seems to be introduced since the beginning, commit
> > d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
> > tried to fix it but not compeletely. It seems not easy to trigger until
> > the recent commit 090e28b229af
> > ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups") was merged.
> > 
> > Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
> > Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
> > Reported-by: Peter Geis <pgwipeout@gmail.com>
> > Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> > Reported-by: Daniël Sonck <dsonck92@gmail.com>
> > Reported-by: Zhang Qiang <qiang.zhang@windriver.com>
> > Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
> > Tested-by: Peter Geis <pgwipeout@gmail.com>
> > Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Zefan Li <lizefan@huawei.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Roman Gushchin <guro@fb.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> [...]
> > +void cgroup_sk_clone(struct sock_cgroup_data *skcd)
> > +{
> > +	/* Socket clone path */
> > +	if (skcd->val) {
> 
> Compare to mainline patch, it's missing *if (skcd->no_refcnt)* check here.
> 
> Is it a mistake here ?

Possibly, it is in the cgroup_sk_free() call.  Can you send a patch to
fix this up?

thanks,

greg k-h
