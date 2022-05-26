Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78082534EDD
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiEZMKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiEZMKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D2FD4117
        for <stable@vger.kernel.org>; Thu, 26 May 2022 05:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF04CB8204D
        for <stable@vger.kernel.org>; Thu, 26 May 2022 12:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DB3C385A9;
        Thu, 26 May 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653567018;
        bh=ou8OZvKYi4x79xtMGCnSEnyEEKcpMhpj0VBbure6Xjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=13/K84UiivFfWRMNxoVIkkXGdrRxQGFldvY55oz3nDsyeUHEYCiJkWPfHimGMB+wz
         lVCypKIsEv3fZJmb1MRDogonHdRiHPoGYqcYeANBAPbnca2xK/tW4plububuXx8ujx
         0JpERqs2VTyr65Sr4FHoc8nIqDx8uFrG06YS+esU=
Date:   Thu, 26 May 2022 14:10:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     stable@vger.kernel.org, vkuznets@redhat.com, pbonzini@redhat.com,
        sebastien.boeuf@intel.com, kai.liu@suse.com
Subject: Re: [PATCH 5.10] KVM: x86: Properly handle APF vs disabled LAPIC
 situation
Message-ID: <Yo9uJx9DXXkO9V4C@kroah.com>
References: <20220524064204.18598-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524064204.18598-1-guoqing.jiang@linux.dev>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 02:42:04PM +0800, Guoqing Jiang wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Backport of commit 2f15d027c05fac406decdb5eceb9ec0902b68f53 upstream.
> 
> Async PF 'page ready' event may happen when LAPIC is (temporary) disabled.
> In particular, Sebastien reports that when Linux kernel is directly booted
> by Cloud Hypervisor, LAPIC is 'software disabled' when APF mechanism is
> initialized. On initialization KVM tries to inject 'wakeup all' event and
> puts the corresponding token to the slot. It is, however, failing to inject
> an interrupt (kvm_apic_set_irq() -> __apic_accept_irq() -> !apic_enabled())
> so the guest never gets notified and the whole APF mechanism gets stuck.
> The same issue is likely to happen if the guest temporary disables LAPIC
> and a previously unavailable page becomes available.
> 
> Do two things to resolve the issue:
> - Avoid dequeuing 'page ready' events from APF queue when LAPIC is
>   disabled.
> - Trigger an attempt to deliver pending 'page ready' events when LAPIC
>   becomes enabled (SPIV or MSR_IA32_APICBASE).
> 
> Reported-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20210422092948.568327-1-vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [Guoqing: backport to 5.10-stable ]
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
> Hi,
> 
> We encountered below task hang issue with 5.10.113 stable kernel.
> 
> [  246.845061] INFO: task rpmbuild:2303 blocked for more than 122 seconds.
> [  246.846269]       Not tainted 5.10.113-1.1.se2-default #1
> [  246.847103] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  246.848248] task:rpmbuild        state:D stack:    0 pid: 2303 ppid:  2302 flags:0x00000000
> [  246.848252] Call Trace:
> [  246.848266]  __schedule+0x3f6/0x7c0
> [  246.848289]  ? __handle_mm_fault+0x3dd/0x6d0
> [  246.848291]  schedule+0x46/0xb0
> [  246.848295]  kvm_async_pf_task_wait_schedule+0x4b/0x90
> [  246.848297]  ? handle_mm_fault+0xbc/0x280
> [  246.848300]  __kvm_handle_async_pf+0x4f/0xb0
> [  246.848303]  exc_page_fault+0x204/0x540
> [  246.848305]  ? asm_exc_page_fault+0x8/0x30
> [  246.848307]  asm_exc_page_fault+0x1e/0x30
> [  246.848310] RIP: 0033:0x7f122fbdfc90
> 
> And after investigating, this patch resolve the issue. 5.12 stable kernel
> has already merged it by commit 36825931c607.

Now queued up, thanks.

greg k-h
