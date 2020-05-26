Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8441E1F47
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 12:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgEZKEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 06:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbgEZKEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 06:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E884C2073B;
        Tue, 26 May 2020 10:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590487473;
        bh=C+1eug5Mcn4VbY0jVegT7+QT9gZSZNXQu+kV6MICNrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nYfmdQvoBTSikIsXJZUKOo3d00l/UaNkeIrFEoOiMRRog+QFF2N31xUZHImzQ5LIr
         AV13SGGhqz2OwsFqeEhRrBx9nXsDMit+pQNagHzu+Tbihhf9WJ7QutP6CQlMCBXxwB
         Pg0nuAa53T7QuHP87q4gk0ckLJaLxBcgZULwVlh4=
Date:   Tue, 26 May 2020 12:04:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: More build errors in v5.4.y.queue
Message-ID: <20200526100431.GC2738150@kroah.com>
References: <e4eaebf9-3397-6157-887a-3f35ac3daeb1@roeck-us.net>
 <20200526041650.GA20606@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526041650.GA20606@1wt.eu>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 06:16:50AM +0200, Willy Tarreau wrote:
> On Mon, May 25, 2020 at 09:03:45PM -0700, Guenter Roeck wrote:
> > Build reference: v5.4.42-105-g3cb79944b65a
> > gcc version: sh4-linux-gcc (GCC) 9.3.0
> > 
> > Building sh:defconfig ... failed
> > 
> > net/socket.c: In function 'sock_ioctl':
> > arch/sh/include/uapi/asm/sockios.h:16:41: error: invalid application of 'sizeof' to incomplete type 'struct __kernel_old_timespec'
> > 
> > and various other similar errors.
> 
> Based on these patches from 5.5:
>    ca5e9ab ("time: Add time_types.h")
>    94c467d ("y2038: add __kernel_old_timespec and __kernel_old_time_t")
> 
> It seems that these types need to be changed to "__kernel_timespec" in
> backports. At least that's my understanding.

THanks for the information.  I'm just going to drop the offending patch,
fc94cf2092c7 ("sh: include linux/time_types.h for sockios") and if
anyone cares about this for the sh platform, they can provide a set of
working patches for it :)

thanks,

greg k-h
