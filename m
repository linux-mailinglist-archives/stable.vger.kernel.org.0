Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E22B3D2365
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 14:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhGVL4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 07:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhGVL4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 07:56:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68505C061575;
        Thu, 22 Jul 2021 05:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NG4N/2H3vvAjRHdDWUczi40Y7/Fx7mV5GVuGOtkatQQ=; b=R0sVlJzxfmtaJ6WvW3j1P24Mck
        t79mECEBGb+nkFlOvxz64p03TMuphOOxmn0+I8v1F1lRm+D/cvj3h/TA3u6WQWtpycj+xWBmNl9nf
        s/ENwBtucNIFCdCkD2oLdVmzoypMgwjaur21zn9S/SI92T1qohIzy4OGR5WamZAF6p0SJAD3loC2N
        99fCSQrJSH9Z8qV5tGB8/5FMZVFCVDRPmHwX1qge2T6Wv4i6xUoorsF2F804YyXkwklybkJJitkgl
        NCQ6mxnpuTyUyw8tC8v/33aSpL3cX2VNztqLZNefTLOLH674JYKxAr5PoNIuoh0tn8hiohSCet+1h
        RrZEAfCg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6Xvm-00AFjQ-FL; Thu, 22 Jul 2021 12:36:09 +0000
Date:   Thu, 22 Jul 2021 13:36:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc:     Chris Clayton <chris2553@googlemail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Boqun Feng <boqun.feng@gmail.com>, paulmck@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <YPlmMnZKgkcLderp@casper.infradead.org>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <5812280.fcLxn8YiTP@natalenko.name>
 <YPVtBBumSTMKGuld@casper.infradead.org>
 <2237123.PRLUojbHBq@natalenko.name>
 <CAABZP2w4VKRPjNz+TW1_n=NhGw=CBNccMp-WGVRy32XxAVobRg@mail.gmail.com>
 <CAABZP2yh3J8+P=3PLZVaC47ymKC7PcfQCBBxjXJ9Ybn+HREbdg@mail.gmail.com>
 <fb8b8639-bf2d-161e-dc9a-6a63bf9db46e@googlemail.com>
 <CAABZP2xST9787xNujWeKODEW79KpjL7vHtqYjjGxOwoqXSWXDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABZP2xST9787xNujWeKODEW79KpjL7vHtqYjjGxOwoqXSWXDQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 04:57:57PM +0800, Zhouyi Zhou wrote:
> Thanks for reviewing,
> 
> What I have deduced from the dmesg  is:
> In function do_swap_page,
> after invoking
> 3385        si = get_swap_device(entry); /* rcu_read_lock */
> and before
> 3561    out:
> 3562        if (si)
> 3563            put_swap_device(si);
> The thread got scheduled out in
> 3454        locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
> 
> I am only familiar with Linux RCU subsystem, hope mm people can solve our
> confusions.

I don't understamd why you're still talking.  The problem is understood.
You need to revert the unnecessary backport of 2799e77529c2 and
2efa33fc7f6e
