Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A8A18F25
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfEIR35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfEIR34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 13:29:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A592820675;
        Thu,  9 May 2019 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557422996;
        bh=/XvTIuVUeOT5/PLkyyM03I9QreYBiN7G9BlfJVv6zuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nrYbKRx/K4EqiwdgX8fJiVoqmfauEO3jI7DW9EdV5TmA18m97Ap7k8WP7IAgqBlgC
         vUM88DSVIPNAnFL7RAL8Ym57F3YViANNlQh4R9gcbto9RorjU2qCCwLSliF52gkzEs
         aLGh4ex0p22KiDhH0CXZrTruVywvXOAyoK66o03I=
Date:   Thu, 9 May 2019 19:29:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Subject: Re: 8651be8f14a1 ("ipv6: fix a potential deadlock in
 do_ipv6_setsockopt()")
Message-ID: <20190509172953.GA32587@kroah.com>
References: <20190509165413.GA126940@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165413.GA126940@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 09:54:14AM -0700, Zubin Mithra wrote:
> Hello,
> 
> Syzkaller has triggered a lockdep warning when fuzzing a 4.4 kernel with the following stacktrace.
> 
> Call Trace:
>  [<ffffffff81cb9fad>] __dump_stack lib/dump_stack.c:15 [inline]
>  [<ffffffff81cb9fad>] dump_stack+0xc1/0x124 lib/dump_stack.c:51
>  [<ffffffff813eceac>] print_circular_bug.cold.51+0x1bd/0x27d kernel/locking/lockdep.c:1226
>  [<ffffffff81207f1a>] check_prev_add kernel/locking/lockdep.c:1853 [inline]
>  [<ffffffff81207f1a>] check_prevs_add kernel/locking/lockdep.c:1958 [inline]
>  [<ffffffff81207f1a>] validate_chain kernel/locking/lockdep.c:2144 [inline]
>  [<ffffffff81207f1a>] __lock_acquire+0x38da/0x52a0 kernel/locking/lockdep.c:3213
>  [<ffffffff8120b0be>] lock_acquire+0x15e/0x440 kernel/locking/lockdep.c:3592
>  [<ffffffff82a53056>] __mutex_lock_common kernel/locking/mutex.c:624 [inline]
>  [<ffffffff82a53056>] mutex_lock_nested+0xc6/0x10b0 kernel/locking/mutex.c:744
>  [<ffffffff822e186c>] rtnl_lock+0x1c/0x20 net/core/rtnetlink.c:70
>  [<ffffffff828ae743>] ipv6_sock_mc_close+0x113/0x350 net/ipv6/mcast.c:288
>  [<ffffffff82875f06>] do_ipv6_setsockopt.isra.12+0xce6/0x2cc0 net/ipv6/ipv6_sockglue.c:202
>  [<ffffffff82877f7c>] ipv6_setsockopt+0x9c/0x130 net/ipv6/ipv6_sockglue.c:905
>  [<ffffffff828863af>] udpv6_setsockopt+0x4f/0x90 net/ipv6/udp.c:1436
>  [<ffffffff82250fef>] sock_common_setsockopt+0x9f/0xe0 net/core/sock.c:2693
>  [<ffffffff8224e223>] SYSC_setsockopt net/socket.c:1780 [inline]
>  [<ffffffff8224e223>] SyS_setsockopt+0x163/0x250 net/socket.c:1759
>  [<ffffffff82a5f267>] entry_SYSCALL_64_fastpath+0x1e/0xa0
> 
> Could the following patch be applied in order to v4.4.y? This patch is present in
> linux-4.9.y.
> * 8651be8f14a1 ("ipv6: fix a potential deadlock in do_ipv6_setsockopt()")
> 
> Tests run:
> * Chrome OS tryjobs
> * Syzkaller reproducer

Now queued up, thanks.

greg k-h
