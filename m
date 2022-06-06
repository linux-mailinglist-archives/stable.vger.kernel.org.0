Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2F553E8FE
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiFFJ1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 05:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiFFJ1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 05:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC0DBA567
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 02:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1469361324
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 09:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080C8C385A9;
        Mon,  6 Jun 2022 09:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654507609;
        bh=5a1mS+nyYVxIOV3iAJIxiJmOr5zpL9U8roIipNftynY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=elH9eacNdrHZXOEmePmwDCnKNmq7iXL8eVYEZwC4IkgSmePIE5eix5pkdkM605ovc
         MM9wovaxvC+VTAIfqQof5cSCKPbDNimCgGxIcpyj8TVFpXpA6IvQHz4wGixl5RM8/D
         9AxbcL4879CMAoSUrc/NZr9h/azEBqc+bLkgl9cI=
Date:   Mon, 6 Jun 2022 11:26:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     shaoqin.huang@intel.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Check every prev_roots in
 __kvm_mmu_free_obsolete_roots()
Message-ID: <Yp3IVmtCITw6qmub@kroah.com>
References: <y>
 <20220606234636.2931713-1-shaoqin.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606234636.2931713-1-shaoqin.huang@intel.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 05:46:36PM -0600, shaoqin.huang@intel.com wrote:
> From: Shaoqin Huang <shaoqin.huang@intel.com>
> 
> When freeing obsolete previous roots, check prev_roots as intended, not
> the current root.
> 
> Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
> Fixes: 527d5cd7eece ("KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped")
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f4653688fa6d..e826ee9138fa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5179,7 +5179,7 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  		roots_to_free |= KVM_MMU_ROOT_CURRENT;
>  
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> -		if (is_obsolete_root(kvm, mmu->root.hpa))
> +		if (is_obsolete_root(kvm, mmu->prev_roots[i].hpa))
>  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>  	}
>  
> -- 
> 2.30.2
>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
