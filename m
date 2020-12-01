Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298B62C9F05
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 11:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391097AbgLAKTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 05:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgLAKTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 05:19:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE52207FF;
        Tue,  1 Dec 2020 10:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606817938;
        bh=x0EFmzJ4H76MAN3cpDLbL7++bBdsOnfMiVEjI/q6XIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VoZznCUSVLo/wKU7E/ZzY3gvtaoqhvLMVMTT6t1v4EX4SkLZmsF4JiWazeOWbSOCi
         ibPR1zbmhhqFAlBF/C0qsrdnbaRCvrcekYv8XqtejFIWtVDiB3fXMORf/WURVqaPik
         7dyC/3omM8N2nFPu2ivF18UrTrqy8jQlT06c6Jy8=
Date:   Tue, 1 Dec 2020 11:20:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
Message-ID: <X8YY2qW3RQqzmmBl@kroah.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
 <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
 <X8YThgeaonYhB6zi@kroah.com>
 <fe3fa32b-fc84-9e81-80e0-cb19889fc042@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3fa32b-fc84-9e81-80e0-cb19889fc042@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 11:03:36AM +0100, Paolo Bonzini wrote:
> On 01/12/20 10:57, Greg Kroah-Hartman wrote:
> > > Since you did not apply "KVM: x86: handle !lapic_in_kernel case in
> > > kvm_cpu_*_extint" to 4.19 or earlier, please leave this one out as well.
> > Isn't it patch 07 of this series?
> 
> Yes, it arrived a few minutes after I hit send for whatever reason. Though
> it still applies to 4.14 and earlier:
> 
> ` [PATCH 4.14 04/50] wireless: Use linux/stddef.h instead of stddef.h
> ` [PATCH 4.14 07/50] btrfs: adjust return values of btrfs_inode_by_name
> ` [PATCH 4.14 08/50] btrfs: inode: Verify inode mode to avoid NULL pointer
> dereference
> ` [PATCH 4.14 09/50] KVM: x86: Fix split-irqchip vs interrupt injection
> window request
> 
> ` [PATCH 4.9 05/42] btrfs: tree-checker: Enhance chunk checker to validate
> chunk profile
> ` [PATCH 4.9 06/42] btrfs: inode: Verify inode mode to avoid NULL pointer
> dereference
> ` [PATCH 4.9 07/42] KVM: x86: Fix split-irqchip vs interrupt injection
> window request
> 
> ` [PATCH 4.4 01/24] btrfs: tree-checker: Enhance chunk checker to validate
> chunk profile
> ` [PATCH 4.4 02/24] btrfs: inode: Verify inode mode to avoid NULL pointer
> dereference
> ` [PATCH 4.4 03/24] KVM: x86: Fix split-irqchip vs interrupt injection
> window request

Ok, I will go drop this patch from 4.14, 4.9, and 4.4.  Or, should the
needed pre-requisite patch be properly backported there instead?

And was it marked somewhere that this patch depended on that one and I
just missed it?

thanks,

greg k-h
