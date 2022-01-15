Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F408D48F5F7
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 09:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiAOIR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 03:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiAOIR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 03:17:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F65C061574;
        Sat, 15 Jan 2022 00:17:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4194B8243A;
        Sat, 15 Jan 2022 08:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73861C36AE3;
        Sat, 15 Jan 2022 08:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642234643;
        bh=h1NK/0c9wSXudnq0+BJzwUX/vX95yC1eyCQ24ml6b50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gTVJy0eu8CJVM8raR3p2Twi0VyQ5HZtI65CjuFJQsR/qANUSwaFy/m9KMzV93yhQv
         /d8TBWy9M8Gu+ogWWNQ8Px1cflkmJn2ealXCDjU7watTJ4AcRu41rJsXhdO+8KhGYk
         0/5yBuUrGcG9Cnn29XemiqZaGMqvmORCfr9BU778=
Date:   Sat, 15 Jan 2022 09:17:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@embecosm.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Revert the removal of the Cyclades public API
Message-ID: <YeKDD6imTh1Y6GuN@kroah.com>
References: <alpine.DEB.2.20.2201141832330.11348@tpp.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.2201141832330.11348@tpp.orcam.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 08:54:05PM +0000, Maciej W. Rozycki wrote:
> Fix a user API regression introduced with commit f76edd8f7ce0 ("tty: 
> cyclades, remove this orphan"), which removed a part of the API and 
> caused compilation errors for user programs using said part, such as 
> GCC 9 in its libsanitizer component[1]:
> 
> .../libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc:160:10: fatal error: linux/cyclades.h: No such file or directory
>   160 | #include <linux/cyclades.h>
>       |          ^~~~~~~~~~~~~~~~~~
> compilation terminated.
> make[4]: *** [Makefile:664: sanitizer_platform_limits_posix.lo] Error 1

So all we need is an empty header file?  Why bring back all of the
unused structures?

> Any part of the public API is a contract between the kernel and the 
> userland and therefore once there it must not be removed even if its 
> implementation side has gone and any relevant calls will now fail 
> unconditionally.

Does this code actually use any of these structures?

> Revert the part of the commit referred then that affects the user API, 
> bringing the most recent version of <linux/cyclades.h> back verbatim 
> modulo the removal of trailing whitespace which used to be there, and 
> updating <linux/major.h> accordingly.

Why major.h?  What uses that?  No userspace code should care about that.

Also, your text here is full of trailing whitespace, so I couldn't take
this commit as-is anyway :(

thanks,

greg k-h
