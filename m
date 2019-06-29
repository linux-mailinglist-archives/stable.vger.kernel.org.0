Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B02F5A952
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 08:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfF2G5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jun 2019 02:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfF2G5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Jun 2019 02:57:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE550214AF;
        Sat, 29 Jun 2019 06:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561791443;
        bh=Gu4JAKcSxvOi5Rs+wAZ3IANqigEmo57v9By1mLH/Uds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYmvJ9tl+KIX9/77wdvv0Z0z3Ow03xbW0f1+Bqe7ElRMezdXzivqtOgALQLmyQ+jW
         QhBV1AJbS8Z2iNNBm6cyHBSpmZ8QYbM7U6AxFMFOLRFAE+ZdQPZZcXZeSAW32O/XoP
         hO3Ikrb9LVPSyeiZpsH4fxnoyjiEgh9qDv3ovQvY=
Date:   Sat, 29 Jun 2019 08:57:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        akaher@vmware.com, srinidhir@vmware.com, bvikas@vmware.com,
        amakhalov@vmware.com, srivatsab@vmware.com
Subject: Re: [4.19.y PATCH 1/3] efi/x86/Add missing error handling to
 old_memmap 1:1 mapping code
Message-ID: <20190629065721.GA365@kroah.com>
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
 <156174732219.34985.6679541271840078416.stgit@srivatsa-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156174732219.34985.6679541271840078416.stgit@srivatsa-ubuntu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 11:42:13AM -0700, Srivatsa S. Bhat wrote:
> From: Gen Zhang <blackgod016574@gmail.com>
> 
> commit 4e78921ba4dd0aca1cc89168f45039add4183f8e upstream.
> 
> The old_memmap flow in efi_call_phys_prolog() performs numerous memory
> allocations, and either does not check for failure at all, or it does
> but fails to propagate it back to the caller, which may end up calling
> into the firmware with an incomplete 1:1 mapping.
> 
> So let's fix this by returning NULL from efi_call_phys_prolog() on
> memory allocation failures only, and by handling this condition in the
> caller. Also, clean up any half baked sets of page tables that we may
> have created before returning with a NULL return value.
> 
> Note that any failure at this level will trigger a panic() two levels
> up, so none of this makes a huge difference, but it is a nice cleanup
> nonetheless.

With a description like this, why is this needed in a stable kernel if
it does not really fix anything useful?

thanks,

greg k-h
