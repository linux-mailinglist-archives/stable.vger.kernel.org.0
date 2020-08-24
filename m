Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CBA24FC76
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 13:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgHXLXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 07:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgHXLXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 07:23:51 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D3792074D;
        Mon, 24 Aug 2020 11:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598268231;
        bh=vFY4UStV4g+HxgmH/bxoQ67RUTWUD8KzwI1mI27IZ+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QIUYVzjpH8kecZ7gs4/K2eLD6+lfYkWhxuku7kgJxLlZpxzFnRZUI0MmADsoM04/G
         /wJAjmrAfoBN/BlcPDvPgnMUNpF38KwipEwLX5KHCxjtszghaB/+2+bSq2dcjMoD+u
         gpcyZ8BbDVka42EvsAkFeQ/o8Q7RKJMz7TQaVCGw=
Date:   Mon, 24 Aug 2020 12:23:47 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     james.morse@arm.com, maz@kernel.org, pbonzini@redhat.com,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: FAILED: patch "[PATCH] KVM: arm64: Only reschedule if
 MMU_NOTIFIER_RANGE_BLOCKABLE" failed to apply to 5.8-stable tree
Message-ID: <20200824112347.GA24428@willie-the-truck>
References: <1598185625713@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598185625713@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 23, 2020 at 02:27:05PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From b5331379bc62611d1026173a09c73573384201d9 Mon Sep 17 00:00:00 2001
> From: Will Deacon <will@kernel.org>
> Date: Tue, 11 Aug 2020 11:27:25 +0100
> Subject: [PATCH] KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE
>  is not set
> 
> When an MMU notifier call results in unmapping a range that spans multiple
> PGDs, we end up calling into cond_resched_lock() when crossing a PGD boundary,
> since this avoids running into RCU stalls during VM teardown. Unfortunately,
> if the VM is destroyed as a result of OOM, then blocking is not permitted
> and the call to the scheduler triggers the following BUG():

This is in the same boat as:

https://lore.kernel.org/r/20200824112156.GA24319@willie-the-truck

so please drop it from the stable queues while I cook some backports for
you.

Thanks,

Will
