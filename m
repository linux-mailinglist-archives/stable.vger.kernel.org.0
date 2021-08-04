Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948593DFE74
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 11:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhHDJ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 05:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236659AbhHDJ4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 05:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 518AB601FC;
        Wed,  4 Aug 2021 09:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628070980;
        bh=1d9tA3AdDvnlhXjD3Ugn/xlnN8cCmIyfjgOcCevxnqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MfHM1furbp94KogJg6m6eOi3zQf1ifgX/PumR+ZqpRGi/Y4RFj60T3BPVDQKbtMvJ
         8hR/XIPY3YPghFMQRS1b24TylHj7vzTPcevrSL0wcF3l40cQersTEldlxQL3MDjlXK
         QABexY0Ud58QXdaaojrB/YBjw8BdhPkGZ7Bl1NYA=
Date:   Wed, 4 Aug 2021 11:56:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH] KVM: Do not leak memory for duplicate debugfs directories
Message-ID: <YQpkPzWhC0+44cXb@kroah.com>
References: <20210804093737.2536206-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804093737.2536206-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 04, 2021 at 05:37:37AM -0400, Paolo Bonzini wrote:
> KVM creates a debugfs directory for each VM in order to store statistics
> about the virtual machine.  The directory name is built from the process
> pid and a VM fd.  While generally unique, it is possible to keep a
> file descriptor alive in a way that causes duplicate directories, which
> manifests as these messages:
> 
>   [  471.846235] debugfs: Directory '20245-4' with parent 'kvm' already present!
> 
> Even though this should not happen in practice, it is more or less
> expected in the case of KVM for testcases that call KVM_CREATE_VM and
> close the resulting file descriptor repeatedly and in parallel.
> 
> When this happens, debugfs_create_dir() returns an error but
> kvm_create_vm_debugfs() goes on to allocate stat data structs which are
> later leaked.  The slow memory leak was spotted by syzkaller, where it
> caused OOM reports.
> 
> Since the issue only affects debugfs, do a lookup before calling
> debugfs_create_dir, so that the message is downgraded and rate-limited.
> While at it, ensure kvm->debugfs_dentry is NULL rather than an error
> if it is not created.  This fixes kvm_destroy_vm_debugfs, which was not
> checking IS_ERR_OR_NULL correctly.
> 
> Cc: stable@vger.kernel.org
> Fixes: 536a6f88c49d ("KVM: Create debugfs dir and stat files for each VM")
> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
