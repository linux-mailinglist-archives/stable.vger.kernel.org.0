Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A9532E26F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhCEGpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEGpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 01:45:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 681A264FDF;
        Fri,  5 Mar 2021 06:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614926735;
        bh=mZHxDQ/pJjANnd+CxSnLa+94LSMtSD7y4Cs7pM69bbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yGyDEHF7EBGFjselPvOX5mhtTrdOvxUYMLGBPA/wjK2AYVIl2EEss9At1eXXfp9bh
         HJiHm+MOnEAaNTuPQDp/vAU0FlV0cz6nESRmP0s2Z4qRtV4ycgiAE/pZbkczfzavF0
         3DSxO2hGVf2jTYY0o+GkQ0W2AKKV1aWt+7nO8fMs=
Date:   Fri, 5 Mar 2021 07:45:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Galbraith <efault@gmx.de>
Cc:     Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: Linux 5.10.20
Message-ID: <YEHTjCVIoXW1PciT@kroah.com>
References: <1614855672230162@kroah.com>
 <4dac43f81dc390faa6e62de39ade373851dd6b84.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dac43f81dc390faa6e62de39ade373851dd6b84.camel@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 04:16:36AM +0100, Mike Galbraith wrote:
> Damn, I forgot all about this, and it has now has spread.
> 
> f92bac3b141b8 kernel/printk/printk_safe.c (Sergey Senozhatsky 2016-12-27 23:16:05 +0900 267) void printk_safe_flush_on_panic(void)
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 268) {
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 269)    /*
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 270)     * Make sure that we could access the main ring buffer.
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 271)     * Do not risk a double release when more CPUs are up.
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 272)     */
> 554755be08fba kernel/printk/printk_safe.c (Sergey Senozhatsky 2018-05-30 16:03:50 +0900 273)    if (raw_spin_is_locked(&logbuf_lock)) {
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 274)            if (num_online_cpus() > 1)
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 275)                    return;
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 276)
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 277)            debug_locks_off();
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 278)            raw_spin_lock_init(&logbuf_lock);
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 279)    }
> cf9b1106c81c4 kernel/printk/nmi.c         (Petr Mladek        2016-05-20 17:00:42 -0700 280)
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 281)    if (raw_spin_is_locked(&safe_read_lock)) {
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 282)            if (num_online_cpus() > 1)
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 283)                    return;
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 284)
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 285)            debug_locks_off();
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 286)            raw_spin_lock_init(&safe_read_lock);
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 287)    }
> eb9036b4cf4c0 kernel/printk/printk_safe.c (Muchun Song        2021-02-10 11:48:23 +0800 288)
> 
> eb9036b4cf4c0 == 8a8109f303e2 upstream, and accidentally duplicated
> most of printk_safe_flush_on_panic().

I'm sorry, but I do not know what you are trying to say here at all.
What am I supposed to do?

confused,

greg k-h
