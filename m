Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4244D1E1A34
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 06:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgEZEYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 00:24:06 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:35720 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgEZEYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 00:24:06 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2020 00:24:05 EDT
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 04Q4GoXY020686;
        Tue, 26 May 2020 06:16:50 +0200
Date:   Tue, 26 May 2020 06:16:50 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: More build errors in v5.4.y.queue
Message-ID: <20200526041650.GA20606@1wt.eu>
References: <e4eaebf9-3397-6157-887a-3f35ac3daeb1@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4eaebf9-3397-6157-887a-3f35ac3daeb1@roeck-us.net>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 09:03:45PM -0700, Guenter Roeck wrote:
> Build reference: v5.4.42-105-g3cb79944b65a
> gcc version: sh4-linux-gcc (GCC) 9.3.0
> 
> Building sh:defconfig ... failed
> 
> net/socket.c: In function 'sock_ioctl':
> arch/sh/include/uapi/asm/sockios.h:16:41: error: invalid application of 'sizeof' to incomplete type 'struct __kernel_old_timespec'
> 
> and various other similar errors.

Based on these patches from 5.5:
   ca5e9ab ("time: Add time_types.h")
   94c467d ("y2038: add __kernel_old_timespec and __kernel_old_time_t")

It seems that these types need to be changed to "__kernel_timespec" in
backports. At least that's my understanding.

Willy
