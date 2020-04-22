Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB82A1B4532
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 14:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgDVMb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 08:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgDVMb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 08:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7EE62082E;
        Wed, 22 Apr 2020 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587558717;
        bh=Ec3XoTDhjcfPw4YUB5aIqmqqMvz7xRs+Asw2RsdFLq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zsgX877+gHxe/qHcsagt4rfH5jnkh4ntosk0vYdWUsosIbhgKvyB04v61gdhmm0Ua
         Xco/vz7iLyiKDzJ/biVPhQ9jx3tweMICoOtawYe9uI+OnG6CSORuSVKYEy5ayhbION
         +HM0J2BKSA13e5SfnaQtoLv8JgMZpFLmR0Misidg=
Date:   Wed, 22 Apr 2020 14:31:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 4.9 04/21] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Message-ID: <20200422123154.GA3144508@kroah.com>
References: <20200422111957.569589-1-lee.jones@linaro.org>
 <20200422111957.569589-5-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422111957.569589-5-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 12:19:40PM +0100, Lee Jones wrote:
> From: Alexey Brodkin <alexey.brodkin@synopsys.com>
> 
> [ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]
> 
> Initially we bumped into problem with 32-bit aligned atomic64_t
> on ARC, see [1]. And then during quite lengthly discussion Peter Z.
> mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
> If allocation is done by plain kmalloc() obtained buffer will be
> ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
> devm_kmalloc() should have any other alignment?
> 
> This way we at least get the same behavior for both types of
> allocation.
> 
> [1] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004009.html
> [2] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004036.html
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Greg KH <greg@kroah.com>
> Cc: <stable@vger.kernel.org> # 4.8+
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/base/devres.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)


Sony ships this thing?  Wow...  Ok, I'll take it (for the next round),
but supposidly it only affected ARC systems, which I'm pretty sure are
not Sony phones :)

greg k-h
