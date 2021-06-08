Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FF739FB0D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhFHPoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230176AbhFHPoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 11:44:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7DB660698;
        Tue,  8 Jun 2021 15:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623166928;
        bh=i+2gEWVknqEtC8xvM7gT2PjHISpOSFRmL+etYWP5YHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=stg9SrSYmOTAoTb5EAJinOPF0cimJrZRzVd17/QIiMILTN8c7SDFSsuEM2Uaa4aSZ
         xsNQAVr8C0w2deNtxkyRrWye3/e8GTqljQr7N+v79N5lGJ3QNT7QwGu+0HJUNnqrYC
         WasYmCPwrZs5SVKpFMium2x/2D89KkLUza5DrOYg=
Date:   Tue, 8 Jun 2021 17:42:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH][5.10-stable] KVM: arm64: Fix debug register indexing
Message-ID: <YL+PzXvOyepgeoha@kroah.com>
References: <20210601164304.248532-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601164304.248532-1-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 05:43:04PM +0100, Marc Zyngier wrote:
> commit cb853ded1d25e5b026ce115dbcde69e3d7e2e831 upstream.
> 
> Commit 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on
> reset") flipped the register number to 0 for all the debug registers
> in the sysreg table, hereby indicating that these registers live
> in a separate shadow structure.
> 
> However, the author of this patch failed to realise that all the
> accessors are using that particular index instead of the register
> encoding, resulting in all the registers hitting index 0. Not quite
> a valid implementation of the architecture...
> 
> Address the issue by fixing all the accessors to use the CRm field
> of the encoding, which contains the debug register index.
> 
> Fixes: 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on reset")
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/sys_regs.c | 42 +++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)

All now queued up,t hanks.

greg k-h
