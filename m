Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EC75A93FC
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiIAKMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiIAKMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:12:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91EA131DC1
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 532F7B82572
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 10:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C172C433D6;
        Thu,  1 Sep 2022 10:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662027152;
        bh=MC2SWgpB2SraSeOCGrOmEsbs+1Ikep3PLC6vhGA+Zbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jVdjoNRE8+kGkwsCWt9M4hrYLXF0FD8i3FQh4K3n5gJCnIw0u16RVap9AQTEAJD7L
         Bk0kl89pjW/FBhdlkGT7TierW1GIJRfK63d+xtWOzxCHlWbv8hWfNZtAmFUBCIDjtr
         WVqX5/ELOXt987fdoV//33fQ9hQBJFHiH6H+Firw=
Date:   Thu, 1 Sep 2022 12:12:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9] s390/mm: do not trigger write fault when vma does
 not allow VM_WRITE
Message-ID: <YxCFjWQ1BAT6+Evj@kroah.com>
References: <16617586646999@kroah.com>
 <20220829155238.3865621-1-gerald.schaefer@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829155238.3865621-1-gerald.schaefer@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 05:52:38PM +0200, Gerald Schaefer wrote:
> commit 41ac42f137080bc230b5882e3c88c392ab7f2d32 upstream.
> 
> For non-protection pXd_none() page faults in do_dat_exception(), we
> call do_exception() with access == (VM_READ | VM_WRITE | VM_EXEC).
> In do_exception(), vma->vm_flags is checked against that before
> calling handle_mm_fault().
> 
> Since commit 92f842eac7ee3 ("[S390] store indication fault optimization"),
> we call handle_mm_fault() with FAULT_FLAG_WRITE, when recognizing that
> it was a write access. However, the vma flags check is still only
> checking against (VM_READ | VM_WRITE | VM_EXEC), and therefore also
> calling handle_mm_fault() with FAULT_FLAG_WRITE in cases where the vma
> does not allow VM_WRITE.
> 
> Fix this by changing access check in do_exception() to VM_WRITE only,
> when recognizing write access.
> 
> Link: https://lkml.kernel.org/r/20220811103435.188481-3-david@redhat.com
> Fixes: 92f842eac7ee3 ("[S390] store indication fault optimization")
> Cc: <stable@vger.kernel.org>
> Reported-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> ---
>  arch/s390/mm/fault.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index ba2f21873cbd..6fa4220e34b5 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -409,7 +409,9 @@ static inline int do_exception(struct pt_regs *regs, int access)
>  	flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>  	if (user_mode(regs))
>  		flags |= FAULT_FLAG_USER;
> -	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
> +	if ((trans_exc_code & store_indication) == 0x400)
> +		access = VM_WRITE;
> +	if (access == VM_WRITE)
>  		flags |= FAULT_FLAG_WRITE;
>  	down_read(&mm->mmap_sem);
>  
> -- 
> 2.34.1
> 

all now queued up, thanks.

greg k-h
