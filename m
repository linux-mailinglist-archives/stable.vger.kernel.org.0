Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B6647A77E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhLTJz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:55:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38040 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhLTJz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:55:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4EDEB80E32;
        Mon, 20 Dec 2021 09:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03F8C36AE8;
        Mon, 20 Dec 2021 09:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639994155;
        bh=Beoy2P6+fy8z/gUXucA5Q6lCjHYHwarxoLXBRIeKynM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2G0p7fxX62M2JdkO57qLYXGC8Hmf18Er7QRaICY2Q0o+OOvhP4xGH04xGncyLg/Rv
         4TRR4NSJDLbWdy/UYiRLlDSkqC81WA/uSNgAQpTpUk+ODED6Zfw6RhBrlIEvkOrbWG
         AGVb0s6bfYMhsx8KgL2zfIYJFNt7UH4GCNrKRUCM=
Date:   Mon, 20 Dec 2021 10:55:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH for-stable] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr
 if APICv is disabled
Message-ID: <YcBTKJ08/7tjOBAu@kroah.com>
References: <20211220094950.288692-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220094950.288692-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 10:49:50AM +0100, Paolo Bonzini wrote:
> commit e90e51d5f01d2baae5dcce280866bbb96816e978 upstream.
> 
> There is nothing to synchronize if APICv is disabled, since neither
> other vCPUs nor assigned devices can set PIR.ON.
> 
> After the patch was committed to Linus's tree, it was observed that
> this fixes an issue with commit 7e1901f6c86c ("KVM: VMX: prepare
> sync_pir_to_irr for running with APICv disabled", backported to stable
> as e.g. commit 70a37e04c08a for the 5.15 tree).  Without this patch,
> vmx_sync_pir_to_irr can be reached with enable_apicv == false, triggering
> 
>  	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
> 
> Fixes: 7e1901f6c86c ("KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks like it is already queued up, thanks.

greg k-h
