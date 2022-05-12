Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9A5242DC
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 04:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243078AbiELCrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 22:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiELCrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 22:47:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C246E3DDFD
        for <stable@vger.kernel.org>; Wed, 11 May 2022 19:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652323624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EzuImZzUXRQk55j7AQx9zRKfVsHLp/8M2JdEt3xnOyA=;
        b=QVHmF9gPx8DMRK1OxyhX7jiEbbRrEJMMr4vJ8rJjmUSA6el3M1vtdNN08Mv0kvVgomQQXU
        XYnNr9hgtHRNF7EVX5f3BKTWCJLlCH8a+0A5xNCH8H2sVXpdBkt9zOUumS8YCY/cV92TMc
        6BNfa2vIzn2K2chNbU+0aNYWluAuz7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-vEHXaPuYOvumFqfq10WoPw-1; Wed, 11 May 2022 22:46:59 -0400
X-MC-Unique: vEHXaPuYOvumFqfq10WoPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87163811E76;
        Thu, 12 May 2022 02:46:58 +0000 (UTC)
Received: from localhost (ovpn-13-226.pek2.redhat.com [10.72.13.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D96F62026D2D;
        Thu, 12 May 2022 02:46:41 +0000 (UTC)
Date:   Thu, 12 May 2022 10:46:37 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Coiby Xu <coxu@redhat.com>
Cc:     kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Dave Young <dyoung@redhat.com>, Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>, Chun-Yi Lee <jlee@suse.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/4] kexec, KEYS: make the code in
 bzImage64_verify_sig generic
Message-ID: <Ynx1DUvDTL1R4Pj5@MiWiFi-R3L-srv>
References: <20220512023402.9913-1-coxu@redhat.com>
 <20220512023402.9913-3-coxu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512023402.9913-3-coxu@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/12/22 at 10:34am, Coiby Xu wrote:
> commit 278311e417be ("kexec, KEYS: Make use of platform keyring for
> signature verify") adds platform keyring support on x86 kexec but not
> arm64.
> 
> The code in bzImage64_verify_sig makes use of system keyrings including
> .buitin_trusted_keys, .secondary_trusted_keys and .platform keyring to
> verify signed kernel image as PE file. Make it generic so both x86_64
> and arm64 can use it.
> 
> Note this patch is needed by a later patch so Cc it to the stable tree
> as well.

This note should not be added in log.

> 
> Cc: kexec@lists.infradead.org
> Cc: keyrings@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
> Reviewed-by: Michal Suchanek <msuchanek@suse.de>
> Signed-off-by: Coiby Xu <coxu@redhat.com>
> ---

You can put the note here, it won't be added to commit log when merged.
Maybe it can be removed when merged.

Otherwise, LGTM

Acked-by: Baoquan He <bhe@redhat.com>

>  arch/x86/kernel/kexec-bzimage64.c | 20 +-------------------
>  include/linux/kexec.h             |  7 +++++++
>  kernel/kexec_file.c               | 17 +++++++++++++++++
>  3 files changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
> index 170d0fd68b1f..f299b48f9c9f 100644
> --- a/arch/x86/kernel/kexec-bzimage64.c
> +++ b/arch/x86/kernel/kexec-bzimage64.c
> @@ -17,7 +17,6 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/efi.h>
> -#include <linux/verification.h>
>  
>  #include <asm/bootparam.h>
>  #include <asm/setup.h>
> @@ -528,28 +527,11 @@ static int bzImage64_cleanup(void *loader_data)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
> -static int bzImage64_verify_sig(const char *kernel, unsigned long kernel_len)
> -{
> -	int ret;
> -
> -	ret = verify_pefile_signature(kernel, kernel_len,
> -				      VERIFY_USE_SECONDARY_KEYRING,
> -				      VERIFYING_KEXEC_PE_SIGNATURE);
> -	if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING)) {
> -		ret = verify_pefile_signature(kernel, kernel_len,
> -					      VERIFY_USE_PLATFORM_KEYRING,
> -					      VERIFYING_KEXEC_PE_SIGNATURE);
> -	}
> -	return ret;
> -}
> -#endif
> -
>  const struct kexec_file_ops kexec_bzImage64_ops = {
>  	.probe = bzImage64_probe,
>  	.load = bzImage64_load,
>  	.cleanup = bzImage64_cleanup,
>  #ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
> -	.verify_sig = bzImage64_verify_sig,
> +	.verify_sig = kexec_kernel_verify_pe_sig,
>  #endif
>  };
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 413235c6c797..da83abfc628b 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -19,6 +19,7 @@
>  #include <asm/io.h>
>  
>  #include <uapi/linux/kexec.h>
> +#include <linux/verification.h>
>  
>  /* Location of a reserved region to hold the crash kernel.
>   */
> @@ -202,6 +203,12 @@ int arch_kexec_apply_relocations(struct purgatory_info *pi,
>  				 const Elf_Shdr *relsec,
>  				 const Elf_Shdr *symtab);
>  int arch_kimage_file_post_load_cleanup(struct kimage *image);
> +#ifdef CONFIG_KEXEC_SIG
> +#ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
> +int kexec_kernel_verify_pe_sig(const char *kernel,
> +				    unsigned long kernel_len);
> +#endif
> +#endif
>  int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
>  
>  extern int kexec_add_buffer(struct kexec_buf *kbuf);
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 3720435807eb..754885b96aab 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -165,6 +165,23 @@ void kimage_file_post_load_cleanup(struct kimage *image)
>  }
>  
>  #ifdef CONFIG_KEXEC_SIG
> +#ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
> +int kexec_kernel_verify_pe_sig(const char *kernel, unsigned long kernel_len)
> +{
> +	int ret;
> +
> +	ret = verify_pefile_signature(kernel, kernel_len,
> +				      VERIFY_USE_SECONDARY_KEYRING,
> +				      VERIFYING_KEXEC_PE_SIGNATURE);
> +	if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING)) {
> +		ret = verify_pefile_signature(kernel, kernel_len,
> +					      VERIFY_USE_PLATFORM_KEYRING,
> +					      VERIFYING_KEXEC_PE_SIGNATURE);
> +	}
> +	return ret;
> +}
> +#endif
> +
>  static int kexec_image_verify_sig(struct kimage *image, void *buf,
>  		unsigned long buf_len)
>  {
> -- 
> 2.35.3
> 

