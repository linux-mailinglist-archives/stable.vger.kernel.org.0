Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A46F49CB52
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbiAZNuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241631AbiAZNuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ADCC06161C;
        Wed, 26 Jan 2022 05:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EB7F6135E;
        Wed, 26 Jan 2022 13:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC05BC340E3;
        Wed, 26 Jan 2022 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643205017;
        bh=9mDXCoeqsja8rXJhe52fHHw9XzlnXG7asjLqfZfZcZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=taWxoPenqHi5/N2FoZdUABm1Z1CwBtaxeHzAMMuZzVlUoFzlgWwpbCyllHoNeLtXC
         hsemCiRRI1YHCsuV0C3WAk+ZvS2d3ZDCxxV63in9EWXAA7VjjXRn9Waa8MD0Wx7PxU
         Qd2Vs0LaylFbY5N3hnuPcy9vI8SMpbgr5jnz49zc=
Date:   Wed, 26 Jan 2022 14:50:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@embecosm.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] tty: Partially revert the removal of the Cyclades
 public API
Message-ID: <YfFRlbKw4cV+ISfk@kroah.com>
References: <alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 09:22:54AM +0000, Maciej W. Rozycki wrote:
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
> 
> As the absolute minimum required bring `struct cyclades_monitor' and 
> ioctl numbers back then so as to make the library build again.  Add a 
> preprocessor warning as to the obsolescence of the features provided.
> 
> References:
> 
> [1] GCC PR sanitizer/100379, "cyclades.h is removed from linux kernel 
>     header files", <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100379>
> 
> Signed-off-by: Maciej W. Rozycki <macro@embecosm.com>
> Fixes: f76edd8f7ce0 ("tty: cyclades, remove this orphan")
> Cc: stable@vger.kernel.org # v5.13+
> ---
> Changes from v2:
> 
> - Add #warning directives.

Thanks, that looks good, now queued up.

greg k-h
