Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C22C008F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 08:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgKWHT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 02:19:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbgKWHT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 02:19:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31BFF2072C;
        Mon, 23 Nov 2020 07:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606115996;
        bh=ed3ACS4WI0MYocfg7hxw/3dIIIepoVZ8s0ugvdtnLVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=maYxn6Unqb+Fl7qkJXUbgTRN8r4oXI6LClgRvWIIuncdDpHv/q0B8RayIS7Cb0+tG
         M+59eRp2vYwtG4uq31KMJQIenHpEJeYrUPZeRHGz+tPL/pgmvPwwC63eI6yx05F30I
         zf6Hb9T/5hzmtb139MIqumdN21IyWDs4FsIbds70=
Date:   Mon, 23 Nov 2020 08:20:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4.4] powerpc/uaccess-flush: fix corenet64_smp_defconfig
 build
Message-ID: <X7tiwL/L5xn0MUT7@kroah.com>
References: <20201123025822.458568-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201123025822.458568-1-dja@axtens.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 01:58:22PM +1100, Daniel Axtens wrote:
> Gunter reports problems with the corenet64_smp_defconfig:
> 
> In file included from arch/powerpc/kernel/ppc_ksyms.c:10:0:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:11:29: error: redefinition of ‘allow_user_access’
>  static __always_inline void allow_user_access(void __user *to, const void __user *from,
> 			     ^~~~~~~~~~~~~~~~~
> In file included from arch/powerpc/include/asm/uaccess.h:12:0,
> 		 from arch/powerpc/kernel/ppc_ksyms.c:8:
> arch/powerpc/include/asm/kup.h:12:20: note: previous definition of ‘allow_user_access’ was here
>  static inline void allow_user_access(void __user *to, const void __user *from,
> 		    ^~~~~~~~~~~~~~~~~
> 
> This is because ppc_ksyms.c imports asm/book3s/64/kup-radix.h guarded by
> CONFIG_PPC64, rather than CONFIG_PPC_BOOK3S_64 which it should do.
> 
> Fix it.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> ---
>  arch/powerpc/kernel/ppc_ksyms.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

All 3 fixes now queued up, thanks.

greg k-h
