Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C37124B0FA
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgHTIXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgHTIXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 04:23:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38BD922CA1;
        Thu, 20 Aug 2020 08:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597911816;
        bh=YjVacKhand5NsZGGlQGYcqcvZn3bYQ02UFVVSQaIqRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGMyA7qRHFHVLQCR3POC0PGJA7S7i/tOyNOoYVmLNJf4p1fBcVx67ppupyCWnfkcw
         mtzCdIQvdXC0+/9KJiHXjLXMziRX1kolv7tkde2h46SKonJQ/RdD2NAMa76eh90NOZ
         b7LR8GE/g2EbTuM5QRFzeL0nTWqa2X8ylq0eQD4A=
Date:   Thu, 20 Aug 2020 10:23:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will McVicker <willmcvicker@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/1] Netfilter OOB memory access security patch
Message-ID: <20200820082357.GI4049659@kroah.com>
References: <20200727175720.4022402-2-willmcvicker@google.com>
 <20200727190731.4035744-1-willmcvicker@google.com>
 <20200727190731.4035744-2-willmcvicker@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727190731.4035744-2-willmcvicker@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 07:07:30PM +0000, Will McVicker wrote:
> Hi,
> The attached patch fixes an OOB memory access security bug. The bug is
> already fixed in the upstream kernel due to the vulnerable code being
> refactored in commit fe2d0020994c ("netfilter: nat: remove
> l4proto->in_range") and commit d6c4c8ffb5e5 ("netfilter: nat: remove
> l3proto struct"), but the 4.19 and below LTS branches remain vulnerable.
> I have verifed the OOB kernel panic is fixed with this patch on both the
> 4.19 and 4.14 kernels using the approariate hardware.
> 
> Please review the fix and apply to branches 4.19.y, 4.14.y, 4.9.y and
> 4.4.y.

This patch only applied to the 4.19.y tree, it failed to apply to all of
the other branches:

Applying patch netfilter-nat-add-range-checks-for-access-to-nf_nat_lprotos.patch
patching file net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
patching file net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
patching file net/netfilter/nf_nat_core.c
Hunk #1 succeeded at 45 (offset -19 lines).
Hunk #2 succeeded at 298 with fuzz 1 (offset -23 lines).
Hunk #3 succeeded at 309 (offset -23 lines).
Hunk #4 succeeded at 376 (offset -24 lines).
Hunk #5 succeeded at 399 (offset -24 lines).
Hunk #6 succeeded at 419 (offset -24 lines).
Hunk #7 FAILED at 526.
Hunk #8 succeeded at 733 (offset -100 lines).
1 out of 8 hunks FAILED -- rejects in file net/netfilter/nf_nat_core.c
patching file net/netfilter/nf_nat_helper.c

And you didn't cc: the netfilter developers for this, are they ok with
this?  I need an ack from them to be able to take this.

Can you fix this up, resend working versions for all branches, and get
their acks?

thanks,

greg k-h
