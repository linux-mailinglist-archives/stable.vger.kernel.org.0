Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33EC6D4547
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjDCNIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjDCNIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:08:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA110D7;
        Mon,  3 Apr 2023 06:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4965660A71;
        Mon,  3 Apr 2023 13:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33109C433D2;
        Mon,  3 Apr 2023 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680527326;
        bh=LAV//JPbB9QVvq/VUV4Ckfl5qCzolGCOQod4gC5PLk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i13zJ0watYt53sX+Fy1N0c16JMQAbdjExUC21m9z/Srw+VNTZbw+j5VeMdka59AZQ
         u23bWaMKgVaW3VQqECqfzuTv5hL/evKC1UITFmO7XM5q0JsZcZjg9y6l2p9Ic4hL2t
         SPtKDuNoNs4pb02/dL5eEcWBAhb+e9U6QPYnukjU=
Date:   Mon, 3 Apr 2023 15:08:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     pbonzini@redhat.com, stable@vger.kernel.org, seanjc@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, suravee.suthikulpanit@amd.com,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        joneslee@google.com,
        syzbot+b6a74be92b5063a0f1ff@syzkaller.appspotmail.com
Subject: Re: [PATCH][for stable/linux-5.15.y] KVM: VMX: Move preemption timer
 <=> hrtimer dance to common x86
Message-ID: <2023040335-backlash-tubeless-7d21@gregkh>
References: <20230329151747.2938509-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329151747.2938509-1-tudor.ambarus@linaro.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 03:17:47PM +0000, Tudor Ambarus wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> commit 98c25ead5eda5e9d41abe57839ad3e8caf19500c upstream.
> 
> Handle the switch to/from the hypervisor/software timer when a vCPU is
> blocking in common x86 instead of in VMX.  Even though VMX is the only
> user of a hypervisor timer, the logic and all functions involved are
> generic x86 (unless future CPUs do something completely different and
> implement a hypervisor timer that runs regardless of mode).
> 
> Handling the switch in common x86 will allow for the elimination of the
> pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
> timer if and only if it was in use (without additional params).  Add a
> comment explaining why the switch cannot be deferred to kvm_sched_out()
> or kvm_vcpu_block().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20211208015236.1616697-8-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [ta: Fix conflicts in vmx_pre_block and vmx_post_block as per Paolo's
> suggestion. Add Reported-by and Link tags.]
> Reported-by: syzbot+b6a74be92b5063a0f1ff@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=489beb3d76ef14cc6cd18125782dc6f86051a605
> Tested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> ---
>  arch/x86/kvm/vmx/vmx.c |  6 ------
>  arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
>  2 files changed, 21 insertions(+), 6 deletions(-)

Now queued up, thanks.

greg k-h
