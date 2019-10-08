Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B32CD0343
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 00:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJHWP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 18:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJHWP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 18:15:28 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815E021721;
        Tue,  8 Oct 2019 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570572927;
        bh=uhE2EbyNORWa0oQXq9GcY2oyN17kdDI6uD//pAPrAJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n6Hrgoawp90loLd1ugJATT3pzoZEJJ1rHSORdQN1g9XEhBRSlOy+GEEyEnQrH+bCG
         lJw2VCWNw3ALYvyB4pNVMz99H9QEvxvIFC716lJycWSE1K0SH3+V+UT52rdaGx//7P
         e/bwLDZ9krqc2BbAY8T+MOqaVjpRE2oC+nlXa18k=
Date:   Tue, 8 Oct 2019 18:15:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        namit@vmware.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: nVMX: Fix consistency check on
 injected exception error" failed to apply to 5.3-stable tree
Message-ID: <20191008221527.GF1396@sasha-vm>
References: <1570519311128161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570519311128161@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:21:51AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From 567926cca99ba1750be8aae9c4178796bf9bb90b Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Tue, 1 Oct 2019 09:21:23 -0700
>Subject: [PATCH] KVM: nVMX: Fix consistency check on injected exception error
> code
>
>Current versions of Intel's SDM incorrectly state that "bits 31:15 of
>the VM-Entry exception error-code field" must be zero.  In reality, bits
>31:16 must be zero, i.e. error codes are 16-bit values.
>
>The bogus error code check manifests as an unexpected VM-Entry failure
>due to an invalid code field (error number 7) in L1, e.g. when injecting
>a #GP with error_code=0x9f00.
>
>Nadav previously reported the bug[*], both to KVM and Intel, and fixed
>the associated kvm-unit-test.
>
>[*] https://patchwork.kernel.org/patch/11124749/
>
>Reported-by: Nadav Amit <namit@vmware.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Reviewed-by: Jim Mattson <jmattson@google.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

There were minor conflicts due to missing tracepoint in 5.3 and code
movement in 4.19. I've fixed it up.

-- 
Thanks,
Sasha
