Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE23B48EBAE
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 15:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiANOaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 09:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiANOaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 09:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64941C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 06:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31DB1B82604
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74950C36AEA;
        Fri, 14 Jan 2022 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642170607;
        bh=z2n0FD5B/lcKzAfjJxVbTjcHKQrMN/BT2DTsFvw4Q4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e93+rWN76lEhmMXvPA0BA/TrypXut+znN62+1fHenxm2nJ6ilBKkRsL77VfAsoeu1
         Aa2AnST+UavbtatTsvuU23hIopp0KsJydwGvJW0Kp2FEryC+PYt6vj9uCfV8TU96NV
         Lu4d9wNlF8V6b2fsPwLh+FLUyefeXkr6XM1E8Ayg=
Date:   Fri, 14 Jan 2022 15:30:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Barker <paul.barker@sancloud.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport commit f634ca650f72 for 5.10.y, 5.4.y & 4.19.y
Message-ID: <YeGI7NzBpIkxxjsu@kroah.com>
References: <04598430-7383-b725-2f5f-3f2b16aaca36@sancloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04598430-7383-b725-2f5f-3f2b16aaca36@sancloud.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 02:14:02PM +0000, Paul Barker wrote:
> Hi folks,
> 
> Please backport commit f634ca650f72 "kbuild: Add $(KBUILD_HOSTLDFLAGS) to
> 'has_libelf' test" to stable series 5.10.y, 5.4.y & 4.19.y.
> 
> This backport is needed to fix builds with CONFIG_UNWINDER_ORC=y where
> HOSTLDFLAGS is given on the make command line containing library paths
> needed to link against libelf. The issue was found when trying to build
> stable kernel branches for x86-64 using Yocto Project after commit
> 7fd06a57a1d9 "kernel: Rework kernel make flag to variable mappings" was
> added to openembedded-core back in October.
> 
> The backport to 5.10.y is trivial. The backports to 5.4.y & 4.19.y need a
> minor tweak so I'll send patches for those following this email.
> 
> The build failure is also seen in 4.14.y but I can't see a trivial way to
> address this as KBUILD_HOSTLDFLAGS does not exist in 4.14.y and backporting
> the commit which introduces KBUILD_HOSTLDFLAGS would change several other
> kbuild areas. I'm happy to workaround this locally by disabling
> CONFIG_UNWINDER_ORC for 4.14.y builds but it may be worth considering
> alternative fixes for this branch.

Added to 4.19.y queue right now.  Will add to 5.4.y queue once the next
release is out as it is currently in -rc status.

thanks,

greg k-h
