Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1F8377D81
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhEJHx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhEJHx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 03:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF54D61468;
        Mon, 10 May 2021 07:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620633172;
        bh=4U0WIzEGXqXGGl4zQaz8A7YRDreylwWMEFXI7RDYfGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YGCtLp7G+WBx8PNhpMLMr8ikljITH0X9ewMFe6iDKA1ulKgn/V1XSsbx9TEGeVjHn
         r8Lw3HfB2OFUaHmp61Sa2EynyBx8ptM19FcUkWF08z1RUFW83I/OcKsCs46NDtE0rz
         t8PGHKtYmFYSvCfAOMv1swflRdipoTLRyNuVWdNg=
Date:   Mon, 10 May 2021 09:52:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     chenjun102@huawei.com, richardcochran@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] posix-timers: Preserve return value in
 COMPAT(clock_adjtime)
Message-ID: <YJjmUd7YywibopNO@kroah.com>
References: <162040265791232@kroah.com>
 <878s4qm73z.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s4qm73z.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021 at 01:55:44AM +0200, Thomas Gleixner wrote:
> From: Chen Jun <chenjun102@huawei.com>
> 
> commit 2d036dfa5f10df9782f5278fc591d79d283c1fad upstream.
> 
> The return value on success (>= 0) is overwritten by the return value of
> compat_put_timex(). That works correct in the fault case, but is wrong for
> the success case where compat_put_timex() returns 0.
> 
> Just check the return value of compat_put_timex() and return -EFAULT in case
> it is not zero.
> 
> [ tglx: Massage changelog ]
> [ tglx: Backport to 4.19, 4.14 ]

Thanks, now queued up.

greg k-h
