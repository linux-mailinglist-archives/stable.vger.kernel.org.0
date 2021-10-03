Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EF74201F3
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 16:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhJCOSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 10:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230250AbhJCOSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 10:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E9061B00;
        Sun,  3 Oct 2021 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633270575;
        bh=iz8OwoA1KSQRR7ghgLdO4bXC5lIJtF5D8luSFSvaE1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KmFMt40HaC1QnXzwnqpRfJvBuSovqM5unyIPeHWY/UbaBH50RTE1VTuey1KLCkJEv
         gTiJh6x6uFZsRub26lBluUExpAeVygxRKmcqj+4eZyrBcDM4E8l7P0Er5jjHT98mHR
         mUIsdkQuM2s51uEMep4llbs9xoA1/CC577LI9P4Y=
Date:   Sun, 3 Oct 2021 16:16:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Foley <pefoley@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10] KVM: rseq: Update rseq when processing
 NOTIFY_RESUME on xfer to KVM guest
Message-ID: <YVm7LRQSegT0WR0Q@kroah.com>
References: <20210927192846.1533905-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927192846.1533905-1-seanjc@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 12:28:46PM -0700, Sean Christopherson wrote:
> commit 8646e53633f314e4d746a988240d3b951a92f94a upstream.
> 
> Invoke rseq's NOTIFY_RESUME handler when processing the flag prior to
> transferring to a KVM guest, which is roughly equivalent to an exit to
> userspace and processes many of the same pending actions.  While the task
> cannot be in an rseq critical section as the KVM path is reachable only
> by via ioctl(KVM_RUN), the side effects that apply to rseq outside of a
> critical section still apply, e.g. the current CPU needs to be updated if
> the task is migrated.
> 
> Clearing TIF_NOTIFY_RESUME without informing rseq can lead to segfaults
> and other badness in userspace VMMs that use rseq in combination with KVM,
> e.g. due to the CPU ID being stale after task migration.
> 
> Fixes: 72c3c0fe54a3 ("x86/kvm: Use generic xfer to guest work function")
> Reported-by: Peter Foley <pefoley@google.com>
> Bisected-by: Doug Evans <dje@google.com>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20210901203030.1292304-2-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [sean: Resolve benign conflict due to unrelated access_ok() check in 5.10]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  kernel/entry/kvm.c |  4 +++-
>  kernel/rseq.c      | 13 ++++++++++---
>  2 files changed, 13 insertions(+), 4 deletions(-)

Applied, but we also need a 5.14.y version as well.

thanks,

greg k-h
