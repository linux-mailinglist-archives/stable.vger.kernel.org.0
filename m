Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484A5592F16
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiHOMla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHOMl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:41:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD4BD13A
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 05:41:28 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B4C85209E0;
        Mon, 15 Aug 2022 12:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660567286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7gXItFQiBz4NhqP/01odxL98DIpSAo/sgIkYmGKvaq4=;
        b=mUaJlJLz7LBRzSoogRYPXCJUiwP7jRwFvPFpSJF3Q9IqyxeCae2UZZ36kjGhqcSG+bWZxg
        eHoGiTqhhNuDdwTnjQPbo+rIAdjnnhgjaH7XFkMs1s2L+fClsiOXzgg+sTM3K18E0v/hFL
        cZ1H7xIzfTR3lkbct8pw4NPm9hhqxMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660567286;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7gXItFQiBz4NhqP/01odxL98DIpSAo/sgIkYmGKvaq4=;
        b=Kxv8knPPVFcglHiibzE5pQND2CerLDbCpXSuLsHjWiq7mxQLuqGswQDwWPgF0D7G2lEbrC
        PRGe9ynychMyeVBg==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8E9EF2C1C5;
        Mon, 15 Aug 2022 12:41:26 +0000 (UTC)
Date:   Mon, 15 Aug 2022 14:41:25 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     coxu@redhat.com, bhe@redhat.com, ebiederm@xmission.com,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kexec: clean up
 arch_kexec_kernel_verify_sig" failed to apply to 5.15-stable tree
Message-ID: <20220815124125.GD17705@kitsune.suse.cz>
References: <1660564084173149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660564084173149@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

it applies on top of 105e10e2cf1c

Thanks

Michal

On Mon, Aug 15, 2022 at 01:48:04PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 689a71493bd2f31c024f8c0395f85a1fd4b2138e Mon Sep 17 00:00:00 2001
> From: Coiby Xu <coxu@redhat.com>
> Date: Thu, 14 Jul 2022 21:40:24 +0800
> Subject: [PATCH] kexec: clean up arch_kexec_kernel_verify_sig
> 
> Before commit 105e10e2cf1c ("kexec_file: drop weak attribute from
> functions"), there was already no arch-specific implementation
> of arch_kexec_kernel_verify_sig. With weak attribute dropped by that
> commit, arch_kexec_kernel_verify_sig is completely useless. So clean it
> up.
> 
> Note later patches are dependent on this patch so it should be backported
> to the stable tree as well.
> 
> Cc: stable@vger.kernel.org
> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> Reviewed-by: Michal Suchanek <msuchanek@suse.de>
> Acked-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Coiby Xu <coxu@redhat.com>
> [zohar@linux.ibm.com: reworded patch description "Note"]
> Link: https://lore.kernel.org/linux-integrity/20220714134027.394370-1-coxu@redhat.com/
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 8107606ad1e8..7f710fb3712b 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -212,11 +212,6 @@ static inline void *arch_kexec_kernel_image_load(struct kimage *image)
>  }
>  #endif
>  
> -#ifdef CONFIG_KEXEC_SIG
> -int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
> -				 unsigned long buf_len);
> -#endif
> -
>  extern int kexec_add_buffer(struct kexec_buf *kbuf);
>  int kexec_locate_mem_hole(struct kexec_buf *kbuf);
>  
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 0c27c81351ee..6dc1294c90fc 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -81,24 +81,6 @@ int kexec_image_post_load_cleanup_default(struct kimage *image)
>  	return image->fops->cleanup(image->image_loader_data);
>  }
>  
> -#ifdef CONFIG_KEXEC_SIG
> -static int kexec_image_verify_sig_default(struct kimage *image, void *buf,
> -					  unsigned long buf_len)
> -{
> -	if (!image->fops || !image->fops->verify_sig) {
> -		pr_debug("kernel loader does not support signature verification.\n");
> -		return -EKEYREJECTED;
> -	}
> -
> -	return image->fops->verify_sig(buf, buf_len);
> -}
> -
> -int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf, unsigned long buf_len)
> -{
> -	return kexec_image_verify_sig_default(image, buf, buf_len);
> -}
> -#endif
> -
>  /*
>   * Free up memory used by kernel, initrd, and command line. This is temporary
>   * memory allocation which is not needed any more after these buffers have
> @@ -141,13 +123,24 @@ void kimage_file_post_load_cleanup(struct kimage *image)
>  }
>  
>  #ifdef CONFIG_KEXEC_SIG
> +static int kexec_image_verify_sig(struct kimage *image, void *buf,
> +				  unsigned long buf_len)
> +{
> +	if (!image->fops || !image->fops->verify_sig) {
> +		pr_debug("kernel loader does not support signature verification.\n");
> +		return -EKEYREJECTED;
> +	}
> +
> +	return image->fops->verify_sig(buf, buf_len);
> +}
> +
>  static int
>  kimage_validate_signature(struct kimage *image)
>  {
>  	int ret;
>  
> -	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
> -					   image->kernel_buf_len);
> +	ret = kexec_image_verify_sig(image, image->kernel_buf,
> +				     image->kernel_buf_len);
>  	if (ret) {
>  
>  		if (sig_enforce) {
> 
