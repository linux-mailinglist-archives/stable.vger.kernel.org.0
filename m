Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C469E6AF87
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 21:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfGPTDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 15:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbfGPTDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 15:03:32 -0400
Received: from localhost (unknown [113.157.217.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FAF420665;
        Tue, 16 Jul 2019 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563303811;
        bh=SlLad1gTFetYn90NL50+Q9zL3TJWm2yntm0wRhOd1Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=av/PpkucEGO4jBghtD17yRpzR4sC+JMV19GsYGDwHEaCbm4illzuWzXOzNuv5cY7k
         iq/v1sqByCpGOLqQB28FcoMcABAv1jchyNmDepDPO1moNpRUPPUnKUgYvfRBWTIrWe
         WqfPJpkFLXNMtu0oHNIBiP3iDjigC6d9Xur5VHsQ=
Date:   Wed, 17 Jul 2019 04:03:28 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: b21629da120d ("kvm: x86: avoid warning on repeated
 KVM_SET_TSS_ADDR")
Message-ID: <20190716190328.GA20227@kroah.com>
References: <20190716171247.GA7816@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716171247.GA7816@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 10:12:48AM -0700, Zubin Mithra wrote:
> Hello,
> 
> Syzkaller has triggered a kernel WARNING when fuzzing a 4.4 kernel with the following stacktrace.
> Call Trace:
>  [<ffffffff81989d3d>] __dump_stack lib/dump_stack.c:15 [inline]
>  [<ffffffff81989d3d>] dump_stack+0xbf/0x113 lib/dump_stack.c:51
>  [<ffffffff813be4aa>] panic+0x1a6/0x361 kernel/panic.c:116
>  [<ffffffff811c2c00>] __warn+0x168/0x1b0 kernel/panic.c:470
>  [<ffffffff813be6a1>] warn_slowpath_null+0x3c/0x40 kernel/panic.c:514
>  [<ffffffff81030f13>] __x86_set_memory_region+0x1c2/0x3ef arch/x86/kvm/x86.c:7792
>  [<ffffffff81031185>] x86_set_memory_region+0x45/0x5c arch/x86/kvm/x86.c:7838
>  [<ffffffff810add1e>] vmx_set_tss_addr+0x8c/0x246 arch/x86/kvm/vmx.c:5171
>  [<ffffffff8103a798>] kvm_vm_ioctl_set_tss_addr arch/x86/kvm/x86.c:3520 [inline]
>  [<ffffffff8103a798>] kvm_arch_vm_ioctl+0x26b/0x17db arch/x86/kvm/x86.c:3788
>  [<ffffffff81013cb4>] kvm_vm_ioctl+0xb7d/0xbfa arch/x86/kvm/../../../virt/kvm/kvm_main.c:2959
>  [<ffffffff8149d51a>] vfs_ioctl fs/ioctl.c:43 [inline]
>  [<ffffffff8149d51a>] do_vfs_ioctl+0xcb0/0xd0f fs/ioctl.c:630
>  [<ffffffff8149d5ea>] SYSC_ioctl fs/ioctl.c:645 [inline]
>  [<ffffffff8149d5ea>] SyS_ioctl+0x71/0xad fs/ioctl.c:636
>  [<ffffffff832bca35>] tracesys_phase2+0xa3/0xa8
> 
> Could the following patch be applied to v4.4.y. The patch is present in v4.9.y.
> * b21629da120d ("kvm: x86: avoid warning on repeated KVM_SET_TSS_ADDR")
> 
> Tests run:
> * Syzkaller reproducer
> * Chrome OS tryjobs

Now queued up, thanks.

greg k-h
