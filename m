Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06B53E65E
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiFFJ0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 05:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiFFJ0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 05:26:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD77B7DFC
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 02:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C415B8167E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 09:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2ABC385A9;
        Mon,  6 Jun 2022 09:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654507602;
        bh=nCUDPJviz63YVbRsLFDNZ/SDlttQEsa+jB+VgfrA3eg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KakdtJ1RKHms8GTN9NkGDKZAousO3cDCv2QX5v19nUfjceTfZQ/mLW5TywPhoUYGp
         AwEEKC2lL3+yIyYNSHIXqbVBTtN63lb2Gcr1Wa7L+8dS6pN9i97Q1PmdM4fG8mS8kj
         lRrMcTDR5FNsE85N96P40nRRKvtl2LgVbIoHshts=
Date:   Mon, 6 Jun 2022 11:26:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     shaoqin.huang@intel.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Check every prev_roots in
 __kvm_mmu_free_obsolete_roots()
Message-ID: <Yp3ITpkpXuQ7cwPO@kroah.com>
References: <20220606234843.2931871-1-shaoqin.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606234843.2931871-1-shaoqin.huang@intel.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 05:48:43PM -0600, shaoqin.huang@intel.com wrote:
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
