Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3711156C52
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 21:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgBIUGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 15:06:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbgBIUGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 15:06:20 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 523B520726;
        Sun,  9 Feb 2020 20:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581278780;
        bh=UFEc4X4J/JVcztogPu3oGnME3/aqMjesq2FlYHB2k6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xjw3UDc7jt7Jpz1X/pXw92iqXJ5ULarkFDASWlY4dt5vhVVclCt/xcQP/NWglywjj
         n2n2OWGlB+Ulqdrd9RnOPmX8FueV6lAqfmqpnSRFG1Ybl0AcwcIchf8u2wLNxJEEze
         4VMMmTGuyd90aqJ89/RMnr7AOp+oDlOd/WjcGfEg=
Date:   Sun, 9 Feb 2020 15:06:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Use gpa_t for cr2/gpa to fix
 TDP support on 32-bit" failed to apply to 5.4-stable tree
Message-ID: <20200209200619.GY3584@sasha-vm>
References: <1581251500104115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581251500104115@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:31:40PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 736c291c9f36b07f8889c61764c28edce20e715d Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Fri, 6 Dec 2019 15:57:14 -0800
>Subject: [PATCH] KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit
> KVM
>
>Convert a plethora of parameters and variables in the MMU and page fault
>flows from type gva_t to gpa_t to properly handle TDP on 32-bit KVM.
>
>Thanks to PSE and PAE paging, 32-bit kernels can access 64-bit physical
>addresses.  When TDP is enabled, the fault address is a guest physical
>address and thus can be a 64-bit value, even when both KVM and its guest
>are using 32-bit virtual addressing, e.g. VMX's VMCS.GUEST_PHYSICAL is a
>64-bit field, not a natural width field.
>
>Using a gva_t for the fault address means KVM will incorrectly drop the
>upper 32-bits of the GPA.  Ditto for gva_to_gpa() when it is used to
>translate L2 GPAs to L1 GPAs.
>
>Opportunistically rename variables and parameters to better reflect the
>dual address modes, e.g. use "cr2_or_gpa" for fault addresses and plain
>"addr" instead of "vaddr" when the address may be either a GVA or an L2
>GPA.  Similarly, use "gpa" in the nonpaging_page_fault() flows to avoid
>a confusing "gpa_t gva" declaration; this also sets the stage for a
>future patch to combing nonpaging_page_fault() and tdp_page_fault() with
>minimal churn.
>
>Sprinkle in a few comments to document flows where an address is known
>to be a GVA and thus can be safely truncated to a 32-bit value.  Add
>WARNs in kvm_handle_page_fault() and FNAME(gva_to_gpa_nested)() to help
>document such cases and detect bugs.
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

File and variable renames. I've cleaned it up and queued for 5.4 and
4.19.

-- 
Thanks,
Sasha
