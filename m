Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0539A4AB6A3
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 09:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiBGIV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344995AbiBGIRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:17:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED725C043181
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 00:17:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9A0B8100B
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 08:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC605C004E1;
        Mon,  7 Feb 2022 08:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644221836;
        bh=NZSyBkOXUXprC3WjqCeecsqGuhIiEJN65tHerQ+dIbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cYSeHy9d6AAA5oc6z/GmQVU6DBhVhQKK8dVG5Tky/BkwYvZMYrXcnV3mC0ffcQa/6
         4HpZblUFaPRqWqBj1B83AYgNv2jUD62wzKdtm0YcqXrxhP0Rs43r0IQn1Eqk8KHMtB
         L19KRG3CQWp+Y+HBMMQUKQVUQpYRArn7s/r//ScI=
Date:   Mon, 7 Feb 2022 09:17:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     luofei <luofei@unicloud.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm, mm/hwpoison: fix unmap kernel 1:1 pages
Message-ID: <YgDVicpKRYOx88P5@kroah.com>
References: <20220207075023.830571-1-luofei@unicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207075023.830571-1-luofei@unicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 02:50:23AM -0500, luofei wrote:
> Only unmap the page when the memory error is properly handled
> by calling memory_failure(), not the other way around.
> 
> Fixes: 26f8c38bb466("x86/mm, mm/hwpoison: Don't unconditionally unmap kernel 1:1 pages")
> 
> Signed-off-by: luofei <luofei@unicloud.com>
> Cc: stable@vger.kernel.org #v4.14
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 95c09db1bba2..d8399a689165 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -589,7 +589,7 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
>  
>  	if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
>  		pfn = mce->addr >> PAGE_SHIFT;
> -		if (memory_failure(pfn, MCE_VECTOR, 0))
> +		if (!memory_failure(pfn, MCE_VECTOR, 0))
>  			mce_unmap_kpfn(pfn);
>  	}
>  
> -- 
> 2.27.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
