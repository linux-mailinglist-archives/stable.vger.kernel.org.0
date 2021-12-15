Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611134759A8
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhLONaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhLONaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:30:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4542C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 05:30:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 033FD618D8
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D970EC34605;
        Wed, 15 Dec 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639575008;
        bh=2AETNQdAPIRSXz4GH9IbaepZSnbdXp3JKAkLgcvJfds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oGz1yCMWsyehmLC/qsc01Gio/9fLzWzyBquESkls4Uc+njvlTsC745ZQtg410SD/s
         boWa3qi3g/DtV7teYqCtOnoJwWxO0Z5qH6sLIXCdH/FFZnWzIONNa6HWUfM2oYaj2i
         tQYHnq5UWXA/uka17CqvXXFdRPFKK0mvZY5BLxHg=
Date:   Wed, 15 Dec 2021 14:30:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15] staging: most: dim2: use device release method
Message-ID: <Ybnt3WY+VH2qE6xd@kroah.com>
References: <163774098420119@kroah.com>
 <20211213181346.989171-1-nikita.yoush@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213181346.989171-1-nikita.yoush@cogentembedded.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 09:13:46PM +0300, Nikita Yushchenko wrote:
> Upstream commit d445aa402d60014a37a199fae2bba379696b007d.
> 
> Commit 723de0f9171e ("staging: most: remove device from interface
> structure") moved registration of driver-provided struct device to
> the most subsystem. This updated dim2 driver as well.
> 
> However, struct device passed to register_device() becomes refcounted,
> and must not be explicitly deallocated, but must provide release method
> instead. Which is incompatible with managing it via devres.
> 
> This patch makes the device structure allocated without devres, adds
> device release method, and moves device destruction there.
> 
> Fixes: 723de0f9171e ("staging: most: remove device from interface structure")
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
> Link: https://lore.kernel.org/r/20211005143448.8660-2-nikita.yoush@cogentembedded.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/most/dim2/dim2.c | 55 +++++++++++++++++---------------
>  1 file changed, 30 insertions(+), 25 deletions(-)

Both now queued up, thanks.

greg k-h
