Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12B21092E2
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKYReB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfKYReB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 12:34:01 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6352A20748;
        Mon, 25 Nov 2019 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574703240;
        bh=uUrEY8zIBLwh1LeqziC1u72nUhPp4JCyM4AdtCAQuys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=skO7wDhLwg4V4BroVYOX8CjQxnXPVmY4zPodoOCa146RJLZSW2TEZoqsKwvAnfD60
         eqImISvQ8p/JPAm+vFvM2bzNrHsAYNg7DCkSNno9a+G0gEiP2ihyVJl+ckMMG50199
         X8lLxEcjEXCnT0xlPdfpIuFIcvQ/vKTvq0IsTAbc=
Date:   Mon, 25 Nov 2019 12:33:59 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chenyi.qiang@intel.com, pbonzini@redhat.com, xiaoyao.li@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: X86: Fix initialization of MSR
 lists" failed to apply to 5.3-stable tree
Message-ID: <20191125173359.GH5861@sasha-vm>
References: <15740905382212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15740905382212@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 04:22:18PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 7a5ee6edb42e0bb487954806d34877995b6b8d59 Mon Sep 17 00:00:00 2001
>From: Chenyi Qiang <chenyi.qiang@intel.com>
>Date: Wed, 6 Nov 2019 14:35:20 +0800
>Subject: [PATCH] KVM: X86: Fix initialization of MSR lists
>
>The three MSR lists(msrs_to_save[], emulated_msrs[] and
>msr_based_features[]) are global arrays of kvm.ko, which are
>adjusted (copy supported MSRs forward to override the unsupported MSRs)
>when insmod kvm-{intel,amd}.ko, but it doesn't reset these three arrays
>to their initial value when rmmod kvm-{intel,amd}.ko. Thus, at the next
>installation, kvm-{intel,amd}.ko will do operations on the modified
>arrays with some MSRs lost and some MSRs duplicated.
>
>So define three constant arrays to hold the initial MSR lists and
>initialize msrs_to_save[], emulated_msrs[] and msr_based_features[]
>based on the constant arrays.
>
>Cc: stable@vger.kernel.org
>Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>[Remove now useless conditionals. - Paolo]
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Would it make sense taking the commits below to make this patch apply on
5.3?

7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")
e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]")
24c29b7ac0da ("KVM: x86: omit absent pmu MSRs from MSR list")
cf05a67b68b8 ("KVM: x86: omit "impossible" pmu MSRs from MSR list")

-- 
Thanks,
Sasha
