Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF014759A3
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbhLON3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:29:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57588 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbhLON27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:28:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9082DB81F1E
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF06C34605;
        Wed, 15 Dec 2021 13:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639574937;
        bh=VVzKVC7Tt+megRZxmz8Utb4yfF3EnyN00ICXhetFIz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iQtV8Zfc+SJ13cnTSofIocEBcyxyoSuKAUNuK/bbzu/VHjFkRNBeZwc2vDc/oNnyP
         qpphsv/31oTyKiIYjwPOJPpkVXOe9KAxZtSR73ehT7NpQ4opZ5AGE/6UDBPUd0Fk8Y
         4NiAfqqv7GID4KN9GpCeamLO6uGNGt5dapu8KMIE=
Date:   Wed, 15 Dec 2021 14:28:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 5.10] KVM: x86: Ignore sparse banks size for an "all
 CPUs", non-sparse IPI req
Message-ID: <Ybntl+ye8JOVmqmJ@kroah.com>
References: <20211213095012.15021-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213095012.15021-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:50:12AM +0100, Vitaly Kuznetsov wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> commit 3244867af8c065e51969f1bffe732d3ebfd9a7d2 upstream.
> 
> Do not bail early if there are no bits set in the sparse banks for a
> non-sparse, a.k.a. "all CPUs", IPI request.  Per the Hyper-V spec, it is
> legal to have a variable length of '0', e.g. VP_SET's BankContents in
> this case, if the request can be serviced without the extra info.
> 
>   It is possible that for a given invocation of a hypercall that does
>   accept variable sized input headers that all the header input fits
>   entirely within the fixed size header. In such cases the variable sized
>   input header is zero-sized and the corresponding bits in the hypercall
>   input should be set to zero.
> 
> Bailing early results in KVM failing to send IPIs to all CPUs as expected
> by the guest.
> 
> Fixes: 214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20211207220926.718794-2-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Both now queued up, thanks.

greg k-h
