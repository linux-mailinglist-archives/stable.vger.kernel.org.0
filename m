Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E113638CA
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 02:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhDSA3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 20:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231860AbhDSA3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Apr 2021 20:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7B760232;
        Mon, 19 Apr 2021 00:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618792157;
        bh=Eufz817LW5NV6L2sJvkQ0ahClRRrUHYFaxzfNwj2mv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFTqt5NBpGXSkW2m7HA20Iap/bX/bvuFVOJgDdhYvbVp9Y52XJp0k1zRBDL85os1G
         pbfj0fgyxIo8eaHBZWxAxvlzzFOr1yntX6FXylxxuXtsl8dZ0KTymMMPBzgpWLb+mg
         7ydzfpyv6ZOdHyo9co7rkF72RUNtiH6mtZYNgv0s+sxY9DiIzKH6qkraVeCXW5jH/X
         PHT0pyX6Q2PIP+NnWVA1dga1fbepGMh19LI1npViEy8DVgFaX/gfZfWwtbi2Mi5Ckh
         7jp4gSpMTcWIudhMGCVn877yUVAxDwQEuhFOBnt2DXw9eoj595/dCmHkSaPv56rPAf
         8FeC+6+I/3uFA==
Date:   Sun, 18 Apr 2021 20:29:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     reijiw@google.com, jmattson@google.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: VMX: Don't use
 vcpu->run->internal.ndata as an array" failed to apply to 5.11-stable tree
Message-ID: <YHzO3D2cjuJ9f+ZW@sashalap>
References: <1618742076194222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1618742076194222@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 18, 2021 at 12:34:36PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.11-stable tree.
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
>From 04c4f2ee3f68c9a4bf1653d15f1a9a435ae33f7a Mon Sep 17 00:00:00 2001
>From: Reiji Watanabe <reijiw@google.com>
>Date: Tue, 13 Apr 2021 15:47:40 +0000
>Subject: [PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array
> index
>
>__vmx_handle_exit() uses vcpu->run->internal.ndata as an index for
>an array access.  Since vcpu->run is (can be) mapped to a user address
>space with a writer permission, the 'ndata' could be updated by the
>user process at anytime (the user process can set it to outside the
>bounds of the array).
>So, it is not safe that __vmx_handle_exit() uses the 'ndata' that way.
>
>Fixes: 1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
>Signed-off-by: Reiji Watanabe <reijiw@google.com>
>Reviewed-by: Jim Mattson <jmattson@google.com>
>Message-Id: <20210413154739.490299-1-reijiw@google.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I've resolved this by taking 8e5332402164 ("KVM: VMX: Convert
vcpu_vmx.exit_reason to a union").

-- 
Thanks,
Sasha
