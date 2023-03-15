Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894286BAA4B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjCOIBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjCOIBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:01:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9500F7586D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C1B161AFB
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5CAC433D2;
        Wed, 15 Mar 2023 08:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678867275;
        bh=vau5N4PvOlK1JNWqSTKSiQNhOhS+YIwEqKe9yZHFeTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8GQeLS2rJOqB1IBNggo5JkOvrua9Wr9bM9fQqMCwr6LYe3tKR6Q1WlVphsX1aEHt
         uUoPVOU8MPAHRby1wJNsCcRZJ5fL54PtLXjfBqsdN0JQ9bW1MHDeD/JBLbX6NVlwHe
         lvtwRjcjoemcNk+PuDFJbSB2hz9/qaknCK0oRbbQ=
Date:   Wed, 15 Mar 2023 09:01:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     stable@vger.kernel.org, Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH 5.15.y 1/3] KVM: nVMX: Don't use Enlightened MSR Bitmap
 for L3
Message-ID: <ZBF7SQXlCXuxtkAa@kroah.com>
References: <16781188891829@kroah.com>
 <20230314091953.3041-1-alexandru.matei@uipath.com>
 <20230314091953.3041-2-alexandru.matei@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314091953.3041-2-alexandru.matei@uipath.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 11:19:51AM +0200, Alexandru Matei wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 250552b925ce400c17d166422fde9bb215958481 upstream.
> 
> When KVM runs as a nested hypervisor on top of Hyper-V it uses Enlightened
> VMCS and enables Enlightened MSR Bitmap feature for its L1s and L2s (which
> are actually L2s and L3s from Hyper-V's perspective). When MSR bitmap is
> updated, KVM has to reset HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP from
> clean fields to make Hyper-V aware of the change. For KVM's L1s, this is
> done in vmx_disable_intercept_for_msr()/vmx_enable_intercept_for_msr().
> MSR bitmap for L2 is build in nested_vmx_prepare_msr_bitmap() by blending
> MSR bitmap for L1 and L1's idea of MSR bitmap for L2. KVM, however, doesn't
> check if the resulting bitmap is different and never cleans
> HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP in eVMCS02. This is incorrect and
> may result in Hyper-V missing the update.
> 
> The issue could've been solved by calling evmcs_touch_msr_bitmap() for
> eVMCS02 from nested_vmx_prepare_msr_bitmap() unconditionally but doing so
> would not give any performance benefits (compared to not using Enlightened
> MSR Bitmap at all). 3-level nesting is also not a very common setup
> nowadays.
> 
> Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
> now.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20211129094704.326635-2-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

You did not sign off on this backport (or any of the backports), so I
can't take them sorry.

greg k-h
